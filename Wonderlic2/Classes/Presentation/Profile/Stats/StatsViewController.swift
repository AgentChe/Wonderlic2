//
//  StatsViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 02.06.2022.
//

import UIKit
import RxSwift

final class StatsViewController: UIViewController {
    lazy var mainView = StatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StatsViewModel()
    
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
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension StatsViewController {
    static func make() -> StatsViewController {
        StatsViewController()
    }
}

// MARK: StatsTableViewDelegate
extension StatsViewController: StatsTableViewDelegate {
    func statsTableDidTappedUnlock() {
        let vc = PaygateViewController.make()
        present(vc, animated: true)
    }
}

// MARK: Private
private extension StatsViewController {
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
        let showAnimating = activity && mainView.tableView.elements.isEmpty
        showAnimating ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
