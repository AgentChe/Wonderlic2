//
//  TestStatsInfoCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import UIKit

final class TestStatsInfoCell: UIView {
    lazy var placeholderLabel = makePlaceholderLabel()
    lazy var valueLabel = makeLabel()
    lazy var separator = makeSeparator()
    
    private let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension TestStatsInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            placeholderLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.scale),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21.scale),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsInfoCell {
    func makePlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
        
        let view = UILabel()
        view.attributedText = placeholder.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono300.withAlphaComponent(0.16)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
