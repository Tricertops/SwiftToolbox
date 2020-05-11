//
//  Math.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Darwin


//MARK: - Increment & Decrement

extension AdditiveArithmetic where Self : ExpressibleByIntegerLiteral {
    
    /// Good old postfix increment operator without all the undefined behavior.
    public static postfix func ++ (value: inout Self) {
        value += 1
    }
    
    /// Good old postfix decrement operator without all the undefined behavior.
    public static postfix func -- (value: inout Self) {
        value -= 1
    }
}


//MARK: - Division

extension BinaryInteger {
    
    /// Integer division returns a Double.
    public static func / (a: Self, b: Self) -> Double {
        Double(a) / Double(b)
    }
    
    /// Integer division.
    public func divided(by other: Self) -> Self {
        quotientAndRemainder(dividingBy: other).quotient
    }
    
    /// Remainder after division.
    public func remainder(from other: Self) -> Self {
        quotientAndRemainder(dividingBy: other).remainder
    }
    
    /// Remainder after dividion must be 0.
    public func isDivisible(by other: Self) -> Bool {
        remainder(from: other) == 0
    }
}

extension Int {
    
    @available(*, deprecated, message: "Avoid integer division.")
    public static func / (a: Self, b: Self) -> Self {
        a.divided(by: b)
    }
}

extension UInt {
    
    @available(*, deprecated, message: "Avoid integer division.")
    public static func / (a: Self, b: Self) -> Self {
        a.divided(by: b)
    }
}


//MARK: - Signs

extension FloatingPoint {
    
    /// Multiplication with a sign, where minus negates the number.
    public static func * (number: Self, sign: FloatingPointSign) -> Self {
        switch sign {
            case .plus: return number
            case .minus: return -number
        }
    }
    
    /// Multiplication with a sign, where minus negates the number.
    public static func * (sign: FloatingPointSign, number: Self) -> Self {
        switch sign {
            case .plus: return number
            case .minus: return -number
        }
    }
}


//MARK: - Powers

extension FloatingPoint {
    
    /// Returns `self²`.
    public func square() -> Self {
        self * self
    }
    
    /// Returns `self³`
    public func cube() -> Self {
        self * self * self
    }
}

/// Precedence for power and root operators.
precedencegroup ExponentiationPrecedence {
    higherThan: MultiplicationPrecedence
    associativity: left
}

/// Operator for powers, since `^` is already defined for integers.
infix operator ^^ : ExponentiationPrecedence

extension Double {
    
    /// Returns `base` to the power of `exponent`.
    public static func ^^ (base: Self, exponent: Self) -> Self {
        pow(base, exponent)
    }
}

extension BinaryInteger {
    
    /// Returns `base` to the power of `exponent`.
    public static func ^^ (base: Double, exponent: Self) -> Double {
        pow(base, Double(exponent))
    }
    
    /// Returns `base` to the power of `exponent`.
    public static func ^^ (base: Self, exponent: Double) -> Double {
        pow(Double(base), exponent)
    }
    
    /// Returns `base` to the power of `exponent`.
    public static func ^^ (base: Self, exponent: Self) -> Double {
        pow(Double(base), Double(exponent))
    }
}


//MARK: - Roots

extension Double {
    
    /// Returns `³√self`.
    public func cubeRoot() -> Self {
        pow(self, 1/3)
    }
    
    /// Adjusts the number to be `³√self`.
    public mutating func formCubeRoot() {
        self = cubeRoot()
    }
}

/// Operator for square root `²√x`.
prefix operator √

/// Operator for roots `ⁿ√x`.
infix operator √ : ExponentiationPrecedence

extension Double {
    
    /// Returns principal square root `²√self`.
    public static prefix func √ (number: Self) -> Self {
        number.squareRoot()
    }
    
    /// Returns principal root of given order `ⁿ√self`.
    public static func √ (order: Self, number: Self) -> Self {
        pow(number, 1/order)
    }
}

extension BinaryInteger {
    
    /// Returns principal square root `²√self`.
    public static prefix func √ (number: Self) -> Double {
        Double(number).squareRoot()
    }
    
    /// Returns principal root of given order `ⁿ√self`.
    public static func √ (order: Self, number: Double) -> Double {
        pow(number, 1/Double(order))
    }
    
    /// Returns principal root of given order `ⁿ√self`.
    public static func √ (order: Double, number: Self) -> Double {
        pow(Double(number), 1/order)
    }
    
    /// Returns principal root of given order `ⁿ√self`.
    public static func √ (order: Self, number: Self) -> Double {
        pow(Double(number), 1/Double(order))
    }
}

