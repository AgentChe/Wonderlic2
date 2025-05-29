//
//  Stats.swift
//  ITExams
//
//  Created by Андрей Чернышев on 02.06.2022.
//

struct Stats: Codable, Hashable {
    let questionsTaken: Int
    let answeredQuestionsCount: Int
    let correctAnswersCount: Int
    let correntAnswersPercent: Int
    let totalQuestions: Int
    let streak: Int
    let longestStreak: Int
    let week: [Bool]
    let passRateProgress: [PassRateProgress]
    let subjectsProgress: [SubjectProgress]
}
