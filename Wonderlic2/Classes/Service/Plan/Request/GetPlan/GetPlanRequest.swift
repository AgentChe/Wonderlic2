//
//  GetPlanRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

import Alamofire

struct GetPlanRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/plan/list"
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
