//
//  CustomMadeTestTableSwitchCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit

final class CustomMadeTestTableSwitchCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var switchView = makeSwitch()
    
    private var element: CustomMadeTestSwitchElement!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CustomMadeTestTableSwitchCell {
    func setup(element: CustomMadeTestSwitchElement) {
        self.element = element
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
        label.attributedText = element.title.attributed(with: attrs)
        
        switchView.isOn = element.isOn
    }
}

// MARK: Private
private extension CustomMadeTestTableSwitchCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func switched() {
        element.isOn = switchView.isOn
    }
}

// MARK: Make constraints
private extension CustomMadeTestTableSwitchCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 51.scale),
            switchView.heightAnchor.constraint(equalToConstant: 30.scale),
            switchView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CustomMadeTestTableSwitchCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.thumbTintColor = Appearance.mono100
        view.onTintColor = Appearance.main300
        view.tintColor = Appearance.main200
        view.addTarget(self, action: #selector(switched), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
