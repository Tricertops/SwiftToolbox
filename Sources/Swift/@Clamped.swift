//
//  @Clamped.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Property Wrapper

/// Property wrapper that clamps values into a given range.
/// Works for numbers and optional numbers, accepts closed or partial range.
///
///     @Clamped(0...1) var progress: Double = 0
///     @Clamped(0...) var length: Double? = 0
///
@propertyWrapper
public struct Clamped<Value: Clampable> {
    
    /// Declares a clamped property with both minimum an maximum value.
    public init(wrappedValue initialValue: Value, _ range: ClosedRange<Value.ClampableRangeBound>) {
        self.lowerBound = range.lowerBound
        self.upperBound = range.upperBound
        // We want to clamp the initial value, too.
        self.rawValue = initialValue.clamped(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }

    /// Declares a clamped property with only minimum value.
    public init(wrappedValue initialValue: Value, _ range: PartialRangeFrom<Value.ClampableRangeBound>) {
        self.lowerBound = range.lowerBound
        self.upperBound = nil
        // We want to clamp the initial value, too.
        self.rawValue = initialValue.clamped(lowerBound: range.lowerBound, upperBound: nil)
    }

    /// Declares a clamped property with only maximum value.
    public init(wrappedValue initialValue: Value, _ range: PartialRangeThrough<Value.ClampableRangeBound>) {
        self.lowerBound = nil
        self.upperBound = range.upperBound
        // We want to clamp the initial value, too.
        self.rawValue = initialValue.clamped(lowerBound: nil, upperBound: range.upperBound)
    }
    
    /// Access to the wrapper itself.
    public var projectedValue: Self {
        self
    }
    
    /// Lower bound of the property, if defined.
    public let lowerBound: Value.ClampableRangeBound?
    
    /// Upper bound of the property, if defined.
    public let upperBound: Value.ClampableRangeBound?
    
    /// Wrapped value. Setter clamps the value to allowed range.
    public var wrappedValue: Value {
        get {
            rawValue
        }
        set {
            rawValue = newValue.clamped(lowerBound: lowerBound, upperBound: upperBound)
        }
    }
    
    /// Internal raw value.
    private var rawValue: Value
}


//MARK: Conformances

/// Protocol that defines how to clamp its values.
public protocol Clampable {
    
    /// Type to which it can be clamped.
    associatedtype ClampableRangeBound: Comparable
    
    /// Return value clamped to given bounds, if any.
    func clamped(lowerBound: ClampableRangeBound?, upperBound: ClampableRangeBound?) -> Self
}

/// Numbers are clampable.
extension Numeric where Self: Comparable {
    public typealias ClampableRangeBound = Self
    
    public func clamped(lowerBound: ClampableRangeBound?, upperBound: ClampableRangeBound?) -> Self {
        if let lowerBound = lowerBound, self < lowerBound {
            return lowerBound
        }
        if let upperBound = upperBound, self > upperBound {
            return upperBound
        }
        return self
    }
}

extension Double: Clampable {
    // Empty.
}

extension Int: Clampable {
    // Empty.
}

/// Optional numbers are clampable.
extension Optional: Clampable where Wrapped: Clampable & Comparable {
    public typealias ClampableRangeBound = Wrapped.ClampableRangeBound
    
    public func clamped(lowerBound: ClampableRangeBound?, upperBound: ClampableRangeBound?) -> Wrapped? {
        self?.clamped(lowerBound: lowerBound, upperBound: upperBound)
    }
}

