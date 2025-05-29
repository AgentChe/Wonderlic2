//
//  PracticeDateOfExamViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import RxSwift
import RxCocoa

final class PracticeDateOfExamViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var newDate = PublishRelay<Date>()
    
    lazy var currentDate = makeCurrentDate()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension PracticeDateOfExamViewModel {
    func makeCurrentDate() -> Driver<Date> {
        profileManager
            .obtainDateOfExam(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSaved() -> Driver<Void> {
        newDate
            .flatMapLatest { [weak self] date -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    profileManager.set(examDate: date)
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
