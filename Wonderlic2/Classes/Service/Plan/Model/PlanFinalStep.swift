//
//  PlanFinalStep.swift
//  ITExams
//
//  Created by Андрей Чернышев on 17.05.2022.
//

struct PlanFinalStep: Codable, Hashable {
    enum Status: String, Codable {
        case intact, inProgress, completed
    }
    
    let status: Status
    let progress: Int?
}
