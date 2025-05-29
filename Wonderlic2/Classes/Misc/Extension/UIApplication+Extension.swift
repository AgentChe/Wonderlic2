//
//  UIApplication+Extension.swift
//  EMT2thdplatform
//
//  Created by Андрей Чернышев on 27.03.2025.
//

import UIKit

extension UIApplication {
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        return scene.windows.first
    }
}
