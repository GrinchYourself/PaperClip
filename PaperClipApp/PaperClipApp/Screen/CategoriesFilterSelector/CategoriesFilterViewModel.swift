//
//  CategoriesFilterViewModel.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import Foundation
import Domain
import Combine

protocol CategoriesFilterViewModeling {
    func addCategoryAsFilter(_ identifier: Int) -> AnyPublisher<Bool, Never>
    func removeCategoryAsFilter(_ identifier: Int) -> AnyPublisher<Bool, Never>
    func clearFilters() -> AnyPublisher<Bool, Never>
    var filtersPublisher: Published<[CategoryFilter]>.Publisher { get }
}

class CategoriesFilterViewModel: CategoriesFilterViewModeling {

    typealias Dependencies = HasCategoriesRepository

    // MARK: ListingAdsViewModeling properties
    var filtersPublisher: Published<[CategoryFilter]>.Publisher { $filters }

    // MARK: private properties
    private let categoriesRepository: CategoriesRepositoryProtocol
    private var fetchCancellable: AnyCancellable?
    @Published private var filters = [CategoryFilter]()

    // MARK: Initialization
    init(dependencies: Dependencies) {
        categoriesRepository = dependencies.categoriesRepository

        registerHandlers()
    }

    // MARK: ListingAdsViewModeling methods
    func addCategoryAsFilter(_ identifier: Int) -> AnyPublisher<Bool, Never> {
        categoriesRepository.addCategoryAsFilter([identifier])
    }

    func removeCategoryAsFilter(_ identifier: Int) -> AnyPublisher<Bool, Never> {
        categoriesRepository.removeCategoryAsFilter([identifier])
    }

    func clearFilters() -> AnyPublisher<Bool, Never> {
        categoriesRepository.clearFilters()
    }

    // MARK: private methods
    private func registerHandlers() {
        fetchCancellable = fetchFilters().sink { [weak self] categoriesFilters in
            self?.filters = categoriesFilters
        }
    }

    private func fetchFilters() -> AnyPublisher<([CategoryFilter]), Never> {
        let categoriesPublisher = categoriesRepository.categories().replaceError(with: []).eraseToAnyPublisher()
        let filtersPublisher = categoriesRepository.filterIds()
        return categoriesPublisher
            .combineLatest(filtersPublisher)
            .compactMap { [weak self] (categories, filterIds) -> [CategoryFilter]? in
                self?.makeCategoryFilter(categories, filterIds: filterIds)
            }
            .eraseToAnyPublisher()
    }

    private func makeCategoryFilter(_ categories: [Domain.Category], filterIds: [Int]) -> [CategoryFilter] {
        categories.map { category -> CategoryFilter in
            CategoryFilter(identifier: category.id,
                           name: category.name,
                           isSelected: filterIds.contains(category.id))
        }
    }
}
