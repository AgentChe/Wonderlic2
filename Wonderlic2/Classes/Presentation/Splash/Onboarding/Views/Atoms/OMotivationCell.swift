//
//  OMotivationCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 01.03.2022.
//

import UIKit

final class OMotivationCell: UIButton {
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    var element: OMotivationElement? = nil {
        didSet {
            let attrs = TextAttributes()
                .textColor(Appearance.mono200)
                .font(Fonts.Inter.bold(size: 17.scale))
                .lineHeight(23.8.scale)
                .letterSpacing(-0.44.scale)
            label.attributedText = element?.title.attributed(with: attrs)
            
            iconView.image = element?.icon
        }
    }
    
    lazy var label = makeLabel()
    lazy var iconView = makeImageView()
    
    private let iconWidth: CGFloat
    private let iconHeight: CGFloat
    private let iconTop: CGFloat
    
    init(iconWidth: CGFloat, iconHeight: CGFloat, iconTop: CGFloat) {
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        self.iconTop = iconTop
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OMotivationCell {
    func update() {
        backgroundColor = isChecked ? Appearance.main300.withAlphaComponent(0.2) : Appearance.main200
        layer.borderWidth = isChecked ? 2.scale : 0
        layer.borderColor = isChecked ? Appearance.main300.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OMotivationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconWidth),
            iconView.heightAnchor.constraint(equalToConstant: iconHeight),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: iconTop),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OMotivationCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 12.scale
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
