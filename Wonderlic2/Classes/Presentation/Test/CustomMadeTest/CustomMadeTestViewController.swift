//
//  CustomMadeTestViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit
import RxSwift

protocol CustomMadeTestViewControllerDelegate: AnyObject {
    func customMadeTestViewControllerDidStart(attributes: CustomTestAttributes)
}

final class CustomMadeTestViewController: UIViewController {
    weak var delegate: CustomMadeTestViewControllerDelegate?
    
    lazy var mainView = CustomMadeTestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CustomMadeTestViewModel()
    
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
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension CustomMadeTestViewController {
    static func make() -> CustomMadeTestViewController {
        let vc = CustomMadeTestViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: CustomMadeTestTableViewDelegate
extension CustomMadeTestViewController: CustomMadeTestTableViewDelegate {
    func customMadeTestTableDidTappedStartTest(attributes: CustomTestAttributes) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.customMadeTestViewControllerDidStart(attributes: attributes)
        }
    }
}

// MARK: Private
private extension CustomMadeTestViewController {
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
