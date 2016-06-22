//
//  MockFuncFactory.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public class MockFuncFactory {
    /**
     Creates a new MockFunc

     - parameter parameterType: List in an unnamed tuple, for example: `(Int, String, Bool).self`
     - parameter returnType: Return type for example: `Int.self`
     - parameter behavior:
     - returns:
    */
    class func create<Parameter, Return>(
        parameterType parameterType: Parameter.Type, returnType: Return.Type,
                      behavior: MockFuncBehavior<Parameter, Return>? = nil) -> MockFunc<Parameter, Return>
    {
        return MockFunc(parameterType: parameterType, returnType: returnType, behavior: behavior)
    }

    /**
     Creates a new MockFunc with no parameters

     - parameter returnType: Return type for example: `Int.self`
     - parameter behavior:
     - returns:
     */
    class func create<Return>(
        returnType returnType: Return.Type,
                   behavior: MockFuncBehavior<Void, Return>? = nil) -> MockFunc<Void, Return>
    {
        return MockFunc(parameterType: Void.self, returnType: returnType, behavior: behavior)
    }

    /**
     Creates a new MockFunc with no return

     - parameter parameterType: List in an unnamed tuple, for example: `(Int, String, Bool).self`
     - parameter behavior:
     - returns:
     */
    class func create<Parameter>(
        parameterType parameterType: Parameter.Type,
                      behavior: MockFuncBehavior<Parameter, Void>? = nil) -> MockFunc<Parameter, Void>
    {
        return MockFunc(parameterType: parameterType, returnType: Void.self, behavior: behavior)
    }

    /**
     Creates a new MockFunc with no return

     - parameter behavior:
     - returns:
     */
    class func create(behavior behavior: MockFuncBehavior<Void, Void>? = nil) -> MockFunc<Void, Void> {
        return MockFunc(parameterType: Void.self, returnType: Void.self, behavior: behavior)
    }
}
