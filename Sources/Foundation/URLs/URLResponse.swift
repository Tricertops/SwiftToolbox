//
//  URlResponse.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Text Encoding

extension URLResponse {
    
    /// Text encoding used for the response body.
    public var textEncoding: String.Encoding {
        guard let name = textEncodingName else {
            return .utf8
        }
        let encoding = CFStringConvertIANACharSetNameToEncoding(name as CFString)
        let rawValue = CFStringConvertEncodingToNSStringEncoding(encoding)
        return String.Encoding(rawValue: rawValue)
    }
}


//MARK: - Status Code

extension HTTPURLResponse {
    
    /// Returns a localized string corresponding to the HTTP status code.
    public var localizedStatusCodeDescription: String {
        HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    
    /// If status code is in 4xx or 5xx range, this returns an URL error that best describes the status code. Adds custom debugging message.
    public func httpError(message: String) -> URLError? {
        httpErrorCode.map { URLError($0, userInfo: [NSDebugDescriptionErrorKey: message]) }
    }
    
    /// If status code is in 4xx or 5xx range, this returns an URL error that best describes the status code. Adds debugging message with status code description.
    public var httpError: URLError? {
        httpError(message: "HTTP Error \(statusCode): \(localizedStatusCodeDescription)")
    }
    
    /// If status code is in 4xx or 5xx range, this returns an URL error that best describes the status code. Adds debugging message from response body.
    public func httpError(body data: Data) -> URLError? {
        if let description = String(data: data, encoding: textEncoding) {
            return httpError(message: description)
        } else {
            return httpError
        }
    }
    
    /// If status code is in 4xx or 5xx range, this returns an URL error that best describes the status code.
    private var httpErrorCode: URLError.Code? {
        switch statusCode {
            // 401 Unauthorized
            // 402 Payment Required
            // 407 Proxy Authentication Required
            case 401, 402, 407:
                return .userAuthenticationRequired
            // 403 Forbidden
            // 404 Not Found
            // 410 Gone
            case 403, 404, 410:
                return .resourceUnavailable
            // 408 Request Timeout
            case 408:
                return .timedOut
            // 4xx: Client Error
            case 400...499:
                return .unsupportedURL
                
            // 5xx: Server Error
            case 500...599:
                return .badServerResponse
            
            // 1xx: Informational
            // 2xx: Success
            // 3xx: Redirection
            default: return nil
        }
    }
}

