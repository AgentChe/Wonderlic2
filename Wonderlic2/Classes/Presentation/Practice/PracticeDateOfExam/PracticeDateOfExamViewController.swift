//
//  PracticeDateOfExamViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class PracticeDateOfExamViewController: UIViewController {
    enum Mode {
        case change, set
    }
    
    lazy var mainView = PracticeDateOfExamView(mode: mode)
    
    private lazy var viewModel = PracticeDateOfExamViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let mode: Mode
    
    private init(mode: Mode) {
        self.mode = mode
        
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
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.currentDate
            .drive(Binder(self) { base, currentDate in
                base.mainView.datePicker.setDate(currentDate, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.saveButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let date = base.mainView.datePicker.date
                base.viewModel.newDate.accept(date)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                mainView.closeButton.rx.tap.asDriver(),
                viewModel.saved
            )
            .drive(Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension PracticeDateOfExamViewController {
    static func make(mode: Mode) -> PracticeDateOfExamViewController {
        let vc = PracticeDateOfExamViewController(mode: mode)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension PracticeDateOfExamViewController {
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
        mainView.saveButton.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.2
            self?.mainView.layoutIfNeeded()
        })
    }
    
    func dismiss() {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = ScreenSize.isIphoneXFamily ? 422.scale : 372.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
