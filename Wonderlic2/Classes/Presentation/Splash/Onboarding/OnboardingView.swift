//
//  OnboardingView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case start, motivation, age, why, course, quizSolution, test, determingSkill, quizResult, examDate, dailyGoal, studyMode, creatingPlan, plan
    }
    
    var didFinish: (() -> Void)?
    
    lazy var motivationView = OMotivationView(step: .motivation)
    lazy var ageView = OAgeView(step: .age)
    lazy var courseView = OCourseView(step: .course)
    lazy var quizSolutionView = OQuizSolutionView(step: .quizSolution)
    lazy var testView = OTestView(step: .test)
    lazy var examDateView = OExamDateView(step: .examDate)
    lazy var dailyGoalView = ODailyGoalView(step: .dailyGoal)
    lazy var studyModeView = OStudyModeView(step: .studyMode)
    lazy var creatingPlanView = OCreatingPlanView(step: .creatingPlan)
    lazy var planView = OPlanView(step: .plan)
    
    private lazy var contentViews: [OSlideView] = {
        [
            OStartView(step: .start),
            motivationView,
            ageView,
            OWhyView(step: .why),
            courseView,
            quizSolutionView,
            testView,
            ODetermingSkillView(step: .determingSkill),
            OQuizResultView(step: .quizResult),
            examDateView,
            dailyGoalView,
            studyModeView,
            creatingPlanView,
            planView
        ]
    }()
    
    private var step = Step.start
    
    private lazy var combineData = OnboardingCombineData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        scroll(to: nextStep)
    }
    
    func slideViewDidBack(from step: OnboardingView.Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        scroll(to: previousStep)
    }
}

// MARK: OQuizSolutionViewDelegate
extension OnboardingView: OQuizSolutionViewDelegate {
    func quizSolutionDidSkip() {
        scroll(to: .examDate)
    }
    
    func quizSolutionDidStart() {
        scroll(to: .test)
    }
}

// MARK: OTestViewDelegate
extension OnboardingView: OTestViewDelegate {
    func testViewDidFinished() {
        scroll(to: .determingSkill)
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
                
                view.clipsToBounds = true
                view.delegate = self
                
                if index == 0 {
                    view.frame.origin = CGPoint(x: 0, y: 0)
                    addSubview(view)
                    
                    view.moveToThis()
                }
            }
        
        motivationView.motivationDelegate = combineData
        ageView.ageDelegate = combineData
        courseView.add(delegate: combineData)
        courseView.add(delegate: testView)
        quizSolutionView.quizSolutionDelegate = self
        testView.testViewDelegate = self
        examDateView.examDateDelegate = combineData
        dailyGoalView.dailyGoalDelegate = combineData
        studyModeView.studyModeDelegate = combineData
        creatingPlanView.combineData = combineData
        planView.combineData = combineData
    }
    
    func scroll(to newStep: Step) {
        let currentIndex = step.rawValue
        let scrollToIndex = newStep.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = contentViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = contentViews[currentIndex]
        let scrollToView = contentViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 375.scale * CGFloat(direction), y: 0)
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 375.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.step = newStep
        })
    }
}
