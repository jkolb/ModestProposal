//
// Example.swift
// ModestProposal
//
// Copyright (c) 2015 Justin Kolb - http://franticapparatus.net
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public class Example {
    let API = ExampleAPI()
    var task: NSURLSessionDataTask!
    
    public init() { }
    
    public func fetchAll() {
        task = API.subreddit(name: "all", completion: { [weak self] (outcome) in
            if let strongSelf = self {
                outcome.onSuccess { (json) in
                    strongSelf.displayResult(json)
                }
                outcome.onFailure { (error) in
                    strongSelf.displayError(error)
                }
                strongSelf.task = nil
            }
        })
    }
    
    public func displayResult(json: JSON) {
        println(json)
    }
    
    public func displayError(error: NSError) {
        println(error)
    }
}

public class ExampleAPI {
    let session: NSURLSession
    let prototype: NSURLRequest
    
    public convenience init() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let prototype = NSURLRequest(URL: NSURL(string: "http://www.reddit.com")!)
        self.init(session: session, prototype: prototype)
    }
    
    public init(session: NSURLSession, prototype: NSURLRequest) {
        self.session = session
        self.prototype = prototype.copy() as! NSURLRequest
    }

    // MARK: - Your API
    
    public func subreddit(# name: String, completion: (Outcome<JSON, NSError>) -> ()) -> NSURLSessionDataTask {
        return GET("/r/\(name).json", parameters: nil, completion: completion)
    }
    
    public func login(# username: String, password: String, completion: (Outcome<JSON, NSError>) -> ()) -> NSURLSessionDataTask {
        let parameters = [
            "api_type": "json",
            "user": username,
            "passwd": password,
        ]
        return POST("/api/login", parameters: parameters, completion: completion)
    }
    
    public func thumbnail(# url: NSURL, completion: (Outcome<UIImage, NSError>) -> ()) -> NSURLSessionDataTask {
        return GET(url, completion: completion)
    }
    
    // MARK: - Specific HTTP requests
    
    public func GET(path: String, parameters: [String:String]? = nil, completion: (Outcome<JSON, NSError>) -> ()) -> NSURLSessionDataTask {
        return GET(path, parameters: parameters, validator: JSONValidator, transformer: JSONTransformer, completion: completion)
    }
    
    public func GET(url: NSURL, completion: (Outcome<UIImage, NSError>) -> ()) -> NSURLSessionDataTask {
        return request(NSURLRequest(URL: url), validator: ImageValidator, transformer: ImageTransformer, completion: completion)
    }
    
    public func POST(path: String, parameters: [String:String]? = nil, completion: (Outcome<JSON, NSError>) -> ()) -> NSURLSessionDataTask {
        return POST(path, parameters: parameters, validator: JSONValidator, transformer: JSONTransformer, completion: completion)
    }
    
    // MARK: - Request validation and transformation
    
    public func JSONValidator(response: NSURLResponse) -> NSError? {
        return Validator.defaultJSONResponseValidator(response).validate()
    }
    
    public func JSONTransformer(data: NSData) -> Outcome<JSON, NSError> {
        return defaultJSONTransformer(data)
    }
    
    public func ImageValidator(response: NSURLResponse) -> NSError? {
        return Validator.defaultImageResponseValidator(response).validate()
    }
    
    public func ImageTransformer(data: NSData) -> Outcome<UIImage, NSError> {
        return defaultImageTransformer(data)
    }
    
    // MARK: - Generic HTTP requests
    
    public func GET<T>(
        path: String,
        parameters: [String:String]?,
        validator: (NSURLResponse) -> NSError?,
        transformer: (NSData) -> Outcome<T, NSError>,
        completion: (Outcome<T, NSError>) -> ()
        ) -> NSURLSessionDataTask
    {
        return request(prototype.GET(path, parameters: parameters), validator: validator, transformer: transformer, completion: completion)
    }
    
    public func POST<T>(
        path: String,
        parameters: [String:String]?,
        validator: (NSURLResponse) -> NSError?,
        transformer: (NSData) -> Outcome<T, NSError>,
        completion: (Outcome<T, NSError>) -> ()
        ) -> NSURLSessionDataTask
    {
        return request(prototype.POST(path, parameters: parameters), validator: validator, transformer: transformer, completion: completion)
    }
    
    // MARK: - Generic requests
    
    public func request<T>(
        request: NSURLRequest,
        validator: (NSURLResponse) -> NSError?,
        transformer: (NSData) -> Outcome<T, NSError>,
        completion: (Outcome<T, NSError>) -> ()
        ) -> NSURLSessionDataTask
    {
        return session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                completion(Outcome(error))
            }
            
            if let validationError = validator(response) {
                completion(Outcome(validationError))
            }
            
            transform(input: data, transformer: transformer, completion)
        }
    }
}
