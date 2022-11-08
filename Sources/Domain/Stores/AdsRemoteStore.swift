//
//  AdsRemoteStore.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine

public enum AdsRemoteStoreError: Error {
    case somethingWrong
}

public protocol HasAdsRemoteStore {
    var adsRemoteStore: AdsRemoteStoreProtocol { get }
}

public protocol AdsRemoteStoreProtocol {
    func getAds() -> AnyPublisher<[Ad], AdsRemoteStoreError>
}
