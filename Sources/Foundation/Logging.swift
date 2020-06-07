//
//  Logging.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.Thread
import class Foundation.DateFormatter
import func Darwin.POSIX.pthread.pthread_self


//MARK: - Printing

/// Prints the message prefixed with time and thread ID.
public func printLog(_ message: String) {
    let time = dateFormatter.string(from: .now)
    let thread = Thread.isMainThread ? "main" : "thread:\(pthread_self())"
    print("> \(time) [\(thread)]  \(message)")
}

/// Prints the message prefixed with time and thread ID. Appends description of the attachment.
public func printLog(_ message: String, _ attachment: Any?) {
    let description = attachment.map { "\($0)" } ?? "null"
    printLog("\(message): \(description)")
}


//MARK: - Formatting

/// Internal time formatter for logs.
private let dateFormatter = DateFormatter(posix: [.hours(.iso), .colon, .minutes(.iso), .colon, .seconds(.iso), .dot, .milliseconds])

