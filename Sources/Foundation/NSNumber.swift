//
//  NSNumber.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.NSNumber


//MARK: Arithmetic Operators

public func + (a: NSNumber, b: NSNumber) -> NSNumber {
    (a.doubleValue + b.doubleValue) as NSNumber
}

public prefix func - (value: NSNumber) -> NSNumber {
    -value.doubleValue as NSNumber
}

public func - (a: NSNumber, b: NSNumber) -> NSNumber {
    (a.doubleValue - b.doubleValue) as NSNumber
}

public func * (a: NSNumber, b: NSNumber) -> NSNumber {
    (a.doubleValue * b.doubleValue) as NSNumber
}

public func / (a: NSNumber, b: NSNumber) -> NSNumber {
    (a.doubleValue / b.doubleValue) as NSNumber
}

