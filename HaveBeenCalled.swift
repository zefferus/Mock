//
//  HaveBeenCalled.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation
import Nimble

public enum CountingQualifier {
    case Once
    case Twice
    case Exactly(Int)
    case AtMost(Int)
    case LessThan(Int)
    case GreaterThan(Int)
    case AtLeast(Int)
    var time: CountingQualifier {
        return self
    }
    var times: CountingQualifier {
        return self
    }
    var failureExpectation: String {
        switch self {
        case .Once:
            return "once"
        case .Twice:
            return "twice"
        case .Exactly(let count):
            return "exactly \(count) times"
        case .LessThan(let count):
            return "less than \(count) times"
        case .AtMost(let count):
            return "at most \(count) times"
        case .GreaterThan(let count):
            return "greater than \(count) times"
        case .AtLeast(let count):
            return "at least \(count) times"
        }
    }
    func doesMatch(count: Int) -> Bool {
        switch self {
        case .Once:
            return count == 1
        case .Twice:
            return count == 2
        case .Exactly(let expectedCount):
            return count == expectedCount
        case .LessThan(let expectedCount):
            return count < expectedCount
        case .AtMost(let expectedCount):
            return count <= expectedCount
        case .GreaterThan(let expectedCount):
            return count > expectedCount
        case .AtLeast(let expectedCount):
            return count >= expectedCount
        }
    }
}

/**
 Nimble matcher for if a mockable func has been called at least once

 - returns: NonNilMatcherFunc
*/
public func haveBeenCalled(qualifier: CountingQualifier = CountingQualifier.AtLeast(0).times) -> NonNilMatcherFunc<MockableFunc> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        let callCount = try actualExpression.evaluate()?.callCount
        failureMessage.postfixMessage = "have been called " + qualifier.failureExpectation
        if let callCount = callCount {
            failureMessage.actualValue = "\(callCount)"
            failureMessage.postfixActual = " calls"
            return qualifier.doesMatch(callCount)
        } else {
            failureMessage.actualValue = "nil"
            failureMessage.postfixActual = " call count"
            return false
        }
    }
}

/**
 Nimble matcher for if a mockable func has been called with the arguments

 This only works with single parameters at the moment -- I think there's a compiler error with the tuples

 - parameter parameter:
 - returns:
*/
public func haveBeenCalledWith<P, MF where MF: MockableFuncWithType, MF.P == P, P: Equatable>(parameter: P) -> NonNilMatcherFunc<MF> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have been called with"
        failureMessage.actualValue = "no matching calls"
        let actualValue = try actualExpression.evaluate()
        return actualValue?.wasCalledWith(parameter) ?? false
    }
}

