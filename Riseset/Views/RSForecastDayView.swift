//
//  RSForecastDayView.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 05/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit

class RSForecastDayView: UIView {
    
    var didSetupContraints = false
    
    let iconImageView:UIImageView = {
        let iconImageView = UIImageView.newAutoLayoutView()
        return iconImageView
    }()
    
    let temperatureLabel:UILabel = {
        let temperatureLabel = UILabel.newAutoLayoutView()
        if #available(iOS 8.2, *) {
            temperatureLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightRegular)
        } else {
            temperatureLabel.font = UIFont.systemFontOfSize(16.0)
        }
        temperatureLabel.textColor = UIColor(red: 66.0 / 255.0, green: 82.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
        return temperatureLabel
    }()
    
    let dayLabel:UILabel = {
        let dayLabel = UILabel.newAutoLayoutView()
        if #available(iOS 8.2, *) {
            dayLabel.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightRegular)
        } else {
            dayLabel.font = UIFont.systemFontOfSize(20.0)
        }
        dayLabel.textColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
        return dayLabel
    }()
    
    var dataPoint:RSDataPoint? {
        didSet {
            dayLabel.text = dataPoint?.day
            
            iconImageView.image = UIImage(named: dataPoint!.icon)
            iconImageView.image = iconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            iconImageView.tintColor = UIColor(red: 57.0 / 255.0, green: 70.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
            
            let str = "\(dataPoint!.currentTemperatureMin.fahrenheitValue!)°/\(dataPoint!.currentTemperatureMax.fahrenheitValue!)°"

//            let attributedString = NSMutableAttributedString(string: str)
//            
//            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 107.0 / 255.0, green: 131.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: "\(dataPoint!.currentTemperatureMin.fahrenheitValue!)°".characters.count))
//            
//            temperatureLabel.attributedText = attributedString
            
            temperatureLabel.text = str
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(temperatureLabel)
        
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetupContraints {
            
            iconImageView.autoSetDimensionsToSize(CGSizeMake(80.0, 71.0))
            iconImageView.autoCenterInSuperview()
            
            temperatureLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: iconImageView, withOffset: 5.0)
            temperatureLabel.autoAlignAxis(.Vertical, toSameAxisOfView: self)
            
            dayLabel.autoAlignAxis(.Vertical, toSameAxisOfView: self)
            dayLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: iconImageView, withOffset: -5.0)
        
            didSetupContraints = true
        }
        
        super.updateConstraints()
        
    }

}
