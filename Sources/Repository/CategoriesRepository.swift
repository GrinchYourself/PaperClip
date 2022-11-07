//
//  CategoriesRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine
import Domain

public class CategoriesRepository: CategoriesRepositoryProtocol {

    // MARK: Private properties
    private let categoriesRemoteStore: CategoriesRemoteStoreProtocol

    // MARK: Init
    public init(categoriesRemoteStore: CategoriesRemoteStoreProtocol) {
        self.categoriesRemoteStore = categoriesRemoteStore
    }

    // MARK: AdsRepositoryProtocol
    public func categories() -> AnyPublisher<[Domain.Category], Domain.CategoriesRepositoryError> {
        categoriesRemoteStore.getCategories()
            .mapError(convert(_:))
            .eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func convert(_ categoriesRemoteStoreError: CategoriesRemoteStoreError) -> Domain.CategoriesRepositoryError {
        switch categoriesRemoteStoreError {
        case .somethingWrong: return .somethingWrong
        }
    }

}
