//
//  AdItem.swift
//  PaperClipApp
//
//  Created by Grinch on 09/11/2022.
//

import Foundation

struct AdItem {
    let identifier: Int
    let price: Double
    let isUrgent: Bool
    let thumbImageURL: URL?
    let creationDate: Date
    let title: String
    let category: String
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
