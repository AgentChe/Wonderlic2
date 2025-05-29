//
//  TestType.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

enum TestType {
    case get(testId: Int?)
    case tenSet
    case failedSet
    case qotd
    case randomSet
    case saved
    case timed(minutes: Int)
    case plan(testId: Int)
    case quick
    case custom(CustomTestAttributes)
}

// MARK: Public
extension TestType {
    func isQotd() -> Bool {
        guard case .qotd = self else {
            return false
        }
        
        return true
    }
}
