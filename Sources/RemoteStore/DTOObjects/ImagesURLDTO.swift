//
//  ImagesURLDTO.swift
//  
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Domain

struct ImagesURLDTO: Decodable, ImagesURL {
    // MARK: Decodable
    let smallDTO: String?
    let thumbDTO: String?

    // MARK: Domain
    var small: URL? {
        guard let smallDTO else { return nil }
        return URL(string: smallDTO)
    }

    var thumb: URL? {
        guard let thumbDTO else { return nil }
        return URL(string: thumbDTO)
    }
}
