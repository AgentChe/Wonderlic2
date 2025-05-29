//
//  TabView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case plan, practice, profile
    }
    
    lazy var planItem = makeItem(image: "Main.Plan", title: "Main.Plan")
    lazy var practiceItem = makeItem(image: "Main.Practice", title: "Main.Practice")
    lazy var profileItem = makeItem(image: "Main.Profile", title: "Main.Profile")
    
    var selectedTab = Tab.practice {
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
private extension TabView {
    func update() {
        [
            planItem,
            practiceItem,
            profileItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .plan:
            planItem.mode = .selected
        case .practice:
            practiceItem.mode = .selected
        case .profile:
            profileItem.mode = .selected
        }
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            planItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            planItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            planItem.topAnchor.constraint(equalTo: topAnchor),
            planItem.widthAnchor.constraint(equalTo: practiceItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            practiceItem.leadingAnchor.constraint(equalTo: planItem.trailingAnchor),
            practiceItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            practiceItem.topAnchor.constraint(equalTo: topAnchor),
            practiceItem.widthAnchor.constraint(equalTo: profileItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileItem.leadingAnchor.constraint(equalTo: practiceItem.trailingAnchor),
            profileItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileItem.topAnchor.constraint(equalTo: topAnchor),
            profileItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(image: String, title: String) -> TabItemView {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 10.scale))
            .textColor(Appearance.mono300)
            .lineHeight(12.scale)
            .textAlignment(.center)
        
        let view = TabItemView()
        view.backgroundColor = UIColor.clear
        view.iconView.image = UIImage(named: image)
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
