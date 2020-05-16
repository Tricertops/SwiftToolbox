//
//  Assert.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Assertion Operator

/// Assertion operator of low precedence.
infix operator !! : TernaryPrecedence


/// Assertion operator on Optional. If it is nil, the provided Error is thrown.
/// Type `Assert` is provided for convenience, it captures current context and prints it to console.
/// You can use `try` to propagate the failure, `try!` to crash or `try?` to just print the failure to console.
///
///     let first = try array.first !! Assert("List must not be empty.")
///
@discardableResult
public func !! <Value>(optional: Value?, error: @autoclosure () -> Error) throws -> Value {
    if let value = optional {
        return value
    } else {
        throw error()
    }
}

/// Assertion operator on Bool. If it is `false`, the provided Error is thrown.
/// Type `Assert` is provided for convenience, it captures current context and prints it to console.
/// You can use `try` to propagate the failure, `try!` to crash or `try?` to just print the failure to console.
///
///     try value > 0 !! Assert("Must be positive.")
///
public func !! (condition: Bool, error: @autoclosure () -> Error) throws {
    if condition {
        return
    } else {
        throw error()
    }
}


//MARK: - Assertion Error

/// Error that holds information about a failed assertion. Thrown from `assertion()` functions or manually.
public struct Assert: Error, CustomDebugStringConvertible {
    
    /// Assertion message.
    public let message: String
    /// Name of function where the assertion failed.
    public let function: String
    /// Name of the file where the assertion failed.
    public let file: String
    /// Line number on which the assertion failed.
    public let line: Int
    
    /// Provide only the message, context will be captured automatically.
    public init(_ message: String, _ function: StaticString = #function, _ file: StaticString = #file, _ line: UInt = #line) {
        self.message = message
        self.function = "\(function)"
        self.file = "\(file)"
        self.line = Int(line)
        
        debugPrint(self)
    }
    
    public var debugDescription: String {
        """
        *** Assertion Failure ***
        File: \(file):\(line)
        Function: \(function)
        Message: \(message)
        """
    }
}

