//
//  CustomMadeTestTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import CoreGraphics

enum CustomMadeTestTableElement {
    case offset(CGFloat)
    case startTest(CustomMadeTestCollectorElement)
    case title(String)
    case subjects([CustomMadeTestSubjectElement])
    case missedQuestions(CustomMadeTestSwitchElement)
    case answeredQuestions(CustomMadeTestSwitchElement)
    case questionsCount([QuestionsCountCollectionElement])
}

struct CustomMadeTestCollectorElement {
    let subjects: [CustomMadeTestSubjectElement]
    let isOnMissedQuestions: CustomMadeTestSwitchElement
    let isOnAnsweredQuestions: CustomMadeTestSwitchElement
    let questionsCount: [QuestionsCountCollectionElement]
    
    func make() -> CustomTestAttributes {
        let subjects = self.subjects.filter { $0.isSelected }.map { $0.subject }
        let questionsCount = self.questionsCount.first(where: { $0.isSelected })?.count ?? 5
        
        return CustomTestAttributes(subjects: subjects,
                                    isOnMissedQuestions: isOnMissedQuestions.isOn,
                                    isOnAnsweredQuestions: isOnAnsweredQuestions.isOn,
                                    questionsCount: questionsCount)
    }
}

final class CustomMadeTestSubjectElement {
    let subject: Subject
    var isSelected: Bool
    
    init(subject: Subject,
         isSelected: Bool) {
        self.subject = subject
        self.isSelected = isSelected
    }
}

final class CustomMadeTestSwitchElement {
    let title: String
    var isOn: Bool
    
    init(title: String,
         isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
}
