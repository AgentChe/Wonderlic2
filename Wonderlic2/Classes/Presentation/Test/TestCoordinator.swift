//
//  TestCoordinator.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import UIKit

final class TestCoordinator {
    static let shared = TestCoordinator()
    
    private var sequence: TestSequence?
    
    private init() {}
}

// MARK: Public
extension TestCoordinator {
    func start(testTypes: [TestType], from: UIViewController?) {
        sequence = TestSequence(testTypes: testTypes, from: from) { [weak self] in
            self?.sequence = nil
        }
        sequence?.start()
    }
}
