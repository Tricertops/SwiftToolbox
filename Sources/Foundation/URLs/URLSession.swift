//
//  URLSession.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Instances

extension URLSession {
    
    /// Shared instance of a URL Session that targets Main Queue.
    public static let main = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
}


//MARK: - Data Download

extension URLSession {
    
    /// Initiates a data download from given URL using GET method.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func download(_ url: URL, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionDataTask {
        let request = URLRequest(method: .GET, url: url)
        return download(request: request, suspended: suspended, completionHandler: completionHandler)
    }
    
    /// Initiates a data download using given URL request.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func download(request: URLRequest, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionDataTask {
        let onMainQueue = Thread.isMainThread
        let task = dataTask(with: request) { (data, response, error) in
            let result = Result(data: data, response: response, error: error)
            self.invoke(completionHandler, onMainQueue, with: result)
        }
        if suspended.! {
            task.resume()
        }
        return task
    }
}


//MARK: - File Download

extension URLSession {
    
    /// Initiates a file download from given URL using GET method.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func downloadFile(from url: URL, suspended: Bool = no, completionHandler: @escaping FileCompletionHandler) -> URLSessionDownloadTask {
        let request = URLRequest(method: .GET, url: url)
        return downloadFile(request: request, suspended: suspended, completionHandler: completionHandler)
    }
    
    /// Initiates a file download using given URL request.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func downloadFile(request: URLRequest, suspended: Bool = no, completionHandler: @escaping FileCompletionHandler) -> URLSessionDownloadTask {
        let onMainQueue = Thread.isMainThread
        let task = downloadTask(with: request) { (fileURL, response, error) in
            let result = Result(fileURL: fileURL, response: response, error: error)
            self.invoke(completionHandler, onMainQueue, with: result)
        }
        if suspended.! {
            task.resume()
        }
        return task
    }
    
    /// Resumes a file download.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func downloadFile(resumeData: Data, suspended: Bool = no, completionHandler: @escaping FileCompletionHandler) -> URLSessionDownloadTask {
        let onMainQueue = Thread.isMainThread
        let task = downloadTask(withResumeData: resumeData) { (fileURL, response, error) in
            let result = Result(fileURL: fileURL, response: response, error: error)
            self.invoke(completionHandler, onMainQueue, with: result)
        }
        if suspended.! {
            task.resume()
        }
        return task
    }
}


//MARK: - Data Upload

extension URLSession {
    
    /// Initiates a data upload to given URL using POST or any other method.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func upload(to url: URL, method: URLRequest.HTTPMethod = .POST, data: Data, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionUploadTask {
        let request = URLRequest(method: method, url: url)
        return upload(request: request, data: data, completionHandler: completionHandler)
    }
    
    /// Initiates a data upload using gievn URL request.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func upload(request: URLRequest, data: Data, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionUploadTask {
        let onMainQueue = Thread.isMainThread
        let task = uploadTask(with: request, from: data) { (data, response, error) in
            let result = Result(data: data, response: response, error: error)
            self.invoke(completionHandler, onMainQueue, with: result)
        }
        if suspended.! {
            task.resume()
        }
        return task
    }
}

//MARK: - File Upload

extension URLSession {
    
    /// Initiates a file upload to given URL using POST or any other method.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func upload(to url: URL, method: URLRequest.HTTPMethod = .POST, file: URL, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionUploadTask {
        let request = URLRequest(method: method, url: url)
        return upload(request: request, file: file, completionHandler: completionHandler)
    }
    
    /// Initiates a file upload using gievn URL request.
    /// - Note: By default, the returned task is already running. You can optionally request a suspended task.
    /// - Note: The completion handler receives a `Result` where HTTP error is represented as failure despite the received body.
    /// - Important: If this method is invoked on Main Thread, the completion handler is also invoked on Main Thread.
    @discardableResult
    public func upload(request: URLRequest, file: URL, suspended: Bool = no, completionHandler: @escaping DataCompletionHandler) -> URLSessionUploadTask {
        let onMainQueue = Thread.isMainThread
        let task = uploadTask(with: request, fromFile: file) { (data, response, error) in
            let result = Result(data: data, response: response, error: error)
            self.invoke(completionHandler, onMainQueue, with: result)
        }
        if suspended.! {
            task.resume()
        }
        return task
    }
}


//MARK: - Results

extension URLSession {
    
    /// Completion handler of data-returning URL tasks.
    public typealias DataCompletionHandler = (Result<(Data, HTTPURLResponse), URLError>) -> Void
    
    /// Completion handler of file-returning URL tasks.
    public typealias FileCompletionHandler = (Result<(URL, HTTPURLResponse), URLError>) -> Void
    
    /// Internal function for invoking completion handlers. When initial call was made on Main Thread, callback is delivered on Main Thread.
    fileprivate func invoke<Value>(_ completionHandler: @escaping (Result<(Value, HTTPURLResponse), URLError>) -> Void, _ onMainQueue: Bool, with result: Result<(Value, HTTPURLResponse), URLError>) {
        if onMainQueue {
            // Schedule on Main Queue.
            OperationQueue.main.addOperation {
                completionHandler(result)
            }
        } else {
            // Invoke on this session’s queue.
            completionHandler(result)
        }
    }
}

extension Result where Success == (Data, HTTPURLResponse), Failure == URLError {
    
    /// Internally creates a Result from data URL response.
    fileprivate init(data: Data?, response: URLResponse?, error: Error?) {
        // Data and error are mutually exclusive, response is independent.
        if let error = error as? URLError {
            self = .failure(error)
            return
        }
        if let data = data, let response = response as? HTTPURLResponse {
            // If error status code was returned, we construct appropriate URL error.
            if let statusCodeError = response.httpError(body: data) {
                self = .failure(statusCodeError)
            } else {
                self = .success((data, response))
            }
            return
        }
        // Other types of errors are wraped in unknown URL errors.
        let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
        self = .failure(URLError(.unknown, userInfo: userInfo ?? [:]))
    }
}

extension Result where Success == (URL, HTTPURLResponse), Failure == URLError {
    
    /// Internally creates a Result from file URL response.
    fileprivate init(fileURL: URL?, response: URLResponse?, error: Error?) {
        // Data and error are mutually exclusive, response is independent.
        if let error = error as? URLError {
            self = .failure(error)
            return
        }
        if let fileURL = fileURL, let response = response as? HTTPURLResponse {
            // If error status code was returned, we construct appropriate URL error.
            if let statusCodeError = response.httpError {
                self = .failure(statusCodeError)
            } else {
                self = .success((fileURL, response))
            }
            return
        }
        // Other types of errors are wraped in unknown URL errors.
        let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
        self = .failure(URLError(.unknown, userInfo: userInfo ?? [:]))
    }
}

