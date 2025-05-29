//
//  QuestionViewerViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import RxSwift
import RxCocoa

final class QuestionViewerViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let didTapMark = PublishRelay<Bool>()
    
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var elements = makeElements()
    
    private let question: BehaviorRelay<Question>
    private let answeredIds: BehaviorRelay<[Int]>
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(question: Question, answeredIds: [Int]) {
        self.question = BehaviorRelay(value: question)
        self.answeredIds = BehaviorRelay(value: answeredIds)
    }
}

// MARK: Private
private extension QuestionViewerViewModel {
    func makeIsSavedQuestion() -> Driver<Bool> {
        let initial = question
            .asDriver()
            .map { $0.isSaved }
        
        let mark = didTapMark
            .withLatestFrom(question) { ($0, $1.id) }
            .asDriver(onErrorDriveWith: .never())
        
        let isSavedQuestion = mark
            .flatMapFirst { [weak self] isSaved, questionId -> Driver<Bool> in
                guard let self = self else { return .empty() }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                        ? self.questionManager.removeSavedQuestion(questionId: questionId)
                        : self.questionManager.saveQuestion(questionId: questionId)

                    return request
                        .map { !isSaved }
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, isSavedQuestion)
    }
    
    func makeElements() -> Driver<[TestingCellType]> {
        Driver
            .combineLatest(question.asDriver(), answeredIds.asDriver())
            .map { [weak self] question, answeredIds -> [TestingCellType] in
                guard let self = self else {
                    return []
                }
                
                var result = [TestingCellType]()
                
                let questionCells = self.makeQuestionCells(question: question)
                result.append(contentsOf: questionCells)
                
                let answersCells = self.makeAnswersCells(question: question, answeredIds: answeredIds)
                result.append(contentsOf: answersCells)
                
                let explanationCells = self.makeExplanationCells(question: question)
                result.append(contentsOf: explanationCells)
                
                if let reference = question.reference, !reference.isEmpty {
                    result.append(.reference(reference))
                }
                
                return result
            }
    }
    
    func makeQuestionCells(question: Question) -> [TestingCellType] {
        let content: [QuestionContentCollectionType] = [
            question.image.map { .image($0) },
            question.video.map { .video($0) }
        ].compactMap { $0 }
        
        return [
            !content.isEmpty ? .content(content) : nil,
            .question(question.question, html: question.questionHtml)
        ].compactMap { $0 }
    }
    
    func makeAnswersCells(question: Question, answeredIds: [Int]) -> [TestingCellType] {
        let result = question.answers.compactMap { answer -> AnswerResultElement in
            let state: AnswerState = answeredIds.contains(answer.id)
                    ? answer.isCorrect ? .correct : .error
                    : answer.isCorrect ? question.multiple ? .warning : .correct : .initial
            
            return AnswerResultElement(answer: answer.answer,
                                       answerHtml: answer.answerHtml,
                                       image: answer.image,
                                       state: state)
        }
        
        return [.result(result)]
    }
    
    func makeExplanationCells(question: Question) -> [TestingCellType] {
        let explanation: [TestingCellType]
    
        let explanationText: TestingCellType?
        if (question.explanation != nil || question.explanationHtml != nil) {
            explanationText = .explanationText(question.explanation ?? "", html: question.explanationHtml ?? "")
        } else {
            explanationText = nil
        }

        let explanationImages = question.media.map { TestingCellType.explanationImage($0)}

        if explanationText != nil || !explanationImages.isEmpty {
            explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
        } else {
            explanation = []
        }
        
        return explanation
    }
}
