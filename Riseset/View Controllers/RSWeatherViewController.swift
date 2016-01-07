// RSWeatherViewController.swift
//
// Copyright (c) 2016 Riseset (http://pastepasswd.spirosgerokostas.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import RxBlocking
import PureLayout
import RealmSwift

class RSWeatherViewController: UIViewController {

    var didSetupContraints = false
    
    func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    label.text = text
                })
            }
            .addDisposableTo(disposeBag)
    }
    
    let locationController = RSLocationController()
    let geocodeController = RSGeocodeController()
    let forecastController = RSForecastController()
    
    let weatherController = RSWeatherController()

    var disposeBag = DisposeBag()
    var viewModel = RSForecastViewModel()
    var dayViews:NSMutableArray?
    
    let locationLabel:UILabel = {
        let locationLabel = UILabel.newAutoLayoutView()
        if #available(iOS 8.2, *) {
            locationLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightRegular)
        } else {
            locationLabel.font = UIFont.systemFontOfSize(24.0)
        }
        locationLabel.textColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
        return locationLabel
    }()
    
    lazy var verticalLine1:UIView = {
        let verticalLine1 = UIView.newAutoLayoutView()
        verticalLine1.backgroundColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 0.2)
        return verticalLine1
    }()
    
    
    lazy var verticalLine2:UIView = {
        let verticalLine2 = UIView.newAutoLayoutView()
        verticalLine2.backgroundColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 0.2)
        return verticalLine2
    }()
    
    lazy var horizontalLine:UIView = {
        let horizontalLine = UIView.newAutoLayoutView()
        horizontalLine.backgroundColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 0.2)
        return horizontalLine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        
        //bindSourceToLabel(viewModel.cityName, label: myLabel)
        
//        dayViews = NSMutableArray()
//        
//        for item in 0...2 {
//            print(item)
//            let forecastDayView = RSForecastDayView.newAutoLayoutView()
//            view.addSubview(forecastDayView)
//            dayViews?.addObject(forecastDayView)
//        }
        
        Realm.rx_objects(RSForecast).subscribeNext {items in
            //print("items \(items)")
            
            if let dailyDatapoints = items.first?.dailyDataPoints {
                
                let test = dailyDatapoints[1...3]
                let newArray = Array(test)
                
                self.dayViews!.enumerateObjectsUsingBlock({ view, index, stop in
                    let forecastDayView = view as! RSForecastDayView
                    forecastDayView.dataPoint = newArray[index]
                })
            }
            
        }.addDisposableTo(disposeBag)
        
        weatherController.viewModel.items
            .subscribeNext { items in
                
                
                 if let dailyDatapoints = items.first?.dailyDataPoints {
                    let test = dailyDatapoints[1...3]
                    let newArray = Array(test)
                
                    self.dayViews!.enumerateObjectsUsingBlock({ view, index, stop in
                        let forecastDayView = view as! RSForecastDayView
                        print( newArray[index])
                        forecastDayView.dataPoint = newArray[index]
                    })

                }
                
        }.addDisposableTo(disposeBag)
        
        weatherController.viewModel.locationName
            .startWith("updating weather...")
            .subscribeNext { [weak self] text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.locationLabel.text = text
                })
        }.addDisposableTo(disposeBag)
        
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationWillEnterForegroundNotification).subscribeNext { [weak self] _ in
            self?.weatherController.updateActions().subscribeNext { location in
            }.addDisposableTo((self?.disposeBag)!)
        }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
  
        weatherController.updateActions().subscribeNext { location in
            
        }.addDisposableTo(disposeBag)
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(locationLabel)
        
        dayViews = NSMutableArray()
        
        for _ in 0...2 {
            let forecastDayView = RSForecastDayView.newAutoLayoutView()
            view.addSubview(forecastDayView)
            dayViews?.addObject(forecastDayView)
        }
        
        view.addSubview(verticalLine1)
        view.addSubview(verticalLine2)
        view.addSubview(horizontalLine)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width / 3.0
        let height:CGFloat = 160.0
        
        if !didSetupContraints {
            
            locationLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 74.0)
            locationLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            
            dayViews?.autoSetViewsDimensionsToSize(CGSizeMake(width, height))
            dayViews?.autoMatchViewsDimension(.Width)
            
            dayViews?.firstObject?.autoPinEdgeToSuperviewEdge(.Left)
            dayViews?.firstObject?.autoPinEdgeToSuperviewEdge(.Bottom)
            
            var previousView: UIView?
            
            for view in dayViews! {
                if let previousView = previousView {
                    view.autoPinEdge(.Left, toEdge: .Right, ofView: previousView)
                    view.autoPinEdgeToSuperviewEdge(.Bottom)
                }
                previousView = view as? UIView
            }
      
            dayViews?.lastObject?.autoPinEdgeToSuperviewEdge(.Right)
            
            horizontalLine.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
            horizontalLine.autoSetDimension(.Height, toSize: 1.0)
            horizontalLine.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayViews?.firstObject as! UIView)
            
            verticalLine1.autoSetDimensionsToSize(CGSizeMake(1.0, height))
            verticalLine1.autoPinEdge(.Left, toEdge: .Right, ofView: dayViews?.firstObject as! UIView)
            verticalLine1.autoPinEdgeToSuperviewEdge(.Bottom)
            
            verticalLine2.autoSetDimensionsToSize(CGSizeMake(1.0, height))
            verticalLine2.autoPinEdge(.Left, toEdge: .Right, ofView: dayViews?.objectAtIndex(1) as! UIView)
            verticalLine2.autoPinEdgeToSuperviewEdge(.Bottom)

            didSetupContraints = true
        }

        super.updateViewConstraints()
    }
}

