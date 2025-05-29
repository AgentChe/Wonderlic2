//
//  ResetStatsRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 18.05.2022.
//

import Alamofire

struct ResetStatsRequest: APIRequestBody {
    let userToken: String
    let courseId: Int

    var url: String {
        GlobalDefinitions.domain + "/api/stats/reset"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "user_token": userToken,
            "course_id": courseId,
            "platform": 3
        ]
    }
}
