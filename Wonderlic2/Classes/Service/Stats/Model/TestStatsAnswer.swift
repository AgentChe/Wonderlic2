//
//  TestStatsAnswer.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

struct TestStatsAnswer: Codable, Hashable {
    let question: Question
    let isCorrectly: Bool
    let userAnswersIds: [Int]
}
