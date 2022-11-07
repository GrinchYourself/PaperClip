//
//  CategoryDTO.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Domain

struct CategoryDTO: Decodable, Domain.Category {
    let id: Int
    let name: String
}
