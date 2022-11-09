//
//  ListingAdsViewModel.swift
//  PaperClipApp
//
//  Created by Grinch on 09/11/2022.
//

import Foundation
import Combine
import Domain

enum FetchState {
    case none
    case success
    case loading
}

protocol ListingAdsViewModeling {
    func fetchAds() -> AnyPublisher<Void, Never>

    var adsListPublisher: Published<[AdItem]>.Publisher { get }
    var fetchStatePublisher: Published<FetchState>.Publisher { get }
}

class ListingAdsViewModel: ListingAdsViewModeling {
    typealias Dependencies = HasAdsRepository

    // MARK: ListingAdsViewModeling properties
    var adsListPublisher: Published<[AdItem]>.Publisher { $adsList }
    var fetchStatePublisher: Published<FetchState>.Publisher { $fetchState }

    // MARK: Private properties
    private let adsRepository: AdsRepositoryProtocol

    @Published var adsList: [AdItem] = []
    @Published var fetchState: FetchState = .none

    // MARK: Initialization
    init(dependencies: Dependencies) {
        adsRepository = dependencies.adsRepository
    }

    // MARK: ListingAdsViewModeling methods
    func fetchAds() -> AnyPublisher<Void, Never> {
        return adsRepository.ads().map { (ads, categories) -> [AdItem] in
            return ads.map { ad -> AdItem in
                AdItem(identifier: ad.id,
                       price: ad.price,
                       isUrgent: ad.isUrgent,
                       thumbImageURL: ad.imagesUrl?.thumb,
                       creationDate: ad.creationDate,
                       title: ad.title,
                       category: categories.first(where: { $0.id == ad.categoryId })?.name ?? "Sans"
                )
            }.sorted(by: >)
        }.map { [weak self] adItems -> Void in
            self?.adsList = adItems
            return ()
        }.replaceError(with: ())
            .eraseToAnyPublisher()
    }

}
