//
//  ProfileMediator.swift
//  ITExams
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import RxCocoa

protocol ProfileMediatorDelegate: AnyObject {
    func prodileMediatorDidChanged(dateOfExam: Date)
    func prodileMediatorDidChanged(examEnvironment: ExamEnvironment)
    func prodileMediatorDidChanged(testMode: TestMode)
    func prodileMediatorDidChanged(testMinutes: Int)
    func prodileMediatorDidChanged(testDaysOfWeek: [DayOfWeek])
}

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private let changedDateOfExamTrigger = PublishRelay<Date>()
    private let changedExamEnvironmentTrigger = PublishRelay<ExamEnvironment>()
    private let changedTestModeTrigger = PublishRelay<TestMode>()
    private let changedTestMinutesTrigger = PublishRelay<Int>()
    private let changedTestDaysOfWeekTrigger = PublishRelay<[DayOfWeek]>()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension ProfileMediator {
    func notifyAboutChanged(dateOfExam: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(dateOfExam: dateOfExam)
            }
            
            self?.changedDateOfExamTrigger.accept(dateOfExam)
        }
    }
    
    func notifyAboutChanged(examEnvironment: ExamEnvironment) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(examEnvironment: examEnvironment)
            }
            
            self?.changedExamEnvironmentTrigger.accept(examEnvironment)
        }
    }
    
    func notifyAboutChanged(testMode: TestMode) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(testMode: testMode)
            }
            
            self?.changedTestModeTrigger.accept(testMode)
        }
    }
    
    func notifyAboutChanged(testMinutes: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(testMinutes: testMinutes)
            }
            
            self?.changedTestMinutesTrigger.accept(testMinutes)
        }
    }
    
    func notifyAboutChanged(testDaysOfWeek: [DayOfWeek]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(testDaysOfWeek: testDaysOfWeek)
            }
            
            self?.changedTestDaysOfWeekTrigger.accept(testDaysOfWeek)
        }
    }
}

// MARK: Triggers(Rx)
extension ProfileMediator {
    var changedDateOfExam: Signal<Date> {
        changedDateOfExamTrigger.asSignal()
    }
    
    var changedExamEnvironment: Signal<ExamEnvironment> {
        changedExamEnvironmentTrigger.asSignal()
    }
    
    var changedTestMode: Signal<TestMode> {
        changedTestModeTrigger.asSignal()
    }
    
    var changedTestMinutes: Signal<Int> {
        changedTestMinutesTrigger.asSignal()
    }
    
    var changedTestDaysOfWeek: Signal<[DayOfWeek]> {
        changedTestDaysOfWeekTrigger.asSignal()
    }
}

// MARK: Observer
extension ProfileMediator {
    func add(delegate: ProfileMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ProfileMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: ProfileMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
