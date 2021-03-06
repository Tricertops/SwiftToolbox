//
//  TimeInterval.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import typealias Foundation.TimeInterval


//MARK: - Literal Suffixes

extension IntegerLiteralType {
    
    /// Suffix for hours.
    ///
    ///     let delay = 2.hours
    ///
    public var hours: TimeInterval {
        TimeInterval(self) * 3600
    }
    
    /// Suffix for 1 hour.
    ///
    ///     let delay = 1.hour
    ///
    public var hour: TimeInterval {
        TimeInterval(self) * 3600
    }
    
    /// Suffix for minutes.
    ///
    ///     let delay = 5.min
    ///
    public var min: TimeInterval {
        TimeInterval(self) * 60
    }
    
    /// Suffix for seconds.
    ///
    ///     let delay = 30.sec
    ///
    public var sec: TimeInterval {
        TimeInterval(self)
    }
    
    /// Suffix for milliseconds.
    ///
    ///     let delay = 300.ms
    ///
    public var ms: TimeInterval {
        TimeInterval(self) / 1000
    }
}

extension FloatLiteralType {
    
    /// Suffix for hours.
    ///
    ///     let delay = 2.hours
    ///
    public var hours: TimeInterval {
        TimeInterval(self) * 3600
    }
    
    /// Suffix for 1 hour.
    ///
    ///     let delay = 1.hour
    ///
    public var hour: TimeInterval {
        TimeInterval(self) * 3600
    }
    
    /// Suffix for minutes.
    ///
    ///     let delay = 5.min
    ///
    public var min: TimeInterval {
        TimeInterval(self) * 60
    }
    
    /// Suffix for seconds.
    ///
    ///     let delay = 30.sec
    ///
    public var sec: TimeInterval {
        TimeInterval(self)
    }
    
    /// Suffix for milliseconds.
    ///
    ///     let delay = 300.ms
    ///
    public var ms: TimeInterval {
        TimeInterval(self) / 1000
    }
}

