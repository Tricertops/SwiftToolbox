//
//  CGRect.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct CoreGraphics.CGGeometry.CGRect
import struct CoreGraphics.CGGeometry.CGPoint


//MARK: -

extension CGRect {
    
    /// Center of the rectangle.
    public var center: CGPoint {
        origin + CGPoint(size / 2)
    }
}
