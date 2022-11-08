//
//  Coordinator.swift
//  PaperClipApp
//
//  Created by Grinch on 08/11/2022.
//

import Foundation
import UIKit
import Domain

public protocol Coordinator {
    var navigationController : UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {

    typealias MainDependencing = HasAdsRemoteStore & HasCategoriesRemoteStore &
    HasAdsRepository & HasCategoriesRepository
    
    // MARK: Coordinator properties
    var navigationController: UINavigationController

    // MARK: Private properties
    private let dependencies: MainDependencing

    init(dependencies: MainDependencing, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    // MARK: Coordinator method
    func start() {
        let rootVC = ViewController()
        rootVC.view.backgroundColor = .systemOrange
        navigationController.pushViewController(rootVC, animated: true)
    }

}
