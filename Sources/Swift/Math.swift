//
//  Math.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import func Darwin.C.math.pow
import func Darwin.C.math.log
import func Darwin.C.math.log2
import func Darwin.C.math.log10
import let Darwin.C.math.M_E


//MARK: Operator Protocols

/// Common set of arithmetic operations.
/// - Required: `x+y`, `-x`, `x*y`, `x/y`
/// - Synthesized: `x-y`, `x+=y`, `x-=y`, `x*=y`, `x/=y`
///
///       static func + (a: Self, b: Self) -> Self
///       static prefix func - (value: Self) -> Self
///       static func * (a: Self, b: Self) -> Self
///       static func / (a: Self, b: Self) -> Self
///
public protocol ArithmeticOperators: AdditionOperation, SubtractionOperation, MultiplicationOperation, DivisionOperation {
    // Empty.
}

/// Standard addition.
public protocol AdditionOperation {
    /// Sum two values.
    static func + (a: Self, b: Self) -> Self
}

/// In-place addition is synthesized.
extension AdditionOperation {
    public static func += (a: inout Self, b: Self) {
        a = a + b
    }
}

/// Standard subtraction.
public protocol SubtractionOperation {
    /// Unary negation.
    static prefix func - (value: Self) -> Self
    /// Subtract two values.
    /// - Note: Synthesized when addition is also implemented, override only for performance reasons.
    static func - (a: Self, b: Self) -> Self
}

/// Subtraction is synthesized when addition is implemented.
extension SubtractionOperation where Self: AdditionOperation {
    public static func - (a: Self, b: Self) -> Self {
        a + -b
    }
}

/// In-place subtraction is synthesized.
extension SubtractionOperation {
    public static func -= (a: inout Self, b: Self) {
        a = a - b
    }
}

/// Standard multiplication.
public protocol MultiplicationOperation {
    /// Multiply two values.
    static func * (a: Self, b: Self) -> Self
}

/// In-place multiplication is synthesized.
extension MultiplicationOperation {
    public static func *= (a: inout Self, b: Self) {
        a = a * b
    }
}

/// Standard division.
public protocol DivisionOperation {
    /// Divide two values.
    static func / (a: Self, b: Self) -> Self
}

/// In-place division is synthesized.
extension DivisionOperation {
    public static func /= (a: inout Self, b: Self) {
        a = a / b
    }
}


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
    
    /// Returns `self³`.
    public func cube() -> Self {
        self * self * self
    }
}

extension Double {
    
    /// Returns `selfⁿ`.
    public func power(_ exponent: Self) -> Self {
        // This is the only use of Darwin.C.math.pow()
        pow(self, exponent)
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
        base.power(exponent)
    }
}

extension BinaryInteger {
    
    /// Returns `xⁿ`.
    public static func ^^ (base: Double, exponent: Self) -> Double {
        base.power(Double(exponent))
    }
    
    /// Returns `xⁿ`.
    public static func ^^ (base: Self, exponent: Double) -> Double {
        Double(base).power(exponent)
    }
    
    /// Returns `xⁿ`.
    public static func ^^ (base: Self, exponent: Self) -> Double {
        Double(base).power(Double(exponent))
    }
}


//MARK: - Roots

extension Double {
    
    /// Returns `³√self`.
    public func cubeRoot() -> Self {
        root(3)
    }
    
    /// Adjusts the number to be `³√self`.
    public mutating func formCubeRoot() {
        self = cubeRoot()
    }
    
    /// Returns `ⁿ√self`.
    public func root(_ order: Self) -> Self {
        power(1/order)
    }
}

/// Operator for square root `²√x`.
prefix operator √

/// Operator for roots `ⁿ√x`.
infix operator √ : ExponentiationPrecedence

extension Double {
    
    /// Returns `²√self`.
    public static prefix func √ (number: Self) -> Self {
        number.squareRoot()
    }
    
    /// Returns `ⁿ√self`.
    public static func √ (order: Self, number: Self) -> Self {
        number.root(order)
    }
}

extension BinaryInteger {
    
    /// Returns `²√self`.
    public static prefix func √ (number: Self) -> Double {
        Double(number).squareRoot()
    }
    
    /// Returns `ⁿ√self`.
    public static func √ (order: Self, number: Double) -> Double {
        number.root(Double(order))
    }
    
    /// Returns `ⁿ√self`.
    public static func √ (order: Double, number: Self) -> Double {
        Double(number).root(order)
    }
    
    /// Returns `ⁿ√self`.
    public static func √ (order: Self, number: Self) -> Double {
        Double(number).root(Double(order))
    }
}


//MARK: - Logarithm

extension Double {
    
    /// The mathematical constant e (Euler’s number).
    public static let e = Darwin.M_E
    // This is the only use of Darwin.C.math.M_E
    
    /// Calculates logarithm for arbitrary base.
    func logarithm(_ base: Self) -> Self {
        // This is the only use of Darwin.C.math.log functions
        switch base {
            case 2:
                return Darwin.log2(self)
            case 10:
                return Darwin.log10(self)
            case .e:
                return Darwin.log(self)
            default:
                return Darwin.log(self) / Darwin.log(base)
        }
    }
}

