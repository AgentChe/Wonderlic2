//
//  TestStats.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

struct TestStats: Codable, Hashable {
    let correctNumbers: Int
    let incorrectNumbers: Int
    let userTime: String
    let userScore: Int
    let weakestSubject: String?
    let questions: [TestStatsAnswer]
}
