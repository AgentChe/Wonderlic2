//
//  OTestView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.06.2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol OTestViewDelegate: AnyObject {
    func testViewDidFinished()
}

final class OTestView: OSlideView {
    weak var vc: UIViewController?
    weak var testViewDelegate: OTestViewDelegate?
    
    lazy var progressLabel = makeLabel()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var tableView = makeTableView()
    lazy var bottomView = makeBottomView()
    lazy var preloader = makePreloader()
    
    private lazy var questionManager = QuestionManager()
    
    private lazy var disposeBag = DisposeBag()
    private lazy var disposables = [Disposable]()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var selectedCourse = BehaviorRelay<Course?>(value: nil)
    private lazy var currentIndex = BehaviorRelay<Int?>(value: nil)
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OCourseViewDelegate
extension OTestView: OCourseViewDelegate {
    func courseViewDidSelected(course: Course) {
        selectedCourse.accept(course)
    }
}

// MARK: Private
private extension OTestView {
    func initialize() {
        backgroundColor = Appearance.main300
        
        let course = selectedCourse
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        course
            .flatMapLatest { [weak self] course -> Driver<Test> in
                guard let self = self else { return .never() }
                
                func source() -> Single<Test> {
                    self.questionManager
                        .obtainOnboardingTest(
                            courseId: course.id,
                            forceUpdate: true
                        )
                        .flatMap { test -> Single<Test> in
                            guard let test = test else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(test)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    self.openError()
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .drive(Binder(self) { base, test in
                base.start(questions: test.questions) {
                    base.testViewDelegate?.testViewDidFinished()
                }
            })
            .disposed(by: disposeBag)
        
        activity
            .drive(Binder(self) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .flatMapFirst { [weak self] void -> Observable<Bool> in
                guard let self = self else { return .empty() }
                
                let isSaved = self.favoriteButton.isFavorite
                let questionId = self.favoriteButton.question.id
                
                func source() -> Single<Bool> {
                    let request = isSaved
                    ? self.questionManager.removeSavedQuestion(questionId: questionId)
                    : self.questionManager.saveQuestion(questionId: questionId)
                    
                    return request
                        .map { !isSaved }
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { error in self.openError() })
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, isFavorite in
                base.favoriteButton.isFavorite = isFavorite
            })
            .disposed(by: disposeBag)
    }
    
    func start(questions: [Question], completion: @escaping () -> Void) {
        setup(questions: questions, index: 0, completion: completion)
    }
    
    func setup(questions: [Question], index: Int, completion: @escaping () -> Void) {
        guard !questions.isEmpty, questions.indices.contains(index) else {
            completion()
            return
        }
        
        let question = questions[index]
        
        setup(question: question) { [weak self] in
            self?.setup(questions: questions, index: index + 1, completion: completion)
        }
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
        let progress = String(format: "%i/%i", index + 1, questions.count)
        progressLabel.attributedText = progress.attributed(with: attrs)
        
        currentIndex.accept(index + 1)
        
        favoriteButton.question = question
    }
    
    func setup(question: Question, completion: @escaping () -> Void) {
        disposables.forEach { $0.dispose() }
        disposables = []
        
        let questionElement = makeQuestion(question: question)
        
        tableView.setup(question: questionElement)
        
        let answer = tableView
            .selectedAnswersRelay
            .asDriver(onErrorDriveWith: .never())
        
        var bottomState = TestBottomView.State.hidden
        
        let answerDisposable = answer
            .map { answer -> TestBottomView.State in
                answer.answerIds.isEmpty ? .hidden : .confirm
            }
            .startWith(.hidden)
            .drive(Binder(bottomView) { base, state in
                base.setup(state: state)
                bottomState = state
            })
        disposables.append(answerDisposable)
        
        let tappedDisposable = bottomView.button.rx.tap
            .withLatestFrom(answer)
            .bind(to: Binder(self) { base, answer in
                switch bottomState {
                case .confirm:
                    bottomState = .next
                    base.bottomView.setup(state: .next)
                    
                    let resultElement = base.makeResult(question: question, currentAnswer: answer)
                    base.tableView.setup(question: resultElement)
                case .next:
                    completion()
                default:
                    break
                }
            })
        disposables.append(tappedDisposable)
    }
    
    func makeQuestion(question: Question) -> QuestionElement {
        let answers = question.answers.map { PossibleAnswerElement(id: $0.id,
                                                                   answer: $0.answer,
                                                                   answerHtml: $0.answerHtml,
                                                                   image: $0.image) }
        
        let content: [QuestionContentCollectionType] = [
            question.image.map { .image($0) },
            question.video.map { .video($0) }
        ].compactMap { $0 }
        
        let elements: [TestingCellType] = [
            !content.isEmpty ? .content(content) : nil,
            .question(question.question, html: question.questionHtml),
            .answers(answers)
        ].compactMap { $0 }
        
        var referenceCellType = [TestingCellType]()
        if let reference = question.reference, !reference.isEmpty {
            referenceCellType.append(.reference(reference))
        }
        
        let element = QuestionElement(id: question.id,
                                      elements: elements + referenceCellType,
                                      isMultiple: question.multiple,
                                      index: -1,
                                      isAnswered: question.isAnswered,
                                      questionsCount: -1,
                                      isSaved: question.isSaved)
        
        return element
    }
    
    func makeResult(question: Question, currentAnswer: AnswerElement) -> QuestionElement {
        let content: [QuestionContentCollectionType] = [
            question.image.map { .image($0) },
            question.video.map { .video($0) }
        ].compactMap { $0 }
        
        let elements: [TestingCellType] = [
            !content.isEmpty ? .content(content) : nil,
            .question(question.question, html: question.questionHtml)
        ].compactMap { $0 }
        
        let result = question.answers.map { questionAnswer -> AnswerResultElement in
            let state: AnswerState = currentAnswer.answerIds.contains(questionAnswer.id)
                ? questionAnswer.isCorrect ? .correct : .error
                : questionAnswer.isCorrect ? question.multiple ? .warning : .correct : .initial
            
            return AnswerResultElement(answer: questionAnswer.answer,
                                       answerHtml: questionAnswer.answerHtml,
                                       image: questionAnswer.image,
                                       state: state)
        }
        
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
        
        var referenceCellType = [TestingCellType]()
        if let reference = question.reference, !reference.isEmpty {
            referenceCellType.append(.reference(reference))
        }
        
        let element = QuestionElement(id: question.id,
                                      elements: elements + [.result(result)] + explanation + referenceCellType,
                                      isMultiple: question.multiple,
                                      index: -1,
                                      isAnswered: question.isAnswered,
                                      questionsCount: -1,
                                      isSaved: question.isSaved)
        
        return element
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension OTestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 98.scale : 70.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 148.scale : 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OTestView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> OQuestionFavoriteButton {
        let view = OQuestionFavoriteButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.layer.cornerRadius = 12.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.contentInset = UIEdgeInsets(top: 32.scale, left: 0, bottom: ScreenSize.isIphoneXFamily ? 148.scale : 110.scale, right: 0)
        view.backgroundColor = Appearance.main100
        view.separatorStyle = .none
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> TestBottomView {
        let view = TestBottomView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
