//
//  StatsViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 02.06.2022.
//

import RxSwift
import RxCocoa

final class StatsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var stats = makeStats()
    private lazy var examEnvironment = makeExamEnvironment()
    private lazy var selectedTestDaysOfWeek = makeSelectedTestDaysOfWeek()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var profileManager = ProfileManager()
    private lazy var statsManager = StatsManager()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StatsViewModel {
    func makeElements() -> Driver<[StatsTableElement]> {
        Driver
            .combineLatest(stats, selectedTestDaysOfWeek, activeSubscription) { [weak self] stats, daysOfWeek, activeSubscription -> [StatsTableElement] in
                guard let self = self else {
                    return []
                }
                
                var result = [StatsTableElement]()
                
                let main = StatsTableMain(answeredCount: stats.answeredQuestionsCount,
                                          answeredPercent: stats.questionsTaken,
                                          correctCount: stats.correctAnswersCount,
                                          correctPercent: stats.correntAnswersPercent,
                                          totalCount: stats.totalQuestions)
                result.append(.main(main))
                
                if !activeSubscription {
                    result.append(contentsOf: [
                        .offset(24.scale),
                        .unlockPremiumButton(stats.totalQuestions)
                    ])
                }
                
                result.append(contentsOf: [
                    .offset(32.scale),
                    .title("Stats.DailyMetrics.Title".localized),
                    .offset(16.scale),
                    self.makeDailyMetricsElement(stats: stats, selectedDaysOfWeek: daysOfWeek)
                ])
                
                if activeSubscription {
                    result.append(contentsOf: [
                        .offset(28.scale),
                        .title("Stats.PassRate.Title".localized),
                        .offset(16.scale),
                        .passRate(stats.passRateProgress)
                    ])
                    
                    if !stats.subjectsProgress.isEmpty {
                        result.append(contentsOf: [
                            .offset(32.scale),
                            .title("Stats.Subject.Title".localized)
                        ])
                        
                        stats.subjectsProgress.forEach { subject in
                            result.append(contentsOf: [
                                .offset(16.scale),
                                .subject(subject)
                            ])
                        }
                    }
                } else {
                    result.append(contentsOf: [
                        .offset(16.scale),
                        .unlockPremiumFake
                    ])
                }
                
                return result
            }
    }
    
    func makeDailyMetricsElement(stats: Stats, selectedDaysOfWeek: [DayOfWeek]) -> StatsTableElement {
        let taken = stats.week.enumerated().compactMap { index, takenInWeekDay -> (DayOfWeek, Bool)? in
            guard let dayOfWeek = DayOfWeek(weekDayNumber: index + 1) else {
                return nil
            }
            
            return (dayOfWeek, takenInWeekDay)
        }
        
        let week = [DayOfWeek.su, DayOfWeek.mn, DayOfWeek.tu, DayOfWeek.we, DayOfWeek.th, DayOfWeek.fr, DayOfWeek.sa]
            .map { dayOfWeek -> StatsTableDailyMetrics.WeekDay in
                let currentNumberWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? -1
                let currentWeekDay = DayOfWeek(weekDayNumber: currentNumberWeekDay)
                let isCurrent = currentWeekDay == dayOfWeek
                
                let isTaken = taken.first(where: { $0.0 == dayOfWeek })?.1 ?? false
                
                let isPlanned = selectedDaysOfWeek.contains(where: { $0 == dayOfWeek })
                
                return StatsTableDailyMetrics.WeekDay(day: dayOfWeek.oneLetter,
                                                      isTaken: isTaken,
                                                      isPlanned: isPlanned,
                                                      isCurrent: isCurrent)
            }
        
        let dailyMetrics = StatsTableDailyMetrics(currentStreak: stats.streak,
                                                  longestStreak: stats.longestStreak,
                                                  week: week)
        return .dailyMetrics(dailyMetrics)
    }
    
    func makeStats() -> Driver<Stats> {
        examEnvironment
            .flatMapLatest { [weak self] examEnvironment -> Driver<Stats> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Observable<Stats> {
                    let triggers = Signal
                        .merge(
                            StatsMediator.shared.resetedStats,
                            QuestionMediator.shared.testPassed
                        )
                        .asObservable()
                        .startWith(Void())
                    
                    return triggers
                        .flatMapLatest {
                            self.statsManager
                                .obtainStats(courseId: examEnvironment.course.id)
                                .flatMap { stats -> Single<Stats> in
                                    guard let stats = stats else {
                                        return .error(ContentError(.notContent))
                                    }
                                    
                                    return .just(stats)
                                }
                                .trackActivity(self.activity)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return source()
                    .retry(when: { err in
                        err.flatMapLatest {
                            trigger(error: $0)
                        }
                    })
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeExamEnvironment() -> Driver<ExamEnvironment> {
        let initial = profileManager
            .obtainExamEnvironment()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        let updated = ProfileMediator.shared
            .changedExamEnvironment
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, updated)
    }
    
    func makeSelectedTestDaysOfWeek() -> Driver<[DayOfWeek]> {
        let initial = profileManager
            .obtainTestDaysOfWeek()
            .map { $0 ?? [] }
            .asDriver(onErrorJustReturn: [])
        
        let updated = ProfileMediator.shared
            .changedTestDaysOfWeek
            .asDriver(onErrorJustReturn: [])
        
        return Driver.merge(initial, updated)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .compactMap { [weak self] in
                self?.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
