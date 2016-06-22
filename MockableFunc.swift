//
//  MockableFunc.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public protocol MockableFunc {
    /// The number of times the func has been called
    var callCount: Int { get }
    /// Whether the func was ever called
    var anyCall: Bool { get }
    /// Resets all the calls
    func resetCalls()
}

extension MockableFunc where Self: MockableFuncWithType {
    /// The number of times the func has been called
    var callCount: Int {
        return trackedCalls.count
    }

    /// Whether the func was ever called
    var anyCall: Bool {
        return !trackedCalls.isEmpty
    }

    /**
     Returns the tuple parameters for the call at index

     - parameter index:
     - returns: Parameter tuple
    */
    func getCall(index: Int) -> MockFuncCall<P, R> {
        return trackedCalls[index]
    }

    /**
     -returns: All parameter tuples recorded
    */
    func getAllCalls() -> [MockFuncCall<P, R>] {
        return trackedCalls
    }

    /**
     - returns: Most recent parameter tuple
    */
    func mostRecentCall() -> MockFuncCall<P, R>? {
        return trackedCalls.last
    }

    /**
     - returns: First parameter tuple call
    */
    func firstCall() -> MockFuncCall<P, R>? {
        return trackedCalls.first
    }

    /// Resets all the calls
    func resetCalls() {
        trackedCalls.removeAll()
    }
}
