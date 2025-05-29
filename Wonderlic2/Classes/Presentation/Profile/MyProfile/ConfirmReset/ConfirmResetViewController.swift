//
//  ConfirmResetViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 12.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class ConfirmResetViewController: UIViewController {
    lazy var mainView = ConfirmResetView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let reset: () -> Void
    
    private init(reset: @escaping () -> Void) {
        self.reset = reset
        
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
        
        mainView.cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        mainView.resetButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.animateDismiss {
                    base.reset()
                    base.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension ConfirmResetViewController {
    static func make(reset: @escaping () -> Void) -> ConfirmResetViewController {
        let vc = ConfirmResetViewController(reset: reset)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension ConfirmResetViewController {
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
        mainView.containerBottomConstraint.constant = ScreenSize.isIphoneXFamily ? 341.scale : 300.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
