//
//  URLRequest.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import struct Foundation.URL
import struct Foundation.URLRequest


//MARK: - HTTP Methods

extension URLRequest {
    
    /// The set of common methods for HTTP/1.1
    public enum HTTPMethod: String {
        /// Requests the specified resource.
        case GET = "GET"
        /// Requests metadata for the specified resource.
        case HEAD = "HEAD"
        /// Appends to the specified resource.
        case POST = "POST"
        /// Creates or replaces the specified resource.
        case PUT = "PUT"
        /// Deletes the specified resource.
        case DELETE = "DELETE"
        /// Echoes the received request.
        case TRACE = "TRACE"
        /// Asks for available methods.
        case OPTIONS = "OPTIONS"
        /// Converts the request connection to a transparent TCP/IP tunnel.
        case CONNECT = "CONNECT"
        /// Applies partial modifications to a resource.
        case PATCH = "PATCH"
    }
}


//MARK: - Creating

extension URLRequest {
    
    /// Create a request with specific HTTP method and headers.
    public init(method: HTTPMethod, url: URL, headers: [String: String] = [:]) {
        self.init(url: url)
        httpMethod = method.rawValue
        for (field, value) in headers {
            addValue(value, forHTTPHeaderField: field)
        }
    }
}



