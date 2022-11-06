//
//  ClassifiedAdDTO.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation

struct ClassifiedAdDTO: Decodable {
    let id: Int
    let title: String
    let categoryId: Int
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImagesURLDTO
    let price: Double
    let siret: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryId   = "category_id"
        case creationDate = "creation_date"
        case description
        case isUrgent     = "is_urgent"
        case imagesUrl    = "images_url"
        case price
        case siret
    }

}
