//
//  @ThreadLocal.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Property Wrapper

/// Property wrapper that stores the value in a thread-shared storage.
///
///     @ThreadLocal var cache: [String: Int] = [:]
///
@propertyWrapper
public struct ThreadLocal<Value> {
    
    /// Declares a property that stores the value in a thread-shared storage.
    /// - Note: Key is inferred automatically from position in the source code.
    public init(wrappedValue initial: Value, _ function: StaticString = #function, _ line: UInt = #line) {
        self.key = "\(Self.self)@\(CompilerDirectives.declarationIdentifier(function: function, line: line))"
        self.wrappedValue = initial
    }
    
    /// Value stored in current thread dictionary.
    public var wrappedValue: Value {
        get {
            let value = Thread.current.threadDictionary[key]
            return try! value as? Value !! Assert("Type mismatch, expected \(Value.self), found \(type(of: value))")
        }
        set {
            Thread.current.threadDictionary[key] = newValue
        }
    }
    
    /// Internal storage key.
    private let key: String
}

