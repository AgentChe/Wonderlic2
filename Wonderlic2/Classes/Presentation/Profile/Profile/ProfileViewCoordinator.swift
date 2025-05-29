//
//  ProfileViewCoordinator.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit

final class ProfileViewCoordinator {
    weak var parentVC: ProfileViewController?
    
    lazy var statsVC = StatsViewController.make()
    lazy var reviewVC = ReviewViewController.make()
    lazy var settingsVC = SettingsViewController.make()
    
    private var previousVC: UIViewController?
    
    init(parentVC: ProfileViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: ProfileTabsView.Tab) {
        parentVC?.mainView.tabsView.selectedTab = tab
        
        switch tab {
        case .stats:
            changeVC(on: statsVC)
        case .review:
            changeVC(on: reviewVC)
        case .settings:
            changeVC(on: settingsVC)
        }
    }
}

// MARK: Private
private extension ProfileViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
