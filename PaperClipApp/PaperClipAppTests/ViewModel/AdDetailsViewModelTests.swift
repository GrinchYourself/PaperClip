//
//  AdDetailsViewModelTests.swift
//  PaperClipAppTests
//
//  Created by Grinch on 11/11/2022.
//

import XCTest
import Combine
import Domain
@testable import PaperClipApp

final class AdDetailsViewModelTests: XCTestCase {

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

    func testSuccessFetchingDetails() {
        let dependencies = MockDependencies(isAdsSuccess: true, isCategoriesSuccess: true)
        let viewModel: AdDetailsViewModeling = AdDetailsViewModel(dependencies: dependencies, identifier: 123456)

        let expectation = XCTestExpectation(description: "Get fetch Details Success")
        expectation.expectedFulfillmentCount = 2

        viewModel.detailsPublisher
            .dropFirst() // Nil Initialisation
            .sink { adDetails in
            XCTAssertNotNil(adDetails)
            XCTAssertEqual("Meuble tiroirs plastique", adDetails?.title)
            XCTAssertEqual(false, adDetails?.isUrgent)
            XCTAssertEqual(17, adDetails?.price)
            XCTAssertEqual("123 456 789", adDetails?.siret)
            expectation.fulfill()
        }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.success, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchDetails().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    func testFailureFetchingDetailsWhenBothRepositoriesFailed() {
        let dependencies = MockDependencies(isAdsSuccess: false, isCategoriesSuccess: false)
        let viewModel: AdDetailsViewModeling = AdDetailsViewModel(dependencies: dependencies, identifier: 123456)

        let expectation = XCTestExpectation(description: "Get fetch Details Failure")
        viewModel.detailsPublisher
            .dropFirst() // Drop initial empty state
            .sink { adItems in
                XCTFail("Not expected")
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.error, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchDetails().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    func testFailureFetchingDetailsWhenOnlyCategoriesRepositoryFailed() {
        let dependencies = MockDependencies(isAdsSuccess: true, isCategoriesSuccess: false)
        let viewModel: AdDetailsViewModeling = AdDetailsViewModel(dependencies: dependencies, identifier: 123456)

        let expectation = XCTestExpectation(description: "Get fetch Details Failure")
        viewModel.detailsPublisher
            .dropFirst() // Drop initial empty state
            .sink { adItems in
                XCTFail("Not expected")
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.error, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchDetails().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    func testFailureFetchingDetailsWhenOnlyAdsRepositoryFailed() {
        let dependencies = MockDependencies(isAdsSuccess: false, isCategoriesSuccess: true)
        let viewModel: AdDetailsViewModeling = AdDetailsViewModel(dependencies: dependencies, identifier: 123456)

        let expectation = XCTestExpectation(description: "Get fetch Details Failure")
        viewModel.detailsPublisher
            .dropFirst() // Drop initial empty state
            .sink { adItems in
                XCTFail("Not expected")
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.error, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchDetails().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    // MARK: Mock
    struct MockDependencies: AdDetailsViewModel.Dependencies {
        let adsRepository: Domain.AdsRepositoryProtocol
        let categoriesRepository: CategoriesRepositoryProtocol

        init(isAdsSuccess: Bool, isCategoriesSuccess: Bool) {
            self.adsRepository = MockAdsRepository(isSuccess: isAdsSuccess)
            self.categoriesRepository = MockCategoriesRepository(isSuccess: isCategoriesSuccess)
        }
    }

    struct MockAdsRepository: AdsRepositoryProtocol {

        let isSuccess: Bool
        let mocks = Mocks()

        init(isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func adDetail(for identifier: Int) -> AnyPublisher<Domain.Ad, Domain.AdsRepositoryError> {
            if isSuccess {
                return Just(mocks.ads[4]).setFailureType(to: AdsRepositoryError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: .detailNotFound).eraseToAnyPublisher()
            }

        }

        // Not used
        func ads() -> AnyPublisher<[Domain.Ad], Domain.AdsRepositoryError> {
            Fail(error: AdsRepositoryError.somethingWrong).eraseToAnyPublisher()
        }

    }

    struct MockCategoriesRepository: CategoriesRepositoryProtocol {

        let isSuccess: Bool
        let mocks = Mocks()

        init(isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func category(for identifier: Int) -> AnyPublisher<Domain.Category, Domain.CategoriesRepositoryError> {
            if isSuccess {
                return Just(mocks.categories[2])
                    .setFailureType(to: CategoriesRepositoryError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: .categoryNotFound).eraseToAnyPublisher()
            }
        }


        // Not used
        func categories() -> AnyPublisher<[Domain.Category], Domain.CategoriesRepositoryError> {
            Fail(error: CategoriesRepositoryError.somethingWrong).eraseToAnyPublisher()
        }

        func addCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never> {
            Just(true).eraseToAnyPublisher()
        }

        func removeCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never> {
            Just(true).eraseToAnyPublisher()
        }

        func filterIds() -> AnyPublisher<[Int], Never> {
            Just([]).eraseToAnyPublisher()
        }

        func clearFilters() -> AnyPublisher<Bool, Never> {
            Just(true).eraseToAnyPublisher()
        }

    }

}
