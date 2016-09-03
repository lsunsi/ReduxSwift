//
//  Subscriptions.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxSwift

class SubscriptionsTests: QuickSpec {
    override func spec() {
        describe("Subscriptions middleware") {
            it("should feed state on subscribe") {
                let subs = Subscriptions<State, Int>.init()
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [subs.middleware]
                )

                var state: State? = nil
                subs.subscribe(1) {state = $0}

                expect(state?.counter) == store.state.counter
            }

            it("should notify subscribers on state change") {
                let subs = Subscriptions<State, Int>.init()
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [subs.middleware]
                )

                var state1: State? = nil
                var state2: State? = nil
                subs.subscribe(1) {state1 = $0}
                subs.subscribe(2) {state2 = $0}

                store.dispatch(INC())

                expect(state1?.counter) == store.state.counter
                expect(state2?.counter) == store.state.counter
            }

            it("should allow unsubscribing") {
                let subs = Subscriptions<State, Int>.init()
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [subs.middleware]
                )

                var state: State? = nil
                subs.subscribe(1) {state = $0}
                subs.unsubscribe(1)
                store.dispatch(INC())

                expect(state?.counter) == store.state.counter - 1
            }
        }
    }
}
