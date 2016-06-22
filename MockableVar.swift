//
//  MockableVar.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/12/16.
//

import Foundation

public protocol MockableVar {
    /// Number of gets
    var getCount: Int { get }
    /// Number of sets
    var setCount: Int { get }
    /// Whether any get has been recorded
    var anyGet: Bool { get }
    /// Whether any set has been recorded
    var anySet: Bool { get }
    /// Resets the get tracker
    func resetTrackedGet()
    /// Resets the set tracker
    func resetTrackedSet()
    /// Resets both the get and set trackers
    func resetTracked()
}

public extension MockableVar where Self: MockableVarWithType {
    /// Number of gets
    var getCount: Int {
        return getActions.count
    }

    /// Number of sets
    var setCount: Int {
        return setActions.count
    }

    /// Whether any get has been recorded
    var anyGet: Bool {
        return !getActions.isEmpty
    }

    /// Whether any set has been recorded
    var anySet: Bool {
        return !setActions.isEmpty
    }

    /// Resets the get tracker
    func resetTrackedGet() {
        getActions.removeAll()
        trackedActions = setActions
    }

    /// Resets the set tracker
    func resetTrackedSet() {
        setActions.removeAll()
        trackedActions = getActions
    }

    /// Resets both the get and set trackers
    func resetTracked() {
        getActions.removeAll()
        setActions.removeAll()
        trackedActions.removeAll()
    }

    /**
     Returns the action at the given index

     - parameter index:
     - returns: action
    */
    func action(index: Int) -> MockVarAction<T> {
        return trackedActions[index]
    }

    /**
     Returns the get action at the given index

     - parameter index:
     - returns: action
    */
    func getAction(index: Int) -> MockVarAction<T> {
        return getActions[index]
    }

    /**
     Returns the set action at the given index

     - parameter index:
     - returns: aciton
    */
    func setAction(index: Int) -> MockVarAction<T> {
        return setActions[index]
    }

    /**
     - returns: an array of get actions
    */
    func allGetActions() -> [MockVarActionGet<T>] {
        return getActions
    }

    /**
     - returns: an array of set actions
    */
    func allSetActions() -> [MockVarActionSet<T>] {
        return setActions
    }

    /**
     - returns: an array of all actions
    */
    func allActions() -> [MockVarAction<T>] {
        return trackedActions
    }

    /**
     - returns: the most recent action
    */
    func mostRecentAction() -> MockVarAction<T>? {
        return trackedActions.last
    }

    /**
     - returns: the most recent get action
    */
    func mostRecentGetAction() -> MockVarActionGet<T>? {
        return getActions.last
    }

    /**
     - returns: the most recent set action
    */
    func mostRecentSetAction() -> MockVarActionSet<T>? {
        return setActions.last
    }

    /**
     - returns: the first action
    */
    func firstAction() -> MockVarAction<T>? {
        return trackedActions.first
    }

    /**
     - retunrs: the first get action
    */
    func firstGetAction() -> MockVarActionGet<T>? {
        return getActions.first
    }

    /**
     - returns: the first set action
    */
    func firstSetAction() -> MockVarActionSet<T>? {
        return setActions.first
    }
}