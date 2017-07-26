//
//  Planet.swift
//  FindingFalcone
//
//  Created by srinivasan on 19/07/17.
//  Copyright © 2017 srinivasan. All rights reserved.
//

import Foundation

class Planet {
    var name:String?
    var distance:Int?
    var isSelected = false
    var selectedVehicle:Vehicle?
    
     func initWithDictionary(dict: Dictionary<String, Any>) -> Planet{
        self.name = dict["name"] as? String
        self.distance = dict["distance"] as? Int
        return self
    }
    
    
}
