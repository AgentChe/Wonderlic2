//
//  PlanViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

import RxSwift
import RxCocoa

final class PlanViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var currentStep = PublishRelay<StepCollectionElement>()
    
    lazy var stepContent = makeStepContent()
    lazy var planSteps = makePlanSteps()
    lazy var currentCourse = makeCurrentCourse()
    lazy var planStudyScore = makePlanStudyScore()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var examEnvironment = makeExamEnvironment()
    private lazy var plan = makePlan()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var profileManager = ProfileManager()
    private lazy var planManager = PlanManager()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension PlanViewModel {
    func makeStepContent() -> Driver<StepContent> {
        let step = currentStep
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver.combineLatest(step, activeSubscription) { step, activeSubscription in
            switch step {
            case .tests(let element):
                let tests = StepTests(tests: element.step.tests,
                          activeSubscription: activeSubscription,
                          lockedStep: element.locked)
                return .tests(tests)
            case .final(let element):
                return .finalStep(finalStep: element.finalStep, locked: element.locked)
            }
        }
    }
    
    func makePlanSteps() -> Driver<[StepCollectionElement]> {
        plan.map { plan -> [StepCollectionElement] in
            let steps = plan.steps.sorted(by: { $0.sort < $1.sort })
            let elements = StepCollectionElement.from(steps: steps, finalStep: plan.finalStep)
            return elements
        }
    }
    
    func makeCurrentCourse() -> Driver<Course> {
        examEnvironment.map {
            $0.course
        }
    }
    
    func makePlanStudyScore() -> Driver<PlanStudyScore> {
        plan
            .map { plan -> PlanStudyScore in
                PlanStudyScore(goal: plan.goal, progress: plan.progress)
            }
    }
    
    func makePlan() -> Driver<Plan> {
        examEnvironment
            .flatMapLatest { [weak self] examEnvironment -> Driver<Plan> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Observable<Plan> {
                    let triggers = Signal
                        .merge(
                            StatsMediator.shared.resetedStats,
                            QuestionMediator.shared.testPassed,
                            // Поскольку вызов метода сохранения приосходит для каждого экзамена, медиатор кидает соответствующее количество уведомлений. Ставим заглушку в 1 сек, чтобы не делать лишние запросы.
                            ProfileMediator.shared.changedDateOfExam
                                .map { _ in Void() }
                                .debounce(RxTimeInterval.seconds(1))
                        )
                        .asObservable()
                        .startWith(Void())
                    
                    return triggers
                        .flatMapLatest {
                            self.planManager
                                .obtainPlan(courseId: examEnvironment.course.id)
                                .flatMap { plan -> Single<Plan> in
                                    guard let plan = plan else {
                                        return .error(ContentError(.notContent))
                                    }
                                    
                                    return .just(plan)
                                }
                                .trackActivity(self.activity)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return source()
                    .retry(when: { err in
                        err.flatMapLatest {
                            trigger(error: $0)
                        }
                    })
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeExamEnvironment() -> Driver<ExamEnvironment> {
        let initial = profileManager
            .obtainExamEnvironment()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        let updated = ProfileMediator.shared
            .changedExamEnvironment
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, updated)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
