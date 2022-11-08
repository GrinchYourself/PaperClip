//
//  AdsRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine

public typealias AggregatedAds = ([Ad], [Category])

public enum AdsRepositoryError: Error {
    case somethingWrong
}

public protocol HasAdsRepository {
    var adsRepository: AdsRepositoryProtocol { get }
}

public protocol AdsRepositoryProtocol {
    func ads() -> AnyPublisher<AggregatedAds,AdsRepositoryError>
}
