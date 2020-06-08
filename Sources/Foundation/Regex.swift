//
//  Regex.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Regex

/// Representation of a regular expression.
public struct Regex: ExpressibleByStringLiteral {
    
    /// Creates a new regex from a string literal.
    /// - Note: Crashes if pattern is invalid, to catch programmer errors in development.
    ///
    ///       let regex: Regex = "[a-z]"
    ///
    public init(stringLiteral pattern: StringLiteralType) {
        try! self.init(dynamic: pattern)
    }
    
    /// Creates a new regex from static string and options.
    /// - Note: Crashes if pattern is invalid, to catch programmer errors in development.
    ///
    ///       Regex("[a-z]", options: .caseInsensitive)
    ///
    public init(_ pattern: StaticString, options: Options = []) {
        try! self.init(dynamic: "\(pattern)", options: options)
    }
    
    /// Creates a new regex with given pattern and options.
    /// - Note: Throws error if pattern is invalid. Use only with dynamic string.
    ///
    ///       try Regex(dynamic: string)
    ///
    public init(dynamic pattern: String, options: Options = []) throws {
        self.regex = try NSRegularExpression(pattern: pattern, options: options)
    }
    
    /// Options aliased from NSRegularExpression.
    public typealias Options = NSRegularExpression.Options
    
    /// Pattern of this regex.
    public var pattern: String {
        regex.pattern
    }
    
    /// Options for this regex.
    public var options: Options {
        regex.options
    }
    
    /// Checks for at least one match in given string.
    public func matches(_ string: String) -> Bool {
        firstMatch(in: string) != nil
    }
    
    /// Finds first match in given string.
    public func firstMatch(in string: String) -> Match? {
        let length = (string as NSString).length
        let range = NSRange(location: 0, length: length)
        // No options are relevant, since we use full range.
        let result = regex.firstMatch(in: string, options: [], range: range)
        return Match(result: result, originalString: string)
    }
    
    /// Collects all matches in given string.
    public func allMatches(in string: String) -> [Match] {
        var matches: [Match] = []
        enumerateMatches(in: string) { match in
            matches.append(match)
        }
        return matches
    }
    
    /// Enumerates all matches in the given string.
    public func enumerateMatches(in string: String, using handler: (Match) -> Void) {
        let length = (string as NSString).length
        let range = NSRange(location: 0, length: length)
        // No options are relevant, since we use full range and only want results.
        regex.enumerateMatches(in: string, options: [], range: range) { result, flags, stop in
            if let match = Match(result: result, originalString: string) {
                handler(match)
            }
        }
    }
    
    /// Internal regular expression interpreter.
    private let regex: NSRegularExpression
}


//MARK: - Matches

extension Regex {
    
    /// A match in a regular expression.
    public struct Match {
        
        /// Range of this match in original string.
        public let range: Range<String.Index>
        
        /// The matched string.
        public let string: String
        
        /// Capture groups in this match.
        /// - Note: When a capture group didn’t participate in this match, it is `nil`.
        public let captureGroups: [CaptureGroup?]
        
        /// Internal constructor from `NSTextCheckingResult`.
        fileprivate init?(result: NSTextCheckingResult?, originalString: String) {
            guard let result = result else {
                return nil
            }
            guard result.resultType == .regularExpression else {
                return nil
            }
            let range = originalString.range(from: result.range)
            self.range = range
            self.string = String(originalString[range])
            
            var groups: [CaptureGroup?] = []
            for index in 1 ..< result.numberOfRanges {
                let group = CaptureGroup(range: result.range(at: index), originalString: originalString)
                groups.append(group)
            }
            self.captureGroups = groups
        }
    }
    
    /// A capture group in a regular expression match.
    public struct CaptureGroup {
        
        /// Range of this group in original string.
        public let range: Range<String.Index>
        
        /// The matched string.
        public let string: String
        
        /// Internal constructor from `NSRange`.
        fileprivate init?(range: NSRange, originalString: String) {
            guard range.location != NSNotFound else {
                return nil
            }
            let range = originalString.range(from: range)
            self.range = range
            self.string = String(originalString[range])
        }
    }
}

