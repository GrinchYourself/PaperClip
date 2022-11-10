//
//  ListingAdsViewModelTests.swift
//  PaperClipAppTests
//
//  Created by Grinch on 10/11/2022.
//

import XCTest
import Combine
import Domain
@testable import PaperClipApp

final class ListingAdsViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        cancellables.removeAll()
        continueAfterFailure = true
    }

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }

    func testSuccessFetchingAdsListing() {
        let dependencies = MockDependencies(isSuccess: true)
        let viewModel: ListingAdsViewModeling = ListingAdsViewModel(dependencies: dependencies)

        let expectation = XCTestExpectation(description: "Get fetch AdsListing Success")
        viewModel.adsListPublisher
            .dropFirst() // Drop initial empty state
            .sink { adItems in
                XCTAssertEqual(6, adItems.count)
                //Check order
                XCTAssertEqual(1664493117, adItems[0].identifier)
                XCTAssertEqual(1701863581, adItems[1].identifier)
                XCTAssertEqual(1701863736, adItems[2].identifier)
                XCTAssertEqual(1461267313, adItems[3].identifier)
                XCTAssertEqual(1701863750, adItems[4].identifier)
                XCTAssertEqual(1691247255, adItems[5].identifier)
                //Check isUrgent
                XCTAssertTrue(adItems[0].isUrgent)
                XCTAssertTrue(adItems[1].isUrgent)
                XCTAssertTrue(adItems[2].isUrgent)
                XCTAssertFalse(adItems[3].isUrgent)
                XCTAssertFalse(adItems[4].isUrgent)
                XCTAssertFalse(adItems[5].isUrgent)
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.loading, fetchState)
            case 2: XCTAssertEqual(.success, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchAds().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    func testFailureFetchingAdsListing() {
        let dependencies = MockDependencies(isSuccess: false)
        let viewModel: ListingAdsViewModeling = ListingAdsViewModel(dependencies: dependencies)

        let expectation = XCTestExpectation(description: "Get fetch AdsListing Failure")
        viewModel.adsListPublisher
            .dropFirst() // Drop initial empty state
            .sink { adItems in
                XCTFail("Not expected")
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.loading, fetchState)
            case 2: XCTAssertEqual(.error, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchAds().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    struct MockDependencies: ListingAdsViewModel.Dependencies {
        let adsRepository: Domain.AdsRepositoryProtocol

        init(isSuccess: Bool) {
            self.adsRepository = MockAdsRepository(isSuccess: isSuccess)
        }
    }

    struct MockAdsRepository: AdsRepositoryProtocol {
        let isSuccess: Bool
        let mocks = Mocks()

        init(isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func ads() -> AnyPublisher<Domain.AggregatedAds, Domain.AdsRepositoryError> {
            if isSuccess {
                return Just((mocks.ads, mocks.categories))
                    .setFailureType(to: AdsRepositoryError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: AdsRepositoryError.somethingWrong).eraseToAnyPublisher()
            }
        }
    }

}
