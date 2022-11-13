//
//  UrgentSymbol.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import UIKit

class UrgentSymbol: UIView {

    enum K {
        static let spacing = 4.0
        static let symbolSize = 24.0
    }

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSymbol()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private Properties
    private func configureSymbol() {
        let configuration = UIImage.SymbolConfiguration(pointSize: K.symbolSize)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemOrange

        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -.pi/4)
        imageView.transform = transform

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: K.symbolSize),
            imageView.heightAnchor.constraint(equalToConstant: K.symbolSize),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.spacing),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.spacing),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: K.spacing),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.spacing),
        ])
    }

}
