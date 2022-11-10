//
//  ConverterTests.swift
//  PaperClipAppTests
//
//  Created by Grinch on 10/11/2022.
//

import XCTest
@testable import PaperClipApp

final class ConverterTests: XCTestCase {

    private static let dateFormatter = ISO8601DateFormatter()

    func testPriceConverterForFrLocale() {
        XCTAssertEqual("199,00 €", PriceConverter.shared.priceInEur(199, locale: Locale(identifier: "fr_FR")))
        XCTAssertEqual("234,57 €", PriceConverter.shared.priceInEur(234.5677, locale: Locale(identifier: "fr_FR")))
        XCTAssertEqual("199,02 €", PriceConverter.shared.priceInEur(199.0234, locale: Locale(identifier: "fr_FR")))
    }

    func testPriceConverterForEnLocale() {
        XCTAssertEqual("€199.00", PriceConverter.shared.priceInEur(199, locale: Locale(identifier: "en_US")))
        XCTAssertEqual("€234.57", PriceConverter.shared.priceInEur(234.5677, locale: Locale(identifier: "en_US")))
        XCTAssertEqual("€199.02", PriceConverter.shared.priceInEur(199.0234, locale: Locale(identifier: "en_US")))
    }

    func testDateConverterForFrLocale() {
        let fiveNovember2019 = ConverterTests.dateFormatter.date(from: "2019-11-05T15:56:59+0000")!
        let firstJanuary2020 = ConverterTests.dateFormatter.date(from: "2020-01-01T13:46:19+0000")!
        let sixAugust2021 = ConverterTests.dateFormatter.date(from: "2021-08-06T05:23:54+0000")!

        XCTAssertEqual("5 nov. 2019", DateConverter.shared.mediumDate(fiveNovember2019, locale: Locale(identifier: "fr_FR")))
        XCTAssertEqual("1 janv. 2020", DateConverter.shared.mediumDate(firstJanuary2020, locale: Locale(identifier: "fr_FR")))
        XCTAssertEqual("6 août 2021", DateConverter.shared.mediumDate(sixAugust2021, locale: Locale(identifier: "fr_FR")))
    }

    func testDateConverterForEnLocale() {
        let fiveNovember2019 = ConverterTests.dateFormatter.date(from: "2019-11-05T15:56:59+0000")!
        let firstJanuary2020 = ConverterTests.dateFormatter.date(from: "2020-01-01T13:46:19+0000")!
        let sixAugust2021 = ConverterTests.dateFormatter.date(from: "2021-08-06T05:23:54+0000")!

        XCTAssertEqual("Nov 5, 2019", DateConverter.shared.mediumDate(fiveNovember2019, locale: Locale(identifier: "en_US")))
        XCTAssertEqual("Jan 1, 2020", DateConverter.shared.mediumDate(firstJanuary2020, locale: Locale(identifier: "en_US")))
        XCTAssertEqual("Aug 6, 2021", DateConverter.shared.mediumDate(sixAugust2021, locale: Locale(identifier: "en_US")))
     }

}
