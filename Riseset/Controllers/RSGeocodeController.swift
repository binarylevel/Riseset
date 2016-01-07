//
//  RSGeocodeController.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 30/12/15.
//  Copyright © 2015 Spiros Gerokostas. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

final class RSGeocodeController: NSObject {

    private let geocoder = CLGeocoder()
    
    internal func reverseGeocodeLocation(location:CLLocation) -> Observable<CLPlacemark> {
        return Observable.create {observer in
            self.geocoder.reverseGeocodeLocation(location) {
                placemarks, error in
                if error != nil {
                    observer.onError(error!)
                }
                if let placemark = placemarks?.first {
                    observer.onNext(placemark)
                    observer.onCompleted()
                }
            }
            return NopDisposable.instance
        }
    }
}

