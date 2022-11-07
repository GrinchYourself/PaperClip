//
//  CategoriesRemoteStore.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Combine

enum CategoriesRemoteStoreError: Error {
    case somethingWrong
}

class CategoriesRemoteStore {
    
    // MARK: Private properties
    private let httpDataProvider: HTTPDataProvider
    private let urlRequestFactory: URLRequestFactory

    private var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }

    //MARK: Init
    init(httpDataProvider: HTTPDataProvider) {
        self.httpDataProvider = httpDataProvider
        urlRequestFactory = URLRequestFactory()
    }

    func getCategoriess() -> AnyPublisher<[CategoryDTO], CategoriesRemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .category)
        
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [CategoryDTO].self, decoder: jsonDecoder)
            .mapError { _ in CategoriesRemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }
}
