//
//  StatsTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import CoreGraphics

enum StatsTableElement {
    case offset(CGFloat)
    case main(StatsTableMain)
    case title(String)
    case unlockPremiumButton(Int)
    case dailyMetrics(StatsTableDailyMetrics)
    case passRate([PassRateProgress])
    case subject(SubjectProgress)
    case unlockPremiumFake
}

struct StatsTableMain {
    let answeredCount: Int
    let answeredPercent: Int
    let correctCount: Int
    let correctPercent: Int
    let totalCount: Int
}

struct StatsTableDailyMetrics {
    struct WeekDay {
        let day: String
        let isTaken: Bool
        let isPlanned: Bool
        let isCurrent: Bool
    }
    
    let currentStreak: Int
    let longestStreak: Int
    let week: [WeekDay]
}
