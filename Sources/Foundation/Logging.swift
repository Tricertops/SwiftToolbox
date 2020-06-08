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

/// Prints the message prefixed with source code location, time and thread symbol (🔸= main, 🔹= other).
public func printLog(_ message: String, file: StaticString = #file, line: UInt = #line) {
    let location = CompilerDirectives.sourceLocation(file: file, line: line)
    let time = dateFormatter.string(from: .now)
    // These emoji provide a visual separator of metadata and the message itself.
    let thread = Thread.isMainThread ? "🔸" : "🔹"
    print("❯ \(location) • \(time) \(thread) \(message)")
}

/// Prints the message prefixed with source code location, time and thread symbol (🔸= main, 🔹= other). Appends description of the attachment.
public func printLog(_ message: String, _ attachment: Any?, file: StaticString = #file, line: UInt = #line) {
    let description = attachment.map { "\($0)" } ?? "null"
    printLog("\(message): \(description)", file: file, line: line)
}


//MARK: - Control Flow

/// Empty function to fill the void.
public func nothing() {
    // Empty.
}


//MARK: - Formatting

/// Internal time formatter for logs.
private let dateFormatter = DateFormatter(posix: [.hours(.iso), .colon, .minutes(.iso), .colon, .seconds(.iso), .dot, .milliseconds])

