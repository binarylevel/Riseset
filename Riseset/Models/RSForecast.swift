//
//  RSForecastItem.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 04/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import RealmSwift
import CoreLocation

class RSForecast: Object {

    dynamic var id = 0
    dynamic var locality:String?
    dynamic var administrativeArea:String?
    
    dynamic var owner: RSCurrentlyForecast?
    
    let dailyDataPoints = List<RSDataPoint>()
    
    convenience init(placemark:CLPlacemark, json:[String:AnyObject]) {
        self.init()
        
        self.locality = placemark.locality
        self.administrativeArea = placemark.administrativeArea
        
        //["precipIntensity": 0, "icon": wind, "time": 1452181911, "precipProbability": 0, "windSpeed": 20.19, "summary": Breezy, "apparentTemperature": 54.49, "dewPoint": 38.95, "cloudCover": 0.2, "humidity": 0.5600000000000001, "windBearing": 278, "temperature": 54.49, "ozone": 385.25, "pressure": 1000.57]
        if let currently = json["currently"] as? [String:AnyObject] {
            print("currently \(currently)")
            let current = RSTemperature(fahrenheitValue: currently["temperature"] as! Int)
            print(current.description)
            
            let currentlyForecast = RSCurrentlyForecast(json: currently)
            self.owner = currentlyForecast
        }
        
        if let daily = json["daily"] as? [String:AnyObject], data = daily["data"] as? [NSDictionary] {
            for item in data {
                let dataPoint = RSDataPoint(json: item)
                dailyDataPoints.append(dataPoint)
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

  
}
