//
//  DateFormat.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//
//  Unicode Reference:
//  http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
//

import class Foundation.DateFormatter
import struct Foundation.Locale


//MARK: - Date Format

/// Representation of a date format, optionally localized.
public struct DateFormat {
    
    /// Creates non-localized date format that will be used exactly as specified.
    public static func exact(_ components: [Component]) -> Self {
        DateFormat(components: components, localized: no)
    }
    
    /// Creates localized date format that will be adjusted for DateFormatter’s locale before use.
    public static func localized(_ components: [Component]) -> Self {
        DateFormat(components: components, localized: yes)
    }
    
    /// Predefined format for ISO 8601 (2019-05-08T09:02:06+02:00).
    public static let iso8601 = DateFormat.exact([
        .year(.iso), .dash, .month(.iso), .dash, .day(.iso),
        .literal("T"),
        .hours(.iso), .colon, .minutes(.iso), .colon, .seconds(.iso),
        .timeZone(.iso),
    ])
    
    /// Predefined format for HTTP (Fri, 05 Aug 2019 09:02:06 Z).
    public static let http = DateFormat.exact([
        .weekday(.http), .comma, .space,
        .day(.http), .space, .month(.http), .space, .year(.http), .space,
        .hours(.http), .colon, .minutes(.http),
        .literal("GMT"),
    ])
    
    /// List of components in this format. Only used by DateFormatter.
    internal var components: [Component]
    
    /// Flag that indicates localizetion. Only used by DateFormatter.
    internal var shouldBeLocalized: Bool
    
    /// Builds resulting string for given locale. Only used by DateFormatter.
    public func string(for locale: Locale) -> String {
        var string = ""
        for component in components {
            string += component.format
        }
        if shouldBeLocalized {
            let wantsPeriod = components.contains { $0.wantsPeriod }
            string = DateFormatter.dateFormat(fromTemplate: string, options: 0, locale: locale) ?? string
            let hasPeriod = string.contains(" a")
            if wantsPeriod.! && hasPeriod.? {
                string = string.replacingOccurrences(of: " a", with: "")
            }
        }
        return string
    }
    
    /// Internal initializer. Only used by DateFormatter.
    internal init(components: [Component], localized: Bool) {
        self.components = components
        self.shouldBeLocalized = localized
    }
    
    
    //MARK: - Components
    
    /// Representation of all available date format components.
    public enum Component: Equatable {
        
        // Times
        
        /// Hours and minutes, both padded to 2 digits. Range 12 or 24 is automatic and AM/PM is included for 12-hour format.
        /// - Warning: Not suitable for parsing strings, use explicit components.
        /// - Warning: Not suitable for ISO or HTTP formats, use explicit components.
        public static let time: Self = .time(.padded)
        /// Customized hours, minutes and optional seconds. Range 12 or 24 is automatic and AM/PM is included for 12-hour format.
        /// - Warning: Not suitable for parsing strings, use explicit components.
        /// - Warning: Not suitable for ISO or HTTP formats, use explicit components.
        case time(Hours.Width, seconds: Bool = no)
        
        /// Hours padded to 2 digits (01...12 or 00...23). AM/PM must be specified separately.
        /// - Warning: Not suitable for parsing strings, use explicit width and range.
        public static let hours: Self = .hours(.padded)
        /// Customized hours with number of digits and hour range. AM/PM must be specified separately.
        /// - Warning: When parsing strings, do not use automatic range.
        case hours(Hours.Width, range: Hours.Range = .auto)
        
        /// Minutes padded to 2 digits (00...59).
        public static let minutes: Self = .minutes(.padded)
        /// Customized minutes.
        case minutes(Minutes)
        
        /// Seconds padded to 2 digits (00...59).
        public static let seconds: Self = .seconds(.padded)
        /// Customized seconds.
        case seconds(Seconds)
        
        /// Milliseconds.
        /// - Warning: Decimal separator is not included (000...999).
        public static let milliseconds: Self = .subseconds(3)
        /// Microseconds.
        /// - Warning: Decimal separator is not included (000000...999999).
        public static let microseconds: Self = .subseconds(6)
        /// Fractions of second to arbitrary precision.
        /// - Warning: Decimal separator is not included.
        case subseconds(Int)
        
        /// Period of 12-hour clock (AM/PM).
        /// - Note: Automatically included when localized for 12-hour locale.
        /// - Note: When used isolated, will also produce AM/PM to 24-hour locales.
        case am_pm
        
        /// Short name of time zone (PDT/CEST/GMT).
        /// - Warning: Not suitable for parsing strings, use explicit style.
        public static let timeZone: Self = .timeZone(.shortName)
        /// Customized time zone name or offset.
        case timeZone(TimeZone)
        
