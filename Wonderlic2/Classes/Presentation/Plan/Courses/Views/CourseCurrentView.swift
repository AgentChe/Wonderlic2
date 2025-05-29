//
//  CourseCurrentView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import UIKit

final class CourseCurrentView: UIView {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension CourseCurrentView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseCurrentView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 12.scale))
            .lineHeight(14.4.scale)
            .letterSpacing(-0.44.scale)
        
        let view = UILabel()
        view.attributedText = "Courses.Current".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
