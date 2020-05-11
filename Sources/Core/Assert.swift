//
//  Assert.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Assertion Functions

/// Reliable recoverable assertion that throws an Error.
///
///     try assertion(value > 0, "Must be positive.")  // Throws AssertionError.failure
///     try! assertion(value > 0, "Must be positive.")  // Crashes
///     try? assertion(value > 0, "Must be positive.")  // Prints message to console
///
public func assertion(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, _ function: StaticString = #function, _ file: StaticString = #file, _ line: UInt = #line) throws {
    if !condition() {
        let error = AssertionError(message: message().description, function, file, line)
        debugPrint(error)
        throw error
    }
}

/// Reliable recoverable assertion (with no message) that throws an Error.
///
///     try assertion(value > 0)  // Throws AssertionError.failure
///     try! assertion(value > 0)  // Crashes
///     try? assertion(value > 0)  // Prints message to console
///
public func assertion(_ condition: @autoclosure () -> Bool, _ function: StaticString = #function, _ file: StaticString = #file, _ line: UInt = #line) throws {
    try assertion(condition(), "(no message)")
}


//MARK: - Assertion Error

/// Error that holds information about a failed assertion. Thrown from `assertion()` functions or manually.
public struct AssertionError: Error, CustomDebugStringConvertible {
    
    /// Assertion message.
    public let message: String
    /// Name of function where the assertion failed.
    public let function: String
    /// Name of the file where the assertion failed.
    public let file: String
    /// Line number on which the assertion failed.
    public let line: Int
    
    /// Provide only the message, context will be captured automatically.
    public init(message: String, _ function: StaticString = #function, _ file: StaticString = #file, _ line: UInt = #line) {
        self.message = message
        self.function = "\(function)"
        self.file = "\(file)"
        self.line = Int(line)
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

