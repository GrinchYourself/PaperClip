//
//  ProInformation.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import UIKit

class ProInformation: UIView {

    enum K {
        static let spacing = 4.0
        static let betweenElements = 8.0
    }

    private let proLabel: UILabel = {
        let label = UILabel()
        label.text = " Pro "
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.label.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 5
        return label
    }()

    private let siretLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var siret: String = ""

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods
    func configure(with siret: String?) {
        siretLabel.text = siret
    }

    // MARK: Private methods
    private func applyConstraints() {
        addSubview(proLabel)
        addSubview(siretLabel)
        NSLayoutConstraint.activate([
            proLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.spacing),
            proLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.spacing),
            proLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.spacing),
            proLabel.trailingAnchor.constraint(equalTo: siretLabel.leadingAnchor, constant: -K.betweenElements),
            siretLabel.centerYAnchor.constraint(equalTo: proLabel.centerYAnchor),
            siretLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.spacing)
        ])
    }

}
