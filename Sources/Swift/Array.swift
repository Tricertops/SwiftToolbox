//
//  Array.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Operations

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
    
    /// Returns a collection of neighbouring pair from this array.
    public func zipNeighbours() -> Zip2Sequence<Array<Element>.SubSequence, Array<Element>.SubSequence> {
        if count < 2 {
            return zip([], [])
        }
        let left = prefix(upTo: count - 1)
        let right = suffix(from: 1)
        return zip(left, right)
    }
    
    /// Builds a string from the elements using provided formatter and separators.
    public func stringJoin(separator: String = ", ", last: String? = nil, formatter: ((Element) -> String)? = nil) -> String {
        if isEmpty {
            return ""
        }
        let lastSeparator = last ?? separator
        let formatter = formatter ?? { "\($0)" }
        
        var string = ""
        let lastIndex = count - 1
        for (index, element) in self.enumerated() {
            if index > 0 {
                string += (index == lastIndex ? lastSeparator : separator)
            }
            string += formatter(element)
        }
        return string
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


//MARK: Elements

extension Array {
    
    /// Subscript from the end of collection (0 is last, 1 is penultimate, etc.)
    ///
    ///     array[reversed: 1]
    ///
    public subscript(reversed index: Int) -> Element {
        get {
            return self[self.index(endIndex, offsetBy: -index)]
        }
        set {
            self[self.index(endIndex, offsetBy: -index)] = newValue
        }
    }
}

