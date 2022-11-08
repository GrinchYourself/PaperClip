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
}

public protocol HasCategoriesRepository {
    var categoriesRepository: CategoriesRepositoryProtocol { get }
}

public protocol CategoriesRepositoryProtocol {
    func categories() -> AnyPublisher<[Category], CategoriesRepositoryError>
}
