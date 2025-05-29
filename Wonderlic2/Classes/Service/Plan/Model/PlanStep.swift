//
//  PlanStep.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

struct PlanStep: Codable, Hashable {
    let name: String
    let sort: Int
    let progress: Int
    let tests: [PlanTest]
}
