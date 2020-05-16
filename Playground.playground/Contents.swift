// Use this playground to try the package.
import Foundation


let now = Date.now

"\(now)"
"\(now, .date)"
"\(now, .weekday)"

"\(now)"
"\(now, [.hours(.iso), .colon, .minutes(.iso)])"
"\(now, [.weekday(.number), .dash, .week])"

"\(now)"
"\(now, localized: .date)"
"\(now, localized: .weekday)"

"\(now)"
"\(now, localized: [.weekday, .day, .month])"
"\(now, localized: [.time, .timeZone])"

