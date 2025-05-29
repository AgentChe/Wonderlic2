//
//  ProfileTabsView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit

final class ProfileTabsView: UIView {
    enum Tab {
        case stats, review, settings
    }
    
    lazy var statsItem = makeItem(title: "Profile.Stats")
    lazy var reviewItem = makeItem(title: "Profile.Review")
    lazy var settingsItem = makeItem(title: "Profile.Settings")
    
    var selectedTab = Tab.stats {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileTabsView {
    func update() {
        [
            statsItem,
            reviewItem,
            settingsItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .stats:
            statsItem.mode = .selected
        case .review:
            reviewItem.mode = .selected
        case .settings:
            settingsItem.mode = .selected
        }
    }
}

// MARK: Make constraints
private extension ProfileTabsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            statsItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            statsItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            statsItem.topAnchor.constraint(equalTo: topAnchor),
            statsItem.widthAnchor.constraint(equalTo: reviewItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reviewItem.leadingAnchor.constraint(equalTo: statsItem.trailingAnchor),
            reviewItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            reviewItem.topAnchor.constraint(equalTo: topAnchor),
            reviewItem.widthAnchor.constraint(equalTo: settingsItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsItem.leadingAnchor.constraint(equalTo: reviewItem.trailingAnchor),
            settingsItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            settingsItem.topAnchor.constraint(equalTo: topAnchor),
            settingsItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileTabsView {
    func makeItem(title: String) -> ProfileTabView {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .textAlignment(.center)
            .letterSpacing(-0.14.scale)
        
        let view = ProfileTabView()
        view.backgroundColor = UIColor.clear
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
