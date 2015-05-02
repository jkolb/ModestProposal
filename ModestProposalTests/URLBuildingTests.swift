//
// URLBuildingTests.swift
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

import XCTest

class URLBuildingTests: XCTestCase {
    func testBuildPaths() {
        assert(baseURL: "http://test.com", path: nil, parameters: nil, equals: "http://test.com")
        assert(baseURL: "http://test.com", path: "", parameters: nil, equals: "http://test.com")
        assert(baseURL: "http://test.com", path: "test", parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com", path: "/test", parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com", path: "test/", parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com", path: "/test/", parameters: nil, equals: "http://test.com/test/")
        
        assert(baseURL: "http://test.com/", path: nil, parameters: nil, equals: "http://test.com/")
        assert(baseURL: "http://test.com/", path: "", parameters: nil, equals: "http://test.com/")
        assert(baseURL: "http://test.com/", path: "test", parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com/", path: "/test", parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com/", path: "test/", parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com/", path: "/test/", parameters: nil, equals: "http://test.com/test/")
        
        assert(baseURL: "http://test.com/test", path: nil, parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com/test", path: "", parameters: nil, equals: "http://test.com/test")
        assert(baseURL: "http://test.com/test", path: "A", parameters: nil, equals: "http://test.com/A")
        assert(baseURL: "http://test.com/test", path: "A/", parameters: nil, equals: "http://test.com/A/")
        assert(baseURL: "http://test.com/test", path: "/A", parameters: nil, equals: "http://test.com/A")
        assert(baseURL: "http://test.com/test", path: "/A/", parameters: nil, equals: "http://test.com/A/")
        
        assert(baseURL: "http://test.com/test/", path: nil, parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com/test/", path: "", parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com/test/", path: "A", parameters: nil, equals: "http://test.com/test/A")
        assert(baseURL: "http://test.com/test/", path: "A/", parameters: nil, equals: "http://test.com/test/A/")
        assert(baseURL: "http://test.com/test/", path: "A", parameters: nil, equals: "http://test.com/test/A")
        assert(baseURL: "http://test.com/test/", path: "A/", parameters: nil, equals: "http://test.com/test/A/")

        assert(baseURL: "http://test.com/test%20A/", path: nil, parameters: nil, equals: "http://test.com/test%20A/")
        assert(baseURL: "http://test.com/test%20A/", path: "", parameters: nil, equals: "http://test.com/test%20A/")
        assert(baseURL: "http://test.com/test%20A/", path: "A", parameters: nil, equals: "http://test.com/test%20A/A")
        assert(baseURL: "http://test.com/test%20A/", path: "A/", parameters: nil, equals: "http://test.com/test%20A/A/")
        assert(baseURL: "http://test.com/test%20A/", path: "A", parameters: nil, equals: "http://test.com/test%20A/A")
        assert(baseURL: "http://test.com/test%20A/", path: "A/", parameters: nil, equals: "http://test.com/test%20A/A/")
        
        assert(baseURL: "http://test.com/test/", path: nil, parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com/test/", path: "", parameters: nil, equals: "http://test.com/test/")
        assert(baseURL: "http://test.com/test/", path: "A%20A", parameters: nil, equals: "http://test.com/test/A%20A")
        assert(baseURL: "http://test.com/test/", path: "A%20A/", parameters: nil, equals: "http://test.com/test/A%20A/")
        assert(baseURL: "http://test.com/test/", path: "A%20A", parameters: nil, equals: "http://test.com/test/A%20A")
        assert(baseURL: "http://test.com/test/", path: "A%20A/", parameters: nil, equals: "http://test.com/test/A%20A/")
    }
    
    func testBuildParameters() {
        assert(baseURL: "http://test.com", path: nil, parameters: nil, equals: "http://test.com")
        assert(baseURL: "http://test.com", path: nil, parameters: [:], equals: "http://test.com")
        assert(baseURL: "http://test.com", path: nil, parameters: ["test":""], equals: "http://test.com?test=")
        assert(baseURL: "http://test.com", path: nil, parameters: ["test":"A"], equals: "http://test.com?test=A")
        assert(baseURL: "http://test.com", path: nil, parameters: ["test":"A A"], equals: "http://test.com?test=A%20A")
    }

    func testRetrieveParameters() {
        assert(URL: "http://test.com", expected: nil)
        assert(URL: "http://test.com?", expected: [:])
        assert(URL: "http://test.com?test=", expected: ["test": ""])
        assert(URL: "http://test.com?test=A", expected: ["test": "A"])
        assert(URL: "http://test.com?test=A%20A", expected: ["test": "A A"])
        assert(URL: "http://test.com?test=A", expected: ["test": "A"])
        assert(URL: "http://test.com?test=A&test=B", expected: ["test": "A"])
        assert(URL: "http://test.com?test1=A&test2=B", expected: ["test1": "A", "test2": "B"])
    }
    
    func assert(# baseURL: String, path: String?, parameters: [String:String]?, equals: String) {
        let baseURL = NSURL(string: baseURL)!
        let builtURL = baseURL.buildURL(path: path, parameters: parameters)!
        XCTAssertEqual(builtURL.absoluteString!, equals, "Failed")
    }
    
    func assert(# URL: String, expected: [String:String]?) {
        let baseURL = NSURL(string: URL)!
        
        if let parameters = baseURL.parameters {
            XCTAssertEqual(parameters, expected!, "Failed")
        } else {
            XCTAssertNil(expected, "Failed")
        }
    }
}
