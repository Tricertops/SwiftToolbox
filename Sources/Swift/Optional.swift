//
//  Optional.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Bool Operators

extension Optional {
    
    /// Is any?
    public static postfix func .? (optional: Self) -> Bool {
        optional != nil
    }
    
    /// Is none?
    public static postfix func .! (optional: Self) -> Bool {
        optional == nil
    }
}

