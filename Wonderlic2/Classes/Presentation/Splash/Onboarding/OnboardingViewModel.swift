//
//  OnboardingViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case paygate, main
    }
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension OnboardingViewModel {
    func whatNext() -> Step {
        sessionManager.hasActiveSubscriptions() ? .main : .paygate
    }
}
