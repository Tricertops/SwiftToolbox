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


//MARK: - Elements

extension Collection {
    
    /// Second element in the collection, if any.
    public var second: Element? {
        count >= 2 ? self[self.index(startIndex, offsetBy: 1)] : nil
    }
    
    /// Third element in the collection, if any.
    public var third: Element? {
        count >= 3 ? self[self.index(startIndex, offsetBy: 2)] : nil
    }
    
    /// Second-to-last element in the collection, if any.
    public var prelast: Element? {
        count >= 2 ? self[self.index(endIndex, offsetBy: -2)] : nil
    }
    
    /// The only element in the collection. Returns `nil` even if the collection contains more than 1 element.
    public var single: Element? {
        count == 1 ? first : nil
    }
}

