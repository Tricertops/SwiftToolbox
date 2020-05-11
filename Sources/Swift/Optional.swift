//
//  Optional.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Forced Unwrapping

/// Operator for customizing force unwrapping of Optionals.
infix operator !! : NilCoalescingPrecedence


/// Force unwraps the Optional. When nil, crashes with a message.
///
///     array.first !! "Must not be empty."
///
public func !! <Value>(optional: Value?, message: @autoclosure () -> String) throws -> Value {
    optional !! fatalError(message())
}

/// Force unwraps the Optional. When nil, invokes provided Never-returning function.
///
///     array.first !! abort()
///
public func !! <Value>(_ optional: Value?, _ failure: @autoclosure () -> Never) -> Value {
    if let value = optional {
        return value
    }
    else {
        failure()
    }
}

/// Force unwraps the Optional. When nil, throws the provided Error.
///
///     try array.first !! MyError.userMissing
///
public func !! <Value>(optional: Value?, error: @autoclosure () -> Error) throws -> Value {
    if let value = optional {
        return value
    }
    else {
        throw error()
    }
}



//MARK: - Bool Operators

/// Operator for asking Optional for some value.
postfix operator .?
/// Operator for asking Optional for nil.
postfix operator .?!

extension Optional {
    
    /// Is any?
    public static postfix func .? (optional: Self) -> Bool {
        optional != nil
    }
    
    /// Is none?
    public static postfix func .?! (optional: Self) -> Bool {
        optional == nil
    }
}

