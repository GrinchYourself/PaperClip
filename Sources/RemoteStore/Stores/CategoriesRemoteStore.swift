//
//  CategoriesRemoteStore.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Combine
import Domain

public class CategoriesRemoteStore: CategoriesRemoteStoreProtocol {
    
    // MARK: Private properties
    private let httpDataProvider: HTTPDataProvider
    private let urlRequestFactory: URLRequestFactory

    private var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }

    //MARK: Init
    public init(httpDataProvider: HTTPDataProvider) {
        self.httpDataProvider = httpDataProvider
        urlRequestFactory = URLRequestFactory()
    }

    public func getCategories() -> AnyPublisher<[Domain.Category], CategoriesRemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .category)
        
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [CategoryDTO].self, decoder: jsonDecoder)
            .map { categoriesDTO -> [Domain.Category] in categoriesDTO }
            .mapError { _ in CategoriesRemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }
}
