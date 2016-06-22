//
//  HaveBeenSet.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/12/16.
//

import Foundation
import Nimble

/**
 Nimble matcher for if a mockable var has been set at least once

 - returns: NonNilMatcherFunc
 */
public func haveBeenSet(qualifier: CountingQualifier = CountingQualifier.AtLeast(0).times) -> NonNilMatcherFunc<MockableVar> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have been set " + qualifier.failureExpectation
        failureMessage.actualValue = "no set action"
        if let setCount = try actualExpression.evaluate()?.setCount {
            return qualifier.doesMatch(setCount)
        }
        return false
    }
}

/**
 Nimble matcher for if a mockable var has been get at least once

 - returns: NonNilMatcherFunc
 */
public func haveBeenGet(qualifier: CountingQualifier = CountingQualifier.AtLeast(0).times) -> NonNilMatcherFunc<MockableVar> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have been get " + qualifier.failureExpectation
        failureMessage.actualValue = "no set action"
        if let getCount = try actualExpression.evaluate()?.getCount {
            return qualifier.doesMatch(getCount)
        }
        return false
    }
}

/**
 Nimble matcher for if a mockable var has been set to the value

 - parameter value:
 - returns:
 */
public func haveBeenSetTo<T, MV where MV: MockableVarWithType, MV.T == T, T: Equatable>(value: T) -> NonNilMatcherFunc<MV> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have been called with"
        failureMessage.actualValue = "no matching calls"
        let actualValue = try actualExpression.evaluate()
        return actualValue?.wasSetTo(value) ?? false
    }
}