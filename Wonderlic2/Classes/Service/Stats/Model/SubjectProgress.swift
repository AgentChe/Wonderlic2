//
//  SubjectProgress.swift
//  ITExams
//
//  Created by Андрей Чернышев on 02.06.2022.
//

struct SubjectProgress: Codable, Hashable {
    let name: String
    let rate: Int
    let answeredCount: Int
    let totalCount: Int
}
