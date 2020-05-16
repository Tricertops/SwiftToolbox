//
//  File.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Span

extension Range where Bound: AdditiveArithmetic {
    
    /// Distance between upper and lower bounds.
    public var span: Bound {
        upperBound - lowerBound
    }
}

extension ClosedRange where Bound: AdditiveArithmetic {
    
    /// Distance between upper and lower bounds.
    public var span: Bound {
        upperBound - lowerBound
    }
}

extension ClosedRange where Bound: FloatingPoint {
    
    /// Calculates middle value of the range.
    public var middle: Bound {
        lowerBound + (upperBound - lowerBound) / 2
    }
}

/// Operator for inacuracies.
infix operator ±

/// Create numeric range from middle value and inaccuracy span.
public func ± <Number: Numeric>(middle: Number, inaccuracy: Number) -> ClosedRange<Number> {
    let inaccuracy = (inaccuracy < 0 ? inaccuracy * -1 : inaccuracy)
    return (middle - inaccuracy) ... (middle + inaccuracy)
}

//MARK: - Literals

extension ClosedRange: ExpressibleByIntegerLiteral where Bound: ExpressibleByIntegerLiteral {
    
    /// Allows creation of range from a single value.
    public init(integerLiteral value: Bound.IntegerLiteralType) {
        let bound = Bound(integerLiteral: value)
        self = bound ... bound
    }
}

extension ClosedRange: ExpressibleByFloatLiteral where Bound: ExpressibleByFloatLiteral {
    
    /// Allows creation of range from a single value.
    public init(floatLiteral value: Bound.FloatLiteralType) {
        let bound = Bound(floatLiteral: value)
        self = bound ... bound
    }
}

