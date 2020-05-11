//
//  Collection.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Emptiness

extension Collection {
    
    /// Has some elements?
    public static postfix func .? (collection: Self) -> Bool {
        collection.isEmpty.!
    }
    
    /// Has no characters?
    public static postfix func .?! (collection: Self) -> Bool {
        collection.isEmpty
    }
    
    /// Coalesce empty string.
    public static func ?? (collection: Self, fallback: @autoclosure () -> Self) -> Self {
        collection.? ? collection : fallback()
    }
}

