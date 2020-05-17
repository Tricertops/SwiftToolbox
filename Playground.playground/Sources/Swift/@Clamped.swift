//
//  @Clamped.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Property Wrapper

/// Property wrapper that constrains values into a given range.
@propertyWrapper
public struct Clamped<Number: Comparable> {
    
    /// Declares a clamped property with both minimum an maximum value.
    public init(wrappedValue initialValue: Number, _ range: ClosedRange<Number>) {
        self.lowerBound = range.lowerBound
        self.upperBound = range.upperBound
        // We want to clamp the initial value, too.
        self.rawValue = range.lowerBound
        self.wrappedValue = initialValue
    }
    
    /// Declares a clamped property with only minimum value.
    public init(wrappedValue initialValue: Number, _ range: PartialRangeFrom<Number>) {
        self.lowerBound = range.lowerBound
        self.upperBound = nil
        // We want to clamp the initial value, too.
        self.rawValue = range.lowerBound
        self.wrappedValue = initialValue
    }
    
    /// Declares a clamped property with only maximum value.
    public init(wrappedValue initialValue: Number, _ range: PartialRangeThrough<Number>) {
        self.lowerBound = nil
        self.upperBound = range.upperBound
        // We want to clamp the initial value, too.
        self.rawValue = range.upperBound
        self.wrappedValue = initialValue
    }
    
    /// Access to the wrapper itself.
    public var projectedValue: Self {
        self
    }
    
    /// Lower bound of the property, if defined.
    public let lowerBound: Number?
    
    /// Upper bound of the property, if defined.
    public let upperBound: Number?
    
    /// Wrapped value. Setter clamps the value to allowed range.
    public var wrappedValue: Number {
        get {
            rawValue
        }
        set {
            var newValue = newValue
            if let lowerBound = lowerBound {
                newValue = max(newValue, lowerBound)
            }
            if let upperBound = upperBound {
                newValue = min(newValue, upperBound)
            }
            rawValue = newValue
        }
    }
    
    /// Internal raw value.
    private var rawValue: Number
}

