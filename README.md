# Swift Toolbox

I don’t expect anyone to like this or use this, stuff here can be very opinionated.

##### Some examples:

 ### Booleans
 - constants `yes`/`no` for `Bool`
 - postfix negation operator `isEnabled.!`
 
 ### Numbers
 - literal suffixes `45°` for angles and `75%` for percentages
 - literal suffixes `5.min`, `30.sec`, and `300.ms` for time intervals
 - operators `++`/`--` without undefined behavior
 - deprecated integer division, `10/3` now correctly returns `3.333...`
 - operators for powers `2^^5` and roots `√2`
 - simple formatting to string:
 
       "Automatic: \(x.pretty)"  // same as %g in printf() 
       "Fixed: \(pi.pretty(3))"  // 3.142
       "Degrees: \(pi.pretty(°))"  // 180°
       "Percents: \(opacity.pretty(%))"  // 42%
 
 ### Optionals
 - operator for using `Optional` in conditions `if view.? { ... }`
 - operator for force unwrapping with custom message: `optional !! "Message"`
 - operator for converting `nil` to `Error`: `try optional !! MyError.fail`

### Other
 - function `assertion()` that `throws`, so it can be recoverable
 - construction of `URL` from String literal
 - simple constructors for Timers:
 
       Timer.after(10.sec) { ... }
       Timer.every(10.sec) { ... }

 - simple observation of Notifications:

       let observation = UIApplication.didBecomeActiveNotification.observe { notification in
           // Handle observation.
       }

