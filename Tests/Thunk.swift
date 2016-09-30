//
//  Thunk.swift
//  ReduxSwift
//
//  Created by Lucas Sunsi on 8/28/16.
//  Copyright © 2016 lsunsi. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxSwift

class ThunkTests: QuickSpec {
    override func spec() {
        describe("Thunk middleware") {
            it("should call thunk on dispatch") {
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [Middlewares.thunk]
                )

                var called = false
                _ = store.dispatch(THUNK<State>(thunk: {_ in called = true}))
                expect(called) == true
            }

            it("should pass store reference to thunk") {
                let store = Store<State>.init(
                    reducer: reducer,
                    state: nil,
                    middlewares: [Middlewares.thunk]
                )

                var equal = false
                _ = store.dispatch(THUNK<State>(thunk: {s in equal = s === store}))
                expect(equal) == true
            }
        }
    }
}
