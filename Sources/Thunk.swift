//
//  Thunk.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

public struct THUNK<State>: ActionType {
    public typealias Thunk = (Store<State>) -> ()
    public let thunk: Thunk
    public init(_ thunk: Thunk) {
        self.thunk = thunk
    }
}

public extension Middlewares {
    public static func thunk(store: Store<State>, yield: Dispatcher) -> Dispatcher {
        return {action in
            if let a = action as? THUNK<State> {
                a.thunk(store)
                return action
            }

            return yield(action)
        }
    }
}
