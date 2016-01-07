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
    
    let dailyDataPoints = List<RSDataPoint>()
    
    convenience init(placemark:CLPlacemark, json:[String:AnyObject]) {
        self.init()
        
        self.locality = placemark.locality
        self.administrativeArea = placemark.administrativeArea
        
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
