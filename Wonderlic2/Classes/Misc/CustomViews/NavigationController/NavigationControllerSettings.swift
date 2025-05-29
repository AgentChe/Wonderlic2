//
//  NursingNavigationControllerSettings.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct NavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NavigationControllerSettings {
    static func `default`() -> NavigationControllerSettings {
        NavigationControllerSettings(backgroundImage: UIImage(),
                                     shadowImage: UIImage(),
                                     isTranslucent: true,
                                     tintColor: Appearance.mono200,
                                     titleTextAttrributes: TextAttributes()
                                        .textColor(Appearance.mono200)
                                        .font(Fonts.Inter.semiBold(size: 17.scale))
                                        .textAlignment(.center)
                                        .dictionary)
    }
}
