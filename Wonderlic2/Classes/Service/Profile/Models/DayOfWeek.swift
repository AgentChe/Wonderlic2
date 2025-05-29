//
//  DayOfWeek.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

enum DayOfWeek: String, Codable {
    case  su, mn, tu, we, th, fr, sa
}

// MARK: Public
extension DayOfWeek {
    init?(weekDayNumber: Int) {
        switch weekDayNumber {
        case 1: self = .su
        case 2: self = .mn
        case 3: self = .tu
        case 4: self = .we
        case 5: self = .th
        case 6: self = .fr
        case 7: self = .sa
        default: return nil
        }
    }
    
    var short: String {
        switch self {
        case .su:
            return "DayOfWeek.Short.Su".localized
        case .mn:
            return "DayOfWeek.Short.Mn".localized
        case .tu:
            return "DayOfWeek.Short.Tu".localized
        case .we:
            return "DayOfWeek.Short.We".localized
        case .th:
            return "DayOfWeek.Short.Th".localized
        case .fr:
            return "DayOfWeek.Short.Fr".localized
        case .sa:
            return "DayOfWeek.Short.Sa".localized
        }
    }
    
    var oneLetter: String {
        switch self {
        case .su:
            return "DayOfWeek.OneLetter.Su".localized
        case .mn:
            return "DayOfWeek.OneLetter.Mn".localized
        case .tu:
            return "DayOfWeek.OneLetter.Tu".localized
        case .we:
            return "DayOfWeek.OneLetter.We".localized
        case .th:
            return "DayOfWeek.OneLetter.Th".localized
        case .fr:
            return "DayOfWeek.OneLetter.Fr".localized
        case .sa:
            return "DayOfWeek.OneLetter.Sa".localized
        }
    }
}
