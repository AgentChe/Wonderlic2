//
//  GetFinalTestRequest.swift
//  AAMACMA2
//
//  Created by Андрей Чернышев on 10.08.2025.
//

import Alamofire

struct GetFinalTestRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    let activeSubscription: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/plan/final_exam"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription,
            "platform": 3
        ]
    }
}
