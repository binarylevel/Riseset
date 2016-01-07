//
//  TestSpec.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 07/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Expecta

class TestSpec: QuickSpec {

    override func spec() {
        describe("the 'Documentation' directory") {
            it("has everything you need to get started") {
                expect("foo").to(equal("foo"))
            }
            
            context("if it doesn't have what you're looking for") {
                it("needs to be updated") {
                }
            }
        }
    }
}
