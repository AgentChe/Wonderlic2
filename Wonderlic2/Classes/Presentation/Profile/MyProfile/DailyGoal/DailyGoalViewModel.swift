//
//  DailyGoalViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import RxSwift
import RxCocoa

final class DailyGoalViewModel {
    typealias DailyGoalBundle = (minutes: Int, daysOfWeek: [DayOfWeek])
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var save = PublishRelay<DailyGoalBundle>()
    
    lazy var currentTestMinutes = makeCurrentTestMinutes()
    lazy var currentTestDaysOfWeek = makeCurrentTestDaysOfWeek()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension DailyGoalViewModel {
    func makeCurrentTestMinutes() -> Driver<Int> {
        profileManager
            .obtainTestMinutes(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeCurrentTestDaysOfWeek() -> Driver<[DayOfWeek]> {
        profileManager
            .obtainTestDaysOfWeek()
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSaved() -> Driver<Void> {
        save
            .flatMapLatest { [weak self] bundle -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let (testMinutes, testDaysOfWeek) = bundle
                
                func source() -> Single<Void> {
                    profileManager.set(
                        testMinutes: testMinutes,
                        testDaysOfWeek: testDaysOfWeek
                    )
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
