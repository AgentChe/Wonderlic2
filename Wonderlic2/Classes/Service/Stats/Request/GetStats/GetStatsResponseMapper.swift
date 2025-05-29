//
//  GetStatsResponseMapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 02.06.2022.
//

import Foundation

final class GetStatsResponseMapper {
    static func map(from response: Any) throws -> Stats? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let code = json["_code"] as? Int
        else {
            throw ContentError(.notContent)
        }
        
        guard code == 200 else {
            throw ContentError(.notContent)
        }
        
        guard
            let main = data["main"] as? [String: Any],
            let totalQuestions = main["total_questions"] as? Int,
            let week = main["calendar"] as? [Bool]
        else {
            return nil
        }
        
        let questionsTaken = main["questions_taken"] as? Int ?? 0
        let answeredQuestionsCount = main["answered_questions"] as? Int ?? 0
        let correctAnswersCount = main["correct_answers_num"] as? Int ?? 0
        let correntAnswersPercent = main["correct_answers"] as? Int ?? 0
        let streak = main["streak"] as? Int ?? 0
        let longestStreak = main["longest_streak"] as? Int ?? 0
        
        let passRateProgressArray = main["pass_rate_progress"] as? [[String: Any]] ?? []
        let passRateProgress = passRateProgressArray.compactMap { json -> PassRateProgress? in
            guard
                let timestamp = json["date"] as? Double,
                let rate = json["rate"] as? Int
            else {
                return nil
            }
            
            let date = Date(timeIntervalSince1970: timestamp)
            
            return PassRateProgress(date: date,
                                    rate: rate)
        }
        
        let subjectsProgressArray = main["subject_progress"] as? [[String: Any]] ?? []
        let subjectsProgress = subjectsProgressArray.compactMap { json -> SubjectProgress? in
            guard
                let name = json["name"] as? String,
                let rate = json["rate"] as? Int,
                let answeredCount = json["answered_count"] as? Int,
                let totalCount = json["total_count"] as? Int
            else {
                return nil
            }
            
            return SubjectProgress(name: name,
                                   rate: rate,
                                   answeredCount: answeredCount,
                                   totalCount: totalCount)
        }
        
        return Stats(questionsTaken: questionsTaken,
                     answeredQuestionsCount: answeredQuestionsCount,
                     correctAnswersCount: correctAnswersCount,
                     correntAnswersPercent: correntAnswersPercent,
                     totalQuestions: totalQuestions,
                     streak: streak,
                     longestStreak: longestStreak,
                     week: week,
                     passRateProgress: passRateProgress,
                     subjectsProgress: subjectsProgress)
    }
}
