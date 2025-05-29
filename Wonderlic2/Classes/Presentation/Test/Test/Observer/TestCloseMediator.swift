//
//  TestCloseMediator.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import RxSwift
import RxCocoa

final class TestCloseMediator {
    static let shared = TestCloseMediator()
    
    private let testClosedTrigger = PublishRelay<TestFinish>()
    
    private init() {}
}

// MARK: Public
extension TestCloseMediator {
    func notifyAboudTestClosed(with element: TestFinish) {
        testClosedTrigger.accept(element)
    }
}

// MARK: Triggers
extension TestCloseMediator {
    var testClosed: Signal<TestFinish> {
        testClosedTrigger.asSignal()
    }
}
