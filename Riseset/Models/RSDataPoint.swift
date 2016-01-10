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

    dynamic var day:String = ""
    dynamic var summary:String = ""
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
    dynamic var precipIntensityMaxTime:Double = 0
    dynamic var precipType:String = ""
    dynamic var precipAccumulation:Double = 0
    dynamic var pressure:Double = 0
    dynamic var sunriseTime:Double = 0
    dynamic var sunsetTime:Double = 0
    dynamic var temperature:Double = 0
    dynamic var temperatureMax:Double = 0
    dynamic var temperatureMaxTime:Double = 0
    dynamic var temperatureMin:Double = 0
    dynamic var temperatureMinTime:Double = 0
    dynamic var time:Double = 0
    dynamic var windSpeed:Double = 0
    dynamic var visibility:Double = 0
    dynamic var windBearing:Double = 0
    
    var currentTemperature:RSTemperature {
        let currentTemperature = RSTemperature(fahrenheitValue: Int(self.temperature))
        return currentTemperature
    }
    
    var currentTime:String {
        
        let date = NSDate(timeIntervalSince1970: time)
            
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "HH:mm a"
        
        return dateFormatter.stringFromDate(date)
    }
    
    convenience init(json:NSDictionary) {
        self.init()
        
        if let time = json["time"] {
            
            let date = NSDate(timeIntervalSince1970: (time as? Double)!)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "ccc"
            
            let day = dateFormatter.stringFromDate(date)
            
            self.day = day
        }
    
        if let summary = json["summary"] {
            self.summary = summary as! String
        }
        
        if let apparentTemperatureMax = json["apparentTemperatureMax"] {
            self.apparentTemperatureMax = apparentTemperatureMax as! Double
        }
        
        if let apparentTemperatureMin = json["apparentTemperatureMin"] {
            self.apparentTemperatureMin = apparentTemperatureMin as! Double
        }
        
        if let apparentTemperatureMaxTime = json["apparentTemperatureMaxTime"] {
            self.apparentTemperatureMaxTime = apparentTemperatureMaxTime as! Double
        }
        
        if let apparentTemperatureMinTime = json["apparentTemperatureMinTime"] {
            self.apparentTemperatureMinTime = apparentTemperatureMinTime as! Double
        }
        
        if let cloudCover = json["cloudCover"] {
           self.cloudCover = cloudCover as! Double
        }
        
        if let dewPoint = json["dewPoint"] {
            self.dewPoint = dewPoint as! Double
        }

        if let humidity = json["humidity"] {
            self.humidity = humidity as! Double
        }
        
        if let icon = json["icon"] {
            self.icon = icon as! String
        }
        
        if let moonPhase = json["moonPhase"] {
            self.moonPhase = moonPhase as! Double
        }
        
        if let ozone = json["ozone"] {
            self.ozone = ozone as! Double
        }
        
        if let precipIntensity = json["precipIntensity"] {
          self.precipIntensity = precipIntensity as! Double
        }
        
        if let precipIntensityMax = json["precipIntensityMax"] {
            self.precipIntensityMax = precipIntensityMax as! Double
        }
        
        if let precipProbability = json["precipProbability"] {
            self.precipProbability = precipProbability as! Double
        }
        
        if let pressure = json["pressure"] {
            self.pressure = pressure as! Double
        }
        
        if let sunriseTime = json["sunriseTime"]  {
            self.sunriseTime = sunriseTime as! Double
        }
        
        if let sunsetTime = json["sunsetTime"] {
            self.sunsetTime = sunsetTime as! Double
        }
        
        if let temperatureMax = json["temperatureMax"] {
             self.temperatureMax = temperatureMax as! Double
        }
        
        if let temperatureMaxTime = json["temperatureMaxTime"] {
            self.temperatureMaxTime = temperatureMaxTime as! Double
        }
        
        if let temperatureMin = json["temperatureMin"] {
             self.temperatureMin = temperatureMin as! Double
        }
        
        if let temperatureMinTime = json["temperatureMinTime"] {
            self.temperatureMinTime = temperatureMinTime as! Double
        }
        
        if let temperature = json["temperature"] {
            self.temperature = temperature as! Double
        }
        
        if let time = json["time"] {
            self.time = time as! Double
        }
        
        if let windSpeed = json["windSpeed"] {
            self.windSpeed = windSpeed as! Double
        }
        
        if let visibility = json["visibility"] {
            self.visibility = visibility as! Double
        }
        
        if let precipIntensityMaxTime = json["precipIntensityMaxTime"] {
            self.precipIntensityMaxTime = precipIntensityMaxTime as! Double
        }
        
        if let precipType = json["precipType"] {
            self.precipType = precipType as! String
        }
        
        if let precipAccumulation = json["precipAccumulation"] {
            self.precipAccumulation = precipAccumulation as! Double
        }
        
        if let windBearing = json["windBearing"] {
          self.windBearing = windBearing as! Double
        }
    }
}
