//
//  AdDetailsViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import UIKit
import Combine

class AdDetailsViewController: UIViewController {

    // MARK: Private properties
    private let viewModel: AdDetailsViewModeling
    private weak var flow: ListingAdsFlow?
    private var subscriptions = Set<AnyCancellable>()
    private var fetchCancellable: AnyCancellable?

    // MARK: Initialization
    init(viewModel: AdDetailsViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func viewDidLoad() {
        super.viewDidLoad()

        registerHandlers()
        view.backgroundColor = .yellow
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDetails()
    }

    //MARK: Private methods
    private func fetchDetails() {
        fetchCancellable = viewModel.fetchDetails().sink { [weak self] _ in self?.fetchCancellable = nil }
    }

    private func registerHandlers() {
        viewModel.detailsPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                print(details?.title)
            }.store(in: &subscriptions)
    }

}
