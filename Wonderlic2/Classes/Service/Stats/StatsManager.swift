//
//  StatsManager.swift
//  ITExams
//
//  Created by Андрей Чернышев on 18.05.2022.
//

import RxSwift

protocol StatsManagerProtocol {
    func resetStats(courseId: Int) -> Single<Void>
    func obtainStats(courseId: Int) -> Single<Stats?>
    func obtainTestStats(courseId: Int, userTestId: Int) -> Single<TestStats?>
}

final class StatsManager: StatsManagerProtocol {
    private lazy var xorRequestWrapper = XORRequestWrapper()
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension StatsManager {
    func resetStats(courseId: Int) -> Single<Void> {
        let request = ResetStatsRequest(
            userToken: sessionManager.internalId,
            courseId: courseId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                StatsMediator.shared.notifyAboutResetedStats()
            })
    }
    
    func obtainStats(courseId: Int) -> Single<Stats?> {
        let request = GetStatsRequest(
            userToken: sessionManager.internalId,
            courseId: courseId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetStatsResponseMapper.map(from: $0) }
    }
    
    func obtainTestStats(courseId: Int, userTestId: Int) -> Single<TestStats?> {
        let request = GetTestStatsRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            userTestId: userTestId,
            peek: true
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestStatsResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
}
