//
//  Enums.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//


//MARK: - Cases

extension CaseIterable {
    
    /// Returns a random case of this enum.
    public static func randomCase() -> Self {
        Self.allCases.randomElement()!
    }
}

