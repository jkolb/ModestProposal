//
// NSMutableURLRequest+HTTP.swift
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

public extension NSURLRequest {
    public func DELETE(path: String, parameters: [String:String]? = nil) -> NSMutableURLRequest {
        return buildHTTP(.DELETE, path: path, parameters: parameters)
    }
    
    public func GET(path: String, parameters: [String:String]? = nil) -> NSMutableURLRequest {
        return buildHTTP(.GET, path: path, parameters: parameters)
    }
    
    public func POST(path: String, json: JSON) -> NSMutableURLRequest {
        return POST(path, body: json.format(prettyPrinted: false), mediaType: .ApplicationJSON)
    }
    
    public func POST(path: String, parameters: [String:String]? = nil, encoding: UInt = NSUTF8StringEncoding) -> NSMutableURLRequest {
        return POST(path, body: NSData.formURLEncode(parameters, encoding: encoding), mediaType: .ApplicationXWWWFormURLEncoded)
    }
    
    public func POST(path: String, body: NSData? = nil, mediaType: HTTPMediaType? = nil) -> NSMutableURLRequest {
        return buildHTTP(.POST, path: path, parameters: nil, body: body, mediaType: mediaType)
    }

    public func PUT(path: String, json: JSON) -> NSMutableURLRequest {
        return PUT(path, body: json.format(prettyPrinted: false), mediaType: .ApplicationJSON)
    }

    public func PUT(path: String, parameters: [String:String]? = nil, encoding: UInt = NSUTF8StringEncoding) -> NSMutableURLRequest {
        return PUT(path, body: NSData.formURLEncode(parameters, encoding: encoding), mediaType: .ApplicationXWWWFormURLEncoded)
    }
    
    public func PUT(path: String, body: NSData? = nil, mediaType: HTTPMediaType? = nil) -> NSMutableURLRequest {
        return buildHTTP(.PUT, path: path, parameters: nil, body: body, mediaType: mediaType)
    }
    
    public func buildHTTP(method: HTTPRequestMethod, path: String, parameters: [String:String]? = nil, body: NSData? = nil, mediaType: HTTPMediaType? = nil) -> NSMutableURLRequest {
        return buildHTTP(method.rawValue, path: path, parameters: parameters, body: body, contentType: mediaType?.rawValue)
    }
    
    public func buildHTTP(method: String, path: String, parameters: [String:String]? = nil, body: NSData? = nil, contentType: String? = nil) -> NSMutableURLRequest {
        let request = mutableCopy() as! NSMutableURLRequest
        request.URL = request.URL?.buildURL(path: path, parameters: parameters)
        request.HTTPMethod = method
        request.HTTPBody = body
        request[.ContentType] = contentType
        if let length = body?.length {
            request[.ContentLength] = String(length)
        }
        return request
    }
}

public extension NSMutableURLRequest {
    public func basicAuthorization(# username: String, password: String, encoding: NSStringEncoding = NSUTF8StringEncoding) {
        let authorizationString = "\(username):\(password)"
        if let authorizationData = authorizationString.dataUsingEncoding(encoding, allowLossyConversion: false) {
            let base64String = NSString(data: authorizationData.base64EncodedDataWithOptions(nil), encoding: NSASCIIStringEncoding) ?? ""
            self[.Authorization] = "Basic \(base64String)"
        }
    }

    public var method : HTTPRequestMethod? {
        get {
            return HTTPRequestMethod(rawValue: HTTPMethod)
        }
        set {
            HTTPMethod = newValue?.rawValue ?? ""
        }
    }
    
    public var contentType : HTTPMediaType? {
        get {
            if let rawValue = self[.ContentType] {
                return HTTPMediaType(rawValue: rawValue)
            } else {
                return nil
            }
        }
        set {
            self[.ContentType] = newValue?.rawValue
        }
    }
    
    public var contentLength : Int? {
        get {
            return self[.ContentLength]?.toInt()
        }
        set {
            if let value = newValue {
                let string = String(value)
                self[.ContentLength] = string
            } else {
                self[.ContentLength] = nil
            }
        }
    }
    
    public subscript(field: HTTPRequestField) -> String? {
        get {
            return valueForHTTPHeaderField(field.rawValue)
        }
        set {
            setValue(newValue, forHTTPHeaderField: field.rawValue)
        }
    }
    
    public subscript(field: String) -> String? {
        get {
            return valueForHTTPHeaderField(field)
        }
        set {
            setValue(newValue, forHTTPHeaderField: field)
        }
    }
    
    public func addValue(value: String?, forHTTPHeaderField field: HTTPRequestField) {
        addValue(value, forHTTPHeaderField: field.rawValue)
    }
}
