//
//  StudyModeViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import RxSwift
import RxCocoa

final class StudyModeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var newMode = PublishRelay<TestMode>()
    
    lazy var currentMode = makeCurrentMode()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StudyModeViewModel {
    func makeCurrentMode() -> Driver<TestMode> {
        profileManager
            .obtainTestMode(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSaved() -> Driver<Void> {
        newMode
            .flatMapLatest { [weak self] mode -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    profileManager.set(testMode: mode)
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
