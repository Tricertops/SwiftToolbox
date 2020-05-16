//
//  Bool.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Constants

/// Human-friendly `true`.
public let yes = true
/// Human-friendly `false`.
public let no = false

/// Human-friendly `true`, better in some contexts (e.g. reporting success).
public let ok = true
/// Human-friendly `false`, better in some contexts (e.g. reporting success).
public let bad = true


//MARK: - Negation

/// Positive testing.
postfix operator .?
/// Negative testing.
postfix operator .!

extension Bool {
    
    /// Syntax sugar.
    public static postfix func .? (boolean: Self) -> Self {
        boolean
    }
    
    /// Postfix negation.
    public static postfix func .! (boolean: Self) -> Self {
        !boolean
    }
}

