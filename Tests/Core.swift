//
//  Core.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxSwift

class CoreTests: QuickSpec {
    func initializing() {
        context("Initializing") {
            it("should provided state") {
                let state = State.init(counter: -1)
                let store = Store<State>.init(reducer: reducer, state: state, middlewares: [])

                expect(store.state.counter) == -1
            }

            it("should initialize the state otherwise") {
                let store = Store<State>.init(reducer: reducer, state: nil, middlewares: [])

                expect(store.state.counter) == 0
            }
        }
    }

    func updating() {
        context("Updating") {
            it("should reduce action into new state") {
                let store = Store<State>.init(reducer: reducer, state: nil, middlewares: [])

                expect(store.state.counter) == 0
                store.dispatch(INC())
                expect(store.state.counter) == 1
                store.dispatch(DEC())
                expect(store.state.counter) == 0
                store.dispatch(ADD(amount: 2))
                expect(store.state.counter) == 2
                store.dispatch(NOP())
                expect(store.state.counter) == 2
            }
        }

    }

    func extending() {
        context("Extending") {
            it("should allow middlewares") {
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [decOnIncMiddleware]
                )

                expect(store.state.counter) == 0
                store.dispatch(INC())
                expect(store.state.counter) == 0
            }

            it("should compose middlewares right->left") {
                let store1 = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [decOnIncMiddleware, incToAddMiddleware]
                )
                let store2 = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [incToAddMiddleware, decOnIncMiddleware]
                )

                expect(store1.state.counter) == 0
                expect(store2.state.counter) == 0
                store1.dispatch(INC())
                store2.dispatch(INC())
                expect(store1.state.counter) == 1
                expect(store2.state.counter) == 0
            }
        }
    }

    override func spec() {
        describe("Core functionality") {
            self.initializing()
            self.updating()
            self.extending()
        }
    }
}
