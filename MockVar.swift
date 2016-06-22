//
//  MockVar.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/11/16.
//

import Foundation

public class MockVar<Type>: MockableVarWithType, MockableVar {
    var behavior: MockVarBehavior<Type>
    public var trackedActions: [MockVarAction<Type>] = []
    public var getActions: [MockVarActionGet<Type>] = []
    public var setActions: [MockVarActionSet<Type>] = []
    var actionCount: Int {
        return trackedActions.count
    }

    /**
     Creates a new mock variable

     - parameter varType:
     - parameter behavior:
    */
    init(
        varType: Type.Type,
        behavior: MockVarBehavior<Type>? = nil)
    {
        self.behavior = behavior ?? MockVarBehavior.defaultBehavor
    }

    /**
     Mocks out a get call on a var

     - parameter superVar:
     - returns: Type
    */
    func mockGet(superVar: Type) -> Type {
        let value = performGetBehavior(behavior, superVar: superVar)
        trackActions(behavior, action: MockVarActionGet(value: value))
        return value
    }

    /**
     Mocks out a set call on a var

     - parameter superVar:
     - returns: Type
    */
    func mockSet(inout superVar: Type, newValue: Type) {
        trackActions(behavior, action: MockVarActionSet(value: newValue))
        performSetBehavior(behavior, superVar: &superVar, newValue: newValue)
    }

    /**
     Helper functin to add actions to tracking arrays

     - parameter behavior:
     - parameter action:
    */
    private func trackActions(behavior: MockVarBehavior<Type>, action: MockVarAction<Type>) {
        switch behavior {
        case .Repeats(let behavior, let times, let then):
            if times > 0 {
                trackActions(behavior, action: action)
            } else {
                trackActions(then, action: action)
            }
        case .Proxy(_), .Returns(_), .Spies, .Stubs(_):
            switch action.actionType {
            case .Get(let action):
                getActions.append(action)
            case .Set(let action):
                setActions.append(action)
            default: break
            }
            trackedActions.append(action)
        default: break
        }
    }

    /**
     Helper function to perform get behavior

     - parameter behavior:
     - parameter superVar:
    */
    private func performGetBehavior(
        behavior: MockVarBehavior<Type>,
        superVar: Type) -> Type
    {
        switch behavior {
        case .Repeats(let repeatBehavior, let times, let then):
            if times > 0 {
                self.behavior = .Repeats(behavior: repeatBehavior, times: times - 1, then: then)
                return performGetBehavior(repeatBehavior, superVar: superVar)
            } else {
                self.behavior = then
                return performGetBehavior(then, superVar: superVar)
            }
        case .Spies, .StopsTracking:
            return superVar
        case .Stubs(let get, _):
            guard let get = get else {
                return superVar
            }
            return get()
        case .Proxy(let proxy):
            return proxy.value
        case .Returns(let value):
            return value
        }
    }

    /**
     Helper to perform set behavior

     - parameter behavior:
     - parameter superVar:
    */
    private func performSetBehavior(
        behavior: MockVarBehavior<Type>,
        inout superVar: Type, newValue: Type)
    {
        switch behavior {
        case .Repeats(let repeatBehavior, let times, let then):
            if times > 0 {
                self.behavior = .Repeats(behavior: repeatBehavior, times: times - 1, then: then)
                performSetBehavior(repeatBehavior, superVar: &superVar, newValue: newValue)
            } else {
                self.behavior = then
                performSetBehavior(then, superVar: &superVar, newValue: newValue)
            }
        case .Spies, .StopsTracking:
            superVar = newValue
        case .Stubs(_, let set):
            guard let set = set else {
                superVar = newValue
                return
            }
            set(newValue)
        case .Proxy(let proxy):
            proxy.value = newValue
        case .Returns(_):
            break
        }
    }

    /**
     Sets the behavior to stop tracking the calls and pass through to super
    */
    func stopsTracking() {
        behavior = .StopsTracking
    }

    /**
     Sets the behavior to set through to super and track the calls
    */
    func spies() {
        behavior = .Spies
    }

    /**
     Uses the get and set callbacks rather than the super variable.

     - parameter get: If nil, spies
     - parameter set: If nil, spies
    */
    func stubs(get: (() -> Type)? = nil, set: ((Type) -> Void)? = nil) {
        behavior = .Stubs(get: get, set: set)
    }

    /**
     Repeats the behavior a number of times and then switches to the other behavior

     - parameter behavior:
     - parameter times:
     - parameter then:
    */
    func repeats(behavior: MockVarBehavior<Type>, times: Int, then: MockVarBehavior<Type>) {
        guard times > 0 else {
            self.behavior = then
            return
        }
        self.behavior = .Repeats(behavior: behavior, times: times, then: then)
    }

    /**
     Returns the value whenever the get is called and swallows sets

     - parameter value:
    */
    func returns(value: Type) {
        behavior = .Returns(value)
    }

    /**
     Proxies the get and set to a MockVarProxy

     - parameter proxy:
    */
    func proxies(proxy: MockVarProxy<Type>) {
        behavior = .Proxy(proxy)
    }

    deinit {
        // In case our behavior stores a reference to self
        behavior = .Spies
    }
}

