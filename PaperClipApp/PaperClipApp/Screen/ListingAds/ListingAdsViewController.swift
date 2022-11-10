//
//  ListingAdsViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 06/11/2022.
//

import UIKit
import Combine

class ListingAdsViewController: UIViewController {

    // MARK: Enum
    enum TableViewSection: Hashable {
        case main
    }

    enum K {
        static let cellIdentifier = "AdItemTableViewCell"
    }

    // MARK: UI
    private var tableView = UITableView(frame: CGRect.zero, style: .grouped)
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
    private var adItems = [AdItem]()
    private var subscriptions = Set<AnyCancellable>()
    private var fetchCancellable: AnyCancellable?


    // MARK: Init
    init(viewModel: ListingAdsViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "PaperClip"
        registerHandlers()
        configureTableView()

        fetchItems()
    }

    // MARK: Private methods
    private func registerHandlers() {
        viewModel.adsListPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] adItems in
                self?.adItems = adItems
                self?.makeDataSnapshot(for: adItems)
            }.store(in: &subscriptions)
    }

    private func fetchItems() {
        fetchCancellable = viewModel.fetchAds().sink { [weak self] _ in self?.fetchCancellable = nil }
    }

    private func configureTableView() {
        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(AdItemTableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func makeDataSnapshot(for items: [AdItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, AdItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ListingAdsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        adItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adItem = adItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toto") else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "toto")
            cell.textLabel?.text = adItem.price //adItem.title
            cell.detailTextLabel?.text = adItem.price
            cell.accessoryType =  adItem.isUrgent ? .checkmark : .none
            return cell
        }
        cell.textLabel?.text = adItem.price
        cell.detailTextLabel?.text = adItem.price
        cell.accessoryType =  adItem.isUrgent ? .checkmark : .none
        return cell
    }
}

extension ListingAdsViewController: UITableViewDelegate {

}
