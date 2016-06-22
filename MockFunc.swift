//
//  MockFunc.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public struct MockFuncCall<Parameter, Return> {
    var parameters: Parameter
    var returned: Return
    let actionTime: NSDate = NSDate()
}


class MockFunc<Parameter, Return>: MockableFunc, MockableFuncWithType {
    typealias P = Parameter
    typealias R = Return
    var behavior: MockFuncBehavior<Parameter, Return>
    var trackedCalls: [MockFuncCall<Parameter, Return>] = []
    var callCount: Int {
        return trackedCalls.count
    }

    /**
     Creates a new MockFunc

     - parameter parameterType: List in an unnamed tuple, for example: `(Int, String, Bool).self`
     - parameter returnType: Return type for example: `Int.self`
     - parameter behavior:
     - returns:
     */
    init(
        parameterType: Parameter.Type, returnType: Return.Type,
        behavior: MockFuncBehavior<Parameter, Return>? = nil)
    {
        self.behavior = behavior ?? MockFuncBehavior.defaultBehavor
    }

    /**
     Performs the proper behavior given the super func and parameters

     - parameter superFunc:
     - parameter parameters:
     - returns: Return
    */
    func mockFunc(superFunc: Parameter throws -> Return, parameters: Parameter) rethrows -> Return {
        let returned = try performBehavior(behavior, superFunc: superFunc, parameters: parameters)
        trackCalls(behavior, parameters: parameters, returned: returned)
        return returned
    }

    /**
     Performs the proper behavior given the super func and parameters, and also possibly throws
    
     - parameter superFunc:
     - parameter parameters:
     - returns: Return
    */
    func mockThrowingFunc(superFunc: Parameter throws -> Return, parameters: Parameter) throws -> Return {
        let returned: Return
        switch behavior {
        case .Throws(let stub):
            returned =  try stub(parameters)
        default:
            returned = try performBehavior(behavior, superFunc: superFunc, parameters: parameters)
        }
        trackCalls(behavior, parameters: parameters, returned: returned)
        return returned
    }

    /**
     Updates the call counter, if recording is on

     - parameter behavior:
     - parameter parameters
    */
    private func trackCalls(behavior: MockFuncBehavior<Parameter, Return>, parameters: Parameter, returned: Return) {
        switch behavior {
        case .Repeats(let behavior, let times, let then):
            if times > 0 {
                trackCalls(behavior, parameters: parameters, returned: returned)
            } else {
                trackCalls(then, parameters: parameters, returned: returned)
            }
        case .Returns(_), .Spies, .SpiesAnd(_), .Stubs(_), .Throws(_):
            trackedCalls.append(MockFuncCall(parameters: parameters, returned: returned))
        default: break
        }
    }

    /**
     Perform behavior (possibly recursively)

     - parameter behavior:
     - parameter superFunc:
     - parameter parameters:
     - returns: Return
    */
    private func performBehavior(
        behavior: MockFuncBehavior<P, R>, superFunc: Parameter throws -> Return,
        parameters: Parameter) rethrows -> R
    {
        switch behavior {
        case .Repeats(let repeatBehavior, let times, let then):
            if times > 0 {
                self.behavior = MockFuncBehavior<P, R>.Repeats(behavior: repeatBehavior, times: times - 1, then: then)
                return try performBehavior(repeatBehavior, superFunc: superFunc, parameters: parameters)
            } else {
                self.behavior = then
                return try performBehavior(then, superFunc: superFunc, parameters: parameters)
            }
        case .SpiesAnd(let preProcess, let postProcess):
            var parameters = parameters
            if let preProcess = preProcess {
                parameters = preProcess(parameters)
            }
            var returnValue = try superFunc(parameters)
            if let postProcess = postProcess {
                returnValue = postProcess(returnValue)
            }
            return returnValue
        case .StopsTracking, .Spies, .Throws(_):
            return try superFunc(parameters)
        case .Stubs(let stub):
            return stub(parameters)
        case .Returns(let value):
            return value
        }
    }

    deinit {
        // In case our behavior stores a reference to self
        behavior = .Spies
    }
}

extension MockableFuncWithType where Self.P == Void {
    /**
     Performs the proper behavior given the super func and parameters

     - parameter superFunc:
     - parameter parameters:
     - returns: Return
     */
    func mockFunc(superFunc: Void throws -> R) rethrows -> R {
        return try mockFunc(superFunc, parameters: ())
    }

    /**
     Performs the proper behavior given the super func and parameters, and also possibly throws

     - parameter superFunc:
     - parameter parameters:
     - returns: Return
     */
    func mockThrowingFunc(superFunc: Void throws -> R) throws -> R {
        return try mockThrowingFunc(superFunc, parameters: ())
    }
}
