//
//  GetTestModeRequest.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import Alamofire

struct GetProfileRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/show"
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
