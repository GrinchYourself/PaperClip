//
//  UIApplication+isSplitOrSlideOver.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import UIKit

extension UIApplication {

    var isSplitOrSlideOver: Bool {
        guard let window = self.windows.first(where: { $0.isKeyWindow }) else { return false }
        let maxScreenSize = max(window.screen.bounds.size.width, window.screen.bounds.size.height)
        let minScreenSize = min(window.screen.bounds.size.width, window.screen.bounds.size.height)
        let maxAppSize = max(window.frame.size.width, window.frame.size.height)
        let minAppSize = min(window.frame.size.width, window.frame.size.height)
        return !(maxScreenSize == maxAppSize && minScreenSize == minAppSize)
    }
    
}
