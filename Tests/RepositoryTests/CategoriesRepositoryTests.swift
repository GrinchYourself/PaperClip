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

    // MARK: Filters management
    func testAddFilters() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)
        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        //Add
        let addExpectation = XCTestExpectation(description: "Add Filter Ids")
        addExpectation.expectedFulfillmentCount = 3
        var count = 0
        categoriesRepository.filterIds().sink { ids in
            if count == 0 {
                XCTAssertEqual(0, ids.count)
                addExpectation.fulfill()
            } else {
                XCTAssertEqual(4, ids.count)
                XCTAssertTrue(ids.contains(1))
                XCTAssertTrue(ids.contains(3))
                XCTAssertTrue(ids.contains(6))
                XCTAssertTrue(ids.contains(8))
                addExpectation.fulfill()
            }
            count += 1
        }.store(in: &cancellables)

        categoriesRepository.addCategoryAsFilter([1, 6, 3, 8])
            .sink { success in
                XCTAssertTrue(success)
                addExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [addExpectation], timeout: 0.2)
    }

    func testRemoveFilters() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)
        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        let _ = categoriesRepository.addCategoryAsFilter([1, 6, 3, 8]).sink(receiveValue: { _ in })
        //Remove
        let removeExpectation = XCTestExpectation(description: "Remove Filter Ids")
        removeExpectation.expectedFulfillmentCount = 2
        categoriesRepository.filterIds()
            .dropFirst() // Do not want to check the actual ids
            .sink { ids in
                XCTAssertEqual(2, ids.count)
                XCTAssertTrue(ids.contains(8))
                XCTAssertTrue(ids.contains(6))
                removeExpectation.fulfill()
        }.store(in: &cancellables)

        categoriesRepository.removeCategoryAsFilter([1, 3])
            .sink { success in
                XCTAssertTrue(success)
                removeExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [removeExpectation], timeout: 0.2)

    }

    func testClearFilters() {
        let categoriesRemoteStoreDependency = MockCategoriesRemoteStore(isSucceeded: true)
        let categoriesRepository = CategoriesRepository(categoriesRemoteStore: categoriesRemoteStoreDependency)

        let _ = categoriesRepository.addCategoryAsFilter([1, 6, 3, 8]).sink(receiveValue: { _ in })
        //Clear
        let clearExpectation = XCTestExpectation(description: "Clear Filter Ids")
        clearExpectation.expectedFulfillmentCount = 2
        categoriesRepository.filterIds()
            .dropFirst() // Do not want to check the actual ids
            .sink { ids in
                XCTAssertEqual(0, ids.count)
                clearExpectation.fulfill()
        }.store(in: &cancellables)

        categoriesRepository.clearFilters()
            .sink { success in
                XCTAssertTrue(success)
                clearExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [clearExpectation], timeout: 0.2)

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
