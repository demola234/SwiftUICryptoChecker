//
//  Double.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import Foundation


extension Double {
    /// Converts a `Double` value to a currency formatted `String`.
    /// ```
    /// Example:
    /// let value: Double = 123456.789
    /// let formattedValue = value.asCurrencyString
    /// print(formattedValue) // Output: $123,456.79
    /// ```
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// ```
    /// Example:
    /// let value: Double = 123456.789
    /// let formattedValue = value.asCurrencyString
    /// print(formattedValue) // Output: $123,456.79
    /// ```
    func asCurrencyString() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    /// ```
    /// Example:
    /// let value: Double = 123456.789
    /// let formattedValue = value.asNumberString
    /// print(formattedValue) // Output: 123456.79
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    
    /// ```
    /// Example:
    /// let value: Double = 0.123
    /// let formattedValue = value.asPercentString
    /// print(formattedValue) // Output: 12.3%
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    func formattedWithAbbreviation() -> String {
        let numFormatter = NumberFormatter()
        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [(0, 1, ""),
                                            (1000, 1_000, "K"),
                                            (100_000, 1_000_000, "M"),
                                            (100_000_000, 1_000_000_000, "B"),
//                                            (100_000_000_000, 1_000_000_000_000, "T")
        
        ]
        
        let startValue = Double(abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()
        
        let value = self / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}
