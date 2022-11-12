//
//  FilterCategoryCollectionViewCell.swift
//  PaperClipApp
//
//  Created by Grinch on 12/11/2022.
//

import UIKit

class FilterCategoryCollectionViewCell: UICollectionViewCell {

    // MARK: UI Properties
    let categoryPill: CategoryPill = {
        let pill = CategoryPill(frame: CGRect.zero)
        pill.translatesAutoresizingMaskIntoConstraints = false
        return pill
    }()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration
    func configure(for filter: CategoryFilter) {
        categoryPill.configure(with: filter.name, and: filter.isSelected)
    }

    // MARK: Private methods
    private func applyConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryPill)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            categoryPill.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryPill.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryPill.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryPill.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
