//
//  Array.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Indexes

extension Array {
    
    /// Range of all indexes of this array.
    ///
    ///     for index in array.indexes { ... }
    ///
    public var indexes: CountableRange<Int> {
        0 ..< self.count
    }
    
    /// Validates the index within the range of the array.
    public func hasIndex(_ index: Int) -> Bool {
        indexes.contains(index)
    }
    
    /// Allows iteration of elements along with their indexes.
    ///
    ///     for (index, element) in array.withIndexes { ... }
    ///
    public var withIndexes: Array<(Int, Element)> {
        indexes.lazy.map { index in
            (index, self[index])
        }
    }
}


//MARK: - Testing Content

extension Array {

    /// Tests elements in array using arbitrary comparator.
    ///
    ///     array.contains(object, ===)
    ///
    public func contains(_ element: Element, _ comparator: (Element, Element) -> Bool) -> Bool {
        for each in self {
            if comparator(each, element) {
                return yes
            }
        }
        return no
    }
    
    /// Tests multiple elements at once using arbitrary comparator.
    public func contains(_ set: MultiSet.Either<Element>, _ comparator: (Element, Element) -> Bool) -> Bool {
        set.each { self.contains($0, comparator) }
    }
    
    /// Tests multiple elements at once using arbitrary comparator.
    public func contains(_ set: MultiSet.All<Element>, _ comparator: (Element, Element) -> Bool) -> Bool {
        set.each { self.contains($0, comparator) }
    }
}

extension Array where Element: Equatable {
    
    /// Tests multiple elements at once.
    public func contains(_ set: MultiSet.Either<Element>) -> Bool {
        set.each { self.contains($0) }
    }
    
    /// Tests multiple elements at once.
    public func contains(_ set: MultiSet.All<Element>) -> Bool {
        set.each { self.contains($0) }
    }
}

