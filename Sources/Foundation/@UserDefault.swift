//
//  @UserDefault.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Property Wrapper

/// Property wrapper that syncs its value with UserDefaults.
///
///     @UserDefault("key") var value = 42
///
@propertyWrapper
public struct UserDefault<Value: UserDefaultCodable> {
    
    /// Declares a property that syncs with UserDefaults for given key.
    /// - Note: Initial value is used as fallback value when UserDefaults doesn’t contain given key.
    /// - Note: You can add conformance to `UserDefaultCodable` to store your own types.
    public init(wrappedValue initial: Value, suite suiteName: String? = nil, _ storageKey: String) {
        suite = UserDefaults(suiteName: suiteName) ?? .standard
        key = storageKey
        initialValue = initial
        observer = Observer(suite: suite, key: key)
    }
    
    /// Access to the wrapper itself.
    public var projectedValue: Self {
        get {
            self
        }
        set {
            self = newValue
        }
    }
    
    /// Removes value for key from UserDefaults, effectively reverting it to initial value.
    public func remove() {
        suite.removeObject(forKey: key)
    }
    
    /// Checks for customized value in the UserDefaults, returns `yes` when there is none.
    /// - Note: Even if `wrappedValue == initialValue`, this may return false, if there is a stored value in UserDefaults.
    public var isInitialValue: Bool {
        suite.object(forKey: key).!
    }
    
    /// UserDefaults suite which to use for storage.
    public let suite: UserDefaults
    
    /// Key which to use for storage.
    public let key: String
    
    /// Initial value which serves as fallback.
    /// - Note: To find out whether this value was customized, use `.isInitialValue`, don’t simply do `wrappedValue == initialValue`.
    public let initialValue: Value
    
    /// Value accessed from the UserDefaults.
    public var wrappedValue: Value {
        get {
            // Some types read non-nil value even when the key is missing.
            if isInitialValue {
                // When the key is missing, we strictly return the initial value.
                return initialValue
            } else {
                // Otherwise the initial value only serves as nil-fallback.
                return Value.readUserDefault(from: suite, for: key) ?? initialValue
            }
        }
        set {
            newValue.writeUserDefault(to: suite, for: key)
            // Since this is a struct, we manually mutates some state to trigger an update.
            didChange()
        }
    }
    
    /// Observes UserDefaults for given value. You can invoke `didChange()` from withing the handler to mutate this property.
    /// - Note: Can be invoked multiple times and all handlers are invoked in the order they were added.
    public func observe(handler: @escaping () -> Void) {
        observer.addHandler(handler)
        // Initial invocation.
        handler()
    }
    
    /// Removes all observation handlers.
    public func cancelObservation() {
        observer.removeAllHandlers()
    }
    
    /// Performs a meaningless mutation. When this property is in a struct, the mutation will be propagated.
    public mutating func didChange() {
        toggler.toggle()
    }
    
    /// Object that observes the UserDefaults for changes.
    private let observer: Observer
    
    /// A meaningless mutator, see `didChange()`.
    public var toggler: Bool = no
}


//MARK: - Debugging

extension UserDefaults {
    
    /// Prints only the relevant content of UserDefaults to console.
    public func dump() {
        if self == UserDefaults.standard {
            print("UserDefaults.standard:")
        } else {
            print(String(format: "UserDefaults(\"%p\"):", self))
        }
        dump(domain: Self.argumentDomain, label: "arguments")
        if let identifier = Bundle.main.bundleIdentifier {
            dump(domain: identifier, label: "application")
        }
        // We ignore global domain.
        dump(domain: Self.argumentDomain, label: "registration")
    }
    
    /// Prints only a single domain of UserDefault to console.
    private func dump(domain name: String, label: String) {
        if let persistent = self.persistentDomain(forName: name) {
            if persistent.hasElements {
                print("-\(label): \(persistent as NSDictionary)")
            }
        } else {
            let volatile = self.volatileDomain(forName: name)
            if volatile.hasElements {
                print("-\(label): \(volatile as NSDictionary)")
            }
        }
    }
}


//MARK: - Observer

extension UserDefault {
    
    /// Internal object that manages KVO of UserDefaults.
    private class Observer: NSObject {
        
        /// The observed UserDefaults suite.
        private let suite: UserDefaults
        
        /// The observed key.
        private let key: String
        
        /// Create an observer with given suite an key.
        fileprivate init(suite: UserDefaults, key: String) {
            self.suite = suite
            self.key = key
            super.init()
        }
        
