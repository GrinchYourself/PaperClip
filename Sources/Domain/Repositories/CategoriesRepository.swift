//
//  CategoriesRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine


public enum CategoriesRepositoryError: Error {
    case somethingWrong
    case categoryNotFound
}

public protocol HasCategoriesRepository {
    var categoriesRepository: CategoriesRepositoryProtocol { get }
}

public protocol CategoriesRepositoryProtocol {
    func categories() -> AnyPublisher<[Category], CategoriesRepositoryError>
    func category(for identifier: Int) -> AnyPublisher<Category, CategoriesRepositoryError>
    func addCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never>
    func removeCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never>
    func filterIds() -> AnyPublisher<[Int], Never>
    func clearFilters() -> AnyPublisher<Bool, Never>
}
