//
//  Timer.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.Timer
import typealias Foundation.TimeInterval


//MARK: - Constructors

extension Timer {
        
    /// Starts a one-shot timer.
    @discardableResult
    public static func after(_ interval: TimeInterval, handler: @escaping () -> Void) -> Timer {
        try! assertion(interval > 0, "Negative interval \(interval)")
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: no) { timer in
            handler()
        }
        return timer
    }
    
    /// Starts a repeating timer and immediately fires it once.
    @discardableResult
    public static func every(_ interval: TimeInterval, handler: @escaping () -> Void) -> Timer {
        try! assertion(interval > 0, "Negative interval \(interval)")
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: yes) { timer in
            handler()
        }
        timer.fire()
        return timer
    }
}


//MARK: - Lifetime

extension Timer {
    
    /// Stops the timer.
    public func stop() {
        // Just a better name.
        invalidate()
    }
    
    /// Delays the timer by given interval.
    public func postpone(by delay: TimeInterval) {
        fireDate = fireDate.addingTimeInterval(delay)
    }
    
    /// Pauses the timer, but doesn’t invalidate it.
    public func hold() {
        fireDate = .distantFuture
    }
}

