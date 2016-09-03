//: Playground - noun: a place where people can play

import ReduxSwift

struct AppState {
    struct Todo {
        let text: String
        var done: Bool
    }

    var todos: [Todo] = []
}

struct ADD_TODO: ActionType {
    let text: String
}

struct DO_TODO: ActionType {
    let id: Int
}

struct CLEAR_DONE: ActionType {}

func reducer(action: ActionType, state: AppState?) -> AppState {
    var state = state ?? AppState.init()
    
    switch action {

    case let a as ADD_TODO:
        let todo = AppState.Todo(text: a.text, done: false)
        state.todos.append(todo)
        
        
    case let a as DO_TODO:
        state.todos[a.id].done = true
    
    case _ as CLEAR_DONE:
        let todos = state.todos.filter{!$0.done}
        state.todos = todos
    
    default: break
    }
    
    return state
}

let store = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [])

store.state.todos
store.dispatch(ADD_TODO(text: "Code some Swift!"))
store.state.todos
store.dispatch(ADD_TODO(text: "Code more Swift!"))
store.state.todos
store.dispatch(DO_TODO(id: 0))
store.state.todos
store.dispatch(CLEAR_DONE())
store.state.todos

let logger = Middlewares<AppState>.logger
let loggedStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [logger])

store.state.todos
loggedStore.dispatch(ADD_TODO(text: "Hack some Swift!"))
store.state.todos

let thunk = Middlewares<AppState>.thunk
let thunkStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [thunk])

store.dispatch(THUNK<AppState>{store in
    store.dispatch(CLEAR_DONE())
})

let subs = Subscriptions<AppState, Int>.init()
let subsStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [subs.middleware])

subs.subscribe(1) {state in
    print("state changed!")
}

subs.unsubscribe(1)