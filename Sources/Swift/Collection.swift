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
    
    /// When collection is empty, returns nil.
    public var emptyAsNil: Self? {
        isEmpty ? nil : self
    }
    
    /// Coalesce empty string.
    public static func ?? (collection: Self, fallback: @autoclosure () -> Self) -> Self {
        collection.hasElements ? collection : fallback()
    }
}

