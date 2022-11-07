//
//  RepositoryTests.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import XCTest
import Combine
import Foundation
import Domain
@testable import Repository

final class RepositoryTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        cancellables.removeAll()
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testSuccessGetAdsListing() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: true)
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency,
                                          categoriesRemoteStore: categoriesRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Ads success")

        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { aggregatedAds in
            XCTAssertEqual(3, aggregatedAds.0.count)
            XCTAssertEqual(6, aggregatedAds.1.count)
            //Continue to check values
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Mock
    class MockAdsRemoteStore: Domain.AdsRemoteStoreProtocol {

        let mocks = Mocks()
        let isSucceeded: Bool

        init(isSucceeded: Bool) {
            self.isSucceeded = isSucceeded
        }

        func getAds() -> AnyPublisher<[Domain.Ad], Domain.AdsRemoteStoreError> {
            if isSucceeded {
                return Just(mocks.ads).setFailureType(to: Domain.AdsRemoteStoreError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: Domain.AdsRemoteStoreError.somethingWrong).eraseToAnyPublisher()
            }
        }

    }

    class MockCategoriesRemoteStore: Domain.CategoriesRemoteStoreProtocol {


        let mocks = Mocks()
        let isSucceeded: Bool

        init(isSucceeded: Bool) {
            self.isSucceeded = isSucceeded
        }

        func getCategories() -> AnyPublisher<[Domain.Category], Domain.CategoriesRemoteStoreError> {
            if isSucceeded {
                return Just(mocks.categories)
                    .setFailureType(to: Domain.CategoriesRemoteStoreError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: Domain.CategoriesRemoteStoreError.somethingWrong).eraseToAnyPublisher()
            }
        }

    }

}
