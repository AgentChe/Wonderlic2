//
//  MyProfileViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import RxSwift
import RxCocoa

final class MyProfileViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var resetStats = PublishRelay<Void>()
    
    lazy var elements = makeElements()
    
    private lazy var dateOfExam = makeDateOfExam()
    private lazy var examEnvironment = makeExamEnvironment()
    private lazy var studyMode = makeStudyMode()
    private lazy var dailyGoal = makeDailyGoal()
    private lazy var resetedStats = makeResetStats()
    
    private lazy var profileManager = ProfileManager()
    private lazy var statsManager = StatsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension MyProfileViewModel {
    func makeElements() -> Driver<[MyProfileTableElement]> {
        Driver
            .combineLatest(
                dateOfExam,
                examEnvironment,
                studyMode,
                dailyGoal,
                resetedStats
            )
            .map { stub -> [MyProfileTableElement] in
                let (dateOfExam, examEnvironment, studyMode, dailyGoal, resetedStats) = stub
                
                return [
                    .dateOfExam(dateOfExam),
                    .course(examEnvironment?.course.name ?? ""),
                    .studyMode(studyMode),
                    .dailyGoal(dailyGoal),
                    .resetProgress(resetedStats)
                ]
            }
    }
    
    func makeDateOfExam() -> Driver<String> {
        let initial = profileManager
            .obtainDateOfExam(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedDateOfExam
            .map { date -> Date? in
                date
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver
            .merge(initial, updated)
            .map { date -> String in
                guard let date = date else {
                    return ""
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy"
                formatter.locale = Locale.current
                return formatter.string(from: date)
            }
    }
    
    func makeCourse() -> Driver<Course?> {
        examEnvironment.map { $0?.course }
    }
    
    func makeExamEnvironment() -> Driver<ExamEnvironment?> {
        let initial = profileManager
            .obtainExamEnvironment()
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedExamEnvironment
            .map { examEnvironment -> ExamEnvironment? in
                examEnvironment
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeStudyMode() -> Driver<String> {
        let initial = profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedTestMode
            .map { mode -> TestMode? in
                mode
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver
            .merge(initial, updated)
            .map { mode -> String in
                guard let mode = mode else {
                    return ""
                }
                
                switch mode {
                case .noExplanations:
                    return "MyProfile.StudyMode.WithoutExplanations".localized
                case .fullComplect:
                    return "MyProfile.StudyMode.FullSupport".localized
                case .onAnExam:
                    return "MyProfile.StudyMode.Exam-style".localized
                }
            }
    }
    
    func makeDailyGoal() -> Driver<String> {
        let initial = profileManager
            .obtainTestMinutes(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedTestMinutes
            .map { testMinutes -> Int? in
                testMinutes
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
            .map { testMinutes -> String in
                guard let testMinutes = testMinutes else {
                    return ""
                }
                
                return String(format: "MyProfile.min".localized, testMinutes)
            }
    }
    
    func makeResetStats() -> Driver<Bool> {
        let start = resetStats.map { true }
        
        let action = resetStats
            .withLatestFrom(examEnvironment)
            .flatMapLatest { [weak self] examEnvironment -> Observable<Bool> in
                guard let self = self, let examEnvironment = examEnvironment else {
                    return .never()
                }

                func source() -> Single<Void> {
                    self.statsManager
                        .resetStats(courseId: examEnvironment.course.id)
                }

                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }

                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .asObservable()
                    .map { false }
            }
        
        return Observable
            .merge(start, action)
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
    }
}
