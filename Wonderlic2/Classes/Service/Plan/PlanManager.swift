//
//  PlanManager.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

import RxSwift

protocol PlanManagerProtocol {
    func obtainPlan(courseId: Int) -> Single<Plan?>
}

final class PlanManager: PlanManagerProtocol {
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension PlanManager {
    func obtainPlan(courseId: Int) -> Single<Plan?> {
        let request = GetPlanRequest(
            userToken: sessionManager.internalId,
            courseId: courseId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetPlanResponseMapper.map(from: $0) }
    }
}
