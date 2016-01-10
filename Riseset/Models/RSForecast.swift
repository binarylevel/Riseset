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
    
    dynamic var latitude:Double = 0
    
    dynamic var currently: RSDataPoint?
    
    dynamic var hourly:RSDataBlock?
    dynamic var daily:RSDataBlock?
    dynamic var minutely:RSDataBlock?
    
    convenience init(placemark:CLPlacemark, json:[String:AnyObject]) {
        self.init()
        
        self.locality = placemark.locality
        self.administrativeArea = placemark.administrativeArea
        
        self.latitude = json["latitude"] as!  Double
        
        //DataPoint
        
        if let currently = json["currently"] as? [String:AnyObject] {            
            let currentlyForecast = RSDataPoint(json: currently)
            self.currently = currentlyForecast
        }
        
        //DataBlocks
        
        if let daily = json["daily"] as? [String:AnyObject] {
            let dailyDataBlock = RSDataBlock(json: daily)
            self.daily = dailyDataBlock
        }
        
        if let minutely = json["minutely"] as? [String:AnyObject]  {
            let minutelyDataBlock = RSDataBlock(json: minutely)
            self.minutely = minutelyDataBlock
        }
        
        if let hourly = json["hourly"] as? [String:AnyObject] {
            let hourlyDataBlock = RSDataBlock(json: hourly)
            self.hourly = hourlyDataBlock
        }
    }
    

    var time:Double {
        return self.currently!.time
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

  
}
