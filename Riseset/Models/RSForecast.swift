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
    
    dynamic var currently: RSDataPoint?
    
    let dailyDataPoints = List<RSDataPoint>()
    
    convenience init(placemark:CLPlacemark, json:[String:AnyObject]) {
        self.init()
        
        self.locality = placemark.locality
        self.administrativeArea = placemark.administrativeArea
        
        if let currently = json["currently"] as? [String:AnyObject] {
            //print("currently \(currently)")
            let current = RSTemperature(fahrenheitValue: currently["temperature"] as! Int)
            print(current.description)
            
            let currentlyForecast = RSDataPoint(json: currently)
            self.currently = currentlyForecast
        }
        
        if let daily = json["daily"] as? [String:AnyObject], data = daily["data"] as? [NSDictionary] {
            for item in data {
                let dataPoint = RSDataPoint(json: item)
                dailyDataPoints.append(dataPoint)
            }
        }
    }
    
    var currentTemperature:RSTemperature {
        let temp = self.currently?.temperature
        let currentTemperature = RSTemperature(fahrenheitValue: Int(temp!))
        return currentTemperature
    }
    
    var time:Double {
        return self.currently!.time
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

  
}
