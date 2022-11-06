//
//  RemoteStoreTests.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import XCTest
import Combine
import Foundation
@testable import RemoteStore

final class RemoteStoreTests: XCTestCase {

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
        let dependencies = MockHTTPDataProvider(status: .adsSuccess)
        let remoteStore = RemoteStore(httpDataProvider: dependencies)
        
        let expectation = XCTestExpectation(description: "get Listing Ads success")
        
        remoteStore.getAds().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { ads in
            XCTAssertEqual(3, ads.count)
            let ad = ads.first(where: { $0.id == 1664493117 })
            XCTAssertNotNil(ad)
            XCTAssertEqual(9, ad?.categoryId)
            XCTAssertEqual(true, ad?.isUrgent)
            XCTAssertEqual("123 323 002", ad?.siret)
            XCTAssertEqual("Professeur natif d'espagnol à domicile", ad?.title)
            XCTAssertEqual(25, ad?.price)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetAdsListing() {
        let dependencies = MockHTTPDataProvider(status: .adsFailure)
        let remoteStore = RemoteStore(httpDataProvider: dependencies)
        
        let expectation = XCTestExpectation(description: "get Listing Ads failure")
        
        remoteStore.getAds().sink { completion in
            switch completion {
            case .finished:
                XCTFail("success not expected")
            case .failure:
                expectation.fulfill()
            }
        } receiveValue: { _ in }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccessGetCategoriesListing() {
        let dependencies = MockHTTPDataProvider(status: .categoriesSuccess)
        let remoteStore = RemoteStore(httpDataProvider: dependencies)
        
        let expectation = XCTestExpectation(description: "get Listing Categories success")
        
        remoteStore.getCategoriess().sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { categories in
            XCTAssertEqual(11, categories.count)
            let homeCategory = categories.first(where: { $0.name == "Maison" })
            XCTAssertNotNil(homeCategory)
            XCTAssertEqual(4, homeCategory?.id)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetCategoriesListing() {
        let dependencies = MockHTTPDataProvider(status: .categoriesFailure)
        let remoteStore = RemoteStore(httpDataProvider: dependencies)
        
        let expectation = XCTestExpectation(description: "get Listing Categories failure")
        
        remoteStore.getCategoriess().sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure:
                expectation.fulfill()
            }
        } receiveValue: { _ in  }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Mock
    class MockHTTPDataProvider: HTTPDataProvider {
        enum Status {
            case adsSuccess
            case adsFailure
            case categoriesSuccess
            case categoriesFailure
            
            var resource: String {
                switch self {
                case .adsSuccess, .categoriesFailure:  return "ListingClassifiedAds"
                case .adsFailure, .categoriesSuccess:  return "ListingCategories"
                }
            }
            
            var type: String {
                "json"
            }
        }
        
        let status: Status

        init(status: Status) {
            self.status = status
        }
        
        func dataPublisher(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
            let url = Bundle.module.url(forResource: status.resource, withExtension: status.type, subdirectory: "Stub")!
            let data = try! Data(contentsOf: url)
            let response = URLResponse()
            return Just((data: data, response: response)).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }

    }
}
