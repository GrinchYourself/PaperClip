//
//  CategoriesRemoteStore.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine

public enum CategoriesRemoteStoreError: Error {
    case somethingWrong
}

public protocol HasCategoriesRemoteStore {
    var categoriesRemoteStore: CategoriesRemoteStoreProtocol { get }
}

public protocol CategoriesRemoteStoreProtocol {
    func getCategories() -> AnyPublisher<[Category], CategoriesRemoteStoreError>
}
