//
//  PracticeTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import Foundation
import CoreGraphics

enum PracticeTableElement {
    case offset(CGFloat)
    case examDate(PracticeTableExamDate)
    case title(String)
    case dailyQuestion(String)
    case tests(PracticeTableTestsCount)
    case unlockPremium(Int)
}

struct PracticeTableExamDate {
    let referenceDateOfExam: Date?
    let dateOfExam: Date?
}

struct PracticeTableTestsCount {
    let random: Int
    let missed: Int
    let quick: Int
    let saved: Int
}
