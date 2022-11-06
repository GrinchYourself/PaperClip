//
//  HTTPClient.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Combine

enum RemoteStoreError: Error {
    case somethingWrong
}

class RemoteStore {
    
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
    
    func getAds() -> AnyPublisher<[ClassifiedAdDTO], RemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .ads)
        
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [ClassifiedAdDTO].self, decoder: jsonDecoder)
            .mapError { _ in RemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }
 
    func getCategoriess() -> AnyPublisher<[CategoryDTO], RemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .category)
        
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [CategoryDTO].self, decoder: jsonDecoder)
            .mapError { _ in RemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }
}
