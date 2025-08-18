//
//  PlanViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

import UIKit
import RxSwift

final class PlanViewController: UIViewController {
    lazy var mainView = PlanView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PlanViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.planSteps
            .drive(Binder(self) { base, planSteps in
                base.mainView.stepCollectionView.setup(elements: planSteps)
                base.determineCurrentStep(elements: planSteps)
            })
            .disposed(by: disposeBag)
        
        viewModel.stepContent
            .drive(Binder(self) { base, stepContent in
                base.handle(stepContent: stepContent)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentCourse
            .drive(Binder(mainView.headerView.currentView) { base, course in
                base.setup(course: course)
            })
            .disposed(by: disposeBag)

        viewModel.planStudyScore
            .drive(Binder(self) { base, studyScore in
                base.mainView.headerView.studyScoreView.setup(goal: studyScore.goal,
                                                              progress: studyScore.progress)
            })
            .disposed(by: disposeBag)
        
        mainView.headerView.currentView.rx.tap
            .subscribe(Binder(self) { base, void in
                let vc = CoursesViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.finalStepView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                if SessionManager().hasActiveSubscriptions() {
                    TestCoordinator.shared.start(testTypes: [.final], from: base)
                } else {
                    let vc = PaygateViewController.make()
                    base.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.stepCollectionView.mainDelegate = self
        mainView.testsTableView.mainDelegate = self
    }
}

// MARK: Make
extension PlanViewController {
    static func make() -> PlanViewController {
        PlanViewController()
    }
}

// MARK: StepCollectionViewDelegate
extension PlanViewController: StepCollectionViewDelegate {
    func stepCollectionViewDidSelect(element: StepCollectionElement) {
        update(stepName: element.name())
        viewModel.currentStep.accept(element)
    }
}

// MARK: StepTestsTableViewDelegate
extension PlanViewController: StepTestsTableViewDelegate {
    func stepTestsTableDidSelect(elements: [PlanTest],
                                 selected: PlanTest,
                                 activeSubscription: Bool,
                                 lockedStep: Bool) {
        guard !lockedStep else {
            return
        }
        
        let needPayment = activeSubscription ? false : selected.paid
        
        if needPayment {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let index = elements.firstIndex(of: selected) ?? 0
            let result = elements.suffix(elements.count - index)
            
            TestCoordinator.shared.start(testTypes: result.map { .plan(testId: $0.id) }, from: self)
        }
    }
}

// MARK: Private
private extension PlanViewController {
    func handle(stepContent: StepContent) {
        func hiddenTable(_ hidden: Bool) {
            mainView.testsTableView.isHidden = hidden
            mainView.finalStepView.isHidden = !hidden
        }
        
        switch stepContent {
        case .tests(let stepTests):
            mainView.testsTableView.setup(elements: stepTests.tests,
                                          activeSubscription: stepTests.activeSubscription,
                                          lockedStep: stepTests.lockedStep)
            hiddenTable(false)
        case .finalStep(let finalStep, let locked):
            mainView.finalStepView.setup(finalStep: finalStep, locked: locked)
            hiddenTable(true)
        }
    }
    
    func determineCurrentStep(elements: [StepCollectionElement]) {
        guard let index = StepCollectionElement.currentIndex(in: elements) else {
            return
        }
        
        let element = elements[index]
        
        stepCollectionViewDidSelect(element: element)
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func activity(_ activity: Bool) {
        let showAnimating = activity && mainView.stepCollectionView.elements.isEmpty
        showAnimating ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.stepCollectionView.alpha = showAnimating ? 0 : 1
        mainView.stepCollectionView.isUserInteractionEnabled = !showAnimating
        
        mainView.stepNameLabel.alpha = showAnimating ? 0 : 1
        mainView.stepNameLabel.isUserInteractionEnabled = !showAnimating
        
        mainView.testsTableView.alpha = showAnimating ? 0 : 1
        mainView.testsTableView.isUserInteractionEnabled = !showAnimating
    }
    
    func update(stepName: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        mainView.stepNameLabel.attributedText = stepName.attributed(with: attrs)
    }
}
