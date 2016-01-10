//
//  RSLocationController.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 23/12/15.
//  Copyright © 2015 Spiros Gerokostas. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import NSObject_Rx

class RSLocationController: NSObject, CLLocationManagerDelegate {
    
    enum Action {
        case UpdateLocation
        case FailWithError
    }
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func requestAlwaysAuthorization() -> Observable<Bool> {
        if needsAuthorization() {
            locationManager.requestAlwaysAuthorization()
            return didAuthorize()
        } else {
            return authorized()
        }
    }
    
    private func authorized() -> Observable<Bool> {
        return Observable.create { observer in
            let authorized = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways
            if authorized {
                observer.onNext(authorized)
            } else {
                observer.onError(NSError(domain: "RxSwiftErrorDomain", code: 1, userInfo: nil))
            }
            return NopDisposable.instance
        }
    }
    
    private func needsAuthorization() -> Bool {
        return CLLocationManager.authorizationStatus() == .NotDetermined
    }

    private func didAuthorize() -> Observable<Bool> {
        return Observable.create { observer in
            self.locationManager.rx_didChangeAuthorizationStatus
                .take(1)
                .subscribe { status in
                    switch status {
                    case .Next(let status):
                        observer.onNext(status == .AuthorizedWhenInUse || status == .AuthorizedAlways)
                        break
                    case .Error(let error):
                        observer.onError(error)
                        break
                    default: break
                    }
            }.addDisposableTo(self.rx_disposeBag)
            
            return NopDisposable.instance
        }
    }

    func updateLocationAction()->Observable<CLLocation> {
        return self.locationManager
            .rx_didUpdateLocations
            .take(1)
            .map {
                $0.last!
            }
    }
    
    func failWithErrorAction()->Observable<NSError> {
        return self.locationManager
            .rx_didFailWithError
            .flatMap { Observable.error($0) }
    }
    
    func runActions() -> Observable <CLLocation> {
        return Observable.create {observer in
            
            let actions:[Observable<Action>] = [
                self.updateLocationAction().map { _ in .UpdateLocation },
                self.failWithErrorAction().map { _ in .FailWithError }
            ]
            
            actions
                .toObservable()
                .merge()
                .debugOnlyInDebugMode("runActions")
                .take(1)
                .subscribe { event in
                    switch event {
                        case .Next(let value):
                            if value == .UpdateLocation {
                                self.fetchCurrentLocation().subscribeNext { location in
                                    observer.onNext(location)
                                    observer.onCompleted()
                                }.addDisposableTo(self.rx_disposeBag)
                            }
                        break
                    case .Completed:
                        break
                    case .Error(let value):
                        observer.onError(value)
                        break
                    }
                }.addDisposableTo(self.rx_disposeBag)
            return NopDisposable.instance
        }
    }
    
    func fetchCurrentLocation()->Observable<CLLocation> {
        return Observable.create { observer in
            self.locationManager.rx_didUpdateLocations.take(1).subscribe { event in
                switch event {
                    case .Next(let value):
                        let location = value.last!
                        observer.onNext(location)
                        break
                    case .Completed:
                        self.locationManager.stopUpdatingLocation()
                        observer.onCompleted()
                        break
                    case .Error(let error):
                        observer.onError(error)
                    break
                }
            }.addDisposableTo(self.rx_disposeBag)
            return NopDisposable.instance
        }
    }
    
    func authorizationStatusEqualTo(status:CLAuthorizationStatus)->Bool {
        return CLLocationManager.authorizationStatus() == status
    }
}
