//
//  TestAnalytics.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

final class TestAnalytics {
    static func name(mode: TestType) -> String {
        switch mode {
        case .failedSet:
            return "missed questions"
        case .get:
            return "get"
        case .qotd:
            return "question of the day"
        case .randomSet:
            return "random set"
        case .tenSet:
            return "10 questions"
        case .saved:
            return "saved"
        case .timed:
            return "timed"
        case .plan:
            return "plan"
        case .quick:
            return "quick"
        case .custom:
            return "custom"
        case .final:
            return "final"
        }
    }
}
