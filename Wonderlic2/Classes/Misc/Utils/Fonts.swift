//
//  Fonts.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Inter
    struct Inter {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-SemiBold", size: size)!
        }
        
        static func black(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Black", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Medium", size: size)!
        }
    }
}
