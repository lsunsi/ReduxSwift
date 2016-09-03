//
//  Base.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

@testable import ReduxSwift

struct State {
    var counter: Int
}

struct NOP: ActionType {}
struct INC: ActionType {}
struct DEC: ActionType {}
struct ADD: ActionType {
    var amount: Int
}

func reducer(action: ActionType, state: State?) -> State {
    var state = state ?? State.init(counter: 0)
    switch action {
    case _ as INC:
        state.counter += 1
    case _ as DEC:
        state.counter -= 1
    case let a as ADD:
        state.counter += a.amount
    default: break
    }
    return state
}

func decOnIncMiddleware(store: Store<State>, yield: Dispatcher) -> Dispatcher {
    return {action in
        if action is INC {
            store.dispatch(DEC())
        }
        return yield(action)
    }
}

func incToAddMiddleware(store: Store<State>, yield: Dispatcher) -> Dispatcher {
    return {action in
        if action is INC {
            return yield(ADD(amount: 1))
        } else {
            return yield(action)
        }
    }
}
