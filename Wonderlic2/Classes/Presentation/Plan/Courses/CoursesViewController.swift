//
//  CoursesViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import UIKit
import RxSwift

final class CoursesViewController: UIViewController {
    private lazy var mainView = CoursesView()
    
    private lazy var viewModel = CoursesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.openError() ?? .never()
        }
        
        let output = viewModel.configure(input: CoursesViewModel.Input(
            didTapCancel: mainView.cancelButton.rx.tap.asSignal(),
            didTapSaveCourse: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CoursesViewController {
    static func make() -> CoursesViewController {
        CoursesViewController()
    }
}

// MARK: Private
private extension CoursesViewController {
    func route(_ route: CoursesViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true)
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
