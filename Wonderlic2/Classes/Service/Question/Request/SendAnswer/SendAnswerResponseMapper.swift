//
//  SendAnswerResponseMapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Foundation

struct SendAnswerResponseMapper {
    static func map(from response: Any) -> Bool? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        guard let isEnd = data["end_of_test"] as? Bool else {
            return nil
        }
        
        return isEnd
    }
}
