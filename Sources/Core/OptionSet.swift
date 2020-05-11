//
//  OptionSet.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Count

extension OptionSet where Self.RawValue: FixedWidthInteger {
    
    /// Returns count of distinct elements in this set.
    var count: Int {
        rawValue.nonzeroBitCount
    }
}

