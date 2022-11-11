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
        let listingViewModel = ListingAdsViewModel(dependencies: dependencies)
        let rootVC = ListingAdsViewController(viewModel: listingViewModel, flow: self)
        rootVC.view.backgroundColor = .systemOrange
        navigationController.pushViewController(rootVC, animated: true)
    }

}

extension MainCoordinator: ListingAdsFlow {

    func showAdDetails(_ identifier: Int) {
        let detailsViewModel = AdDetailsViewModel(dependencies: dependencies, identifier: identifier)
        let detailsVC = AdDetailsViewController(viewModel: detailsViewModel)
        navigationController.pushViewController(detailsVC, animated: true)
    }

    func filterAds() {
        let filterAdsVC = UIViewController()
        filterAdsVC.view.backgroundColor = .systemOrange
        navigationController.present(filterAdsVC, animated: true)
    }

}
