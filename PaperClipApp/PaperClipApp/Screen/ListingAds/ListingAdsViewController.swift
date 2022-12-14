//
//  ListingAdsViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 06/11/2022.
//

import UIKit
import Combine

protocol ListingAdsFlow: AnyObject {
    func showAdDetails(_ identifier: Int)
    func filterAds()
}

class ListingAdsViewController: UIViewController {

    // MARK: Enum
    enum TableViewSection: Hashable {
        case main
    }

    enum K {
        static let cellIdentifier = "AdItemTableViewCell"
    }

    // MARK: UI
    private lazy var filterItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(filterButtonPressed))
        buttonItem.image = UIImage(systemName: "square.stack.3d.up.fill")
        return buttonItem
    }()

    private var tableView = UITableView(frame: CGRect.zero, style: .plain)
    private var leadingConstraint = NSLayoutConstraint()

    private lazy var tableViewDataSource: UITableViewDiffableDataSource< TableViewSection, AdItem> = {
        UITableViewDiffableDataSource<TableViewSection, AdItem>.init(tableView: tableView) {
            tableView, indexPath, adItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as? AdItemTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(for: adItem)
            return cell
        }
    }()

    // MARK: Private properties
    private let viewModel: ListingAdsViewModeling
    private weak var flow: ListingAdsFlow?
    private var subscriptions = Set<AnyCancellable>()
    private var fetchCancellable: AnyCancellable?

    // MARK: Init
    init(viewModel: ListingAdsViewModeling, flow: ListingAdsFlow?) {
        self.viewModel = viewModel
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PaperClip"
        view.backgroundColor = .systemGray5

        registerHandlers()

        configureTableView()
        configureBarItem()

        fetchItems()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLeadingConstraint()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLeadingConstraint()
    }

    // MARK: Private methods
    private func registerHandlers() {
        viewModel.adsListPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] adItems in
                self?.reloadItems(adItems)
            }.store(in: &subscriptions)

        viewModel.fetchStatePublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .error: self?.showError()
                default: break
                }
            }.store(in: &subscriptions)
    }

    private func fetchItems() {
        viewModel.fetchAds()
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.register(AdItemTableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .label
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        leadingConstraint = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        NSLayoutConstraint.activate([
            leadingConstraint,
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureBarItem() {
        navigationItem.setRightBarButton(filterItem, animated: true)
    }

    private func reloadItems(_ items: [AdItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, AdItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func filterButtonPressed() {
        flow?.filterAds()
    }

    private func updateLeadingConstraint() {
        let isLandscape = UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isLandscape : UIApplication.isLandscape
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let isSplit = UIApplication.shared.isSplitOrSlideOver
        let horizontalConstant = (isLandscape && isIpad && !isSplit) ? (UIScreen.main.bounds.width - UIScreen.main.bounds.height) / 2 : 0

        leadingConstraint.constant = horizontalConstant
    }

}

// MARK: error management
extension ListingAdsViewController {
    private func showError() {
        let alertVC = UIAlertController(title: "???? Oop's", message: "Une erreur est survenue, merci de reessayer plus tard", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
}

extension ListingAdsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemIdentifier = tableViewDataSource.itemIdentifier(for: indexPath)?.identifier else { return }
        flow?.showAdDetails(itemIdentifier)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}
