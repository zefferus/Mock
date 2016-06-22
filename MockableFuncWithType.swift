//
//  MockableFuncWithType.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public protocol MockableFuncWithType: class {
    associatedtype P
    associatedtype R
    var behavior: MockFuncBehavior<P, R> { get set }
    /// Calls to the mock that are recorded are stored in this array
    var trackedCalls: [MockFuncCall<P, R>] { get set }
    func mockFunc(superFunc: P throws -> R, parameters: P) rethrows -> R
    func mockThrowingFunc(superFunc: P throws -> R, parameters: P) throws -> R
}

extension MockableFuncWithType where P: Equatable {
    /**
     Checks if any calls match the given parameters

     - parameter parameters:
     */
    func wasCalledWith(parameters: P) -> Bool {
        for trackedCall in trackedCalls {
            if trackedCall.parameters == parameters {
                return true
            }
        }
        return false
    }
}

extension MockableFuncWithType {
    /**
     Repeats a behavior a number of times and then switches to a different behavior

     - parameter behavior:
     - parameter times:
     - parameter then:
    */
    func repeats(behavior: MockFuncBehavior<P, R>, times: Int, then: MockFuncBehavior<P, R>) {
        self.behavior = .Repeats(behavior: behavior, times: times, then: then)
    }

    /**
     Returns a value every time the function is called

     - parameter value:
    */
    func returns(value: R) {
        behavior = .Returns(value)
    }

    /**
     Calls a throwing stub instead of the super method every time the function is called
     
     - Note: only use this method if you intend to throw
     - Note: this will only work if you used `mockThrowingFunc` in the mock.  Otherwise, it can't be used

     - parameter stub:
    */
    func throwing(stub: (P throws -> R)) {
        behavior = .Throws(stub: stub)
    }

    /**
     Calls a stub instead of the super method every time the function is called

     - parameter stub:
    */
    func stubs(stub: (P -> R)) {
        behavior = .Stubs(stub: stub)
    }

    /**
     Records calls and passes through to the super method.  Also optionally
     calls pre and post processing callbacks

     - parameter preRocess:
     - parameter postProcess:
    */
    func spies(preProcess: (P -> P)? = nil, postProcess: (R -> R)? = nil) {
        guard preProcess == nil && postProcess ==  nil else {
            behavior = .SpiesAnd(preProcess: preProcess, postProcess: postProcess)
            return
        }
        behavior = .Spies
    }

    /**
     Stops tracking and passes through to super method
    */
    func stopsTracking() {
        behavior = .StopsTracking
    }
}
