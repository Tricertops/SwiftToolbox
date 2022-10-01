//
//  CGArithmetics.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGSize
import struct CoreGraphics.CGGeometry.CGRect


//MARK: - Math Protocols

/// Scalar multiplication.
public protocol ScalarMultiplicationOperation {
    /// Multiply value with scalar.
    static func * (v: Self, s: CGFloat) -> Self
}

/// Reversed scalar multiplication and in-place scalar multiplication is synthesized.
extension ScalarMultiplicationOperation {
    public static func * (s: CGFloat, p: Self) -> Self {
        p * s
    }
    public static func *= (v: inout Self, s: CGFloat) {
        v = v * s
    }
}

/// Scalar division.
public protocol ScalarDivisionOperation {
    /// Divide value by scalar.
    static func / (v: Self, s: CGFloat) -> Self
}

/// Scalar division is synthesized when scalar multiplication is implemented.
extension ScalarDivisionOperation where Self: ScalarMultiplicationOperation {
    public static func / (v: Self, s: CGFloat) -> Self {
        v * (1 / s)
    }
}

/// In-place scalar division is synthesized.
extension ScalarDivisionOperation {
    public static func /= (v: inout Self, s: CGFloat) {
        v = v / s
    }
}


//MARK: - CGPoint

extension CGPoint: AdditionOperation, SubtractionOperation, ScalarMultiplicationOperation, ScalarDivisionOperation {
    
    /// Sum two points.
    public static func + (a: Self, b: Self) -> Self {
        CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    // In-place addition is synthesized: a += b
    
    /// Unary negation.
    public static prefix func - (p: Self) -> Self {
        CGPoint(x: -p.x, y: -p.y)
    }
    // Subtraction is synthesized: a - b
    // In-place subtraction is synthesized: a -= b
    
    /// Scalar multiplication.
    public static func * (p: Self, s: CGFloat) -> Self {
        CGPoint(x: p.x * s, y: p.y * s)
    }
    // Reverse scalar multiplication is synthesized: scalar * point
    // Scalar division is synthesized: point / scalar
    // In-place scalar multiplication is synthesized: point *= scalar
    // In-place scalar division is synthesized: point /= scalar
}


//MARK: - CGSize

extension CGSize: AdditionOperation, SubtractionOperation, ScalarMultiplicationOperation, ScalarDivisionOperation {
    
    /// Sum two sizes.
    public static func + (a: Self, b: Self) -> Self {
        CGSize(width: a.width + b.width, height: a.height + b.height)
    }
    // In-place addition is synthesized: a += b
    
    /// Unary negation.
    public static prefix func - (s: Self) -> Self {
        CGSize(width: -s.width, height: -s.height)
    }
    // Subtraction is synthesized: a - b
    // In-place subtraction is synthesized: a -= b
    
    /// Scalar multiplication.
    public static func * (size: Self, scalar: CGFloat) -> Self {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }
    // Reverse scalar multiplication is synthesized: scalar * size
    // Scalar division is synthesized: size / scalar
    // In-place scalar multiplication is synthesized: size *= scalar
    // In-place scalar division is synthesized: size /= scalar
}


//MARK: - CGRect

extension CGRect: ScalarMultiplicationOperation, ScalarDivisionOperation {
    
    /// Offset a rect.
    public static func + (rect: Self, offset: CGPoint) -> Self {
        CGRect(origin: rect.origin + offset, size: rect.size)
    }
    public static func + (offset: CGPoint, rect: Self) -> Self {
        rect + offset
    }
    public static func - (rect: Self, offset: CGPoint) -> Self {
        rect + -offset
    }
    public static func += (rect: inout Self, offset: CGPoint) {
        rect = rect + offset
    }
    public static func -= (rect: inout Self, offset: CGPoint) {
        rect = rect - offset
    }
    
    /// Resize a rect.
    public static func + (rect: Self, resizement: CGSize) -> Self {
        CGRect(origin: rect.origin, size: rect.size + resizement)
    }
    public static func + (resizement: CGSize, rect: Self) -> Self {
        rect + resizement
    }
    public static func - (rect: Self, resizement: CGSize) -> Self {
        rect + -resizement
    }
    public static func += (rect: inout Self, resizement: CGSize) {
        rect = rect + resizement
    }
    public static func -= (rect: inout Self, resizement: CGSize) {
        rect = rect - resizement
    }
    
    /// Scalar multiplication.
    public static func * (rect: Self, scalar: CGFloat) -> Self {
        CGRect(origin: rect.origin * scalar, size: rect.size * scalar)
    }
    // Reverse scalar multiplication is synthesized: scalar * size
    // Scalar division is synthesized: size / scalar
    // In-place scalar multiplication is synthesized: size *= scalar
    // In-place scalar division is synthesized: size /= scalar
}

