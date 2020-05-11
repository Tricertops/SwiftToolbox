//
//  Double.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import func Darwin.C.math.ceil
import func Darwin.C.math.log10


//MARK: Formatting

extension BinaryFloatingPoint {
    
    /// Formats the number as percent value, optionally with fractional digits.
    ///
    ///     "\(share)"  // "0.5846153846153845"
    ///     share.formattedPercent()  // "58%"
    ///     share.formattedPercent()  // "58.46%"
    ///
    
    /// Formats the number using to a short pretty string with no trailing fractional zeros.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     pi.pretty  // "3.14159"
    ///     pi.pretty(2)  // "3.14"
    ///
    public var pretty: String {
        pretty(Double.Formatting.auto, 0)
    }
    
    /// Formats the number using to a short pretty string with given number of fractional digits.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     pi.pretty  // "3.14159"
    ///     pi.pretty(2)  // "3.14"
    ///
    public func pretty(_ precision: Int) -> String {
        return pretty(Double.Formatting.fract, precision)
    }
    
    /// Formats the number as degrees (°) or as percents (%), optionally with given number of fractional digits.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     pi.pretty(°)  // "180°"
    ///     pi.pretty(%, 2)  // "314.16%"
    ///
    public func pretty(_ specifier: (Double.Formatting.Type) -> Double.Formatting, _ precision: Int = 0) -> String {
        switch specifier(Double.Formatting.self) {
            case .automatic:
                return String(format: "%g", Double(self))
            case .fractions:
                return String(format: "%.*f", precision, Double(self))
            case .degrees:
                return String(format: "%.*f°", precision, Double(self).toDegrees)
            case .percents:
                return String(format: "%.*f%%", precision, Double(self) * 100)
        }
    }
}

extension Double {
    
    /// Internal enum for resolving numeric formats.
    public enum Formatting {
        /// Either a decimal format with variable number of digits or scientific format.
        case automatic
        /// Decimal format with fixed number of digits.
        case fractions
        /// Decimal format of number converted from radians to degrees and with ° suffix.
        case degrees
        /// Decimal format of number multiplied by 100 and with % suffix.
        case percents
        
        /// Internal specifier for `.automatic` case.
        fileprivate static func auto (_ formatting: Formatting.Type) -> Formatting {
            .automatic
        }
        
        /// Internal specifier for `.fractions` case.
        fileprivate static func fract (_ formatting: Formatting.Type) -> Formatting {
            .fractions
        }
        
        /// Public specifier for `.degrees` case.
        public static postfix func ° (formatting: Formatting.Type) -> Formatting {
            .degrees
        }
        
        /// Public specifier for `.percents` case.
        public static postfix func % (formatting: Formatting.Type) -> Formatting {
            .percents
        }
    }
}


//MARK: - Digits & Fractions

extension BinaryFloatingPoint {
    
    /// Returns only the fractional part of the number.
    public var fraction: Self {
        self - rounded(.towardZero)
    }
    
    /// Number of integer digits when formatted to string.
    public var integerDigits: Int {
        if self == 0 {
            return 1
        }
        if self.isNaN || self.isInfinite {
            return 0
        }
        return Int(ceil(log10(Double(self))))
    }
    
    /// Number of zeros after decimal point when formatted to string.
    public var leadingFractionalZeros: Int {
        let fraction = self.fraction
        if fraction == 0 {
            return 0
        }
        if self.isNaN || self.isInfinite {
            return 0
        }
        return -Int(ceil(log10(Double(fraction))))
    }
}


//MARK: - Linear Mapping

extension FloatingPoint {
    
    /// Maps number from given range to 0...1.
    ///
    ///     let x = 12.normalize(to: 10...20)  // x is 0.2
    ///
    public func normalized(to range: ClosedRange<Self>) -> Self {
        (self - range.lowerBound) / range.span
    }
    
    /// Maps number from 0...1 to given range.
    ///
    ///     let x = (0.2).interpolate(in: 25...40) // x is 30
    ///
    public func interpolated(in range: ClosedRange<Self>) -> Self {
        range.lowerBound + (self * range.span)
    }
    
    /// Maps number from one range to another.
    ///
    ///     let x = 12.map(from: 10...20, to: 25...40)  // x is 30
    ///
    public func map(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
        normalized(to: input).interpolated(in: output)
    }
}


//MARK: - Clamping

extension AdditiveArithmetic where Self: Comparable {
    
    /// Returns the nearest number in the given range.
    public func clamped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        }
        if self > range.upperBound {
            return range.upperBound
        }
        return self
    }
    
    /// Returns the nearest number in the given range.
    public func clamped(to range: PartialRangeFrom<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        }
        return self
    }
    
    /// Returns the nearest number in the given range.
    public func clamped(to range: PartialRangeThrough<Self>) -> Self {
        if self > range.upperBound {
            return range.upperBound
        }
        return self
    }
    
    /// Adjusts the number to be in the given range.
    public mutating func clamp(to range: ClosedRange<Self>) {
        self = clamped(to: range)
    }
    
    /// Adjusts the number to be in the given range.
    public mutating func clamp(to range: PartialRangeFrom<Self>) {
        self = clamped(to: range)
    }
    
    /// Adjusts the number to be in the given range.
    public mutating func clamp(to range: PartialRangeThrough<Self>) {
        self = clamped(to: range)
    }
}


//MARK: - Percent

/// Operator for specifying percent values.
postfix operator %

extension FloatLiteralType {
    
    /// Literal suffix for specifying percentages.
    ///
    ///     opacity = 75%  // = 0.75
    ///
    public static postfix func % (number: Self) -> Self {
        number / 100
    }
}


//MARK: - Angles

/// Operator for specifying degrees values.
postfix operator °

extension FloatLiteralType {
    
    /// Literal suffix for specifying angles in degrees.
    ///
    ///     rotation = 45°  // = 0.7854...
    ///
    static postfix func ° (degrees: Self) -> Self {
        degrees.toRadians
    }
}

extension FloatingPoint {
    
    /// Converts radians to degrees.
    public var toDegrees: Self {
        self / .pi * 180
    }
    
    /// Converts degrees to radians.
    public var toRadians: Self {
        self / 180 * .pi
    }
}

