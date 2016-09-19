//
//  Subscriptions.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

open class Subscriptions<State, Key: Hashable> {
    public typealias Callback = (State) -> ()

    var values: [Key: Callback]
    var store: Store<State>!

    public init() {
        self.values = [:]
        self.store = nil
    }

    open func middleware(store: Store<State>, yield: @escaping Dispatcher) -> Dispatcher {
        self.store = store
        return {action in
            _ = yield(action)
            self.values.forEach {$1(store.state)}
            return action
        }
    }

    open func subscribe(key: Key, callback: @escaping Callback) {
        values[key] = callback
        callback(store.state)
    }

    open func unsubscribe(key: Key) {
        values[key] = nil
    }
}
