//
//  CustomMadeTestViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import RxSwift
import RxCocoa

final class CustomMadeTestViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var subjects = makeSubjects()
    private lazy var examEnvironment = makeExamEnvironment()
    
    private lazy var profileManager = ProfileManager()
    private lazy var questionManager = QuestionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CustomMadeTestViewModel {
    func makeElements() -> Driver<[CustomMadeTestTableElement]> {
        subjects.map { subjects -> [CustomMadeTestTableElement] in
            var result = [CustomMadeTestTableElement]()
            
            let subjectsElement = subjects.map {
                CustomMadeTestSubjectElement(subject: $0, isSelected: false)
            }
            let missedQuestionsElement = CustomMadeTestSwitchElement(title: "CustomMadeTest.MissedQuestions".localized,
                                                                     isOn: false)
            let answeredQuestionsElement = CustomMadeTestSwitchElement(title: "CustomMadeTest.AnsweredQuestions".localized,
                                                                       isOn: false)
            let questionsCount = (5...40).reduce([]) { array, count -> [QuestionsCountCollectionElement] in
                let element = QuestionsCountCollectionElement(count: count, isSelected: count == 5)
                return array + [element]
            }
            let collectorElement = CustomMadeTestCollectorElement(subjects: subjectsElement,
                                                                  isOnMissedQuestions: missedQuestionsElement,
                                                                  isOnAnsweredQuestions: answeredQuestionsElement,
                                                                  questionsCount: questionsCount)
            
            result.append(.startTest(collectorElement))
            if !subjectsElement.isEmpty {
                result.append(contentsOf: [
                    .offset(26.scale),
                    .title("CustomMadeTest.Subjects".localized),
                    .offset(18.scale),
                    .subjects(subjectsElement),
                ])
            }
            result.append(contentsOf: [
                .offset(26.scale),
                .title("CustomMadeTest.QuestionType".localized),
                .offset(18.scale),
                .missedQuestions(missedQuestionsElement),
                .offset(12.scale),
                .missedQuestions(answeredQuestionsElement),
                .offset(26.scale),
                .title("CustomMadeTest.QuestionsCount".localized),
                .offset(18.scale),
                .questionsCount(questionsCount)
            ])
            
            return result
        }
    }
    
    func makeSubjects() -> Driver<[Subject]> {
        examEnvironment
            .flatMapLatest { [weak self] examEnvironment -> Driver<[Subject]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Subject]> {
                    self.questionManager
                        .obtainTestsKit(courseId: examEnvironment.course.id)
                        .map { $0?.subjects ?? [] }
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
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeExamEnvironment() -> Driver<ExamEnvironment> {
        profileManager
            .obtainExamEnvironment()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
    }
}
