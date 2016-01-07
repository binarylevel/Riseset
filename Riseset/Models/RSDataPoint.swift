//
//  RSDataPoint.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 05/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import RealmSwift
import Foundation

class RSDataPoint: Object {

    dynamic var day:String?
    dynamic var summary:String?
    dynamic var apparentTemperatureMax:Double = 0
    dynamic var apparentTemperatureMin:Double = 0
    dynamic var apparentTemperatureMaxTime:Double = 0
    dynamic var apparentTemperatureMinTime:Double = 0
    dynamic var cloudCover:Double = 0
    dynamic var dewPoint:Double = 0
    dynamic var humidity:Double = 0
    dynamic var icon:String = ""
    dynamic var moonPhase:Double = 0
    dynamic var ozone:Double = 0
    dynamic var precipIntensity:Double = 0
    dynamic var precipIntensityMax:Double = 0
    dynamic var precipProbability:Double = 0
    dynamic var pressure:Double = 0
    dynamic var sunriseTime:Double = 0
    dynamic var sunsetTime:Double = 0
    dynamic var temperatureMax:Double = 0
    dynamic var temperatureMaxTime:Double = 0
    dynamic var temperatureMin:Double = 0
    dynamic var temperatureMinTime:Double = 0
    dynamic var time:Double = 0
    dynamic var windSpeed:Double = 0
    
    convenience init(json:NSDictionary) {
        self.init()
        
        let date = NSDate(timeIntervalSince1970: (json["time"] as? Double)!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ccc"
        
        let day = dateFormatter.stringFromDate(date)
        
        self.day = day
        self.summary = json["summary"] as? String
        self.apparentTemperatureMax = json["apparentTemperatureMax"] as! Double
        self.apparentTemperatureMin = json["apparentTemperatureMin"] as! Double
        self.apparentTemperatureMaxTime = json["apparentTemperatureMaxTime"] as! Double
        self.apparentTemperatureMinTime = json["apparentTemperatureMinTime"] as! Double
        self.cloudCover = json["cloudCover"] as! Double
        self.dewPoint = json["dewPoint"] as! Double
        self.humidity = json["humidity"] as! Double
        self.icon = json["icon"] as! String
        self.moonPhase = json["moonPhase"] as! Double
        self.ozone = json["ozone"] as! Double
        self.precipIntensity = json["precipIntensity"] as! Double
        self.precipIntensityMax = json["precipIntensityMax"] as! Double
        self.precipProbability = json["precipProbability"] as! Double
        self.pressure = json["pressure"] as! Double
        self.sunriseTime = json["sunriseTime"] as! Double
        self.sunsetTime = json["sunsetTime"] as! Double
        self.temperatureMax = json["temperatureMax"] as! Double
        self.temperatureMaxTime = json["temperatureMaxTime"] as! Double
        self.temperatureMin = json["temperatureMin"] as! Double
        self.temperatureMinTime = json["temperatureMinTime"] as! Double
        self.time = json["time"] as! Double
        self.windSpeed = json["windSpeed"] as! Double
    }
}