        // Dates
        
        /// Day of month, month name, and a 4-digit year.
        /// - Warning: Not suitable for parsing strings, use explicit components.
        /// - Warning: Not suitable for ISO or HTTP formats, use explicit components.
        public static let date: Self = .date(.name, year: yes)
        /// Day of month, customized month, and optional 4-digit year. When month is padded, day will be too.
        /// - Warning: Not suitable for parsing strings, use explicit components.
        /// - Warning: Not suitable for ISO or HTTP formats, use explicit components.
        case date(Month, year: Bool)
        
        /// Name of weekday (Monday...Sunday).
        public static let weekday: Self = .weekday(.name)
        /// Customized weekday.
        case weekday(Weekday)
        
        /// Day number in month (1...31).
        public static let day: Self = .day(.short)
        /// Day number in month or year, optionally padded.
        case day(Day.Width, of: Day.Relation = .month)
        
        /// Week number in year (1...53).
        public static let week: Self = .week(.short)
        /// Week number in year or month.
        case week(Week)
        
        /// Name of month (January...December).
        public static let month: Self = .month(.name)
        /// Customized month style: name, abbreviation, or number.
        case month(Month)
        
        /// Number of quarter prefixed with Q (Q1...Q4)
        public static let quarter: Self = .quarter(.prefixedNumber)
        /// Customized quarter style: name, abbreviation, or number.
        case quarter(Quarter)
        
        /// Four-digit year of day (1900...2099).
        public static let year: Self = .year(.full)
        /// Year of day or week with customized width.
        case year(Year.Width, of: Year.Relation = .day)
        
        /// Short name of era (BC/AD).
        public static let era: Self = .era(.short)
        /// Customized name of era.
        case era(Era)
        
        // Strings
        
        /// Arbitrary string that should appear in the resulting date as is.
        /// - Note: The string will be escaped, so it’s not accidentally interpreted as formatting.
        /// - Warning: Localization of the format may remove these strings.
        case literal(String)
        
        /// Space character to use as component separator in exact formats. Localization may remove it.
        public static let space: Self = .nonescaped(" ")
        /// Dash character (-) to use as component separator in exact formats. Localization may remove it.
        public static let dash: Self = .nonescaped("-")
        /// Colon character (:) to use as component separator in exact formats. Localization may remove it.
        public static let colon: Self = .nonescaped(":")
        /// Period character (.) to use as component separator in exact formats. Localization may remove it.
        public static let dot: Self = .nonescaped(".")
        /// Slash character (/) to use as component separator in exact formats. Localization may remove it.
        public static let slash: Self = .nonescaped("/")
        /// Comma character (,) to use as component separator in exact formats. Localization may remove it.
        public static let comma: Self = .nonescaped(",")
        /// Apostrophe character (') to use as component separator in exact formats. Localization may remove it.
        /// - Note: Since apostrophe is used to escape literal strings, it also need special escaping (double apostrophe).
        public static let apostrophe: Self = .nonescaped("''")
        /// Raw string that should be included in the format.
        /// - Warning: Letters in this string will be interpreted as formatting. Symbols are OK.
        /// - Warning: Localization of the format may remove these strings.
        case nonescaped(String)
        
        
        /// Returns string to be used as date format for this component.
        fileprivate var format: String {
            switch self {
                
                // Times
                case .time(let hours, let seconds):
                    // $hours:mm[:ss]
                    var components: [Component] = []
                    components += [.hours(hours), .colon, .minutes]
                    if seconds {
                        components += [.colon, .seconds]
                    }
                    // AM/PM will be added in localization
                    return DateFormat.exact(components).string(for: .posix)
                
                case .hours(let width, let range): return Hours.resolve(width, range)
                case .minutes(let format): return format.rawValue
                case .seconds(let format): return format.rawValue
                case .subseconds(let count): return Seconds.fractions(count)
                case .am_pm: return Period.am_pm.rawValue
                case .timeZone(let timeZone): return TimeZone.resolve(timeZone)
                
                // Dates
                case .date(let month, let year):
                    // d[d] $month[ yyyy]
                    var components: [Component] = []
                    // Padded month makes day also padded.
                    let isPadded = (month == .paddedNumber)
                    components += [.day(isPadded ? .padded : .short)]
                    components += [.space, .month(month)]
                    if year {
                        components += [.space, .year]
                    }
                    return DateFormat.exact(components).string(for: .posix)
                
                case .weekday(let weekday): return weekday.rawValue
                case .day(let width, let relation): return Day.resolve(width, relation)
                case .week(let week): return week.rawValue
                case .month(let format): return format.rawValue
                case .quarter(let format): return format.rawValue
                case .year(let width, let relation): return Year.resolve(width, relation)
                case .era(let format): return format.rawValue
                
                // Strings
                case .nonescaped(let string): return string
                case .literal(var string):
                    let apostrophe = "''"
                    string = string.replacingOccurrences(of: apostrophe, with: apostrophe+apostrophe)
                    return apostrophe + string + apostrophe
            }
        }
        
