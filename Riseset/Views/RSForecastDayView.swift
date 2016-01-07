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
            print(dataPoint?.icon)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        addSubview(dayLabel)
        addSubview(iconImageView)
        
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetupContraints {
            
            iconImageView.autoSetDimensionsToSize(CGSizeMake(80.0, 71.0))
            iconImageView.autoCenterInSuperview()
            
            dayLabel.autoAlignAxis(.Vertical, toSameAxisOfView: self)
            dayLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: iconImageView, withOffset: -5.0)
        
            didSetupContraints = true
        }
        
        super.updateConstraints()
        
    }

}
