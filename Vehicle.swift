//
//  Vehicle.swift
//  FindingFalcone
//
//  Created by srinivasan on 19/07/17.
//  Copyright © 2017 srinivasan. All rights reserved.
//

import Foundation

class Vehicle {
    var name:String?
    var count:Int?
    var countUsed = 0
    var maximumDistance:Int?
    var speed:Int?
    
    func initWithDictionary(dict: Dictionary<String, Any>) -> Vehicle{
        self.name = dict["name"] as? String
        self.count = dict["total_no"] as? Int
        self.maximumDistance = dict["max_distance"] as? Int
        self.speed = dict["speed"] as? Int
        return self
    }
    
    
}
