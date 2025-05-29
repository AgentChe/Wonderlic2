//
//  StudyModeViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class StudyModeViewController: UIViewController {
    lazy var mainView = StudyModeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StudyModeViewModel()
    
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
        
        viewModel.currentMode
            .drive(Binder(self) { base, currentMode in
                base.mainView.setup(mode: currentMode)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.saved
            .drive(Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.setNewMode()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension StudyModeViewController {
    static func make() -> StudyModeViewController {
        let vc = StudyModeViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension StudyModeViewController {
    func setNewMode() {
        let cells = [mainView.cell1, mainView.cell2, mainView.cell3]
        
        guard let element = cells.first(where: { $0.isChecked })?.element else {
            return
        }
        
        viewModel.newMode.accept(element.code)
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
    
    func activity(_ activity: Bool) {
        mainView.button.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
