//
//  ClassifiedAdDTO.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Domain

struct ClassifiedAdDTO: Decodable, Ad {
    // MARK: Decodable && Domain
    let id: Int
    let title: String
    let categoryId: Int
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let price: Double
    let siret: String?

    // MARK: Decodable
    let imagesUrlDTO: ImagesURLDTO

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryId   = "category_id"
        case creationDate = "creation_date"
        case description
        case isUrgent     = "is_urgent"
        case imagesUrlDTO = "images_url"
        case price
        case siret
    }

    // MARK: Domain
    var imagesUrl: ImagesURL? {
        if imagesUrlDTO.thumbDTO == nil && imagesUrlDTO.smallDTO == nil {
            return nil
        } else {
            return imagesUrlDTO
        }
    }
}
