//
//  GetTestResponseMapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

final class GetTestResponseMapper {
    static func map(from response: Any, key: String? = nil) -> Test? {
        if let key = key {
            return encryptionMap(from: response, key: key)
        }
        
        return defaultMap(from: response)
    }
    
    static func map(json: [String: Any]) -> Test? {
        guard
            let data = json["_data"] as? [String: Any],
            let userTestId = data["user_test_id"] as? Int,
            let questionsJSON = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let paid = data["paid"] as? Bool ?? false
        
        let questions = QuestionMapper.map(from: questionsJSON)
        
        guard !questions.isEmpty else {
            return nil
        }
        
        return Test(
            paid: paid,
            userTestId: userTestId,
            questions: questions
        )
    }
}

// MARK: Private
private extension GetTestResponseMapper {
    static func encryptionMap(from response: Any, key: String) -> Test? {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: key)
        else {
            return nil
        }
        
        return map(json: json)
    }
    
    static func defaultMap(from response: Any) -> Test? {
        guard let json = response as? [String: Any] else {
            return nil
        }
        
        return map(json: json)
    }
}
