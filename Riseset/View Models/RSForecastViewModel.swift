//
//  RSForecastViewModel.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 30/12/15.
//  Copyright © 2015 Spiros Gerokostas. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RealmSwift

class RSForecastViewModel : NSObject  {
    
    let forecastController = RSForecastController()

     var publishHumidity = PublishSubject<String?>()
    var publishTime = PublishSubject<String?>()
    var locationName = PublishSubject<String?>()
    var forecastModel = PublishSubject<RSForecast>()
 
    let items = BehaviorSubject<[RSForecast]>(value: [])
    
    var currentTemperature:String {
        let temp = self.forecast?.currently?.currentTemperature
        return "\(temp!.fahrenheitValue)"
    }
    
    var currentHumidity:String {
        return "\((self.forecast?.currently?.humidity)!*100)%"
    }
    
    var time:String {
        
        if let forecastTime = self.forecast?.time {
            
            let date = NSDate(timeIntervalSince1970: forecastTime)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.dateFormat = "HH:mm a"
            return dateFormatter.stringFromDate(date)
        }
        return ""
    }
        
    var forecast:RSForecast?
    
    var placemark:CLPlacemark? {
        didSet {
            if let value = placemark {
                forecastController.getWeatherForPlacemark(value)
                    .observeOn(MainScheduler.instance)
                    .debug("getWeatherForPlacemark")
                    .subscribeNext { jsonObject in

                        self.forecast = RSForecast(placemark: value, json: jsonObject as! [String : AnyObject])
                        
                        Realm.rx_add([self.forecast!], update: true, thread: Realm.RealmThread.MainThread)
                            .subscribeCompleted { _ in
                                
                                self.updateViewModel()
                                
                            }.addDisposableTo(self.rx_disposeBag)
                        
                }.addDisposableTo(rx_disposeBag)
            }
        }
    }
    
    func updateViewModel() {
        
        if let locality = forecast?.locality, administrativeArea = forecast?.administrativeArea {
            locationName.on(.Next("\(locality), \(administrativeArea)"))
        }
        
        if let forecast = forecast {
            forecastModel.on(.Next(forecast))
            publishHumidity.on(.Next(currentHumidity))
            publishTime.on(.Next(time))
        }
            
        Realm.rx_objects(RSForecast)
            .map { results -> [RSForecast] in
                return results.map { $0 }
            }
            .bindNext { item in
                
                self.items.on(.Next(item))
                
            }.addDisposableTo(self.rx_disposeBag)
    }
}
