//
//  CGPoint.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import func Darwin.C.math.hypot
import func Darwin.C.math.sin
import func Darwin.C.math.cos
import func Darwin.C.math.atan2
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGSize


//MARK: - Vector

extension CGPoint {
    
    /// Create from polar coordinates.
    public init(angle: CGFloat, length: CGFloat) {
        self.init(x: length * sin(angle), y: length * cos(angle))
    }
    
    /// Vector length.
    public var length: CGFloat {
        hypot(x, y)
    }
    
    /// Normalized vector.
    public var normalized: Self {
        self / length
    }
    
    /// Vector angle in radians.
    public var angle: CGFloat {
        atan2(y, x)
    }
}


//MARK: -

extension CGPoint {
    
    /// Create from CGSize.
    public init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
    
    /// Distance from other point.
    public func distance(from point: Self) -> CGFloat {
        (self - point).length
    }
    
    /// Dot operation.
    public func dot(_ other: Self) -> CGFloat {
        x * other.x + y * other.y
    }
}

