//
//  Core.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

public protocol ActionType {}
public struct Middlewares<State> {}
public typealias Dispatcher = (ActionType) -> ActionType
struct INIT: ActionType {}

open class Store<State> {
    public typealias Reducer = (ActionType, State?) -> State

    open var state: State
    open var dispatch: ((ActionType) -> ActionType)!
    public typealias MiddleWare = (Store<State>, @escaping Dispatcher) -> Dispatcher

    public init(reducer: @escaping Reducer, state: State?, middlewares: [MiddleWare]) {
        self.state = state ?? reducer(INIT(), nil)
        self.dispatch = middlewares.reduce({action in
            self.state = reducer(action, self.state)
            return action
        }) {$1(self, $0)}
    }

}
