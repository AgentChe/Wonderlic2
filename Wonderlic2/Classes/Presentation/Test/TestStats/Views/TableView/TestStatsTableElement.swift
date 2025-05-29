//
//  TestStatsTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import CoreGraphics

enum TestStatsTableElement {
    case offset(CGFloat)
    case progress(Int)
    case info(TestStatsInfo)
    case actions
    case title(String)
    case filters
    case answer(TestStatsTableAnswer)
}

struct TestStatsInfo {
    let correctNumber: Int
    let totalNumber: Int
    let quizTime: String
    let weakSubject: String?
}

struct TestStatsTableAnswer {
    let question: Question
    let answeredIds: [Int]
    let correct: Bool
    let separatorHidden: Bool
    let topCorners: Bool
    let bottomCorners: Bool
}
