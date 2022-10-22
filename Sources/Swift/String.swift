//
//  String.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.NSRange
import Foundation.NSString


//MARK: - Length

extension String {
    
    /// Length of the string.
    public var length: Int {
        // Just a better name.
        count
    }
    
    /// Is not empty?
    public var hasCharacters: Bool {
        // Just a better name.
        hasElements
    }
    
    /// Returns nil if the string is empty.
    ///
    ///     string.emptyAsNil ?? "placeholder"
    ///
    public var emptyAsNil: String? {
        isEmpty ? nil : self
    }
    
    /// Coalesce empty string.
    public static func ?? (collection: Self, fallback: @autoclosure () -> Self) -> Self {
        collection.hasCharacters ? collection : fallback()
    }
    
}


//MARK: - Constants

extension String {
    
    /// Empty string.
    public static var empty: Self {
        ""
    }
    
    /// LINE FEED (U+000A)
    public static var newline: Self {
        "\n"
    }
    
    /// CARRIAGE RETURN (U+000D)
    public static var carriageReturn: Self {
        "\r"
    }
    
    /// PARAGRAPH SEPARATOR (U+2029
    public static var softNewline: Self {
        "\u{2029}"
    }
    
    /// CHARACTER TABULATION (U+0009)
    public static var tab: Self {
        "\t"
    }
    
    /// SPACE (U+0020)
    public static var space: Self {
        " "
    }
    
    /// NO-BREAK SPACE (U+00A0).
    public static var noBreakSpace: Self {
        " "
    }
    
    /// ZERO WIDTH SPACE (U+200B)
    public static var zeroWidthSpace: Self {
        "\u{200B}"
    }
    
    /// REVERSE SOLIDUS (U+005C)
    public static var backslash: Self {
        "\\"
    }
    
    /// QUOTATION MARK (U+0022)
    public static var quote: Self {
        "\""
    }
}

extension Character {
    
    /// LINE FEED (U+000A)
    public static let newline = Character(.newline)
    
    /// SPACE (U+0020)
    public static let space = Character(.space)
}


//MARK: - Characters

extension String {
    
    /// Accesses the character at given index.
    public subscript(_ offset: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: offset)
            return self[index]
        }
        set {
            let index = self.index(self.startIndex, offsetBy: offset)
            let nextIndex = self.index(self.startIndex, offsetBy: offset+1)
            replaceSubrange(index ..< nextIndex, with: String(newValue))
        }
    }
}


//MARK: - Ranges

extension String {
    
    /// Returns substring for partial range, from given index to the end of the string.
    ///
    ///     string[index...]
    ///
    public subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        get {
            let fromIndex = index(startIndex, offsetBy: range.lowerBound)
            return String(self[fromIndex ..< endIndex])
        }
        set {
            let fromIndex = index(startIndex, offsetBy: range.lowerBound)
            replaceSubrange(fromIndex ..< endIndex, with: newValue)
        }
    }
    
    /// Returns substring for partial range, from start of the string to the given index (including).
    ///
    ///     string[...index]
    ///
    public subscript(_ range: PartialRangeThrough<Int>) -> String {
        get {
            let toIndex = index(startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ... toIndex])
        }
        set {
            let toIndex = index(startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex ... toIndex, with: newValue)
        }
    }
    
    /// Returns substring for partial range, from start if the string to the given index (not including).
    ///
    ///     string[..< index]
    ///
    public subscript(_ range: PartialRangeUpTo<Int>) -> String {
        get {
            let toIndex = index(startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ..< toIndex])
        }
        set {
            let toIndex = index(startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex ..< toIndex, with: newValue)
        }
    }
    
    /// Converts `NSRange` to native String range.
    public func range(from range: NSRange) -> Range<String.Index> {
        let lowerBound = index(startIndex, offsetBy: range.lowerBound)
        let upperBound = index(startIndex, offsetBy: range.upperBound)
        return lowerBound ..< upperBound
    }
}


//MARK: - Debugging

extension String {
    
    /// Builds debugging description for anything using `.debugDescription` or introspection.
    public init<Subject>(debug subject: Subject) {
        // Just a better name.
        self.init(reflecting: subject)
    }
}


//MARK: - Testing Content

extension String {
    
    /// Tests multiple prefixes at once.
    public func hasPrefix<Prefix>(_ set: MultiSet.Either<Prefix>) -> Bool where Prefix : StringProtocol {
        set.each { self.hasPrefix($0) }
        // Makes no sense to support MultiSet.All
    }
    
    /// Tests multiple suffixes at once.
    public func hasSuffix<Suffix>(_ set: MultiSet.Either<Suffix>) -> Bool where Suffix : StringProtocol {
        set.each { self.hasSuffix($0) }
        // Makes no sense to support MultiSet.All
    }
    
    /// Finds multiple substrings at once.
    public func contains<Sub>(_ set: MultiSet.Either<Sub>) -> Bool where Sub : StringProtocol {
        set.each { self.contains($0) }
    }
    
    /// Finds multiple substrings at once.
    public func contains<Sub>(_ set: MultiSet.All<Sub>) -> Bool where Sub : StringProtocol {
        set.each { self.contains($0) }
    }
}


//MARK: - Concatenation

/// Operator for concatenating string with any other values.
public func + (_ left: String, _ right: CustomStringConvertible?) -> String {
    return left + (right?.description ?? "nil")
}

/// Operator for concatenating string with any other values.
public func + (_ left: CustomStringConvertible?, _ right: String) -> String {
    return (left?.description ?? "nil") + right
}

/// Operator for concatenating string with any other values.
public func + (_ left: String?, _ right: String?) -> String {
    return (left ?? "nil").appending(right ?? "nil")
}


extension String {
    
    /// Returns an array containing substrings from the receiver that have been divided by a given separator.
    public func split(by separator: String) -> [String] {
        (self as NSString).components(separatedBy: separator)
    }
}


