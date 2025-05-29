//
//  DailyGoalViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class DailyGoalViewController: UIViewController {
    lazy var mainView = DailyGoalView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = DailyGoalViewModel()
    
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
        
        viewModel.currentTestMinutes
            .drive(Binder(self) { base, testMinutes in
                base.mainView.setup(minutes: testMinutes)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentTestDaysOfWeek
            .drive(Binder(self) { base, daysOfWeek in
                base.mainView.setup(daysOfWeek: daysOfWeek)
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
            .subscribe(Binder(self) { base, void in
                base.save()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension DailyGoalViewController {
    static func make() -> DailyGoalViewController {
        let vc = DailyGoalViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension DailyGoalViewController {
    func save() {
        let row = mainView.pickerView.selectedRow(inComponent: 0)
        let minutes = row + 10
        
        let days = [mainView.suDayView,
                    mainView.mnDayView,
                    mainView.tuDayView,
                    mainView.weDayView,
                    mainView.thDayView,
                    mainView.frDayView,
                    mainView.saDayView]
            .filter { $0.isChecked }
            .compactMap { $0.day }
        
        let bundle = DailyGoalViewModel.DailyGoalBundle(minutes, days)
        
        viewModel.save.accept(bundle)
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
