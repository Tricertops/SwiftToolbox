//
//  CGSize.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGSize


//MARK: -

extension CGSize {
    
    /// Create from CGPoint.
    public init(_ point: CGPoint) {
        self.init(width: point.y, height: point.y)
    }
    
    /// Calculates a size from area and aspect ratio.
    public init(area: CGFloat, aspectRatio: CGFloat) {
        self.init(width: √(area * aspectRatio), height: √(area / aspectRatio))
    }
    
    /// Width-to-height ratio.
    public var aspectRatio: CGFloat {
        width / height
    }
    
    /// Product of widt hand height.
    public var area: CGFloat {
        width * height
    }
}
