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
    private var localCategory: [Domain.Category] = []

    // MARK: Init
    public init(categoriesRemoteStore: CategoriesRemoteStoreProtocol) {
        self.categoriesRemoteStore = categoriesRemoteStore
    }

    // MARK: AdsRepositoryProtocol
    public func categories() -> AnyPublisher<[Domain.Category], Domain.CategoriesRepositoryError> {
        categoriesRemoteStore.getCategories()
            .map { [weak self] categories -> [Domain.Category] in
                self?.localCategory = categories
                return categories
            }
            .mapError(convert(_:))
            .eraseToAnyPublisher()
    }

    public func category(for identifier: Int) -> AnyPublisher<Domain.Category, CategoriesRepositoryError> {
        guard let category = localCategory.first(where: { $0.id == identifier }) else {
            return Fail(error: .categoryNotFound).eraseToAnyPublisher()
        }
        return Just(category).setFailureType(to: CategoriesRepositoryError.self).eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func convert(_ categoriesRemoteStoreError: CategoriesRemoteStoreError) -> Domain.CategoriesRepositoryError {
        switch categoriesRemoteStoreError {
        case .somethingWrong: return .somethingWrong
        }
    }

}
