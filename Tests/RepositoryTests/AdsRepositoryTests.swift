//
//  AdsRepositoryTests.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import XCTest
import Combine
import Foundation
import Domain
@testable import Repository

final class AdsRepositoryTests: XCTestCase {

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

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Ads success")

        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { ads in
            XCTAssertEqual(3, ads.count)
            let ad = ads.first(where: { $0.id == 1691247255 })
            XCTAssertNotNil(ad)
            XCTAssertEqual(199, ad?.price)
            XCTAssertNil(ad?.siret)
            XCTAssertEqual("Pc portable hp elitebook 820 g1 core i5 4 go ram 250 go hdd", ad?.title)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetAdsListingWhenAdsRemoteStoreFails() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: false)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Ads fails")

        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("Value not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccessGetAdByIdentifier() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: true)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Ads success")

        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { _ in
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.5)

        let getAdExpectation = XCTestExpectation(description: "get Ad success")
        adsRepository.adDetail(for: 1691247255).sink { completion in
            switch completion {
            case .finished:
                getAdExpectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { ad in
            XCTAssertEqual(1691247255, ad.id)
            XCTAssertEqual(8, ad.categoryId)
            XCTAssertEqual("Pc portable hp elitebook 820 g1 core i5 4 go ram 250 go hdd", ad.title)
            XCTAssertNil(ad.siret)
        }.store(in: &cancellables)
        wait(for: [getAdExpectation], timeout: 0.5)
    }

    func testFailureGetAdByIdentifier() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: true)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency)

        let getAdBeforeFetchExpectation = XCTestExpectation(description: "get Ad failure")
        adsRepository.adDetail(for: 1691247255).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                getAdBeforeFetchExpectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("value not expected")
        }.store(in: &cancellables)
        wait(for: [getAdBeforeFetchExpectation], timeout: 0.5)

        //Fetch
        let expectation = XCTestExpectation(description: "get Listing Ads success")
        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Success not expected")
            }
        } receiveValue: { _ in
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.5)

        //Get ad with unknown id
        let getAdExpectation = XCTestExpectation(description: "get Ad failure, unknown id")
        adsRepository.adDetail(for: 12343234213).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                getAdExpectation.fulfill()
            }
        } receiveValue: { ad in
            XCTFail("value not expected")
        }.store(in: &cancellables)
        wait(for: [getAdExpectation], timeout: 0.5)
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

}
