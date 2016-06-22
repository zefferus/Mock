//
//  MockVarAction.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/12/16.
//

import Foundation

public enum MockVarActionType<Type> {
    /// Null action
    case None
    /// Get action
    case Get(MockVarActionGet<Type>)
    /// Set action
    case Set(MockVarActionSet<Type>)
}

public class MockVarAction<Type> {
    let value: Type
    var actionType: MockVarActionType<Type> = .None
    let actionTime: NSDate = NSDate()

    /**
     Private init for base MockVarAction
    */
    private init(value: Type) {
        self.value = value
    }
}

public class MockVarActionSet<Type>: MockVarAction<Type> {
    /**
     Creates a new set action

     - parameter value:
    */
    override init(value: Type) {
        super.init(value: value)
        self.actionType = .Set(self)
    }
}

public class MockVarActionGet<Type>: MockVarAction<Type> {
    /**
     Creates a new get action

     - parameter value:
    */
    override init(value: Type) {
        super.init(value: value)
        self.actionType = .Get(self)
    }
}
