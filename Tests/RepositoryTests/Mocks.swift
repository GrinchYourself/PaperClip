//
//  File.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Domain
import Foundation

struct MockAd: Domain.Ad {
    let id: Int
    let title: String
    let categoryId: Int
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: Domain.ImagesURL?
    let price: Double
    let siret: String?
}

struct MockImagesURL: Domain.ImagesURL {
    let small: URL?
    let thumb: URL?
}

struct MockCategory: Domain.Category {
    let id: Int
    let name: String
}

struct Mocks {
    private static let dateFormatter = ISO8601DateFormatter()

    var ads = [MockAd(id: 1461267313,
                      title: "Statue homme noir assis en plâtre polychrome",
                      categoryId: 4,
                      creationDate: dateFormatter.date(from: "2019-11-05T15:56:59+0000")!,
                      description: "Magnifique Statuette homme noir assis...",
                      isUrgent: false,
                      imagesUrl: MockImagesURL(
                        small: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg"),
                        thumb: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")),
                      price: 140.00,
                      siret: nil),
               MockAd(id: 1691247255,
                      title: "Pc portable hp elitebook 820 g1 core i5 4 go ram 250 go hdd",
                      categoryId: 8,
                      creationDate: dateFormatter.date(from: "2019-10-16T17:10:20+0000")!,
                      description: "= = = = = = = = = PC PORTABLE HP ELITEBOOK 820 G1 = = = = = = = = =...",
                      isUrgent: false,
                      imagesUrl: MockImagesURL(
                        small: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/633f278423b9aa6b04fa9cc954079befd294473f.jpg"),
                        thumb: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/633f278423b9aa6b04fa9cc954079befd294473f.jpg")),
                      price: 199.00,
                      siret: nil),
               MockAd(id: 1664493117,
                      title: "Professeur natif d'espagnol à domicile",
                      categoryId: 9,
                      creationDate: dateFormatter.date(from: "2019-11-05T15:56:55+0000")!,
                      description: "Doctorant espagnol, ayant fait des études de linguistique comparée français - espagnol ...",
                      isUrgent: true,
                      imagesUrl: nil,
                      price: 25.00,
                      siret: "123 323 002")
    ]

    var categories = [MockCategory(id: 1,
                                   name: "Véhicule"),
                      MockCategory(id: 4,
                                   name: "Maison"),
                      MockCategory(id: 8,
                                   name: "Multimédia"),
                      MockCategory(id: 9,
                                   name: "Service"),
                      MockCategory(id: 10,
                                   name: "Animaux"),
                      MockCategory(id: 11,
                                   name: "Enfants")
    ]
}
