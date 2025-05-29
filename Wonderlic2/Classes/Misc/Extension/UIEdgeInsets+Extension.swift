//
//  UIEdgeInsets+Extension.swift
//  ITExams
//
//  Created by Андрей Чернышев on 22.02.2022.
//

import UIKit

extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        UIEdgeInsets(
            top: -top,
            left: -left,
            bottom: -bottom,
            right: -right
        )
    }
    
    init(value: CGFloat) {
        self = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(t: CGFloat = 0, l: CGFloat = 0, b: CGFloat = 0, r: CGFloat = 0) {
        self = UIEdgeInsets(top: t, left: l, bottom: b, right: r)
    }
}
