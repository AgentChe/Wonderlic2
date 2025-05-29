//
//  Answer.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import Foundation

struct Answer: Codable, Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let isCorrect: Bool
}
