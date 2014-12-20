//
// HTTPTransform.swift
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
import UIKit

public func defaultJSONTransformer(JSONData: NSData) -> Outcome<JSON, NSError> {
    var error: NSError?
    
    if let json = JSON.parse(JSONData, options: nil, error: &error) {
        return .Success(json)
    } else {
        return .Failure(error!)
    }
}

public func defaultImageTransformer(imageData: NSData) -> Outcome<UIImage, NSError> {
    if let image = UIImage(data: imageData) {
        return .Success(image)
    } else {
        return .Failure(NSError.invalidImageDataError())
    }
}

public extension NSError {
    public class func invalidImageDataError() -> NSError {
        return NSError(
            domain: ImageTransformerErrorDomain,
            code: ImageTransformerInvalidDataErrorCode,
            userInfo: nil
        )
    }
    
    public var isInvalidImageDataError: Bool {
        return domain == ImageTransformerErrorDomain && code == ImageTransformerInvalidDataErrorCode
    }
}

public let ImageTransformerErrorDomain = "net.franticapparatus.ImageTransformerErrorDomain"
public let ImageTransformerInvalidDataErrorCode = 100
