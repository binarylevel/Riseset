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

    var locationName = PublishSubject<String?>()
    var forecastModel = PublishSubject<RSForecast>()
 
    let items = BehaviorSubject<[RSForecast]>(value: [])
    
    var currentTemperature:String {
        let temp = self.forecast?.currentTemperature
        return "\(temp!.fahrenheitValue)"
    }
        
    var forecast:RSForecast?// {
//        didSet {
//            updateViewModel()
//        }
//    }
    
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
                                print("completed")
                                self.updateViewModel()
//                                Realm.rx_objects(RSForecast)
//                                    .map { results -> [RSForecast] in
//                                        return results.map { $0 }
//                                    }
//                                    .bindNext { item in
//                                        //print("item \(item)")
//                                        self.items.on(.Next(item))
//                                       
//                                    }.addDisposableTo(self.rx_disposeBag)
                                
                            }.addDisposableTo(self.rx_disposeBag)
                        
                }.addDisposableTo(rx_disposeBag)
            }
        }
    }
    
    func updateViewModel() {
        
        if let locality = forecast?.locality, administrativeArea = forecast?.administrativeArea {
            locationName.on(.Next("\(locality), \(administrativeArea)"))
        }
        
        if let f = forecast {
             forecastModel.on(.Next(f))
        }
        
        Realm.rx_objects(RSForecast)
            .map { results -> [RSForecast] in
                return results.map { $0 }
            }
            .bindNext { item in
                print("testrrrrrrrrrrrrrrrr \(item)")
                self.items.on(.Next(item))
                
            }.addDisposableTo(self.rx_disposeBag)
    }
}
