//
//  MyProfileViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit
import RxSwift

final class MyProfileViewController: UIViewController {
    lazy var mainView = MyProfileView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = MyProfileViewModel()
    
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
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension MyProfileViewController {
    static func make() -> MyProfileViewController {
        let vc = MyProfileViewController()
        vc.navigationItem.title = "MyProfile.Title".localized
        return vc
    }
}

// MARK: MyProfileTableViewDelegate
extension MyProfileViewController: MyProfileTableViewDelegate {
    func myProfileDidSelect(element: MyProfileTableElement) {
        switch element {
        case .dateOfExam:
            let vc = DateOfExamViewController.make()
            present(vc, animated: true)
        case .course:
            let vc = CoursesViewController.make()
            present(vc, animated: true)
        case .studyMode:
            let vc = StudyModeViewController.make()
            present(vc, animated: true)
        case .dailyGoal:
            let vc = DailyGoalViewController.make()
            present(vc, animated: true)
        case .resetProgress(let activity):
            guard !activity else {
                return
            }
            
            let vc = ConfirmResetViewController.make { [weak self] in
                self?.viewModel.resetStats.accept(Void())
            }
            present(vc, animated: false)
        }
    }
}

// MARK: Private
private extension MyProfileViewController {
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
