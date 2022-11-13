//
//  UIWindow+isLandscape.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import UIKit

extension UIApplication {

    static var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }

}
