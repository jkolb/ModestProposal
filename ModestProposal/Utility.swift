// Copyright (c) 2016 Justin Kolb - http://franticapparatus.net
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

import Foundation

public class Value<T> {
    public let unwrap: T
    
    public init(_ value: T) {
        self.unwrap = value
    }
}

public enum Outcome<Result, Reason> {
    case Success(Value<Result>)
    case Failure(Value<Reason>)
    
    public init(_ result: Result) {
        self = .Success(Value(result))
    }
    
    public init(_ reason: Reason) {
        self = .Failure(Value(reason))
    }
    
    public func onSuccess(@noescape handler: (Result) -> ()) {
        switch self {
        case .Success(let value):
            handler(value.unwrap)
        default:
            return
        }
    }
    
    public func onFailure(@noescape handler: (Reason) -> ()) {
        switch self {
        case .Failure(let value):
            handler(value.unwrap)
        default:
            return
        }
    }
}

public func rawValues<T : RawRepresentable>(rawRepresentables: [T]) -> [T.RawValue] {
    var rawValues = Array<T.RawValue>()

    for rawRepresentable in rawRepresentables {
        rawValues.append(rawRepresentable.rawValue)
    }
    
    return rawValues
}
