//
//  ProfileViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController {
    lazy var mainView = ProfileView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ProfileViewModel()
    
    private lazy var coordinator = ProfileViewCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.update(selectedTab: .stats)
            })
            .disposed(by: disposeBag)
        
        addActionsToTabs()
    }
}

// MARK: Make
extension ProfileViewController {
    static func make() -> ProfileViewController {
        let vc = ProfileViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ProfileViewController {
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.tabsView.statsItem
                    .rx.tap.map { ProfileTabsView.Tab.stats },
                
                mainView.tabsView.reviewItem
                    .rx.tap.map { ProfileTabsView.Tab.review },
                
                mainView.tabsView.settingsItem
                    .rx.tap.map { ProfileTabsView.Tab.settings }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: ProfileTabsView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
