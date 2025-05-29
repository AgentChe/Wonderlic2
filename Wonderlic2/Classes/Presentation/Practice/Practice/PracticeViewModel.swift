//
//  PracticeViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import RxSwift
import RxCocoa

final class PracticeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var activity = RxActivityIndicator()
    
    lazy var elements = makeElements()
    
    private lazy var referenceExamDate = makeReferenceExamDate()
    private lazy var examDate = makeExamDate()
    private lazy var dailyQiestion = makeDailyQuestion()
    private lazy var testsCount = makeTestsCount()
    private lazy var questionsCount = makeQuestionsCount()
    private lazy var examEnvironment = makeExamEnvironment()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    private lazy var questionManager = QuestionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension PracticeViewModel {
    func makeElements() -> Driver<[PracticeTableElement]> {
        Driver
            .combineLatest(referenceExamDate, examDate, dailyQiestion, testsCount, questionsCount)
            .map { referenceExamDate, examDate, dailyQiestion, testsCount, questionsCount -> [PracticeTableElement] in
                var result = [PracticeTableElement]()
                
                let examDateElement = PracticeTableExamDate(referenceDateOfExam: referenceExamDate,
                                                            dateOfExam: examDate)
                result.append(.examDate(examDateElement))
                
                if let dailyQiestion = dailyQiestion {
                    result.append(contentsOf: [
                        .offset(32.scale),
                        .title("Practice.DailyQuestion.Title".localized),
                        .offset(16.scale),
                        .dailyQuestion(dailyQiestion)
                    ])
                }
                
                result.append(contentsOf: [
                    .offset(32.scale),
                    .title("Practice.Tests.Title".localized),
                    .offset(16.scale),
                    .tests(testsCount)
                ])
                
                if let questionsCount = questionsCount {
                    result.append(contentsOf: [
                        .offset(60.scale),
                        .unlockPremium(questionsCount)
                    ])
                }
                
                return result
            }
    }
    
    func makeReferenceExamDate() -> Driver<Date?> {
        let initial = profileManager
            .obtainReferenceDateOfExam()
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedDateOfExam
            .flatMapLatest { [weak self] examDate -> Driver<Date?> in
                guard let self = self else {
                    return .never()
                }
                
                return self.profileManager
                    .obtainReferenceDateOfExam()
                    .asDriver(onErrorJustReturn: nil)
            }
        
        return Driver.merge(initial, updated)
    }
    
    func makeExamDate() -> Driver<Date?> {
        let initial = profileManager
            .obtainDateOfExam(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedDateOfExam
            .map { examDate -> Date? in
                examDate
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeDailyQuestion() -> Driver<String?> {
        examEnvironment
            .flatMap { [weak self] examEnvironment -> Driver<String?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<String?> {
                    self.questionManager
                        .obtainQotdTest(
                            courseId: examEnvironment.course.id,
                            activeSubscription: false,
                            forceUpdate: false
                        )
                        .map { qotdTest -> String? in
                            qotdTest?.test.questions.first?.question
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeTestsCount() -> Driver<PracticeTableTestsCount> {
        let trigger = QuestionMediator.shared.testPassed
            .asDriver(onErrorDriveWith: .never())
            .startWith(Void())
        
        return Driver
            .combineLatest(trigger, examEnvironment) { $1 }
            .flatMap { [weak self] examEnvironment -> Driver<TestsKit?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<TestsKit?> {
                    self.questionManager
                        .obtainTestsKit(courseId: examEnvironment.course.id)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: nil)
            }
            .compactMap { testsKit -> PracticeTableTestsCount? in
                guard let testsKit = testsKit else {
                    return nil
                }
                
                return PracticeTableTestsCount(random: testsKit.randomCount,
                                               missed: testsKit.missedCount,
                                               quick: testsKit.quickCount,
                                               saved: testsKit.savedCount)
            }
    }
    
    func makeQuestionsCount() -> Driver<Int?> {
        Driver
            .combineLatest(activeSubscription, examEnvironment)
            .map { activeSubscription, examEnvironment -> Int? in
                guard !activeSubscription else {
                    return nil
                }
                
                return 5000
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
