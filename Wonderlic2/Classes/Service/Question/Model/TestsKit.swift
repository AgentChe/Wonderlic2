//
//  TestsKit.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

struct TestsKit: Codable, Hashable {
    let randomCount: Int
    let missedCount: Int
    let quickCount: Int
    let savedCount: Int
    let subjects: [Subject]
}
