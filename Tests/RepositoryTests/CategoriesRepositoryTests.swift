//
//  CategoriesRepositoryTests.swift
//  
//
//  Created by Grinch on 11/11/2022.
//

import XCTest
import Combine
import Foundation
import Domain
@testable import Repository

final class CategoriesRepositoryTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        cancellables.removeAll()
    }

    override func tearDown() {
        cancellables.removeAll()
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

    func testSuccessGetCategoryByIdentifier() {
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
        } receiveValue: { _ in
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.5)

        let getCategoryExpectation = XCTestExpectation(description: "get Category success")
        categoriesRepository.category(for: 9).sink { completion in
            switch completion {
            case .finished:
                getCategoryExpectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { category in
            XCTAssertEqual(9, category.id)
            XCTAssertEqual("Service", category.name)
        }.store(in: &cancellables)
        wait(for: [getCategoryExpectation], timeout: 0.5)
    }

    func testFailureGetAdByIdentifier() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)

        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        let getCategoryBeforeFetchExpectation = XCTestExpectation(description: "get Category failure")
        categoriesRepository.category(for: 9).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                getCategoryBeforeFetchExpectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("value not expected")
        }.store(in: &cancellables)
        wait(for: [getCategoryBeforeFetchExpectation], timeout: 0.5)

        //Fetch
        let expectation = XCTestExpectation(description: "get Listing Categories success")
        categoriesRepository.categories().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { _ in
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.5)


        //Get ad with unknown id
        let getCategoryExpectation = XCTestExpectation(description: "get Category failure, unknown id")
        categoriesRepository.category(for: 2).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                getCategoryExpectation.fulfill()
            }
        } receiveValue: { ad in
            XCTFail("value not expected")
        }.store(in: &cancellables)
        wait(for: [getCategoryExpectation], timeout: 0.5)
    }

    // MARK: Mock
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
