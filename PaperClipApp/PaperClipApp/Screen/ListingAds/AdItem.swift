//
//  AdItem.swift
//  PaperClipApp
//
//  Created by Grinch on 09/11/2022.
//

import Foundation

struct AdItem: Hashable {
    let identifier: Int
    let creationDate: Date
    let isUrgent: Bool
    let thumbImageURL: URL?
    let title: String
    let category: String
    let price: String?
}

extension AdItem: Comparable {
    static func < (lhs: AdItem, rhs: AdItem) -> Bool {
        if lhs.isUrgent == rhs.isUrgent {
            if lhs.creationDate == rhs.creationDate {
                return lhs.identifier < rhs.identifier
            } else {
                return lhs.creationDate < rhs.creationDate
            }
        } else {
            return lhs.isUrgent && !rhs.isUrgent
        }
    }

    static func == (lhs: AdItem, rhs: AdItem) -> Bool {
        lhs.identifier == rhs.identifier
    }

    static func > (lhs: AdItem, rhs: AdItem) -> Bool {
        if lhs.isUrgent == rhs.isUrgent {
            if lhs.creationDate == rhs.creationDate {
                return lhs.identifier > rhs.identifier
            } else {
                return lhs.creationDate > rhs.creationDate
            }
        } else {
            return lhs.isUrgent && !rhs.isUrgent
        }
    }
}
