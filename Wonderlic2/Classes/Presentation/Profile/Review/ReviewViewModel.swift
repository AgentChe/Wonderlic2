//
//  ReviewViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import RxSwift
import RxCocoa

final class ReviewViewModel {
    lazy var filter = PublishRelay<ReviewFilter>()
    lazy var nextPage = PublishRelay<Void>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var currentFilter = makeCurrentFilter()
    private lazy var examEnvironment = makeExamEnvironment()
    
    private lazy var profileManager = ProfileManager()
    private lazy var questionManager = QuestionManager()
    
    private lazy var paginationLoader = ReviewDataLoader(nextPage: nextPage.asObservable())
}

// MARK: Private
private extension ReviewViewModel {
    func makeElements() -> Driver<[ReviewTableElement]> {
        let passTestTrigger = QuestionMediator.shared.testPassed
            .asDriver(onErrorDriveWith: .never())
            .startWith(Void())
         
        return Driver
            .combineLatest(examEnvironment, currentFilter, passTestTrigger)
            .flatMapLatest { [weak self] args -> Driver<[Review]> in
                guard let self = self else {
                    return .never()
                }
                
                let (examEnvironment, filter, _) = args
                
                return self.makeLoader(
                    courseId: examEnvironment.course.id,
                    filter: filter
                ).scan([]) { $0 + $1 }
            }
            .map { reviews -> [ReviewTableElement] in
                var result = [ReviewTableElement]()
                
                reviews.enumerated().forEach { index, review in
                    result.append(.question(review))
                    
                    if index != (reviews.count - 1) {
                        result.append(.separator)
                    }
                }
                
                return result
            }
    }
    
    func makeLoader(courseId: Int, filter: Int) -> Driver<[Review]> {
        paginationLoader.load { [weak self] page -> Observable<Page<Review>> in
            guard let self = self else {
                return .empty()
            }

            return self.questionManager
                .obtainReview(courseId: courseId, mode: filter, offset: page * 20)
                .trackActivity(self.activity)
                .map { Page(page: page, data: $0) }
                .asObservable()
        }
    }
    
    func makeCurrentFilter() -> Driver<Int> {
        filter
            .map { filter -> Int in
                switch filter {
                case .all: return 0
                case .incorrect: return 1
                case .correct: return 2
                }
            }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
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
}
