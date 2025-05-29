//
//  TestStatsViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import RxSwift
import RxCocoa

final class TestStatsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var userTestId = BehaviorRelay<Int?>(value: nil)
    lazy var filter = BehaviorRelay<TestStatsFilter>(value: .all)
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var stats = makeStats()
    private lazy var examEnvironment = makeExamEnvironment()
    
    private lazy var statsManager = StatsManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension TestStatsViewModel {
    func makeElements() -> Driver<[TestStatsTableElement]> {
        Driver
            .combineLatest(stats, filter.asDriver())
            .map { element, filter -> [TestStatsTableElement] in
                var result: [TestStatsTableElement] = [
                    .progress(element.userScore),
                    .offset(21.scale),
                    .info(TestStatsInfo(
                        correctNumber: element.correctNumbers,
                        totalNumber: element.correctNumbers + element.incorrectNumbers,
                        quizTime: element.userTime,
                        weakSubject: element.weakestSubject
                    )),
                    .offset(24.scale),
                    .actions,
                    .offset(24.scale),
                    .title("TestStats.Review".localized),
                    .offset(16.scale),
                    .filters,
                    .offset(16.scale)
                ]
                
                let questions: [TestStatsAnswer]
                switch filter {
                case .all:
                    questions = element.questions
                case .correct:
                    questions = element.questions.filter { $0.isCorrectly }
                case .incorrect:
                    questions = element.questions.filter { !$0.isCorrectly }
                }
                
                questions.enumerated().forEach { index, question in
                    let isLast = index == (questions.count - 1)
                    
                    let element = TestStatsTableAnswer(question: question.question,
                                                       answeredIds: question.userAnswersIds,
                                                       correct: question.isCorrectly,
                                                       separatorHidden: isLast,
                                                       topCorners: index == 0,
                                                       bottomCorners: isLast)
                    result.append(.answer(element))
                }
                
                return result
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeStats() -> Driver<TestStats> {
        Driver
            .combineLatest(
                userTestId.compactMap { $0 }
                    .asDriver(onErrorDriveWith: .never()),
                
                examEnvironment
            )
            .flatMapLatest { [weak self] args -> Driver<TestStats> in
                guard let self = self else {
                    return .empty()
                }
                
                let (userTestId, examEnvironment) = args
                
                func source() -> Single<TestStats> {
                    self.statsManager
                        .obtainTestStats(
                            courseId: examEnvironment.course.id,
                            userTestId: userTestId
                        )
                        .flatMap { stats -> Single<TestStats> in
                            guard let stats = stats else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(stats)
                        }
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
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeExamEnvironment() -> Driver<ExamEnvironment> {
        profileManager
            .obtainExamEnvironment()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
    }
}
