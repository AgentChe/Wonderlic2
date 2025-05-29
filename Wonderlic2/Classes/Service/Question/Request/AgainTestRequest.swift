//
//  AgainTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Alamofire

struct AgainTestRequest: APIRequestBody {
    let userToken: String
    let userTestId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/testings/again"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "user_test_id": userTestId,
            "platform": 3
        ]
    }
}
