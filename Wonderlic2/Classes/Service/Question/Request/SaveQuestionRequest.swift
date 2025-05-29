//
//  SaveQuestionRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.06.2022.
//

import Alamofire

struct SaveQuestionRequest: APIRequestBody {
    let userToken: String
    let questionId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/tests/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "question_id": questionId,
            "platform": 3
        ]
    }
}
