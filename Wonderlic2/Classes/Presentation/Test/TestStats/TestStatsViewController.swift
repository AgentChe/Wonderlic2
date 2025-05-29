//
//  TestStatsViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import RxSwift

protocol TestStatsViewControllerDelegate: AnyObject {
    func testStatsViewControllerDidTapped(event: TestStatsViewController.Event)
}

final class TestStatsViewController: UIViewController {
    enum Event {
        case close
        case restart(Int)
        case nextTest
    }
    
    weak var delegate: TestStatsViewControllerDelegate?
    
    lazy var mainView = TestStatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestStatsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.delegate?.testStatsViewControllerDidTapped(event: .close)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension TestStatsViewController {
    static func make(finish: TestFinish) -> TestStatsViewController {
        let vc = TestStatsViewController()
        vc.viewModel.userTestId.accept(finish.userTestId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: TestStatsTableViewDelegate
extension TestStatsViewController: TestStatsTableViewDelegate {
    func testStatsTableDidTappedRestart() {
        guard let userTestId = viewModel.userTestId.value else {
            return
        }
        
        delegate?.testStatsViewControllerDidTapped(event: .restart(userTestId))
    }
    
    func testStatsTableDidTappedNextTest() {
        delegate?.testStatsViewControllerDidTapped(event: .nextTest)
    }
    
    func testStatsTableDidTapped(filter: TestStatsFilter) {
        viewModel.filter.accept(filter)
    }
    
    func testStatsTableDidTapped(question: TestStatsTableAnswer) {
        let vc = QuestionViewerViewController.make(question: question.question,
                                                   answeredIds: question.answeredIds)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension TestStatsViewController {
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
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
