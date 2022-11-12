//
//  NavigationControllerAppearance.swift
//  PaperClipApp
//
//  Created by Grinch on 12/11/2022.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var navigationBar: UINavigationBar {
        let bar = super.navigationBar
        bar.tintColor = .systemGray5
        return bar
    }

}

struct Appearance {
    var navigationAppearance: UINavigationBarAppearance = {
        let standard = UINavigationBarAppearance()

        standard.configureWithOpaqueBackground()

        standard.backgroundColor = .systemOrange
        standard.titleTextAttributes = [.foregroundColor: UIColor.systemGray5,
                                        .font: UIFont.preferredFont(forTextStyle: .title2)]

        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray5]
        standard.buttonAppearance = button

        let back = UIBarButtonItemAppearance(style: .plain)
        back.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray5]
        standard.backButtonAppearance = back

        return standard
    }()
}
