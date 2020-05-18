//
//  Double.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import func Darwin.C.math.log


//MARK: Formatting

extension String.StringInterpolation {
    
    /// Formats the number using to a short pretty string with no trailing fractional zeros.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     "\(pi, .pretty)"  // "3.14159"
    ///     "\(pi, .percent)"  // "314%"
    ///     "\(pi, .degrees)"  // "180°"
    ///
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ specifier: Double.Formatting) {
        appendInterpolation(number, specifier, 0)
    }
    
    /// Formats the number using to a short pretty string with no trailing fractional zeros.
    /// - Note: Due to a Swift parsing bug, the operator must be in parentheses.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     "\(pi, (~))"  // "3.14159"
    ///     "\(pi, (%))"  // "314%"
    ///     "\(pi, (°))"  // "180°"
    ///
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ specifier: Double.Formatting.Specifier) {
        appendInterpolation(number, specifier(Double.Formatting.self), 0)
    }
    
    /// Formats the number using to a short pretty string with given number of fractional digits.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     "\(pi, 0)"  // "3"
    ///     "\(pi, 3)"  // "3.142"
    ///     "\(pi, 6)"  // "3.141593"
    ///
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ fractions: Int) {
        appendInterpolation(number, Double.Formatting.fractions, fractions)
    }
    
    /// Formats the number using to a short pretty string with given number of fractional digits.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     "\(pi, %, 1)"  // "314.2%"
    ///     "\(pi, °, 2)"  // "180.00°"
    ///
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ specifier: Double.Formatting.Specifier, _ fractions: Int) {
        appendInterpolation(number, specifier(Double.Formatting.self), fractions)
    }
    
    /// Formats the number using to a short pretty string with given number of fractional digits.
    ///
    ///     "\(pi)"  // "3.141592653589793"
    ///     "\(pi, .percent, 1)"  // "314.2%"
    ///     "\(pi, .degrees, 2)"  // "180.00°"
    ///
    public mutating func appendInterpolation<Number: BinaryFloatingPoint>(_ number: Number, _ specifier: Double.Formatting, _ fractions: Int) {
        let string = specifier.format(number, fractions: fractions)
        appendLiteral(string)
    }
    
}


/// Operator for specifying automatic pretty formatting.
postfix operator ~

extension Double {
    
    /// Internal enum for resolving numeric formats.
    public enum Formatting {
        /// Either a decimal format with variable number of digits or scientific format.
        case pretty
        /// Decimal format with fixed number of digits.
        case fractions
        /// Decimal format of number converted from radians to degrees and with ° suffix.
        case degrees
        /// Decimal format of number multiplied by 100 and with % suffix.
        case percent
        
        public typealias Specifier = (Double.Formatting.Type) -> Double.Formatting
        
        /// Public specifier for `.pretty` case.
        public static postfix func ~ (dummy: Formatting.Type) -> Formatting {
            .pretty
        }
        
        /// Public specifier for `.degrees` case.
        public static postfix func ° (dummy: Formatting.Type) -> Formatting {
            .degrees
        }
        
        /// Public specifier for `.percents` case.
        public static postfix func % (dummy: Formatting.Type) -> Formatting {
            .percent
        }
        
        /// Builds string from the number. Number will be converted to Double.
        fileprivate func format<Number: BinaryFloatingPoint>(_ number: Number, fractions: Int) -> String {
            let double = Double(number)
            let fractions = fractions.clamped(to: 0...10)
            switch self {
                case .pretty:
                    return String(format: "%g", double) // Ignores fractions.
                case .fractions:
                    return String(format: "%.*f", fractions, double)
                case .degrees:
                    return String(format: "%.*f°", fractions, double.toDegrees)
                case .percent:
                    return String(format: "%.*f%%", fractions, double * 100)
            }
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
        if self.isNaN || self.isInfinite {
            return 0
        }
        let abs = Double(self.magnitude)
        if abs == 0 {
            return 1
        }
        let digits = abs.logarithm(10).rounded(.awayFromZero)
        return Int(digits)
    }
    
    /// Number of zeros after decimal point when formatted to string.
    public var leadingFractionalZeros: Int {
        if self.isNaN || self.isInfinite {
            return 0
        }
        let fraction = Double(self.fraction.magnitude)
        if fraction == 0 {
            return 0
        }
        let zeros = fraction.logarithm(10).rounded(.awayFromZero)
        return Int(-zeros)
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


//MARK: - Comparisons

extension AdditiveArithmetic {
    
    /// Checks whether the number is in given range.
    public func isWithin<Range: RangeExpression>(_ range: Range) -> Bool where Range.Bound == Self {
        range.contains(self)
    }
}

extension FloatingPoint {
    
    /// Coalesce NaN into nil.
    var nanAsNil: Self? {
        (isNaN ? nil : self)
    }
}

