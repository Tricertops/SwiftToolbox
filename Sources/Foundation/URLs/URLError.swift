//
//  URLError.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - User Info

extension URLError {
    
    /// Access user info dictionary.
    public subscript(_ key: String) -> Any? {
        get {
            userInfo[key]
        }
        set {
            var copy = userInfo
            copy[key] = newValue
            self = URLError(code, userInfo: copy)
        }
    }
}


//MARK: - Retrying

extension URLError {
    
    /// Some kinds of errors are temporary from nature, so they may be worths retrying without any changes.
    public var canRetry: Bool {
        code == (.timedOut | .networkConnectionLost | .notConnectedToInternet | .callIsActive)
    }
}

