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
    
    /// Coalesce empty collection.
    public static func ?? (collection: Self, fallback: @autoclosure () -> Self) -> Self {
        collection.hasElements ? collection : fallback()
    }
}


//MARK: - Elements

extension Collection {
    
    /// Second element in the collection, if any.
    public var second: Element? {
        self[optional: 1]
    }
    
    /// Third element in the collection, if any.
    public var third: Element? {
        self[optional: 2]
    }
    
    /// Second-to-last element in the collection, if any.
    public var prelast: Element? {
        let index = count - 2
        guard index >= 0 else {
            return nil
        }
        return self[optional: index]
    }
    
    /// The only element in the collection. Returns `nil` even if the collection contains more than 1 element.
    public var single: Element? {
        count == 1 ? first : nil
    }
    
    /// Subscript safe for out-of-range indexes. Negative index is still an error.
    ///
    ///     array[optional: 34]
    ///
    public subscript(optional index: Int) -> Element? {
        if index >= self.count {
            return nil
        }
        return self[self.index(startIndex, offsetBy: index)]
    }
}

