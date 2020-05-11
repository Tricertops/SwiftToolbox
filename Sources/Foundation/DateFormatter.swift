//
//  DateFormatter.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Constructing

extension DateFormatter {
    
    /// Initializes DateFormatter using POSIX locale and given format.
    public convenience init(posix format: String) {
        self.init()
        self.locale = .posix
        self.dateFormat = format
    }
    
    /// Initializes DateFormat using given locale and format that will be localized
    public convenience init(locale: Locale = .current, format template: String) {
        self.init()
        self.locale = locale
        self.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
    }
}

