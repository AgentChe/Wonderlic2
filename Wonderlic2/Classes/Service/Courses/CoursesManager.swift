//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

protocol CoursesManagerProtocol: AnyObject {
    func obtainCourses() -> Single<[Course]>
}

final class CoursesManager: CoursesManagerProtocol {
    enum Constants {
        static let courseKey = "courses_manager_course_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension CoursesManager {
    func obtainCourses() -> Single<[Course]> {
        let request = GetCourcesRequest(userToken: sessionManager.internalId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try Course.map(from: $0) }
    }
}
