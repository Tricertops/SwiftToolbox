//
//  Locale.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.Locale
import class Foundation.DateFormatter


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
        let formatter = DateFormatter(locale: self, format: [.time])
        return formatter.dateFormat.hasSuffix(DateFormat.Period.am_pm.rawValue)
    }
    
    /// Whether the locale uses 24-hour clock format.
    public var uses24HourFormat: Bool {
        !uses12HourFormat
    }
}

