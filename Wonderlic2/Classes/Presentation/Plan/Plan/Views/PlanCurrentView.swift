//
//  PlanCurrentView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import UIKit

final class PlanCurrentView: UIButton {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PlanCurrentView {
    func setup(course: Course) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
            .lineBreakMode(.byTruncatingTail)
        label.attributedText = course.name.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension PlanCurrentView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            container.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12.scale),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 250.scale)
        ])

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -35.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.scale)
        ])

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanCurrentView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 17.scale
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Plan.CurrentExam.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
