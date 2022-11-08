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

    //MARK: AdsRepository
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
            // check ads
            let ads = aggregatedAds.0
            XCTAssertEqual(3, ads.count)
            let ad = ads.first(where: { $0.id == 1691247255 })
            XCTAssertNotNil(ad)
            XCTAssertEqual(199, ad?.price)
            XCTAssertNil(ad?.siret)
            XCTAssertEqual("Pc portable hp elitebook 820 g1 core i5 4 go ram 250 go hdd", ad?.title)

            //Check categories
            let categories = aggregatedAds.1
            XCTAssertEqual(6, categories.count)
            let multimediaCategory = categories.first(where: { $0.id == 8 })
            XCTAssertNotNil(multimediaCategory)
            XCTAssertEqual("Multimédia", multimediaCategory?.name)

        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetAdsListingWhenAdsRemoteStoreFails() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: false)
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency,
                                          categoriesRemoteStore: categoriesRemoteStoreDependency)

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

    func testFailureGetAdsListingWhenCategoriesRemoteStoreFails() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: true)
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: false)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency,
                                          categoriesRemoteStore: categoriesRemoteStoreDependency)

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

    func testFailureGetAdsListingWhenRemoteStoresFail() {
        let adsRemoteStoreDependency = MockAdsRemoteStore(isSucceeded: false)
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: false)

        let adsRepository = AdsRepository(adsRemoteStore: adsRemoteStoreDependency,
                                          categoriesRemoteStore: categoriesRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Ads fails")

        adsRepository.ads().sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("value not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: CategoriesRepository

    func testSuccessGetCategoriesListing() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)

        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Categories success")

        categoriesRepository.categories().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { categories in
            XCTAssertEqual(6, categories.count)
            let multimediaCategory = categories.first(where: { $0.id == 8 })
            XCTAssertNotNil(multimediaCategory)
            XCTAssertEqual("Multimédia", multimediaCategory?.name)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetCategoriesListing() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: false)

        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        let expectation = XCTestExpectation(description: "get Listing Categories success")

        categoriesRepository.categories().sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("values not expected")
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
