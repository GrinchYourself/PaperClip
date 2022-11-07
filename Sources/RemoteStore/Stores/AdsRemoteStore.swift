//
//  AdsRemoteStore.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine
import Domain

public class AdsRemoteStore: Domain.AdsRemoteStoreProtocol {
    
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
    
    public func getAds() -> AnyPublisher<[Ad], AdsRemoteStoreError> {
        let urlRequest = urlRequestFactory.makeUrlRequest(for: .ads)
        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [ClassifiedAdDTO].self, decoder: jsonDecoder)
            .map { classifiedAdDTO -> [Ad] in classifiedAdDTO }
            .mapError { _ in AdsRemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }

}

