//
//  AdsRemoteStore.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine

enum AdsRemoteStoreError: Error {
    case somethingWrong
}

class AdsRemoteStore {
    
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
    
    func getAds() -> AnyPublisher<[ClassifiedAdDTO], AdsRemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .ads)
        
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [ClassifiedAdDTO].self, decoder: jsonDecoder)
            .mapError { _ in AdsRemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }

}

