import XCTest
import Foundation
import Combine
@testable import RemoteStore

final class URLRequestFactoryTests: XCTestCase {
    
    func testURLRequestFactoryForAdsListing() {
        let factory = URLRequestFactory()
        
        let urlForAds = factory.makeUrlRequest(for: .ads)
        XCTAssertEqual("https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json", urlForAds.url?.absoluteString)
        XCTAssertEqual("GET", urlForAds.httpMethod)
        XCTAssertEqual(true, urlForAds.allHTTPHeaderFields?.contains(where: { header, value in
            header == "Content-Type" && value == "application/json"
        }))
    }
    
    func testURLRequestFactoryForCategories() {
        let factory = URLRequestFactory()
        
        let urlForAds = factory.makeUrlRequest(for: .category)
        XCTAssertEqual("https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json", urlForAds.url?.absoluteString)
        XCTAssertEqual("GET", urlForAds.httpMethod)
        XCTAssertEqual(true, urlForAds.allHTTPHeaderFields?.contains(where: { header, value in
            header == "Content-Type" && value == "application/json"
        }))
    }

}
