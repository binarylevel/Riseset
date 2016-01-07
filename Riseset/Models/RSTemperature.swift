//
//  RSTemperature.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 07/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit

final class RSTemperature: NSObject {

    var fahrenheitValue:Int?
    
    lazy var celsiusValue:Int = {
        return Int(round(Float(self.fahrenheitValue! - 32) * 5.0 / 9.0))
    }()
    
    init(fahrenheitValue:Int) {
        self.fahrenheitValue = fahrenheitValue
    }
    
    override var description: String {
        return "Fahrenheit: \(fahrenheitValue!)°\nCelsius: \(celsiusValue)°"
    }
}
