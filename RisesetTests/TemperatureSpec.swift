//
//  TemperatureSpec.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 07/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Expecta

@testable import Riseset
class TemperatureSpec: QuickSpec {

    override func spec() {
        describe("Temperature") {
        
            context("Conversion to celsius should return correct values") {
                it("should convert 75 to 24") {
                    expect(RSTemperature(fahrenheitValue: 75).celsiusValue).to(equal(24))
                }
                
                it("should convert 50 to 10") {
                    expect(RSTemperature(fahrenheitValue: 50).celsiusValue).to(equal(10))
                }
            }
        }
    }
}
