//
//  CategoryFilter.swift
//  PaperClipApp
//
//  Created by Grinch on 11/11/2022.
//

import Foundation
import Domain

struct CategoryFilter: Hashable {
    let identifier: Int
    let name: String
    let isSelected: Bool
}

extension CategoryFilter: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier && lhs.isSelected == rhs.isSelected
    }

}
