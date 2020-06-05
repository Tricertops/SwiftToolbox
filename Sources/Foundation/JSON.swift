//
//  JSON.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class Foundation.JSONSerialization
import struct Foundation.Data


//MARK: - Pretty Format

extension JSONSerialization {
    
    /// Returns a pretty-formatted JSON string for debugging purposes.
    public static func prettify(_ data: Data) -> String {
        do {
            let object = try jsonObject(with: data)
            let prettyData = try self.data(withJSONObject: object, options: .prettyPrinted)
            return try String(data: prettyData, encoding: .utf8) !! Assert("Failed to read JSON.")
        }
        catch {
            return "(invalid JSON)"
        }
    }
}

