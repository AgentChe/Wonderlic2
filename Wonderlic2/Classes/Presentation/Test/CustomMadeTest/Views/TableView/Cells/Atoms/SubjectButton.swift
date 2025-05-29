//
//  SubjectButton.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit

final class SubjectButton: UIButton {
    lazy var label = makeLabel()
    
    let element: CustomMadeTestSubjectElement
    
    init(element: CustomMadeTestSubjectElement) {
        self.element = element
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SubjectButton {
    static func width(for element: CustomMadeTestSubjectElement) -> CGFloat {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
        let string = element.subject.name.attributed(with: attrs)
        let width = string.size().width
        return width + 32.scale
    }
    
    func update() {
        backgroundColor = backgroundColor()
        
        let attrs = TextAttributes()
            .textColor(textColor())
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        label.attributedText = element.subject.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension SubjectButton {
    func backgroundColor() -> UIColor {
        // Фейковый элемент для кнопки More с id -1000
        if element.subject.id == -1000 {
            return Appearance.mono300.withAlphaComponent(0.1)
        }
        
        return element.isSelected ? Appearance.main300 : Appearance.mono300.withAlphaComponent(0.1)
    }
    
    func textColor() -> UIColor {
        // Фейковый элемент для кнопки More с id -1000
        if element.subject.id == -1000 {
            return Appearance.main300
        }
        
        return element.isSelected ? Appearance.mono100 : Appearance.mono200
    }
}

// MARK: Make constraints
private extension SubjectButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SubjectButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
