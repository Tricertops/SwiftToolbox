//
//  JSONCoding.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Float Decoding

extension JSONDecoder.NonConformingFloatDecodingStrategy {
    
    /// Interprets strings "inf", "-inf", and "nan" as floating point numbers.
    public static let stringRepresentation: Self = .convertFromString(positiveInfinity: "inf", negativeInfinity: "-inf", nan: "nan")
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

