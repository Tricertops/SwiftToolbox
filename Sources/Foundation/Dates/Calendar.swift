//
//  Date.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: Enums

public extension Calendar {
    
    /// Named values for months.
    enum Month: Int {
        case january = 1
        case february = 2
        case march = 3
        case april = 4
        case may = 5
        case june = 6
        case july = 7
        case august = 8
        case september = 9
        case october = 10
        case november = 11
        case december = 12
    }
    
    /// Named values for weekdays.
    enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    
}


//MARK: Date Building

public extension Calendar {
    
    /// Cached Gregorian calendar instance.
    static let gregorian = Calendar(identifier: .gregorian)
    
    /// Creates Gregorian date from day, month and year. Time components are set to zeros.
    static func date(_ day: Int, _ month: Month, _ year: Int) -> Date {
        try! day.isWithin(1...31) !! Assert("Invalid day \(day)")
        try! year.isWithin(1900...2100) !! Assert("Invalid year \(year)")
        
        var components = DateComponents()
        components.year = year
        components.month = month.rawValue
        components.day = day
        return try! Calendar.gregorian.date(from: components) !! Assert("Failed to create date from: \(components)")
    }
}
