//
//  AdDetailsViewModel.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import Foundation
import Combine
import Domain

enum AdDetailsError: Error {
    case detailNotFound
}

protocol AdDetailsViewModeling {
    func fetchDetails() -> AnyPublisher<Void, Never>
    var detailsPublisher: Published<AdDetails?>.Publisher { get }
    var fetchStatePublisher: Published<FetchState>.Publisher { get }
}

class AdDetailsViewModel: AdDetailsViewModeling {

    typealias Dependencies = HasAdsRepository & HasCategoriesRepository

    // MARK: ListingAdsViewModeling properties
    var detailsPublisher: Published<AdDetails?>.Publisher { $details }
    var fetchStatePublisher: Published<FetchState>.Publisher { $fetchState }

    // MARK: private properties
    private let adIdentifier: Int
    private let adsRepository: AdsRepositoryProtocol
    private let categoriesRepository: CategoriesRepositoryProtocol
    @Published private var details: AdDetails?
    @Published private var fetchState: FetchState = .none

    // MARK: initialization
    init(dependencies: Dependencies, identifier: Int) {
        self.adIdentifier = identifier
        self.adsRepository = dependencies.adsRepository
        self.categoriesRepository = dependencies.categoriesRepository
    }

    //MARK: Public methods
    func fetchDetails() -> AnyPublisher<Void, Never> {
        fetchState = .loading
        return getDetails().map { [weak self] (ad, category) -> Void in
            self?.details = AdDetails(title: ad.title,
                                      description: ad.description,
                                      creationDate: ad.creationDate,
                                      price: ad.price,
                                      imageURL: ad.imagesUrl?.small,
                                      category: category.name,
                                      isUrgent: ad.isUrgent,
                                      siret: ad.siret)
            self?.fetchState = .success
            return
        }.catch { [weak self] _ -> Just<Void> in
            self?.fetchState = .error
            return Just(())
        }.eraseToAnyPublisher()
    }
    
    private func getDetails() -> AnyPublisher<(Ad, Domain.Category), AdDetailsError> {
        let categoriesRepository = categoriesRepository

        return adsRepository.adDetail(for: adIdentifier)
            .mapError { $0.asAdDetailsError }
            .flatMap { ad -> AnyPublisher<(Ad, Domain.Category), AdDetailsError> in
                Just(ad).setFailureType(to: AdDetailsError.self).combineLatest(
                    categoriesRepository.category(for: ad.categoryId).mapError { $0.asAdDetailsError }
                ).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

}

private extension CategoriesRepositoryError {
    var asAdDetailsError: AdDetailsError {
        .detailNotFound
    }
}

private extension AdsRepositoryError {
    var asAdDetailsError: AdDetailsError {
        .detailNotFound
    }
}
