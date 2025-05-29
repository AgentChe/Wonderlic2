//
//  Profile.swift
//  ITExams
//
//  Created by Андрей Чернышев on 18.05.2022.
//

import Foundation

struct Profile: Codable, Hashable {
    let testMode: TestMode?
    let testMinutes: Int?
    let examDate: Date?
    let selectedCourse: Course?
}
