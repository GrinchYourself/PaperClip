//
//  AdsRepository.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation
import Combine
import Domain

public class AdsRepository: AdsRepositoryProtocol {

    // MARK: Private properties
    private let adsRemoteStore: AdsRemoteStoreProtocol
    private var localDds: [Ad] = []

    // MARK: Init
    public init(adsRemoteStore: AdsRemoteStoreProtocol) {
        self.adsRemoteStore = adsRemoteStore
    }

    // MARK: AdsRepositoryProtocol
    public func ads() -> AnyPublisher<[Ad], Domain.AdsRepositoryError> {
        adsRemoteStore.getAds()
            .map { [weak self] ads -> [Ad] in
                self?.localDds = ads
                return ads
            }
            .mapError(convert(_:))
            .eraseToAnyPublisher()
    }

    public func adDetail(for identifier: Int) -> AnyPublisher<Ad, AdsRepositoryError> {
        guard let adDetails = localDds.first(where: { $0.id == identifier }) else {
            return Fail(error: .detailNotFound).eraseToAnyPublisher()
        }
        return Just(adDetails).setFailureType(to: AdsRepositoryError.self).eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func convert(_ adsRemoteStoreError: AdsRemoteStoreError) -> Domain.AdsRepositoryError {
        switch adsRemoteStoreError {
        case .somethingWrong: return .somethingWrong
        }
    }
}
