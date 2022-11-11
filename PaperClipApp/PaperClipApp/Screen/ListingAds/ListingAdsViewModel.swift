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
    case error
    case loading
}

protocol ListingAdsViewModeling {
    func fetchAds() -> AnyPublisher<Void, Never>

    var adsListPublisher: Published<[AdItem]>.Publisher { get }
    var fetchStatePublisher: Published<FetchState>.Publisher { get }
}

class ListingAdsViewModel: ListingAdsViewModeling {
    typealias Dependencies = HasAdsRepository & HasCategoriesRepository

    enum FetchError: Error{
        case somethingWrong
    }

    // MARK: ListingAdsViewModeling properties
    var adsListPublisher: Published<[AdItem]>.Publisher { $adsList }
    var fetchStatePublisher: Published<FetchState>.Publisher { $fetchState }

    // MARK: Private properties
    private let adsRepository: AdsRepositoryProtocol
    private let categoriesRepository: CategoriesRepositoryProtocol

    @Published private var adsList: [AdItem] = []
    @Published private var fetchState: FetchState = .none

    // MARK: Initialization
    init(dependencies: Dependencies) {
        adsRepository = dependencies.adsRepository
        categoriesRepository = dependencies.categoriesRepository
    }

    // MARK: ListingAdsViewModeling methods
    func fetchAds() -> AnyPublisher<Void, Never> {
        fetchState = .loading
        return adsRepository.ads()
            .mapError(convert(_:))
            .combineLatest(
                categoriesRepository.categories()
                    .mapError(convert(_:))
            )
            .map { (ads, categories) -> [AdItem] in
                return ads.map { ad -> AdItem in
                    AdItem(identifier: ad.id,
                           creationDate: ad.creationDate,
                           isUrgent: ad.isUrgent,
                           thumbImageURL: ad.imagesUrl?.thumb,
                           title: ad.title,
                           category: categories.first(where: { $0.id == ad.categoryId })?.name ?? "Sans",
                           price: ad.price.euros
                    )
                }.sorted(by: >)
            }.map { [weak self] adItems -> Void in
                self?.adsList = adItems
                self?.fetchState = .success
                return ()
            }.catch { [weak self] _ -> Just<Void> in
                self?.fetchState = .error
                return Just(())
            }
            .eraseToAnyPublisher()
    }

    private func convert(_ error: AdsRepositoryError) -> FetchError {
        .somethingWrong
    }

    private func convert(_ error: CategoriesRepositoryError) -> FetchError {
        .somethingWrong
    }

}
