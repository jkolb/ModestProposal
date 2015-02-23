//
// Validator.swift
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

public class Validator {
    public struct Rule {
        let isValid: () -> Bool
        let invalid: () -> NSError
    }
    
    let rules: [Rule]
    
    public init(rules: [Rule]) {
        self.rules = rules
    }
    
    public func validate() -> NSError? {
        for rule in rules {
            if !rule.isValid() {
                return rule.invalid()
            }
        }
        
        return nil
    }
}

public class ValidatorBuilder {
    var rules = Array<Validator.Rule>()
    
    public func valid(@autoclosure(escaping) # when: () -> Bool, @autoclosure(escaping) otherwise: () -> NSError) {
        rules.append(Validator.Rule(isValid: when, invalid: otherwise))
    }
    
    public func build() -> Validator {
        return Validator(rules: rules)
    }
}
