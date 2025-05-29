//
//  OnboardingCombineDate.swift
//  ITExams
//
//  Created by Андрей Чернышев on 10.03.2022.
//

import Foundation

struct OCombineData {
    let motivation: OMotivationElement
    let age: String
    let course: Course
    let examDate: Date?
    let studyMode: OStudyModeElement
    let testMinutes: Int
    let testDays: [DayOfWeek]
}

final class OnboardingCombineData {
    private var motivation: OMotivationElement?
    private var age: String?
    private var course: Course?
    private var examDate: Date?
    private var studyMode: OStudyModeElement?
    private var testMinutes: Int?
    private var testDays: [DayOfWeek]?
    
    func combineData() -> OCombineData? {
        guard
            let motivation = motivation,
            let age = age,
            let course = course,
            let studyMode = studyMode,
            let testMinutes = testMinutes,
            let testDays = testDays
        else {
            return nil
        }
        
        return OCombineData(
            motivation: motivation,
            age: age,
            course: course,
            examDate: examDate,
            studyMode: studyMode,
            testMinutes: testMinutes,
            testDays: testDays
        )
    }
}

// MARK: OMotivationViewDelegate
extension OnboardingCombineData: OMotivationViewDelegate {
    func motivationViewDidSelected(element: OMotivationElement) {
        self.motivation = element
    }
}

// MARK: OAgeViewDelegate
extension OnboardingCombineData: OAgeViewDelegate {
    func ageViewDidSelected(age: String) {
        self.age = String(format: "Onboarding.CreatingPlanView.Years".localized, age)
    }
}

// MARK: OCourseViewDelegate
extension OnboardingCombineData: OCourseViewDelegate {
    func courseViewDidSelected(course: Course) {
        self.course = course
    }
}

// MARK: OExamDateViewDelegate
extension OnboardingCombineData: OExamDateViewDelegate {
    func examDateDidSelected(date: Date?) {
        self.examDate = date
    }
}

// MARK: OStudyModeViewDelegate
extension OnboardingCombineData: OStudyModeViewDelegate {
    func studyModeViewDidSelected(element: OStudyModeElement) {
        self.studyMode = element
    }
}

// MARK: ODailyGoalViewDelegate
extension OnboardingCombineData: ODailyGoalViewDelegate {
    func dailyGoalDidSelected(testMinutes: Int) {
        self.testMinutes = testMinutes
    }
    
    func dailyGoalDidSelected(daysOfWeek: [DayOfWeek]) {
        self.testDays = daysOfWeek
    }
}
