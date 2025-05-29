//
//  OStudyModeCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.03.2022.
//

import UIKit

final class OStudyModeCell: UIButton {
    var element: OStudyModeElement? = nil {
        didSet {
            let nameAttrs = TextAttributes()
                .textColor(Appearance.mono200)
                .font(Fonts.Inter.bold(size: 17.scale))
                .lineHeight(20.4.scale)
                .letterSpacing(-0.44.scale)
            nameLabel.attributedText = element?.name.attributed(with: nameAttrs)
            
            let subTitleAttrs = TextAttributes()
                .textColor(Appearance.mono200)
                .font(Fonts.Inter.regular(size: 15.scale))
                .lineHeight(22.5.scale)
                .letterSpacing(-0.14.scale)
            subTitleLabel.attributedText = element?.text.attributed(with: subTitleAttrs)
        }
    }
    
    var isChecked = false {
        didSet {
            update()
        }
    }
    
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OStudyModeCell {
    func update() {
        container.backgroundColor = isChecked ? Appearance.main300.withAlphaComponent(0.1) : Appearance.mono100
        container.layer.borderColor = isChecked ? Appearance.main300.cgColor : UIColor.clear.cgColor
        container.layer.borderWidth = isChecked ? 2.scale : 0
    }
}

// MARK: Make constraints
private extension OStudyModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale),
        ])
    }
}

// MARK: Lazy initialization
private extension OStudyModeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 12.scale
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
