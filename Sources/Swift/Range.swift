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

