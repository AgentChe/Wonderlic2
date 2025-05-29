//
//  Course.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

struct Course: Codable, Hashable {
    let id: Int
    let name: String
    let subTitle: String
    let isMain: Bool
    let sort: Int
}

// MARK: Public
extension Course {
    static func map(from response: Any) throws -> [Course] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let code = json["_code"] as? Int,
            let courses = data["courses"] as? [[String: Any]]
        else {
            throw ContentError(.notContent)
        }
        
        guard code == 200 else {
            throw ContentError(.notContent)
        }
        
        return courses.compactMap { json -> Course? in
            Course(json: json)
        }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let subTitle = json["sub"] as? String,
            let isMain = json["main"] as? Bool,
            let sort = json["sort"] as? Int
        else { return nil }
        
        self.id = id
        self.name = name
        self.subTitle = subTitle
        self.isMain = isMain
        self.sort = sort
    }
}