        /// Some components allow presence of AM/PM in the string. If they are not used, it won’t be formatted.
        fileprivate var wantsPeriod: Bool {
            switch self {
                case .am_pm, .time(_, _):
                    return yes
                default:
                    return no
            }
        }
    }
    
    
    //MARK: - Time Formats
    
    /// Format for hours.
    public enum Hours {
        
        /// Width of hours format.
        public enum Width: Equatable {
            /// 1...12 or 0...23
            case short
            /// 01...12 or 00...23
            case padded
            /// 00...23 (forces 24-hour clock)
            case standardized
            
            /// ISO 8601 (00…23)
            public static let iso: Self = .standardized
            /// HTTP (00…23)
            public static let http: Self = .standardized
        }
        
        /// Range of hours format.
        public enum Range: String, Equatable {
            /// Automatic based on locale.
            /// - Warning: Not suitable for parsing.
            case auto = "j"
            /// 1...12 or 01...12
            case h12 = "h"
            /// 0...23 or 00...23
            case h24 = "H"
            
            /// ISO 8601 (00…23)
            public static let iso: Self = .h24
            /// HTTP (00…23)
            public static let http: Self = .h24
        }
        
        /// Builds format of hours from width and range.
        public static func resolve(_ width: Width, _ range: Range) -> String {
            switch width {
                case .short:
                    return range.rawValue
                case .padded:
                    return range.rawValue + range.rawValue
                case .standardized:
                    return Range.h24.rawValue + Range.h24.rawValue
            }
            
        }
    }
    
    /// Format for minutes.
    public enum Minutes: String, Equatable {
        /// 0…59
        case short = "m"
        /// 00…59
        case padded = "mm"
        
        /// ISO 8601 (00…59)
        public static let iso: Self = .padded
        /// HTTP (00…59)
        public static let http: Self = .padded
    }
    
    /// Format for seconds.
    public enum Seconds: String, Equatable {
        /// 0…59
        case short = "s"
        /// 00…59
        case padded = "ss"
        
        /// Fractions of second with arbitrary precision.
        public static func fractions(_ count: Int) -> String {
            String(repeating: "S", count: count)
        }
        
        /// ISO 8601 (00…59)
        public static let iso: Self = .padded
        /// HTTP (00…59)
        public static let http: Self = .padded
    }
    
    /// Format for period.
    public enum Period: String, Equatable {
        /// AM / PM
        case am_pm = "a"
    }
    
    
    //MARK: - Date Formats
        
    /// Format of weekday.
    public enum Weekday: String, Equatable {
        /// 1…7
        case number = "e"
        /// (of) Sunday…Saturday
        case name = "eeee"
        /// Sun Mon Tue Wed Thu Fri Sat
        case shortName = "eee"
        /// Su Mo Tu We Th Fr Sa
        case shorterName = "eeeeee"
        /// S M T W T F S
        case initialLetter = "eeeee"
        /// Sunday…Saturday
        case standaloneName = "cccc"
        
        /// Weekday of month: 1…6
        case ofMonth = "F"
        
        /// ISO 8601 (1…7)
        public static let iso: Self = .number
        /// HTTP (Sun Mon Tue Wed Thu Fri Sat)
        public static let http: Self = .shortName
    }
    
    /// Format of day.
    public enum Day {
        
        /// Width for hours format.
        public enum Width: Equatable {
            /// 1…31 or 1...366
            case short
            /// 01…31 or 001...366
            case padded
            
            /// ISO 8601 (01…31)
            public static let iso: Self = .padded
            /// HTTP (01…31)
            public static let http: Self = .padded
            
            /// Returns width to be used for given relation.
            public func width(for relation: Relation) -> Int {
                switch (self, relation) {
                    case (.short, _): return 1
                    case (.padded, .month): return 2
                    case (.padded, .year): return 3
                }
            }
        }
        
        /// Calendar unit in which the number of days is expressed.
        public enum Relation: String, Equatable {
            /// Day of month: 1...31 or 01...31
            case month = "d"
            /// Day of year: 1...366 or 001...366
            case year = "D"
        }
        
        /// Builds format of day from width and range.
        public static func resolve(_ width: Width, _ relation: Relation) -> String {
            String(repeating: relation.rawValue, count: width.width(for: relation))
        }
    }
    
