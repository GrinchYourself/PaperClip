//
//  CategoryPill.swift
//  PaperClipApp
//
//  Created by Grinch on 12/11/2022.
//

import UIKit

class CategoryPill: UIView {

    enum K {
        static let horizontalSpacing = 16.0
        static let verticalSpacing = 8.0
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var isFilter: Bool = false
    private var name: String = ""

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.cornerRadius = 5
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods
    func configure(with name: String, and isFilter: Bool) {
        label.text = name
        backgroundColor = isFilter ? .secondarySystemBackground : .tertiarySystemBackground
    }

    // MARK: Private methods
    private func configureLabel() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.horizontalSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.horizontalSpacing),
            label.topAnchor.constraint(equalTo: topAnchor, constant: K.verticalSpacing),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.verticalSpacing),
        ])
    }

}
