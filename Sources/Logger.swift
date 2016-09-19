//
//  Logger.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

public extension Middlewares {
    public static func logger(store: Store<State>, yield: @escaping Dispatcher) -> Dispatcher {
        return {action in
            let s = store.state
            let a = yield(action)
            print("↓ (\(action) \(s)) → (\(a) \(store.state)) ↑")
            return a
        }
    }
}
