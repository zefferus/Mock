//
//  MockVarBehavior.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public indirect enum MockVarBehavior<Type> {
    /// Stop tracking the calls and just passes through to super
    case StopsTracking
    /// Tracks and passes through to super
    case Spies
    /// Calls a stub rather than the super method
    case Stubs(get: (() -> Type)?, set: ((Type) -> Void)?)
    /// Repeats the given behavior the number of times and then switches to another behavior
    case Repeats(behavior: MockVarBehavior<Type>, times: Int, then: MockVarBehavior<Type>)
    /// Swallows assignments and always returns a value
    case Returns(Type)
    /// Proxies gets and sets to another variable
    case Proxy(MockVarProxy<Type>)
    /// Defines the default behavior
    static var defaultBehavor: MockVarBehavior {
        return .Spies
    }
}