    /// Format of week.
    public enum Week: String, Equatable {
        /// 1…53
        case short = "w"
        /// 01…53
        case padded = "ww"
        
        /// Week of month: 1…6
        case ofMonth = "W"
        
        /// ISO 8601 (01…53)
        public static let iso: Self = .padded
    }
    
    /// Format of month.
    public enum Month: String, Equatable {
        /// 1…12
        case shortNumber = "M"
        /// 01…12
        case paddedNumber = "MM"
        /// (of) January…December
        case name = "MMMM"
        /// Jan…Dec
        case shortName = "MMM"
        /// J…D
        case initialLetter = "MMMMM"
        /// January…December
        case standaloneName = "LLLL"
        
        /// ISO 8601 (01…12)
        public static let iso: Self = .paddedNumber
        /// HTTP (Jan…Dec)
        public static let http: Self = .shortName
    }
    
    /// Format of quarter.
    public enum Quarter: String, Equatable {
        /// 1…4
        case number = "Q"
        /// Q1…Q4
        case prefixedNumber = "QQQ"
        /// (of) 1st…4th quarter
        case name = "QQQQ"
        /// 1st…4th quarter
        case standaloneName = "qqqq"
    }
    
    /// Format of year.
    public enum Year {
        
        public enum Width: Int, Equatable {
            /// 1900…2099
            case full = 4
            /// 00…99
            case short = 2
            
            /// ISO 8601 (1900…2099)
            public static let iso: Self = .full
            /// HTTP (1900…2099)
            public static let http: Self = .full
        }
        
        /// Calendar unit of which year to be used.
        public enum Relation: String, Equatable {
            /// Year of day.
            case day = "y"
            /// Year of week. May be different than standard year for first and last weeks of year.
            /// - Warning: Only use when using week formats.
            case week = "Y"
        }
        
        /// Builds format of day from width and range.
        public static func resolve(_ width: Width, _ relation: Relation) -> String {
            String(repeating: relation.rawValue, count: width.rawValue)
        }
    }
    
    /// Format of era.
    public enum Era: String, Equatable {
        /// BC / AD
        case short = "G"
        /// Before Christ / Anno Domini
        case full = "GGGG"
    }
    
    
    //MARK: - Time Zone Formats
    
    /// Format of time zone.
    public enum TimeZone: Equatable {
        /// Abbreviation of the zone name, including DST: PDT
        case shortName
        /// Full name of the zone, including DST: Pacific Daylight Time
        case longName
        /// Abbreviation of zone name, ignoring DST: PT
        case shortGenericName
        /// Abbreviation of zone name, ignoring DST: Pacific Time
        case longGenericName
        /// Los Angeles Time
        case standaloneName
        /// Los Angeles
        case city
        /// America/Los_Angeles
        case identifier
        
        /// Short time zone offset with ‘GMT’ prefix.
        public static let offset: Self = .offset(.shortGMT)
        /// Customized time zone offset, optionally with ‘Z’ for zero offset.
        /// - Note: Not all offset styles support ‘Z’ option.
        case offset(Offset, Z: Bool = yes)
        
        /// ISO 8601 (+01:00 / Z)
        /// - Note: Several other time zone formats are supported by ISO 8601.
        public static let iso: Self = .offset(.long)
        
        public static func resolve(_ timeZone: TimeZone) -> String {
            switch timeZone {
                case .shortName: return "z"
                case .longName: return "zzzz"
                case .shortGenericName: return "v"
                case .longGenericName: return "vvvv"
                case .standaloneName: return "VVVV"
                case .city: return "VVV"
                case .identifier: return "VV"
                case .offset(let offset, let allowZ): return Offset.resolve(offset, Z: allowZ)
            }
        }
        
        /// Style of time zone offset.
        public enum Offset: Equatable {
            /// +01 / Z
            /// - Note: Compliant with ISO 8601.
            case short
            /// +01:00 / Z
            /// - Note: Compliant with ISO 8601.
            case long
            /// +0100 / Z
            /// - Note: Compliant with ISO 8601.
            case compact
            /// GMT+1
            case shortGMT
            /// GMT+01:00
            case longGMT
            
            /// Builds format of time zone offset.
            public static func resolve(_ offset: Offset, Z allowZ: Bool) -> String {
                switch offset {
                    case .short: return (allowZ ? "X" : "x")
                    case .long: return (allowZ ? "XXX" : "xxx")
                    case .compact: return (allowZ ? "XX" : "xx")
                    case .shortGMT: return "O" // Z not supported
                    case .longGMT: return "OOOO" // Z not supported
                }
            }
        }
    }
}

