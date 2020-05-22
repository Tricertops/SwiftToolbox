//
//  NumberFormatter.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.NumberFormatter
import class Foundation.NSNumber


//MARK: - Constructing

extension NumberFormatter {
    
    /// Configures a number formatter with common user-facing strings.
    public convenience init(fractions: ClosedRange<Int>, suffix: String = "", multiplier: Double = 1) {
        self.init()
        numberStyle = .decimal
        minimumIntegerDigits = 1
        minusSign = "−" // MINUS SIGN (U+2212)
        exponentSymbol = "×10^"
        notANumberSymbol = "--"
        positiveInfinitySymbol = "∞" // INFINITY (U+221E)
        negativeInfinitySymbol = minusSign + positiveInfinitySymbol
        
        self.fractionDigits = fractions
        self.suffix = suffix
        self.multiplier = multiplier as NSNumber
    }
    
    /// Creates a formatter for formatting numbers as percents.
    public static func percent(fractions: ClosedRange<Int>) -> NumberFormatter {
        NumberFormatter(fractions: fractions, suffix: " %", multiplier: 100)
    }
    
    /// Creates a formatter for formatting numbers as degrees (from radians).
    public static func degrees(fractions: ClosedRange<Int>) -> NumberFormatter {
        NumberFormatter(fractions: fractions, suffix: "°", multiplier: 1.toDegrees)
    }
}


//MARK: - Accessors

extension NumberFormatter {
    
    /// Prefix for both positive and negative values. Setter prepends `.minusSign` and `.plusSign` to the value.
    /// - Warning: Returns nil when positive and negative prefixes differ in addition to their signs.
    public var prefix: String? {
        get {
            // Cut plus sign.
            var positive = positivePrefix ?? ""
            if positive.hasPrefix(plusSign) {
                positive = positive[plusSign.length...]
            }
            // Cut minus sign.
            var negative = positivePrefix ?? ""
            if negative.hasPrefix(minusSign) {
                negative = negative[minusSign.length...]
            }
            // Only return when they are equal.
            if positive == negative {
                return positive
            } else {
                return nil
            }
        }
        set {
            // Prepend the appropriate signs.
            positivePrefix = newValue.flatMap { plusSign + $0 }
            negativePrefix = newValue.flatMap { minusSign + $0 }
        }
    }
    
    /// Suffix for both positive and negative values.
    /// - Warning: Returns nil when suffixes differ.
    public var suffix: String? {
        get {
            // Only return when they are equal.
            if positiveSuffix == negativeSuffix {
                return positiveSuffix
            } else {
                return nil
            }
        }
        set {
            positiveSuffix = newValue
            negativeSuffix = newValue
        }
    }
    
    /// Access the range of integer digits.
    /// - Note: Setter turns off usage of significant digits.
    public var integerDigits: ClosedRange<Int> {
        get {
            minimumIntegerDigits ... maximumIntegerDigits
        }
        set {
            usesSignificantDigits = no
            minimumIntegerDigits = newValue.lowerBound
            maximumIntegerDigits = newValue.upperBound
        }
    }
    
    /// Access the range of fractional digits.
    /// - Note: Setter turns off usage of significant digits.
    public var fractionDigits: ClosedRange<Int> {
        get {
            minimumFractionDigits ... maximumFractionDigits
        }
        set {
            usesSignificantDigits = no
            minimumFractionDigits = newValue.lowerBound
            maximumFractionDigits = newValue.upperBound
        }
    }
    
    /// Access the range of significant digits.
    /// - Note: Setter turns on usage of significant digits.
    public var significantDigits: ClosedRange<Int> {
        get {
            minimumSignificantDigits ... maximumSignificantDigits
        }
        set {
            usesSignificantDigits = yes
            minimumSignificantDigits = newValue.lowerBound
            maximumSignificantDigits = newValue.upperBound
        }
    }
}


//MARK: - Formatting

extension NumberFormatter {
    
    /// Formats a floating point number.
    public func string<Number: BinaryFloatingPoint>(from number: Number) -> String {
        string(from: Double(number) as NSNumber) ?? ""
    }
    
    /// Formats an integer number.
    public func string<Number: BinaryInteger>(from number: Number) -> String {
        string(from: Int64(number) as NSNumber) ?? ""
    }
}


//MARK: - String Interpolation

extension String.StringInterpolation {
    
    /// Formats the number using a pre-configured number formatter with given fractional digits range.
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, localized fractions: ClosedRange<Int>) {
        appendInterpolation(number, NumberFormatter(fractions: fractions))
    }
    
    /// Formats the number using the given number formatter.
    public mutating func appendInterpolation<Number: BinaryInteger>(_ number: Number, _ formatter: NumberFormatter) {
        appendLiteral(formatter.string(from: number))
    }
    
    /// Formats the number using the given number formatter.
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ formatter: NumberFormatter) {
        appendLiteral(formatter.string(from: number))
    }
}
