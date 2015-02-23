//
// HTTPValidator.swift
// ModestProposal
//
// Copyright (c) 2014 Justin Kolb - http://franticapparatus.net
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

public extension Validator {
    public class func defaultJSONResponseValidator(response: NSURLResponse) -> Validator {
        let builder = ValidatorBuilder()
        builder.valid(when: response.isHTTP, otherwise: NSError.notAnHTTPResponseError())
        builder.valid(when: response.asHTTP.isSuccessful, otherwise: NSError.unexpectedStatusCodeError(response.asHTTP.statusCode))
        builder.valid(when: response.asHTTP.isJSON, otherwise: NSError.unexpectedContentTypeError(response.asHTTP.MIMEType))
        return builder.build()
    }
    
    public class func defaultImageResponseValidator(response: NSURLResponse) -> Validator {
        let builder = ValidatorBuilder()
        builder.valid(when: response.isHTTP, otherwise: NSError.notAnHTTPResponseError())
        builder.valid(when: response.asHTTP.isSuccessful, otherwise: NSError.unexpectedStatusCodeError(response.asHTTP.statusCode))
        builder.valid(when: response.asHTTP.isImage, otherwise: NSError.unexpectedContentTypeError(response.asHTTP.MIMEType))
        return builder.build()
    }
    
    public class func HTTPResponseValidator(response: NSURLResponse, allowedStatuses: [Int], allowedContentTypes: [String]) -> Validator {
        let builder = ValidatorBuilder()
        builder.valid(when: response.isHTTP, otherwise: NSError.notAnHTTPResponseError())
        builder.valid(when: response.asHTTP.matchesStatuses(allowedStatuses), otherwise: NSError.unexpectedStatusCodeError(response.asHTTP.statusCode))
        builder.valid(when: response.asHTTP.matchesContentTypes(allowedContentTypes), otherwise: NSError.unexpectedContentTypeError(response.asHTTP.MIMEType))
        return builder.build()
    }
}

public extension NSError {
    public class func notAnHTTPResponseError() -> NSError {
        return NSError(
            domain: HTTPResponseValidationErrorDomain,
            code: HTTPResponseValidationNotAnHTTPResponseErrorCode,
            userInfo: nil
        )
    }
    
    public class func unexpectedStatusCodeError(statusCode: Int) -> NSError {
        return NSError(
            domain: HTTPResponseValidationErrorDomain,
            code: HTTPResponseValidationUnexpectedStatusCodeErrorCode,
            userInfo: ["statusCode": statusCode]
        )
    }
    
    public class func unexpectedContentTypeError(contentType: String?) -> NSError {
        return NSError(
            domain: HTTPResponseValidationErrorDomain,
            code: HTTPResponseValidationUnexpectedContentTypeErrorCode,
            userInfo: ["contentType": contentType ?? ""]
        )
    }
    
    public var isNotAnHTTPResponseError: Bool {
        return domain == HTTPResponseValidationErrorDomain && code == HTTPResponseValidationNotAnHTTPResponseErrorCode
    }
    
    public var isUnexpectedStatusCodeError: Bool {
        return domain == HTTPResponseValidationErrorDomain && code == HTTPResponseValidationUnexpectedStatusCodeErrorCode
    }
    
    public var isUnexpectedContentTypeError: Bool {
        return domain == HTTPResponseValidationErrorDomain && code == HTTPResponseValidationUnexpectedContentTypeErrorCode
    }
}

public let HTTPResponseValidationErrorDomain = "net.franticapparatus.HTTPResponseValidationErrorDomain"
public let HTTPResponseValidationNotAnHTTPResponseErrorCode = 100
public let HTTPResponseValidationUnexpectedStatusCodeErrorCode = 200
public let HTTPResponseValidationUnexpectedContentTypeErrorCode = 300
