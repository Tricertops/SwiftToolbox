//
//  DateFormatter.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.DateFormatter
import struct Foundation.Locale


//MARK: - Constructing

extension DateFormatter {
    
    /// Initializes DateFormatter using POSIX locale and given format components.
    public convenience init(posix components: [DateFormat.Component]) {
        self.init()
        self.locale = .posix
        self.format = DateFormat.exact(components)
    }
    
    /// Initializes DateFormat using given locale and format that will be localized
    public convenience init(locale: Locale = .current, format components: [DateFormat.Component]) {
        self.init()
        self.locale = locale
        self.format = DateFormat.localized(components)
    }
    
    /// Access DateFormat of this formatter. Format is not stored, the getter always builds new format.
    public var format: DateFormat {
        get {
            // We can only guess what format it was. Let’s use the entire string as non-escaped component.
            let components: [DateFormat.Component] = [.nonescaped(self.dateFormat)]
            // Let’s guess when the format is localized. This allows assigning format from one formatter to another.
            let isLocalized = (self.locale == .current)
            return DateFormat(components: components, localized: isLocalized)
        }
        set {
            self.dateFormat = newValue.string(for: self.locale ?? .current)
        }
    }
}

