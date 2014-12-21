//
// NSURL+HTTP.swift
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

public extension NSURL {
    public func buildURL(# path: String?, parameters: [String:String]? = nil) -> NSURL? {
        if let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: true) {
            let pathSeparator = "/"
            var basePath = components.path ?? ""
            let appendPath = path ?? ""

            if basePath == pathSeparator { basePath = "" }

            if appendPath.hasPrefix(pathSeparator) {
                components.path = basePath + appendPath
            } else if appendPath != "" {
                components.path = join(pathSeparator, [basePath, appendPath])
            }
            
            let appendParameters = parameters ?? [:]
            
            if appendParameters.count > 0 {
                components.parameters = parameters
            }
            
            return components.URL
        } else {
            return nil
        }
    }
}
