# ReduxSwift

ReduxSwift is a minimal Swift port of [Redux](https://github.com/reactjs/redux), a popular JavaScript library for application state management.

[![Swift version](https://img.shields.io/badge/Swift-2.2-brightgreen.svg?style=flat-square)](https://swift.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20tvOS%20macOS%20watchOS-lightgrey.svg?style=flat-square)](https://swift.org/)
[![Release](https://img.shields.io/badge/Release-1.0.0-blue.svg?style=flat-square)](https://github.com/lsunsi/ReduxSwift/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/lsunsi/ReduxSwift/blob/master/LICENSE)

###### Functionality
- Centralized State
- Unidirectional Data Flow
- Functional Reactive Programming

###### Implementation
- Type Safe
- Extensible
- Unobtrusive

## Getting Started

> "The whole state of your app is stored in an object tree inside a single store.
> The only way to change the state tree is to emit an action, an object describing what happened.
> To specify how the actions transform the state tree, you write pure reducers.
> That's it!" - Redux's Documentation

### Application State
The Application State is a container that stores all information needed for your app to render.
Since it's only a data container, it can be of any type from a single Int to a complex Struct.

```swift
struct AppState {
    struct Todo {
        let text: String
        var done: Bool
    }

    var todos: [Todo] = []
}
```

###### Tips
- Structs are recommended for complex state structures, since they guarantee the reducer can't modify the state directly
- State should be as minimal as possible, which means cheaply derivable data should be excluded from it

### Actions
Actions are structs that describe changes to be made to the Application State.
Since actions are the only way to change it, the action set represents all ways your app can change its own state.
The only requirement for your action types are that they follow the ActionType protocol.

```swift
struct ADD_TODO: ActionType {
    let text: String
}

struct DO_TODO: ActionType {
    let id: Int
}

struct CLEAN_DONE: ActionType {

}
```

###### Tips
- Although classes can be used to define Actions as well, little data containers like that benefit from the pass-by-value behavior offered by structs
- Actions should carry all information needed by the reducer to make the actual change (more on that next).

### Reducers
Reducers are pure functions that take an action and the current state (if any), and return a new state.
Reducers are required to initialize the state in case of absence and must always return a state instance.
Since these functions must be pure, all data needed for the change to be made have to be included in the action struct.

```swift
func reducer(action: ActionType, state: AppState?) -> AppState {
    var state = state ?? AppState.init()

    switch action {

    case let a as ADD_TODO:
        let todo = AppState.Todo(text: a.text, done: false)
        state.todos.append(todo)

    case let a as DO_TODO:
        state.todos[a.id].done = true

    case _ as CLEAN_DONE:
        let todos = state.todos.filter{!$0.done}
        state.todos = todos

    default: break
    }

    return state
}
```

###### Tips
- Reducers can be composed together, making it possible to modularize your state architecture
- Reducers cannot have side-effects, so if you need asynchronous action dispatching you might need to check out some middleware for it

### Fire it up
The State, Actions and Reducers come together in the Store creation.
It exposes the current state through the 'state' property and a single method 'dispatch' used for dispatching actions.

```swift
let store = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [])

// State.todos => []
store.dispatch(ADD_TODO(text: "Code some Swift!"))
// State.todos => [{text "Code some Swift!", done false}]
store.dispatch(ADD_TODO(text: "Code more Swift!"))
// State.todos => [{text "Code some Swift!", done false}, {text "Code more Swift!", done false}]
store.dispatch(DO_TODO(id: 0))
// State.todos => [{text "Code some Swift!", done true}, {text "Code more Swift!", done false}]
store.dispatch(CLEAN_DONE())
// State.todos => [{text "Code more Swift!", done false}]
```

###### Tips
- The Store can be initialized with a State, making it easy to save and restore it
- Middlewares can be used to enhance the Store functionality (more on that next)

## Going deeper

You just learned about the core concepts of the Redux architecture.
Next we'll talk about two middlewares included in this framework that extend the store functionality to help you integrate it in your application.

### Subscriptions
Everything we learned until now would be pointless if you didn't have a way to get notified about state changes whenever they happen.
This middleware lets you do that in a cool reactive programming way.

```swift
let subs = Subscriptions<AppState, Int>.init()
let subsStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [subs.middleware])

subs.subscribe(key: 1) {state in
    print("state changed!")
}

subs.unsubscribe(key: 1)
```

###### Tips
- Your subscriber id can be of whatever Hashable type, as long as you identify it as the second generic parameter (Int in the previous example)
- Did you know UIView's are Hashable?

### Thunk
This is a basic middleware that enables asynchronous dispatching.
It works alongside an action type called THUNK, that takes a function that takes the Store as it's first parameter.
That way you can dispatch an function that will be responsible for dispatching other actions.

```swift
let thunk = Middlewares<AppState>.thunk
let thunkStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [thunk])

thunkStore.dispatch(THUNK<AppState>{store in
    _ = store.dispatch(CLEAR_DONE())
})
```

###### Tips
- Your thunk function can use the store reference however they want, including through in background routines
- Thunks are just a basic way of inverting the control flow of the Store. For complex asynchronous workflows you might need to check elsewhere.

### Logger
This middleware is a developer helper that logs action and state in down and up stream through the middleware chain.
That means it will print to console all actions dispatched and the states before and after they were reduced.

```swift
let logger = Middlewares<AppState>.logger
let loggedStore = Store<AppState>.init(reducer: reducer, state: nil, middlewares: [logger])

```

## Installation

### Carthage

```
github "lsunsi/ReduxSwift"
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Dan Abramov for bringing Redux to our lives
