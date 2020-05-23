//
//  Date.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.Date
import typealias Foundation.TimeInterval


//MARK: - Now

extension Date {
    
    /// Current date.
    public static var now: Self {
        // Just a better name.
        Date()
    }
    
    /// Constructs a date with a time interval since now.
    ///
    ///     Date(now: +4.min)
    ///
    init(now interval: TimeInterval) {
        // Just a better name.
        self.init(timeIntervalSinceNow: interval)
    }
}


//MARK: - Timestamps

extension Date {
    
    /// Constructs a date with a time interval since Cocoa reference date.
    init(timestamp interval: TimeInterval) {
        // Just a better name.
        self.init(timeIntervalSinceReferenceDate: interval)
    }
    
    /// Constructs a date with a time interval since UNIX reference date.
    init(unixTimestamp interval: TimeInterval) {
        // Just a better name.
        self.init(timeIntervalSince1970: interval)
    }
    
    /// Time interval since Cocoa reference date.
    public var timestamp: TimeInterval {
        // Just a better name.
        get {
            timeIntervalSinceReferenceDate
        }
        set {
            self = Date(timeIntervalSinceReferenceDate: newValue)
        }
    }
    
    /// Time interval since UNIX reference date.
    public var unixTimestamp: TimeInterval {
        // Just a better name.
        get {
            timeIntervalSince1970
        }
        set {
            self = Date(timeIntervalSince1970: newValue)
        }
    }
}


//MARK: - Operations

extension Date {
    
    /// Compares date to now.
    public func isOlder(than interval: TimeInterval) -> Bool {
        timeIntervalSinceNow < -interval
    }
    
    /// Compares date to now.
    public func isLater(than interval: TimeInterval) -> Bool {
        timeIntervalSinceNow > interval
    }
    
    /// Compares date to now.
    public func isInLast(_ interval: TimeInterval) -> Bool {
        timeIntervalSinceNow.isWithin(-interval ... 0)
    }
    
    /// Compares date to now.
    public func isInNext(_ interval: TimeInterval) -> Bool {
        timeIntervalSinceNow.isWithin(0 ... interval)
    }

    /// Calculates difference in seconds between two dates.
    public static func - (a: Self, b: Self) -> TimeInterval {
        a.timeIntervalSinceReferenceDate - b.timeIntervalSinceReferenceDate
    }
}

