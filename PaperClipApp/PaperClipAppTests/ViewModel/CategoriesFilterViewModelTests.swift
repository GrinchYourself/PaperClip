//
//  CategoriesFilterViewModelTests.swift
//  PaperClipAppTests
//
//  Created by Grinch on 12/11/2022.
//

import XCTest
import Combine
import Domain
@testable import PaperClipApp

final class CategoriesFilterViewModelTests: XCTestCase {

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

    // MARK: Filters management
    func testFiltersManagement() {
        let mockDependencies = MockDependencies()
        let viewModel = CategoriesFilterViewModel(dependencies: mockDependencies)

        let expectation = XCTestExpectation(description: "filters management")
        expectation.expectedFulfillmentCount = 6

        var count = -1
        viewModel.filtersPublisher
            .sink { filterCategories in
            count += 1
            XCTAssertEqual(7, filterCategories.count)
            let selectedCategories = filterCategories.filter{ $0.isSelected == true }
            switch count {
            case 0:
                XCTAssertTrue(selectedCategories.count == 0)
                expectation.fulfill()
            case 1:
                XCTAssertTrue(selectedCategories.count == 1)
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 1 }))
                expectation.fulfill()
            case 2:
                XCTAssertTrue(selectedCategories.count == 2)
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 1 }))
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 11 }))
                expectation.fulfill()
            case 3:
                XCTAssertTrue(selectedCategories.count == 3)
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 1 }))
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 11 }))
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 6 }))
                expectation.fulfill()
            case 4:
                XCTAssertTrue(selectedCategories.count == 2)
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 11 }))
                XCTAssertTrue(selectedCategories.contains(where: {$0.identifier == 6 }))
                expectation.fulfill()
            case 5:
                XCTAssertTrue(selectedCategories.count == 0)
                expectation.fulfill()
            default:
                XCTFail("Not expected")
            }
        }.store(in: &cancellables)

        let addExpectation = XCTestExpectation(description: "add Filter")
        addExpectation.expectedFulfillmentCount = 3
        viewModel.addCategoryAsFilter(1)
            .sink { success in
                XCTAssertTrue(success)
                addExpectation.fulfill()
            }.store(in: &cancellables)
        viewModel.addCategoryAsFilter(11)
            .sink { success in
                XCTAssertTrue(success)
                addExpectation.fulfill()
            }.store(in: &cancellables)
        viewModel.addCategoryAsFilter(6)
            .sink { success in
                XCTAssertTrue(success)
                addExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [addExpectation], timeout: 0.2)

        let removeExpectation = XCTestExpectation(description: "remove Filter")
        viewModel.removeCategoryAsFilter(1)
            .sink { success in
                XCTAssertTrue(success)
                removeExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [removeExpectation], timeout: 0.2)

        let clearExpectation = XCTestExpectation(description: "Clear Filters")
        viewModel.clearFilters()
            .sink { success in
                XCTAssertTrue(success)
                clearExpectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [clearExpectation], timeout: 0.2)

        wait(for: [expectation], timeout: 0.8)
    }

    // MARK: Mock
    struct MockDependencies: CategoriesFilterViewModel.Dependencies {
        let categoriesRepository: CategoriesRepositoryProtocol = MockCategoriesRepository()
    }

    class MockCategoriesRepository: CategoriesRepositoryProtocol {
        var filterSubject = CurrentValueSubject<[Int], Never>([])

        var addCount = 0

        func addCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never> {
            addCount += 1
            switch addCount {
            case 1: filterSubject.send([1])
            case 2: filterSubject.send([1, 11])
            case 3: filterSubject.send([1, 11, 6])
            default: break
            }
            return Just(true).eraseToAnyPublisher()
        }

        func removeCategoryAsFilter(_ ids: [Int]) -> AnyPublisher<Bool, Never> {
            filterSubject.send([11, 6])
            return Just(true).eraseToAnyPublisher()
        }

        func clearFilters() -> AnyPublisher<Bool, Never> {
            filterSubject.send([])
            return Just(true).eraseToAnyPublisher()
        }

        func filterIds() -> AnyPublisher<[Int], Never> {
            filterSubject.eraseToAnyPublisher()
        }

        func categories() -> AnyPublisher<[Domain.Category], Domain.CategoriesRepositoryError> {
            Just(Mocks().categories).setFailureType(to: Domain.CategoriesRepositoryError.self).eraseToAnyPublisher()
        }

        // Not used
        func category(for identifier: Int) -> AnyPublisher<Domain.Category, Domain.CategoriesRepositoryError> {
            Fail(error: Domain.CategoriesRepositoryError.categoryNotFound).eraseToAnyPublisher()
        }

    }
}
