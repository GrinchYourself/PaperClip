//
//  ImageLoader.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import Foundation
import Combine
import UIKit

enum ImageLoadingError: Error {
    case somethingWrong
}

protocol ImageLoading {
    func loadImage(for url: URL) -> AnyPublisher<UIImage, ImageLoadingError>
//    func cancelLoad(for url: URL)
}

class ImageLoader: ImageLoading {

    static let loader = ImageLoader()

    private var loadedImages = [URL: UIImage]()
    private var loadingImages = [UUID: AnyPublisher<UIImage, ImageLoadingError>]()

    private init() {}

    func loadImage(for url: URL) -> AnyPublisher<UIImage, ImageLoadingError> {

        /*if let image = loadedImages[url] {
            return Just(image).setFailureType(to: ImageLoadingError.self).eraseToAnyPublisher()
        }

        let identifier = UUID()
        loadingImages[identifier] =*/
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .mapError { _ in ImageLoadingError.somethingWrong }
            .eraseToAnyPublisher()
    }

//    func cancelLoad(for url: URL)
//        <#code#>
//    }

}
