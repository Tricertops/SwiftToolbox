//
//  Locale.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.Locale
import class Foundation.DateFormatter
import struct Foundation.Date


//MARK: - Constants

extension Locale {
    
    /// Standardized locale.
    public static var posix: Self {
        Locale(identifier: "en_US_POSIX")
    }
    
}


//MARK: - Clock Format

extension Locale {
    
    /// Whether the locale uses 12-hour clock format with AM/PM.
    public var uses12HourFormat: Bool {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = self
        timeFormatter.timeStyle = .short
        let time = timeFormatter.string(from: Date.now)
        // We search for: am, pm, AM, PM
        return time.hasSuffix("m" | "M")
    }
    
    /// Whether the locale uses 24-hour clock format.
    public var uses24HourFormat: Bool {
        !uses12HourFormat
    }
}

