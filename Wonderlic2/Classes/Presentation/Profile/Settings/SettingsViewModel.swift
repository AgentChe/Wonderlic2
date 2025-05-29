//
//  SettingsViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    lazy var elements = makeElements()
    
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements() -> Driver<[SettingsTableElement]> {
        activeSubscription
            .map { activeSubscription -> [SettingsTableElement] in
                var result = [SettingsTableElement]()
                
                if !activeSubscription {
                    result.append(contentsOf: [
                        .premium,
                        .offset(32.scale)
                    ])
                }
                
                result.append(contentsOf: [
                    .profile,
                    .offset(32.scale),
                    .title("Settings.App".localized),
                    .offset(16.scale),
                    .app
                ])
                
                return result
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
