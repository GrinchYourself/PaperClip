//
//  Ad.swift
//  
//
//  Created by Grinch on 07/11/2022.
//

import Foundation

public protocol Ad {
    var id: Int { get }
    var title: String { get }
    var categoryId: Int { get }
    var creationDate: Date { get }
    var description: String { get }
    var isUrgent: Bool { get }
    var imagesUrl: ImagesURL? { get }
    var price: Double { get }
    var siret: String? { get }
}

public protocol ImagesURL {
    var small: URL? { get }
    var thumb: URL? { get }
}
