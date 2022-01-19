//
//  Double.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation

extension Double {
    /// Converts a Double into a Currency with 2 digits
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        // change later
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    /// Converts a Double into a Currency with 2 digits
    func currencyTo2Digits() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double into String
    func numberTo6Digits() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double Percent into String
    func percentToString() -> String {
        return numberTo6Digits() + "%"
    }
}
