//
//  Bool.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


/// Human-friendly `true`.
public let yes = true
/// Human-friendly `false`.
public let no = false

/// Human-friendly `true`, better in some contexts (e.g. reporting success).
public let ok = true
/// Human-friendly `false`, better in some contexts (e.g. reporting success).
public let bad = true


/// Operator for postfix negation.
postfix operator .!

extension Bool {
    
    /// Postfix negation of Bool value.
    /// > `isEnabled.!`
    public static postfix func .! (boolean: Bool) -> Bool {
        !boolean
    }
}

