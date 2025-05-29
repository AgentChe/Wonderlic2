//
//  Test.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

struct Test: Codable, Hashable {
    let paid: Bool
    let userTestId: Int
    let questions: [Question]
}
