//
//  MainViewCoordinator.swift
//  ITExams
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import UIKit

final class MainViewCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var planVC = NavigationController(rootViewController: PlanViewController.make())
    lazy var practiceVC = NavigationController(rootViewController: PracticeViewController.make())
    lazy var profileVC = NavigationController(rootViewController: ProfileViewController.make())
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        switch tab {
        case .plan:
            parentVC?.mainView.tabView.selectedTab = tab

            changeVC(on: planVC)
        case .practice:
            parentVC?.mainView.tabView.selectedTab = tab
            
            changeVC(on: practiceVC)
        case .profile:
            parentVC?.mainView.tabView.selectedTab = tab
            
            changeVC(on: profileVC)
        }
    }
}

// MARK: Private
private extension MainViewCoordinator {
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
