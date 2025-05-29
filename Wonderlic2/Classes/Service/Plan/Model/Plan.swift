//
//  Plan.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

struct Plan: Codable, Hashable {
    let progress: Int
    let goal: String
    let steps: [PlanStep]
    let finalStep: PlanFinalStep
}
