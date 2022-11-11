//
//  AdDetailsViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import UIKit
import Combine

class AdDetailsViewController: UIViewController {

    enum K {
        static let spacing = 8.0
        static let imageSize = 100.0
        static let betweenElement = 16.0
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .green
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let itemImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let categoryLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let urgentSymbol: UIView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0)
        let boltImage = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)

        let imageView = UIImageView(image: boltImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemOrange

        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -.pi/4)
        imageView.transform = transform
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

        applyConstraints()
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
                self?.titleLabel.text = details?.title
                self?.priceLabel.text = details?.price.euros
                self?.dateLabel.text = "Posté le \(details?.creationDate.short ?? "")"
                self?.categoryLabel.text = details?.category
                self?.urgentSymbol.isHidden = !(details?.isUrgent ?? false)
                self?.descriptionLabel.text = details?.description
            }.store(in: &subscriptions)
    }

    private func applyConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(urgentSymbol)

        NSLayoutConstraint.activate([
            //ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            //ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //ImageView
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            itemImageView.heightAnchor.constraint(equalToConstant: 200),
            //Category
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            categoryLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: K.spacing),
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: K.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            //Price
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            //Date
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            dateLabel.firstBaselineAnchor.constraint(equalTo: priceLabel.lastBaselineAnchor),
            //UrgentSymbol
            urgentSymbol.widthAnchor.constraint(equalToConstant: 24),
            urgentSymbol.heightAnchor.constraint(equalTo: urgentSymbol.widthAnchor),
            urgentSymbol.centerYAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 12),
            urgentSymbol.centerXAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: 12),
            //Description
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: K.betweenElement),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing)
        ])
    }

}
