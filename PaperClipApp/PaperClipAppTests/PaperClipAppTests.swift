//
//  PaperClipAppTests.swift
//  PaperClipAppTests
//
//  Created by Grinch on 06/11/2022.
//

import XCTest
@testable import PaperClipApp

final class AdItemTests: XCTestCase {

    private static let dateFormatter = ISO8601DateFormatter()

    let items = [AdItem(identifier: 1,
                        creationDate: dateFormatter.date(from: "2019-11-05T15:56:59+0000")!,
                        isUrgent: false,
                        thumbImageURL: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg"),
                        title: "Statue homme noir assis en plâtre polychrome",
                        category: "Maison",
                        price: "140€"),
                 AdItem(identifier: 2,
                        creationDate: dateFormatter.date(from: "2019-10-16T17:10:20+0000")!,
                        isUrgent: false,
                        thumbImageURL: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/633f278423b9aa6b04fa9cc954079befd294473f.jpg"),
                        title: "Pc portable hp elitebook 820 g1 core i5 4 go ram 250 go hdd",
                        category: "Multimédia",
                        price: "199€"),
                 AdItem(identifier: 3,
                        creationDate: dateFormatter.date(from: "2019-11-05T15:56:55+0000")!,
                        isUrgent: true,
                        thumbImageURL: nil,
                        title: "Professeur natif d'espagnol à domicile",
                        category: "Education",
                        price: "25€"),
                 AdItem(identifier: 4,
                        creationDate: dateFormatter.date(from: "2019-11-05T15:56:13+0000")!,
                        isUrgent: true,
                        thumbImageURL: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/6f734e6d789a26f768aa6eaa856ea7fef0f82282.jpg"),
                        title: "Velo course Gitane taille 61 cm , 12 vitesses",
                        category: "Maison",
                        price: "180€"),
                 AdItem(identifier: 5,
                        creationDate: dateFormatter.date(from: "2019-11-05T15:56:13+0000")!,
                        isUrgent: true,
                        thumbImageURL: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/50b3d5870d57b3df834b43088171fef852997529.jpg"),
                        title: "Guitare électro acoustique",
                        category: "Musique",
                        price: "170€")]

    func testAdItemsSortedInDecreasingOrder() {
        let sortedItems = items.sorted(by: >)
        XCTAssertEqual(3, sortedItems[0].identifier)
        XCTAssertEqual(5, sortedItems[1].identifier)
        XCTAssertEqual(4, sortedItems[2].identifier)
        XCTAssertEqual(1, sortedItems[3].identifier)
        XCTAssertEqual(2, sortedItems[4].identifier)
    }

    func testAdItemsSortedInIncreasingOrder() {
        let sortedItems = items.sorted(by: <)
        XCTAssertEqual(4, sortedItems[0].identifier)
        XCTAssertEqual(5, sortedItems[1].identifier)
        XCTAssertEqual(3, sortedItems[2].identifier)
        XCTAssertEqual(2, sortedItems[3].identifier)
        XCTAssertEqual(1, sortedItems[4].identifier)
    }

}
