//
//  RSApplicationController.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 01/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class RSApplicationController: NSObject {

    var rootViewController:UINavigationController?
    var disposeBag = DisposeBag()
    
    let weatherViewController = RSWeatherViewController()
    let weatherController = RSWeatherController()
    let locationController:RSLocationController = RSLocationController()
    
    override init() {
        super.init()
        
        rootViewController = UINavigationController(rootViewController: weatherViewController)
    }
    
    func performBackgroundFetch()-> Observable<CLLocation> {
        return weatherController.updateActions()
    }
    
    func setMinimumBackgroundFetchIntervalForApplication(application:UIApplication) {
        if locationController.authorizationStatusEqualTo(.AuthorizedAlways) {
            application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        } else {
            application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
        }
    }
}
