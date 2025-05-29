//
//  GetOnboardingTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import Alamofire

struct GetOnboardingTestRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/testings/onboarding_set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "platform": 3
        ]
    }
}
