//
//  CategoriesFilterViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import UIKit
import Combine

class CategoriesFilterViewController: UIViewController {

    // MARK: Enum
    enum CollectionViewSection: Hashable {
        case main
    }

    enum K {
        static let cellIdentifier = "CategoryPillCollectionViewCell"
        static let spacing: CGFloat = 16
    }

    // MARK: UI Properties
    private var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        return layout
    }()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    private lazy var collectionDataSource = UICollectionViewDiffableDataSource<CollectionViewSection, CategoryFilter>(collectionView: collectionView) { collectionView, indexPath, categoryFilter in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: K.cellIdentifier,
            for: indexPath) as? FilterCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(for: categoryFilter)
        return cell
    }

    lazy var closeItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(closeButtonPressed))
        buttonItem.image = UIImage(systemName: "xmark")
        return buttonItem
    }()

    lazy var clearItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "effacer",
                                         style: .plain,
                                         target: self,
                                         action: #selector(clearButtonPressed))
        return buttonItem
    }()

    // MARK: Private properties
    private let viewModel: CategoriesFilterViewModeling
    private var subscriptions = Set<AnyCancellable>()
    private var clearCancellable: AnyCancellable?
    private var manageFilterCancellable: AnyCancellable?
    @Published private var filters = [CategoryFilter]()

    // MARK:Initialization
    init(viewModel: CategoriesFilterViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        registerHandlers()

        configureCollectionView()
        configureBarItems()
    }


    // MARK: private methods
    private func configureCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: K.spacing, left: K.spacing, bottom: K.spacing, right: K.spacing)
        collectionView.delegate = self
        collectionView.register(FilterCategoryCollectionViewCell.self, forCellWithReuseIdentifier: K.cellIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func registerHandlers() {
        viewModel.filtersPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filters in
                self?.reloadFilters(filters)
            }.store(in: &subscriptions)
    }

    private func reloadFilters(_ filters: [CategoryFilter]) {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, CategoryFilter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filters, toSection: .main)
        collectionDataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureBarItems() {
        navigationItem.setLeftBarButton(clearItem, animated: true)
        navigationItem.setRightBarButton(closeItem, animated: true)
    }

    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }

    @objc private func clearButtonPressed() {
        clearCancellable = viewModel.clearFilters().sink { [weak self] _ in self?.clearCancellable = nil }
    }
}

extension CategoriesFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filter = collectionDataSource.itemIdentifier(for: indexPath) else { return }
        if filter.isSelected {
            manageFilterCancellable = viewModel.removeCategoryAsFilter(filter.identifier).sink { [weak self]_ in self?.manageFilterCancellable = nil }
        } else {
            manageFilterCancellable = viewModel.addCategoryAsFilter(filter.identifier).sink { [weak self]_ in self?.manageFilterCancellable = nil }
        }
    }
}
