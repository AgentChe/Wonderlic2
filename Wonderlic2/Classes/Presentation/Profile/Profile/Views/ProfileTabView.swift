//
//  ProfileTabView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit

final class ProfileTabView: UIButton {
    enum Mode {
        case selected, deselected
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var label = makeLabel()
    
    var mode = Mode.deselected {
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
private extension ProfileTabView {
    func update() {
        let color: UIColor
        
        switch mode {
        case .selected:
            color = Appearance.main300
        case .deselected:
            color = Appearance.mono100
        }
        
        label.textColor = color
        
        backgroundView.isHidden = mode == .deselected
    }
}

// MARK: Make constraints
private extension ProfileTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -24.scale),
            backgroundView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 24.scale),
            backgroundView.topAnchor.constraint(equalTo: label.topAnchor, constant: -4.scale),
            backgroundView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileTabView {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
