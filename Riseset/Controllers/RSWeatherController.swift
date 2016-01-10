//
//  RSWeatherController.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 01/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import NSObject_Rx

class RSWeatherController: NSObject {

    let locationController = RSLocationController()
    let geocodeController = RSGeocodeController()
    
    var viewModel = RSForecastViewModel()
    
    override init() {
        super.init()
    }
    
    func updateActions() -> Observable<CLLocation> {
        return Observable.create {observer in
            self.locationController.requestAlwaysAuthorization()
                .debug("requestAuthorization")
                .subscribe { event in
                    
                    switch event {
                    case .Next(let authorized):
                      
                        //check if value is authorized here TODO
                        
                        self.locationController.runActions().subscribe { event in
                            switch event {
                                case .Next(let location):
                                    observer.onNext(location)
                                    self.geocodeController.reverseGeocodeLocation(location).debug("reverseGeocodeLocation").subscribeNext { [weak self] placemark in
                                    
                                    self?.viewModel.placemark = placemark
                                    
                                    }.addDisposableTo(self.rx_disposeBag)
                                    break
                                case .Completed:
                                    break
                            case .Error(let error):
                                    observer.onError(error)
                                    break
                                }
                            }.addDisposableTo(self.rx_disposeBag)
                        self.locationController.locationManager.startUpdatingLocation()
                        break
                    case .Completed:
                        break
                    case .Error(let error):
                        observer.onError(error)
                        break
                    }
                }.addDisposableTo(self.rx_disposeBag)
            return NopDisposable.instance
        }
    }
}
