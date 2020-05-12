//
//  Collection.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Emptiness

extension Collection {
    
    /// Is not empty.
    public var hasElements: Bool {
        isEmpty.!
    }
    
    /// Coalesce empty string.
    public static func ?? (collection: Self, fallback: @autoclosure () -> Self) -> Self {
        collection.hasElements ? collection : fallback()
    }
}

