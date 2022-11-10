//
//  Date+DateConverter.swift
//  PaperClipApp
//
//  Created by Grinch on 10/11/2022.
//

import Foundation

extension Date {

    var short: String? {
        DateConverter.shared.mediumDate(self)
    }

}
