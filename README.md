# Swift Toolbox

I don’t expect anyone to like this or use this, stuff here can be very opinionated.

##### Some examples:

- Bool constants `yes` and `no`.

- Postfix testing operators `optional.?` and `isEnabled.!`.

- Literal suffixes `45°` for angles and `75%` for percentages.

- Literal suffixes `5.min`, `30.sec`, and `300.ms` for time intervals.

- Operators `++` and `--` without undefined behavior.

- Deprecated integer division, `10/3` now correctly returns `3.333...`.

- Operators for powers `2^^5` and roots `√2`.
 
- Extended String interpolation for formatting numbers:
 
      "Automatic: \(x, .pretty)"  // same as %g in printf() 
      "Fixed: \(pi, 3))"  // 3.142
      "Degrees: \(pi, (°))"  // 180°
      "Percents: \(opacity, %, 1))"  // 42.5%

- Building system for date formats with automatic localization:

      dateFormatter.format = .localized([.time, .weekday, .day, .month])  // "h:mm a eeee, d MMMM"
      dateFormatter.format = .exact([.day(.padded), .slash, .month(.paddedNumber)])  // "dd/MM"

- NumberFormatter and DateFormatter support in String interpolation:

      "Today is \(now, localized: .weekday)."  // specifying format ad-hoc
      "Since \(date, formatter)."  // using custom formatter object
      "Result is \(result, localized: 0...3)"  // formatted up to 3 fractional digits
      "Total \(total, formatter)."  // using custom formatter object
 
- Assertion operator that throws custom Error and generic `Assert` error that captures context:
 
       let first = try array.first !! Assert("List must not be empty.")
       try value > 0 !! Assert("Value must be positive.")
       try number.isFinite !! EncodingError.invalidValue

- Construction of URL from String literal:
 
      let link: URL = "https:​//apple.com"
      let app: URL = "/Applications/Xcode.app"
 
- Simple constructors for Timers:
 
      Timer.after(10.sec) { ... }
      Timer.every(10.sec) { ... }

- Simple observation of Notifications:

      let observation = UIApplication.didBecomeActiveNotification.observe { notification in
          // Handle observation.
      }

- Multiple equality testing:

      direction == (.up | .down)  // direction is either up or down
      string.contains("+" & "-")  // string contains both plus and minus signs

