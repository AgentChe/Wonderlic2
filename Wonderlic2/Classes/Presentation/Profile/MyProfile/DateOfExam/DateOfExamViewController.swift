//
//  DateOfExamViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class DateOfExamViewController: UIViewController {
    lazy var mainView = DateOfExamView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = DateOfExamViewModel()
    
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
        
        viewModel.currentDate
            .drive(Binder(self) { base, currentDate in
                base.mainView.setup(date: currentDate)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                mainView.skipButton.rx.tap.asDriver(),
                viewModel.saved
            )
            .drive(Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                let date = base.mainView.datePicker.date
                base.viewModel.newDate.accept(date)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension DateOfExamViewController {
    static func make() -> DateOfExamViewController {
        let vc = DateOfExamViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension DateOfExamViewController {
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
        mainView.button.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
