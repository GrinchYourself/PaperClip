//
//  Mocks.swift
//  PaperClipAppTests
//
//  Created by Grinch on 10/11/2022.
//

import Foundation
import Domain

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
                      siret: "123 323 002"),

               MockAd(id: 1701863581,
                      title: "Table basse verre/blanc laqué",
                      categoryId: 4,
                      creationDate: dateFormatter.date(from: "2019-11-05T15:56:18+0000")!,
                      description: "La table basse design LOUNA sera du plus bel effet...",
                      isUrgent: true,
                      imagesUrl: MockImagesURL(
                        small: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/e0ab1cc449b519ed0e26d56e1e3ddc57ebf4d4c5.jpg"),
                        thumb: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/e0ab1cc449b519ed0e26d56e1e3ddc57ebf4d4c5.jpg")),
                      price: 200.00,
                      siret: nil),

               MockAd(id: 1701863750,
                      title: "Meuble tiroirs plastique",
                      categoryId: 6,
                      creationDate: dateFormatter.date(from: "2019-10-22T17:10:20+0000")!,
                      description: "Je vends un meuble 4 tiroirs en plastique. Il y a un accroc sur le dessus, visible sur la 3eme photo.",
                      isUrgent: false,
                      imagesUrl: MockImagesURL(
                        small: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/ccb12e503db57eb612c6c2a986530d9a3ef34db9.jpg"),
                        thumb: URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/ccb12e503db57eb612c6c2a986530d9a3ef34db9.jpg")),
                      price: 17.00,
                      siret: "123 456 789"),
               MockAd(id: 1701863736,
                      title: "Suspension nacré peint art deco",
                      categoryId: 4,
                      creationDate: dateFormatter.date(from: "2019-11-05T15:56:14+0000")!,
                      description: "Suspension en nacre peint art deco  35 Cm de diamètre  A retirer à Paris 16eme",
                      isUrgent: true,
                      imagesUrl: nil,
                      price: 25.00,
                      siret: "123 323 002")
    ]

    var categories = [MockCategory(id: 1,
                                   name: "Véhicule"),
                      MockCategory(id: 4,
                                   name: "Maison"),
                      MockCategory(id: 6,
                                   name: "Immobilier"),
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

struct MockAd: Ad {
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
