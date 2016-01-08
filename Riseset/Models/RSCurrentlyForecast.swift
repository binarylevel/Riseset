//
//  RSCurrentlyForecast.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 07/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import RealmSwift

class RSCurrentlyForecast: Object {

    dynamic var icon:String?
    dynamic var temperature:Int = 0
    
    var tmp: RSTemperature { // read-only properties are automatically ignored
        let temp = RSTemperature(fahrenheitValue: self.temperature)
        return temp
    }
    
    convenience init(json:[String:AnyObject]) {
        self.init()
        
        //["precipIntensity": 0, "icon": wind, "time": 1452181911, "precipProbability": 0, "windSpeed": 20.19, "summary": Breezy, "apparentTemperature": 54.49, "dewPoint": 38.95, "cloudCover": 0.2, "humidity": 0.5600000000000001, "windBearing": 278, "temperature": 54.49, "ozone": 385.25, "pressure": 1000.57]
        
        self.icon = json["icon"] as? String
        self.temperature = json["temperature"] as! Int
    }
}
