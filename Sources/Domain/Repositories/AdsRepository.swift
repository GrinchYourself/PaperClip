//
//  AdsRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine

public enum AdsRepositoryError: Error {
    case somethingWrong
    case detailNotFound
}

public protocol HasAdsRepository {
    var adsRepository: AdsRepositoryProtocol { get }
}

public protocol AdsRepositoryProtocol {
    func ads() -> AnyPublisher<[Ad],AdsRepositoryError>
    func adDetail(for identifier: Int) -> AnyPublisher<Ad, AdsRepositoryError>
}
