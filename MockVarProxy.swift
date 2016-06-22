//
//  MockVarProxy.swift
//  Wing
//
//  Created by Tom Wilkinson on 5/12/16.
//

import Foundation

/// A class to proxy a mock var to another var
public class MockVarProxy<Type> {
    var value: Type

    /**
     Creates a new proxy to the variable
    */
    init(_ value: Type) {
        self.value = value
    }
}
