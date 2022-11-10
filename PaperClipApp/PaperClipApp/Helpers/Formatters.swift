//
//  Formatters.swift
//  PaperClipApp
//
//  Created by Grinch on 10/11/2022.
//

import Foundation

struct PriceConverter {

    static var shared: PriceConverter = PriceConverter()

    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "eur"
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private init() {}

    func priceInEur(_ price: Double, locale: Locale = .current) -> String? {
        let number = NSNumber(value: price)
        formatter.locale = locale
        return formatter.string(from: number)
    }

}

struct DateConverter {
    static var shared: DateConverter = DateConverter()

    private var dateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .current
        return formatter
    }()

    private init() {}

    func mediumDate(_ date: Date, locale: Locale = .current) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
}
