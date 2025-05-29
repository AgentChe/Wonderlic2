//
//  ReviewViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import UIKit
import RxSwift

final class ReviewViewController: UIViewController {
    lazy var mainView = ReviewView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ReviewViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
                base.isEmpty(elements.isEmpty)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.emptyView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                TestCoordinator.shared.start(testTypes: [.quick], from: base)
            })
            .disposed(by: disposeBag)
        
        addFilterTappedActions()
        isEmpty(false)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension ReviewViewController {
    static func make() -> ReviewViewController {
        ReviewViewController()
    }
}

// MARK: ReviewTableViewDelegate
extension ReviewViewController: ReviewTableViewDelegate {
    func reviewTableDidReachedBottom() {
        viewModel.nextPage.accept(Void())
    }
    
    func reviewTableDidTapped(element: Review) {
        let vc = QuestionViewerViewController.make(question: element.question,
                                                   answeredIds: element.userAnswersIds)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension ReviewViewController {
    func addFilterTappedActions() {
        Observable
            .merge(
                mainView.filterView.allButton.rx.tap.map { ReviewFilter.all },
                mainView.filterView.incorrectButton.rx.tap.map { ReviewFilter.incorrect },
                mainView.filterView.correctButton.rx.tap.map { ReviewFilter.correct }
            )
            .startWith(.all)
            .distinctUntilChanged()
            .bind(to: Binder(self) { base, filter in
                base.mainView.filterView.filter = filter
                base.viewModel.filter.accept(filter)
                base.mainView.tableView.setup(elements: [])
            })
            .disposed(by: disposeBag)
    }
    
    func activity(_ activity: Bool) {
        if activity {
            let footerView = UIView()
            footerView.frame.size = CGSize(width: 335.scale, height: 50.scale)
            footerView.backgroundColor = UIColor.clear
            
            let preloader = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
            preloader.frame.origin = CGPoint(x: footerView.frame.width / 2 - preloader.intrinsicContentSize.width / 2,
                                             y: footerView.frame.height / 2 - preloader.intrinsicContentSize.height / 2)
            footerView.addSubview(preloader)
            
            mainView.tableView.tableFooterView = footerView
            
            preloader.startAnimating()
        } else {
            mainView.tableView.tableFooterView = nil
        }
    }
    
    func isEmpty(_ isEmpty: Bool) {
        mainView.tableView.isHidden = isEmpty
        mainView.emptyView.isHidden = !isEmpty
    }
}
