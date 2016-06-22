//
//  MockableVarWithType.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/12/16.
//

import Foundation

public protocol MockableVarWithType: class {
    associatedtype T
    /// Both get and set actions on the mock
    var trackedActions: [MockVarAction<T>] { get set }
    /// Get actions on the mock
    var getActions: [MockVarActionGet<T>] { get set }
    /// Set actions on the mock
    var setActions: [MockVarActionSet<T>] { get set }
}

extension MockableVarWithType where T: Equatable {
    /**
     Returns true if the Mock has ever been assigned the value

     - parameter value:
    */
    func wasSetTo(value: T) -> Bool {
        for action in trackedActions {
            switch action.actionType {
            case .Set(let action):
                if value == action.value {
                    return true
                }
            default: break
            }
        }
        return false
    }
}
