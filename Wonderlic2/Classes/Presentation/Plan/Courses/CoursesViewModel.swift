//
//  CoursesViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import RxSwift
import RxCocoa

final class CoursesViewModel {
    enum Route {
        case dismiss
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    private lazy var coursesManager = CoursesManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension CoursesViewModel {
    struct Input {
        let didTapCancel: Signal<Void>
        let didTapSaveCourse: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CoursesTableCourseElement]>
        let activity: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(
            initialCurrentCourse: makeInitialCurrentCourse(),
            allCourses: makeAllCourses()
        )
        
        return Output(
            elements: elements,
            activity: activity.asDriver(),
            route: makeRoute(
                didTapCancel: input.didTapCancel,
                didTapSaveCourse: input.didTapSaveCourse,
                elements: elements
            )
        )
    }
}

// MARK: Private
private extension CoursesViewModel {
    func makeElements(
        initialCurrentCourse: Driver<Course?>,
        allCourses: Driver<[Course]>
    ) -> Driver<[CoursesTableCourseElement]> {
        Driver
            .combineLatest(initialCurrentCourse, allCourses) { initialCurrentCourse, allCourses -> [CoursesTableCourseElement] in
                allCourses.map { course -> CoursesTableCourseElement in
                    CoursesTableCourseElement(
                        course: course,
                        isCurrent: course.id == initialCurrentCourse?.id,
                        isSelected: course.id == initialCurrentCourse?.id
                    )
                }
            }
    }
    
    func makeInitialCurrentCourse() -> Driver<Course?> {
        profileManager
            .obtainExamEnvironment()
            .map { $0?.course }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAllCourses() -> Driver<[Course]> {
        func source() -> Single<[Course]> {
            coursesManager
                .obtainCourses()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            tryAgain?(error) ?? .empty()
        }
        
        return self.observableRetrySingle
            .retry(
                source: { source() },
                trigger: { trigger(error: $0) }
            )
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(
        didTapCancel: Signal<Void>,
        didTapSaveCourse: Signal<Void>,
        elements: Driver<[CoursesTableCourseElement]>
    ) -> Driver<Route> {
        let cancel = didTapCancel
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let save = didTapSaveCourse
            .withLatestFrom(elements)
            .compactMap { elements -> Course? in
                elements.first(where: { $0.isSelected })?.course
            }
            .flatMapLatest { [weak self] course -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    profileManager
                        .set(course: course)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
                    .map { Route.dismiss }
            }
        
        return Driver
            .merge(cancel, save)
    }
}
