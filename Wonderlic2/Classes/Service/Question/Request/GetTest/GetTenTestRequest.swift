//
//  GetTenTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Alamofire

struct GetTenTestRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    let activeSubscription: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/testings/ten_set"
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
