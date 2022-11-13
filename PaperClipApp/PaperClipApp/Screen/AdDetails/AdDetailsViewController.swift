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
        static let imageHeight = 200.0
        static let betweenElement = 16.0
        static let symbolSize = UrgentSymbol.K.symbolSize
        static let cornerRadius = 5.0
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let itemImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.backgroundColor = .secondarySystemFill
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = K.cornerRadius
        imageView.clipsToBounds = true
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

    let categoryPill: CategoryPill = {
        let pill = CategoryPill(frame: CGRect.zero)
        pill.translatesAutoresizingMaskIntoConstraints = false
        return pill
    }()

    let proInformation: ProInformation = {
        let information = ProInformation(frame: CGRect.zero)
        information.translatesAutoresizingMaskIntoConstraints = false
        return information
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

    let urgentSymbol: UrgentSymbol = {
        let symbol = UrgentSymbol(frame: CGRect.zero)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        return symbol
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
    private let imageLoader: ImageLoading = ImageLoader.loader
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
        view.backgroundColor = .systemGray5

        registerHandlers()

        applyConstraints()

        fetchDetails()
    }

    //MARK: Private methods
    private func fetchDetails() {
        viewModel.fetchDetails()
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func registerHandlers() {
        viewModel.detailsPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                guard let details else { return }
                self?.updateInformations(details)
            }.store(in: &subscriptions)
    }

    private func updateInformations(_ details: AdDetails) {
        loadImage(url: details.imageURL)
        titleLabel.text = details.title
        priceLabel.text = details.price.euros
        dateLabel.text = "Posté le \(details.creationDate.short ?? "")"
        categoryPill.configure(with: details.category, and: false)
        urgentSymbol.isHidden = !(details.isUrgent)
        descriptionLabel.text = details.description
        proInformation.isHidden = details.siret == nil
        proInformation.configure(with: details.siret)
    }

    private func loadImage(url: URL?) {

        guard let url else { return }
        imageLoader.loadImage(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
        } receiveValue: { [weak self] image in
            self?.itemImageView.image = image
        }.store(in: &subscriptions)

    }

    private func applyConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryPill)
        contentView.addSubview(proInformation)
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
            itemImageView.heightAnchor.constraint(equalToConstant: K.imageHeight),
            //Category
            categoryPill.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            categoryPill.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: K.spacing),
            //Pro information
            proInformation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            proInformation.centerYAnchor.constraint(equalTo: categoryPill.centerYAnchor),
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            titleLabel.topAnchor.constraint(equalTo: categoryPill.bottomAnchor, constant: K.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            //Price
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: K.betweenElement),
            //Date
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            dateLabel.firstBaselineAnchor.constraint(equalTo: priceLabel.lastBaselineAnchor),
            //UrgentSymbol
            urgentSymbol.centerYAnchor.constraint(equalTo: itemImageView.topAnchor, constant: K.symbolSize/2),
            urgentSymbol.centerXAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: K.symbolSize/2),
            //Description
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: K.betweenElement),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing)
        ])
    }

}
