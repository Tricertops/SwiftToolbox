//
//  DateFormatter.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.DateFormatter
import struct Foundation.Date
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


//MARK: - String Interpolation

extension String.StringInterpolation {
    
    /// Formats the date using POSIX locale and exact formatting component.
    ///
    ///     "\(now)"  // "2020-05-16 12:30:34 +0000"
    ///     "\(now, .date)"  // "16 May 2020"
    ///     "\(now, .weekday)"  // "Saturday"
    ///
    public mutating func appendInterpolation(_ date: Date, _ component: DateFormat.Component) {
        appendInterpolation(date, DateFormatter(posix: [component]))
    }
    
    /// Formats the date using POSIX locale and exact formatting components.
    ///
    ///     "\(now)"  // "2020-05-16 12:30:34 +0000"
    ///     "\(now, [.hours(.iso), .colon, .minutes(.iso)])"  // "14:30"
    ///     "\(now, [.weekday(.number), .dash, .week])"  // "7-20"
    ///
    public mutating func appendInterpolation(_ date: Date, _ components: [DateFormat.Component]) {
        appendInterpolation(date, DateFormatter(posix: components))
    }
    
    /// Formats the date using current locale and localized formatting component.
    ///
    ///     "\(now)"  // "2020-05-16 12:30:34 +0000"
    ///     "\(now, localized: .date)"  // "16. mája 2020" for sk_SK
    ///     "\(now, localized: .weekday)"  // "sobota" for sk_SK
    ///
    public mutating func appendInterpolation(_ date: Date, localized component: DateFormat.Component) {
        appendInterpolation(date, DateFormatter(locale: .current, format: [component]))
    }
    
    /// Formats the date using current locale and localized formatting components.
    ///
    ///     "\(now)"  // "2020-05-16 12:30:34 +0000"
    ///     "\(now, localized: [.weekday, .day, .month])"  // "sobota, 16. mája" for sk_SK
    ///     "\(now, localized: [.time, .timeZone])"  // "2:30 PM SEČ" for sk_SK
    ///
    public mutating func appendInterpolation(_ date: Date, localized components: [DateFormat.Component]) {
        appendInterpolation(date, DateFormatter(locale: .current, format: components))
    }
    
    /// Formats the date using given date formatter.
    public mutating func appendInterpolation(_ date: Date, _ formatter: DateFormatter) {
        appendLiteral(formatter.string(from: date))
    }
}

