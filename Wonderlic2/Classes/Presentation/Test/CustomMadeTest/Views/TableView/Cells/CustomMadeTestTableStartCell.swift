//
//  CustomMadeTestTableStartCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit

final class CustomMadeTestTableStartCell: UITableViewCell {
    weak var mainDelegate: CustomMadeTestTableViewDelegate?
    
    lazy var button = makeButton()
    
    private var element: CustomMadeTestCollectorElement!
    
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
extension CustomMadeTestTableStartCell {
    func setup(element: CustomMadeTestCollectorElement) {
        self.element = element
    }
}

// MARK: Private
private extension CustomMadeTestTableStartCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tapped() {
        let attributes = element.make()
        mainDelegate?.customMadeTestTableDidTappedStartTest(attributes: attributes)
    }
}

// MARK: Make constraints
private extension CustomMadeTestTableStartCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28.scale),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28.scale),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CustomMadeTestTableStartCell {
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("CustomMadeTest.StartTest".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
