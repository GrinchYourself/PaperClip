//
//  AdsRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine
import Domain

public class AdsRepository: AdsRepositoryProtocol {

    // MARK: Private properties
    private let adsRemoteStore: AdsRemoteStoreProtocol
    private let categoriesRemoteStore: CategoriesRemoteStoreProtocol

    // MARK: Init
    public init(adsRemoteStore: AdsRemoteStoreProtocol, categoriesRemoteStore: CategoriesRemoteStoreProtocol) {
        self.adsRemoteStore = adsRemoteStore
        self.categoriesRemoteStore = categoriesRemoteStore
    }

    // MARK: AdsRepositoryProtocol
    public func ads() -> AnyPublisher<Domain.AggregatedAds, Domain.AdsRepositoryError> {
        adsRemoteStore.getAds()
            .mapError(convert(_:))
            .combineLatest(
                categoriesRemoteStore.getCategories()
                .mapError(convert(_:))
            ).eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func convert(_ adsRemoteStoreError: AdsRemoteStoreError) -> Domain.AdsRepositoryError {
        switch adsRemoteStoreError {
        case .somethingWrong: return .somethingWrong
        }
    }

    private func convert(_ categoriesRemoteStoreError: CategoriesRemoteStoreError) -> Domain.AdsRepositoryError {
        switch categoriesRemoteStoreError {
        case .somethingWrong: return .somethingWrong
        }
    }

}
