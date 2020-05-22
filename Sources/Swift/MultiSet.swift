//
//  MultiSet.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Multi-Set

/// This allows passing multiple values where a single value is expected.
///
/// Examples:
///
/// - Direction is either north or south:
///
///       if direction == (.north | .south) { ... }
///
/// - String has prefix either "http" or "https".
///
///       string.hasPrefix("http" | "https")
///
/// - A is equal to both B and C:
///
///       if a == (b & c) { ... }
///
/// To add support for your function, implement an overload for `MultiSet.Either` and `MultiSet.All`
/// and call their `.each{}` function and in its body call your original function.
public enum MultiSet {
    
    /// Temporary structure created from `|` operators.
    public struct Either<Element> {
        
        /// Performs the `body` on each element and returns whether any of them tested positive.
        public func each(_ body: (Element) -> Bool) -> Bool {
            for each in elements {
                if body(each).? {
                    return yes
                }
            }
            return no
        }
        
        /// Internal list of contained elements.
        fileprivate let elements: [Element]
    }
    
    /// Temporary structure created from `&` operators.
    public struct All<Element> {
        
        /// Performs the `body` on each element and returns whether all of them tested positive.
        public func each(_ body: (Element) -> Bool) -> Bool {
            for each in elements {
                if body(each).! {
                    return no
                }
            }
            return yes
        }
        
        /// Internal list of contained elements.
        fileprivate let elements: [Element]
    }
}


//MARK: - Creating

/// Allows combining multiple elements into `MultiSet.Either`.
public func | <T>(left: T, right: T) -> MultiSet.Either<T> {
    MultiSet.Either(elements: [left, right])
}

/// Allows combining multiple elements into `MultiSet.Either`.
public func | <T>(set: MultiSet.Either<T>, element: T) -> MultiSet.Either<T> {
    MultiSet.Either(elements: set.elements + [element])
}

/// Allows combining multiple elements into `MultiSet.All`.
public func & <T>(left: T, right: T) -> MultiSet.All<T> {
    MultiSet.All(elements: [left, right])
}

/// Allows combining multiple elements into `MultiSet.All`.
public func & <T>(set: MultiSet.All<T>, element: T) -> MultiSet.All<T> {
    MultiSet.All(elements: set.elements + [element])
}


//MARK: - Equality

/// Tests equality to multiple values at once.
public func == <T: Equatable>(value: T, set: MultiSet.Either<T>) -> Bool {
    set.each { value == $0 }
}

/// Tests equality to multiple values at once.
public func == <T: Equatable>(value: T, set: MultiSet.All<T>) -> Bool {
    set.each { value == $0 }
}

/// Tests equality to multiple values at once.
public func != <T: Equatable>(value: T, set: MultiSet.Either<T>) -> Bool {
    set.each { value != $0 }
}

/// Tests equality to multiple values at once.
public func != <T: Equatable>(value: T, set: MultiSet.All<T>) -> Bool {
    set.each { value != $0 }
}

