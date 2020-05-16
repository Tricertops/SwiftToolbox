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


//MARK: - Literals

extension ClosedRange: ExpressibleByIntegerLiteral where Bound == IntegerLiteralType {
    
    /// Allows creation of range from a single value.
    public init(integerLiteral value: IntegerLiteralType) {
        self = value ... value
    }
}

extension ClosedRange: ExpressibleByFloatLiteral where Bound == FloatLiteralType {
    
    /// Allows creation of range from a single value.
    public init(floatLiteral value: FloatLiteralType) {
        self = value ... value
    }
}

