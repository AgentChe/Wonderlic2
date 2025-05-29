//
//  StepTests.swift
//  ITExams
//
//  Created by Андрей Чернышев on 12.05.2022.
//

enum StepContent {
    case tests(StepTests)
    case finalStep(finalStep: PlanFinalStep, locked: Bool)
}

struct StepTests {
    let tests: [PlanTest]
    let activeSubscription: Bool
    let lockedStep: Bool
}
