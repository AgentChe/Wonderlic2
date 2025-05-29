//
//  ODailyView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.03.2022.
//

import UIKit

final class ODailyView: UIButton {
    var isChecked = false {
        didSet {
            update()
        }
    }
    
    var day: DayOfWeek? = nil {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
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
private extension ODailyView {
    func update() {
        backgroundColor = isChecked ? Appearance.main300 : Appearance.main300.withAlphaComponent(0.1)
        
        let attrs = TextAttributes()
            .textColor(isChecked ? Appearance.mono100 : Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        label.attributedText = day?.short.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension ODailyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODailyView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
