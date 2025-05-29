//
//  PlanTest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

struct PlanTest: Codable, Hashable {
    let id: Int
    let name: String
    let sort: Int
    let questionsCount: Int
    let paid: Bool
    let progress: Int
}
