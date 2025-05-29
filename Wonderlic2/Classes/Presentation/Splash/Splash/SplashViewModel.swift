//
//  SplashViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 22.02.2022.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class SplashViewModel {
    enum Route {
        case onboarding, paygateTransitionMain, main
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension SplashViewModel {
    struct Input {
        let didSDKConfigured: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let login = login(didSDKConfigured: input.didSDKConfigured)
        let library = makeLibrary(login: login)
        
        return Output(
            route: makeRoute(library: library)
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeRoute(library: Signal<Void>) -> Driver<Route> {
        library
            .compactMap { [weak self] void -> Route? in
                guard let self else { return nil }
                
                guard OnboardingViewController.wasViewed() else { return .onboarding }
                
                guard sessionManager.hasActiveSubscriptions() else { return .paygateTransitionMain }
                
                return .main
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeLibrary(login: Signal<Void>) -> Signal<Void> {
        login
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let profile = profileManager
                        .obtainProfile(forceUpdate: true)
                        .mapToVoid()
                    
                    return profile
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
    }
    
    func login(didSDKConfigured: Signal<Void>) -> Signal<Void> {
        didSDKConfigured
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let anonymousId = sessionManager.anonymousId
                    let internalId = sessionManager.internalId
                    
                    return anonymousId == internalId ? profileManager.login(userToken: internalId) : profileManager.syncTokens(oldToken: anonymousId, newToken: internalId)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
    }
}
