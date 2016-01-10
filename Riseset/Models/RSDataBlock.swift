//
//  RSDataBlock.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 10/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import RealmSwift

class RSDataBlock: Object {

    dynamic var summary:String = ""
    dynamic var icon:String = ""
    let data = List<RSDataPoint>()
    
    convenience init(json:[String:AnyObject]) {
        self.init()
        
        //print("json \(json)")
        
        self.summary = json["summary"] as! String
        self.icon = json["icon"] as! String
        
        if let data = json["data"] as? [NSDictionary] {
            for item in data {
                let dataPoint = RSDataPoint(json: item)
                self.data.append(dataPoint)
            }
        }
    }
}
