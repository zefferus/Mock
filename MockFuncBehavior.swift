//
//  MockSupport.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public indirect enum MockFuncBehavior<Parameter, Return> {
    /// Stop tracking the calls and just passes through to super
    case StopsTracking
    /// Tracks and passes through to super
    case Spies
    /// Tracks and calls the callbacks on parameters and return values
    case SpiesAnd(preProcess: (Parameter -> Parameter)?, postProcess: (Return -> Return)?)
    /// Throws if using the mockThrowingFunc method, else spies
    case Throws(stub: (Parameter throws -> Return))
    /// Calls a stub rather than the super method
    case Stubs(stub: (Parameter -> Return))
    /// Repeats the given behavior the number of times and then switches to another behavior
    case Repeats(behavior: MockFuncBehavior<Parameter, Return>, times: Int, then: MockFuncBehavior<Parameter, Return>)
    /// Returns a value
    case Returns(Return)
    /// Defines the default behavior
    static var defaultBehavor: MockFuncBehavior {
        return .Spies
    }
}
