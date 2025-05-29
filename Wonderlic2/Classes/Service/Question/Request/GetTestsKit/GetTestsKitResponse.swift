//
//  GetTestsKitResponse.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

final class GetTestsKitResponse {
    static func map(from response: Any) -> TestsKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let options = data["test_options"] as? [String: Any]
        else {
            return nil
        }
        
        let randomCount = options["random_size"] as? Int ?? 0
        let missedCount = options["missed_size"] as? Int ?? 0
        let quickCount = options["quick_size"] as? Int ?? 0
        let savedCount = options["saved_size"] as? Int ?? 0
        
        let subjectsArray = options["subjects"] as? [[String: Any]] ?? []
        let subjects = subjectsArray.compactMap { json -> Subject? in
            guard
                let id = json["id"] as? Int,
                let name = json["name"] as? String
            else {
                return nil
            }
            
            return Subject(id: id, name: name)
        }
        
        return TestsKit(randomCount: randomCount,
                        missedCount: missedCount,
                        quickCount: quickCount,
                        savedCount: savedCount,
                        subjects: subjects)
    }
}
