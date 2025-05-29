//
//  GetCoursesRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import Alamofire

struct GetCourcesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/courses/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "platform": 3
        ]
    }
}
