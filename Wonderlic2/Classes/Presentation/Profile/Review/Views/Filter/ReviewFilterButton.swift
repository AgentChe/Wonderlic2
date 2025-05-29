//
//  ReviewFilterButton.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import UIKit

final class ReviewFilterButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewFilterButton {
    func update() {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 15.scale))
            .letterSpacing(-0.14.scale)
        let selectedAttrs = attrs.textColor(Appearance.mono100)
        let unselectedAttrs = attrs.textColor(Appearance.mono200)
        let string = title.attributed(with: isChecked ? selectedAttrs : unselectedAttrs)
        setAttributedTitle(string, for: .normal)
        
        backgroundColor = isChecked ? Appearance.main300 : Appearance.mono300.withAlphaComponent(0.1)
    }
}
