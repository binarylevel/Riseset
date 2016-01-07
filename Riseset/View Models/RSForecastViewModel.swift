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

class RSForecastViewModel   {
    
    var disposeBag = DisposeBag()
    let forecastController = RSForecastController()

    var locationName = PublishSubject<String?>()
    var forecastModel = PublishSubject<RSForecast>()
    
    let items = BehaviorSubject<[RSForecast]>(value: [])
    
    var forecast:RSForecast? {
        didSet {
            updateViewModel()
        }
    }
        
    var placemark:CLPlacemark? {
        didSet {
            if let value = placemark {
                forecastController.getWeatherForPlacemark(value)
                    .debug("getWeatherForPlacemark")
                    .subscribeNext { jsonObject in

                        self.forecast = RSForecast(placemark: value, json: jsonObject as! [String : AnyObject])
                        
                        Realm.rx_add([self.forecast!], update: true, thread: Realm.RealmThread.MainThread)
                            .subscribeCompleted { _ in
                                print("completed")
                                
                                Realm.rx_objects(RSForecast)
                                    .map { results -> [RSForecast] in
                                        return results.map { $0 }
                                    }
                                    .bindNext { item in
                                        print("item \(item)")
                                        self.items.on(.Next(item))
                                       
                                    }.addDisposableTo(self.disposeBag)
                                
                            }.addDisposableTo(self.disposeBag)
                        
                }.addDisposableTo(disposeBag)
            }
        }
    }
    
    func updateViewModel() {
        
        //print("updateViewModel \(forecast)")
        
        if let locality = forecast?.locality, administrativeArea = forecast?.administrativeArea {
            locationName.on(.Next("\(locality), \(administrativeArea)"))
        }
        
//        Realm.rx_objects(RSForecast)
//            .map { results -> [RSForecast] in
//                return results.map { $0 }
//            }
//            .bindNext { item in
//                print("item \(item)")
//        
//                self.items.on(.Next(item))
//            }.addDisposableTo(disposeBag)
    }
}
