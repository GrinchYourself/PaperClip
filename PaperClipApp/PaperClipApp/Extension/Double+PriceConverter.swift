//
//  Double+PriceConverter.swift
//  PaperClipApp
//
//  Created by Grinch on 10/11/2022.
//

import Foundation

extension Double {

    var euros: String? {
        PriceConverter.shared.priceInEur(self)
    }

}
