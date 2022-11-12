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
}

protocol ListingAdsViewModeling {
    func fetchAds() -> AnyPublisher<Void, Never>

    var adsListPublisher: Published<[AdItem]>.Publisher { get }
    var fetchStatePublisher: Published<FetchState>.Publisher { get }
}

class ListingAdsViewModel: ListingAdsViewModeling {
    typealias Dependencies = HasAdsRepository & HasCategoriesRepository

    enum FetchError: Error {
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
    private var filterIdsSubscription: AnyCancellable?

    // MARK: Initialization
    init(dependencies: Dependencies) {
        adsRepository = dependencies.adsRepository
        categoriesRepository = dependencies.categoriesRepository
    }

    // MARK: ListingAdsViewModeling methods
    func fetchAds() -> AnyPublisher<Void, Never> {
        let categoriesPublisher = categoriesRepository.categories()
            .mapError(convert(_:)).eraseToAnyPublisher()
        return fetchAndFilterIfNeeded()
            .combineLatest(categoriesPublisher)
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

    // MARK: Private methods

    private func fetchAndFilterIfNeeded() -> AnyPublisher<[Ad], FetchError> {
        let fetchPublisher = adsRepository.ads().mapError(convert(_:)).eraseToAnyPublisher()
        let filterIdsPublisher = categoriesRepository.filterIds().setFailureType(to: FetchError.self).eraseToAnyPublisher()
        return fetchPublisher
            .combineLatest(filterIdsPublisher)
            .map { (ads, filterIds) -> [Ad] in
                guard !filterIds.isEmpty else {
                    return ads
                }
                return ads.filter { filterIds.contains($0.categoryId) }
            }.eraseToAnyPublisher()
    }

    private func convert(_ error: AdsRepositoryError) -> FetchError {
        .somethingWrong
    }

    private func convert(_ error: CategoriesRepositoryError) -> FetchError {
        .somethingWrong
    }

}
