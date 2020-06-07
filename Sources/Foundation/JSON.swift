//
//  JSON.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Supported Types

/// Type that can be encoded into JSON.
public protocol JSON {
    // Empty.
}

/// Type that can be encoded into JSON as leaf (not a container).
public protocol JSONLeaf: JSON {
    // Empty.
}

/// Type that can be encoded into JSON as a top-level object.
public protocol JSONContainer: JSON {
    // Empty.
}

extension Bool: JSONLeaf {
    // Empty.
}

extension Int: JSONLeaf {
    // Empty.
}

extension Double: JSONLeaf {
    // NaN, Infinity, and -Infinity are NOT supported.
}

extension String: JSONLeaf {
    // Empty.
}

extension Optional: JSON, JSONLeaf where Wrapped: JSON {
    // Empty.
}

extension Array: JSON, JSONContainer where Element: JSON {
    // Empty.
}

extension Dictionary: JSON, JSONContainer where Key == String, Value: JSON {
    // Empty.
}


//MARK: - Serialization

/// These extensions fully replace `JSONSerialization` class.

extension JSONDecoder {
    
    /// Deserializes objects from a JSON data.
    public static func deserialize(data: Data) throws -> JSONContainer {
        // No options are relevant here: fragments are not supported, mutability is handled by var/let.
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        return try (object as? JSONContainer) !! Assert("Unsupported type in JSON: \(type(of: object))")
    }
    
    /// Returns a pretty-formatted JSON string for debugging purposes.
    public static func prettify(_ data: Data) -> String {
        do {
            let object = try deserialize(data: data)
            let prettyData = try JSONEncoder.serialize(object: object, options: .prettyPrinted)
            return try String(data: prettyData, encoding: .utf8) !! Assert("Failed to read JSON.")
        }
        catch {
            return "(invalid JSON)"
        }
    }
    
    /// Deserializes objects from a JSON stream.
    public static func read(from stream: InputStream) throws -> JSONContainer {
        // No options are relevant here: fragments are not supported, mutability is handled by var/let.
        let object = try JSONSerialization.jsonObject(with: stream, options: [])
        return try (object as? JSONContainer) !! Assert("Unsupported type in JSON: \(type(of: object))")
    }
}

extension JSONEncoder {
    
    /// Checks whether the object can be serialized into JSON.
    public static func isValid(object: JSONContainer) -> Bool {
        JSONSerialization.isValidJSONObject(object)
    }
    
    /// Serializes given object into a JSON data.
    public static func serialize(object: JSONContainer, options: JSONSerialization.WritingOptions = []) throws -> Data {
        try JSONSerialization.data(withJSONObject: object, options: options)
    }
    
    /// Serializes given object into a JSON stream.
    @discardableResult
    public static func write(object: JSONContainer, to stream: OutputStream, options: JSONSerialization.WritingOptions = []) throws -> Int {
        var error: NSError?
        let count = JSONSerialization.writeJSONObject(object, to: stream, options: options, error: &error)
        if let error = error {
            throw error
        }
        return count
    }
}


//MARK: - Float Decoding

extension JSONDecoder.NonConformingFloatDecodingStrategy {
    
    /// Interprets strings "inf", "-inf", and "nan" as floating point numbers.
    public static let stringRepresentation: Self = .convertFromString(positiveInfinity: "inf", negativeInfinity: "-inf", nan: "nan")
}

extension JSONEncoder.NonConformingFloatEncodingStrategy {
    
    /// Uses strings "inf", "-inf", and "nan" for floating point numbers.
    public static let stringRepresentation: Self = .convertToString(positiveInfinity: "inf", negativeInfinity: "-inf", nan: "nan")
}


//MARK: - Key Translation

extension JSONDecoder.KeyDecodingStrategy {
    
    /// Prefixes keys starting with number with given string.
    public static func prefixInitialNumbers(with prefix: String) -> Self {
        .custom { codingKeys in
            guard let key = codingKeys.last else {
                // There is no coding key.
                return AnyCodingKey(stringValue: "")
            }
            if let initial = key.stringValue.first, initial.isWholeNumber {
                // We prefix all initial numbers.
                return AnyCodingKey(stringValue: prefix + key.stringValue)
            }
            // Leave as is.
            return key
        }
    }
}


//MARK: - Any Coding Key

/// Internal structure to carry arbitrary string or integer value.
private struct AnyCodingKey: CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}



