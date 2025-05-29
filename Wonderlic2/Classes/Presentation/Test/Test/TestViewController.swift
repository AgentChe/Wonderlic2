//
//  TestViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

protocol TestViewControllerDelegate: AnyObject {
    func testViewControllerDismiss()
    func testViewControllerClose(finish: TestFinish)
    func testViewControllerNeedPayment()
    func testViewController(finish: TestFinish)
}

final class TestViewController: UIViewController {
    weak var delegate: TestViewControllerDelegate?
    
    lazy var mainView = TestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    private let testType: TestType
    
    private init(testType: TestType) {
        self.testType = testType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .empty()
            }
            
            return self.openError()
        }
        
        viewModel.loadTestActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.activityView.startAnimating() : base.mainView.activityView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendAnswerActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.bottomView.preloader.start() : base.mainView.bottomView.preloader.stop()
            })
            .disposed(by: disposeBag)
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.progress
            .drive(Binder(self) { base, progress in
                base.update(progress: progress)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (answers, name) = args
                
                base.viewModel.answers.accept(answers)
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .startWith(.hidden)
            .drive(Binder(mainView.bottomView) {
                $0.setup(state: $1)
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomView.button.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .submit ? () : nil }
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.delegate?.testViewControllerDismiss()
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .next }
            .withLatestFrom(viewModel.courseName)
            .bind(to: Binder(self) { base, name in
                base.viewModel.didTapNext.accept(Void())
            })
            .disposed(by: disposeBag)
        
        viewModel.isEndOfTest
            .filter(!)
            .withLatestFrom(viewModel.testMode)
            .bind(with: self, onNext: { base, testMode in
                if testMode == .onAnExam {
                    base.viewModel.didTapNext.accept(Void())
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.expandContent
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (content, courseName) = args
                
                switch content {
                case let .image(url):
                    let controller = PhotoViewController.make(imageURL: url)
                    base.present(controller, animated: true)
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.needPayment
            .filter { $0 }
            .emit(to: Binder(self) { base, needPayment in
                base.delegate?.testViewControllerNeedPayment()
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .withLatestFrom(viewModel.userTestId)
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (userTestId, courseName) = args
                
                let finish = TestFinish(
                    userTestId: userTestId,
                    courseName: courseName,
                    testType: base.testType
                )
                
                base.delegate?.testViewControllerClose(finish: finish)
            })
            .disposed(by: disposeBag)
        
        viewModel.testFinish
            .drive(Binder(self) { base, element in
                base.delegate?.testViewController(finish: element)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType) -> TestViewController {
        let controller = TestViewController(testType: testType)
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.testType.accept(testType)
        return controller
    }
}

// MARK: Public
extension TestViewController {
    func restart(userTestId: Int) {
        viewModel.didTapRestart.accept(userTestId)
    }
}

// MARK: Private
private extension TestViewController {
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Question.Favorite.Check" : "Question.Favorite.Uncheck")
        mainView.favoriteButton.setImage(image, for: .normal)
    }
    
    func update(progress: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .textAlignment(.center)
        
        switch testType {
        case .qotd:
            mainView.titleLabel.attributedText = "Question.TodayTitle".localized.attributed(with: attrs)
        case .timed:
            mainView.titleLabel.attributedText = progress.attributed(with: attrs)
        default:
            mainView.titleLabel.attributedText = progress.attributed(with: attrs)
        }
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
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
