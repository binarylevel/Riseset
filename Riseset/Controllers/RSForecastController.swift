//
//  RSForecastController.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 30/12/15.
//  Copyright © 2015 Spiros Gerokostas. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import RxSwift

class RSForecastController: NSObject {

    func getWeatherForPlacemark(placemark:CLPlacemark)->Observable<AnyObject> {
         return Observable.create {observer in
            Alamofire.request(.GET, "\(FORECAST_API_URL)/\(FORECAST_API_KEY)/\(placemark.location!.coordinate.latitude),\(placemark.location!.coordinate.longitude)", parameters: nil).response(responseSerializer: Alamofire.Request.JSONResponseSerializer()) { response in
                switch response.result {
                    case .Success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                        break
                    case .Failure(let error):
                        observer.onError(error)
                        break
                    }
                }
            return NopDisposable.instance
        }
    }
}