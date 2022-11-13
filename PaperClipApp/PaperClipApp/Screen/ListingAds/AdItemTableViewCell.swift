//
//  AdItemTableViewCell.swift
//  PaperClipApp
//
//  Created by Grinch on 10/11/2022.
//

import UIKit
import Domain
import Combine

class AdItemTableViewCell: UITableViewCell {

    enum K {
        static let spacing = 8.0
        static let imageSize = 100.0
        static let betweenElement = 16.0
        static let symbolSize = UrgentSymbol.K.symbolSize
        static let cornerRadius = 5.0
    }

    let itemImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = K.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    let categoryPill: CategoryPill = {
        let pill = CategoryPill(frame: CGRect.zero)
        pill.translatesAutoresizingMaskIntoConstraints = false
        return pill
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

    private let imageLoader: ImageLoading = ImageLoader.loader
    private var imageLoadingCancellable: AnyCancellable?

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray6
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func prepareForReuse() {
        imageLoadingCancellable?.cancel()
        imageLoadingCancellable  = nil
        itemImageView.image = UIImage(systemName: "photo")
        titleLabel.text = ""
        priceLabel.text = ""
        categoryPill.configure(with: "", and: false)
        dateLabel.text = ""
        urgentSymbol.isHidden = true
    }

    // MARK: private methods
    private func applyConstraints() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryPill)
        contentView.addSubview(dateLabel)
        contentView.addSubview(urgentSymbol)

        NSLayoutConstraint.activate([
            //ImageView
            itemImageView.widthAnchor.constraint(equalToConstant: K.imageSize),
            itemImageView.heightAnchor.constraint(equalToConstant: K.imageSize),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing),
            //Category
            categoryPill.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            categoryPill.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: K.betweenElement),
            titleLabel.topAnchor.constraint(equalTo: categoryPill.bottomAnchor, constant: K.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor, constant: -K.betweenElement),
            //Price
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            priceLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: K.betweenElement),
            //Date
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            dateLabel.firstBaselineAnchor.constraint(equalTo: priceLabel.lastBaselineAnchor),
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: categoryPill.bottomAnchor),
            //UrgentSymbol
            urgentSymbol.centerYAnchor.constraint(equalTo: itemImageView.topAnchor, constant: K.symbolSize/2),
            urgentSymbol.centerXAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: K.symbolSize/2)
        ])
    }

    // MARK: Configuration
    func configure(for adItem: AdItem) {
        loadImage(url: adItem.thumbImageURL)
        titleLabel.text = adItem.title
        priceLabel.text = adItem.price
        dateLabel.text = "Posté le \(adItem.creationDate.short ?? "")"
        categoryPill.configure(with: adItem.category, and: false)
        urgentSymbol.isHidden = !adItem.isUrgent
    }

    private func loadImage(url: URL?) {
        guard let url else { return }

        imageLoadingCancellable = imageLoader.loadImage(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
        } receiveValue: { [weak self] image in
            self?.itemImageView.image = image
        }

    }

}
