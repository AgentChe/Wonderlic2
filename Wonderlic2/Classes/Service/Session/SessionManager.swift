//
//  SessionManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxCocoa
import OtterScaleiOS

protocol SessionManagerProtocol {
    var anonymousId: String { get }
    var internalId: String { get }
    func hasActiveSubscriptions() -> Bool
}

final class SessionManager {}

// MARK: SessionManagerProtocol
extension SessionManager: SessionManagerProtocol {
    var anonymousId: String {
        OtterScale.shared.getAnonymousID()
    }
    
    var internalId: String {
        OtterScale.shared.getInternalID()
    }
    
    func hasActiveSubscriptions() -> Bool {
        guard let paymentData = OtterScale.shared.getPaymentData() else {
            return false
        }

        let subscriptions = paymentData.subscriptions.appleAppStore
            + paymentData.subscriptions.googlePlay
            + paymentData.subscriptions.stripe
            + paymentData.subscriptions.paypal
        let nonConsumables = paymentData.nonConsumables.appleAppStore
            + paymentData.nonConsumables.googlePlay
            + paymentData.nonConsumables.stripe
            + paymentData.nonConsumables.paypal

        let hasValidSubscription = subscriptions.contains(where: { $0.valid })
        let hasValidNonConsumable = nonConsumables.contains(where: { $0.valid })

        return hasValidSubscription || hasValidNonConsumable
    }
}
