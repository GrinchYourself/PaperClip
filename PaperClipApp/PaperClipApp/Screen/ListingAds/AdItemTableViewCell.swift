//
//  AdItemTableViewCell.swift
//  PaperClipApp
//
//  Created by Grinch on 10/11/2022.
//

import UIKit
import Domain

class AdItemTableViewCell: UITableViewCell {

    enum K {
        static let spacing = 8.0
        static let imageSize = 100.0
        static let betweenElement = 16.0
    }

    let itemImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private methods
    private func applyConstraints() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(urgentSymbol)

        let imageHeightConstraint = itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor)
        imageHeightConstraint.priority = .defaultHigh - 1
        NSLayoutConstraint.activate([
            //ImageView
            itemImageView.widthAnchor.constraint(equalToConstant: K.imageSize),
            imageHeightConstraint,
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing),
            //Category
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: K.betweenElement),
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: K.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor, constant: -K.betweenElement),
            //Price
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            priceLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 16),
            //Date
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            dateLabel.firstBaselineAnchor.constraint(equalTo: priceLabel.lastBaselineAnchor),
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: categoryLabel.bottomAnchor),
            //UrgentSymbol
            urgentSymbol.widthAnchor.constraint(equalToConstant: 24),
            urgentSymbol.heightAnchor.constraint(equalTo: urgentSymbol.widthAnchor),
            urgentSymbol.centerYAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 12),
            urgentSymbol.centerXAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: 12)
        ])
    }

    // MARK: Configuration
    func configure(for adItem: AdItem) {
        titleLabel.text = adItem.title
        priceLabel.text = adItem.price
        dateLabel.text = "Posté le \(adItem.creationDate.short ?? "")"
        categoryLabel.text = adItem.category
        urgentSymbol.isHidden = !adItem.isUrgent
    }
}
