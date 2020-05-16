# Swift Toolbox

I don’t expect anyone to like this or use this, stuff here can be very opinionated.

##### Some examples:

 ### Booleans
 - constants `yes` and `no` for Bool
 - postfix testing operators `optional.?` and `isEnabled.!`
 
 ### Numbers
 - literal suffixes `45°` for angles and `75%` for percentages
 - literal suffixes `5.min`, `30.sec`, and `300.ms` for time intervals
 - operators `++` and `--` without undefined behavior
 - deprecated integer division – `10/3` now correctly returns `3.333...`
 - operators for powers `2^^5` and roots `√2`
 - simple formatting to string:
 
       "Automatic: \(x, .pretty)"  // same as %g in printf() 
       "Fixed: \(pi, 3))"  // 3.142
       "Degrees: \(pi, (°))"  // 180°
       "Percents: \(opacity, %, 1))"  // 42.5%
 
 ### Optionals
 - operator for using Optional in conditions `if view.? { ... }`
 - operator for force unwrapping with custom message: `optional !! "Message"`
 - operator for converting `nil` to Error: `try optional !! MyError.fail`

### Other
 - function `func assertion()` that `throws`, so it can be caught and recovered
 
       try assertion(x > 0)  // prints failure to console and throws Error
       try! assertion(x > 0)  // prints failure to console and crashes
       try? assertion(x > 0)  // only prints failure to console
 
 - construction of URL from String literal
 
       let link: URL = "https:​//apple.com"
       let app: URL = "/Applications/Xcode.app"
 
 - simple constructors for Timers:
 
       Timer.after(10.sec) { ... }
       Timer.every(10.sec) { ... }

 - simple observation of Notifications:

       let observation = UIApplication.didBecomeActiveNotification.observe { notification in
           // Handle observation.
       }

 - multiple equality testing:

       direction == (.up | .down)  // direction is either up or down
       string.contains("+" & "-")  // string contains both plus and minus signs

 - building system for date formats:
 
       dateFormatter.format = .localized([.time, .weekday, .day, .month])  // "h:mm a eeee, d MMMM"
       dateFormatter.format = .exact([.day(.padded), .slash, .month(.paddedNumber)])  // "dd/MM"

