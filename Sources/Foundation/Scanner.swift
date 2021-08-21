//
//  Scanner.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.Scanner


//MARK: - Scanning

extension Scanner {
    
    /// Scans the string until a given string is encountered and then scans that string.
    @discardableResult
    public func scanThroughString(_ string: String) -> Bool {
        guard let _ = scanUpToString(string) else {
            return no
        }
        guard let _ = scanString(string) else {
            return no
        }
        return yes
    }
}
