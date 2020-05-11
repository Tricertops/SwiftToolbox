//
//  URL.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.URL


//MARK: - Constructing

extension URL: ExpressibleByStringLiteral {
    
    /// Allows implicit conversion from literal, either from full URL or a path.
    ///
    ///     let link: URL = "https:​//apple.com"
    ///     let app: URL = "/Applications/Xcode.app"
    ///
    public init(stringLiteral string: String) {
        if string.hasPrefix("/") || string.hasPrefix("~/") {
            self.init(fileURLWithPath: string)
        }
        else {
            self.init(string: string)!
        }
    }
}

extension URL: ExpressibleByStringInterpolation {
    // Automatically inferred by the compiler.
}