        /// Flag indicating whether this object is registered for KVO.
        private var isAttached: Bool = no
        
        /// Registers this object for KVO, if not yet registered.
        private func attach() {
            if isAttached {
                return
            }
            isAttached = yes
            // We need to use old KVO, because we are not using static key-path.
            suite.addObserver(self, forKeyPath: key, options: [], context: nil)
        }
        
        /// Unregisters this object from KVO, if registered.
        private func detach() {
            if isAttached.! {
                return
            }
            suite.removeObserver(self, forKeyPath: key)
            isAttached = no
        }
        
        /// Automatically detaches on deinit.
        deinit {
            detach()
        }
        
        /// List of handlers to invoke on observation.
        private var handlers: [() -> Void] = []
        
        /// Add a new handler to the list of handlers and attaches the object to KVO.
        fileprivate func addHandler(_ handler: @escaping () -> Void) {
            handlers.append(handler)
            attach()
        }
        
        /// Clears the list of handlers and detaches the object from KVO.
        fileprivate func removeAllHandlers() {
            handlers = []
            detach()
        }
        
        /// KVO callback that invokes all handlers.
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            for each in handlers {
                each()
            }
        }
    }
}


//MARK: - Conformances

/// Types that can be stored in UserDefaults.
public protocol UserDefaultCodable {
    
    /// Read an optional value of this type from UserDefaults.
    static func readUserDefault(from suite: UserDefaults, for key: String) -> Self?
    
    /// Write the value of this type to UserDefaults.
    func writeUserDefault(to suite: UserDefaults, for key: String)
}

extension Bool: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Converts strings to bools: "true", "false", "YES", "NO", "1", "0"
        // Converts numbers to bools: 1, 0
        // Returns false when the stored object is not a Bool.
        return suite.bool(forKey: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension Data: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Returns nil when the stored object is not a Data.
        return suite.data(forKey: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension String: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Converts numbers to strings.
        // Returns nil when the stored object is not a String.
        return suite.string(forKey: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension URL: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Unarchives Data into URL.
        // Resolves paths relative to user home directory.
        if let url = suite.url(forKey: key) {
            return url
        }
        // Additonally, we attempt to convert a String to URL.
        if let string = suite.string(forKey: key) {
            return URL(string: string)
        }
        return nil
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        // When URL is absolute, we store it as a String.
        if self == absoluteURL {
            suite.set(absoluteString, forKey: key)
        }
        suite.set(self, forKey: key)
    }
}

extension Int: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Converts strings to numbers.
        // Rounds floating point numbers down.
        // Converts bools to numbers.
        // Returns 0 when the stored object is not a Number.
        return suite.integer(forKey: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension Double: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Converts strings to numbers.
        // Converts bools to numbers.
        // Returns 0 when the stored object is not a Number.
        return suite.double(forKey: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension Date: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // Returns nil when the stored object is not a Date.
        if let date = suite.object(forKey: key) as? Date {
            return date
        }
        // Additionally, we decode the date as ISO 8601.
        if let string = suite.string(forKey: key) {
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: string)
        }
        return nil
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        suite.set(self, forKey: key)
    }
}

extension Optional: UserDefaultCodable where Wrapped: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        Wrapped.readUserDefault(from: suite, for: key)
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        if let wrapped = self {
            wrapped.writeUserDefault(to: suite, for: key)
        } else {
            suite.removeObject(forKey: key)
        }
    }
}

extension Array: UserDefaultCodable where Element: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // We rely on NSArray conversion here.
        suite.array(forKey: key) as? Self
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        // We rely on NSArray conversion here.
        suite.set(self, forKey: key)
    }
}

extension Dictionary: UserDefaultCodable where Key == String, Value: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        // We rely on NSDictionary conversion here.
        suite.dictionary(forKey: key) as? Self
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        // We rely on NSDictionary conversion here.
        suite.set(self, forKey: key)
    }
}

/// This extension allows enums to automatically support UserDefaults storage.
extension RawRepresentable where RawValue: UserDefaultCodable {
    
    public static func readUserDefault(from suite: UserDefaults, for key: String) -> Self? {
        if let rawValue = RawValue.readUserDefault(from: suite, for: key) {
            return Self(rawValue: rawValue)
        } else {
            return nil
        }
    }
    
    public func writeUserDefault(to suite: UserDefaults, for key: String) {
        rawValue.writeUserDefault(to: suite, for: key)
    }
}

