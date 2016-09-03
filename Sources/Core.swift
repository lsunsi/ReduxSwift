//
//  Core.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

public protocol ActionType {}
public struct Middlewares<State> {}
public typealias Dispatcher = ActionType -> ActionType
struct INIT: ActionType {}

public class Store<State> {
    public typealias Reducer = (ActionType, State?) -> State
    public typealias Middleware = (Store<State>, Dispatcher) -> Dispatcher

    public var state: State
    public var dispatch: Dispatcher!

    public init(reducer: Reducer, state: State?, middlewares: [Middleware]) {
        self.state = state ?? reducer(INIT(), nil)
        self.dispatch = middlewares.reduce({action in
            self.state = reducer(action, self.state)
            return action
        }) {$1(self, $0)}
    }
}
