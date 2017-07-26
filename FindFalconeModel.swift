//
//  FindFalconeModel.swift
//  FindingFalcone
//
//  Created by srinivasan on 18/07/17.
//  Copyright © 2017 srinivasan. All rights reserved.
//

import Foundation

class FindFalconeModel {
    
    var planetsArray = [Planet]()
    var vehiclesArray = [Vehicle]()
    var token:String?
    var dataArray = Array<String>(
    )
    typealias SuccessHandler = (_ data:AnyObject) -> Void
    typealias ErrorHandler = (_ error:AnyObject) -> Void
    
    // MARK: - API calls
    func getPlanetsList(success:(SuccessHandler)? = nil,fail:(ErrorHandler)? = nil){
        
        let urlString = "https://findfalcone.herokuapp.com/planets"
        
        NetworkHelper.sharedInstance.getData(urlString, params: nil, onSuccess: { (data) in
            guard let  array = self.convertStringToArray(data as! String) else{
                return
            }
            var planetsArray = [Planet]()
            for item in array{
                planetsArray.append(Planet().initWithDictionary(dict: item as! Dictionary<String, Any>))
            }
            success!(planetsArray as AnyObject)
            
        }) { (error) in
            print(error)
            fail!(error)
        }
    }
    
    func getVehiclesList(success:(SuccessHandler)? = nil,fail:(ErrorHandler)? = nil){
        
        let urlString = "https://findfalcone.herokuapp.com/vehicles"
        
        NetworkHelper.sharedInstance.getData(urlString, params: nil, onSuccess: { (data) in
            guard let  array = self.convertStringToArray(data as! String) else{
                return
            }
            var vehiclesArray = [Vehicle]()
            for item in array{
                vehiclesArray.append(Vehicle().initWithDictionary(dict: item as! Dictionary<String, Any>))
            }
            
            success!(vehiclesArray as AnyObject)
            
        }) { (error) in
            print(error)
            fail!(error)
        }
    }
    
    func getToken(success:(SuccessHandler)? = nil,fail:(ErrorHandler)? = nil){
        
        let urlString = "https://findfalcone.herokuapp.com/token"
        
        NetworkHelper.sharedInstance.postData(urlString, params: nil, onSuccess: { (data) in
            guard let  dic = self.convertStringToDic(data as! String) else{
                return
            }
            self.token = dic["token"]
            
            success!(self.token as AnyObject)
            
        }) { (error) in
            print(error)
            fail!(error)
        }
    }
    
    func getFindFalconeResult(success:(SuccessHandler)? = nil,fail:(ErrorHandler)? = nil){
        let urlString = "https://findfalcone.herokuapp.com/find"
        
        var selectedPlanets = [String]()
        var selectedVehicles = [String]()
        for item in self.planetsArray {
            if item.isSelected && item.selectedVehicle != nil {
                selectedPlanets.append(item.name!)
                selectedVehicles.append(item.selectedVehicle!.name!)
            }
        }
        var params = [String:AnyObject]()
        params["token"] = self.token! as AnyObject
        params["planet_names"] = selectedPlanets as AnyObject
        params["vehicle_names"] = selectedVehicles as AnyObject
        
        NetworkHelper.sharedInstance.postData(urlString, params: params, onSuccess: { (data) in
            guard let  dic = self.convertStringToDic(data as! String) else{
                return
            }
            
            success!(dic as AnyObject)
            
        }) { (error) in
            print(error)
            fail!(error)
        }
    }



    
    // MARK: - Data conversion methods

    func convertStringToArray(_ text: String) -> Array<Any>? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertStringToDic(_ text: String) -> Dictionary<String, String>? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    // MARK: - Data updation methods
    func updateDataArrayForPlanetPicker(titleArray:Array<String>){
        self.dataArray.removeAll()
        for item in planetsArray {
            if titleArray.contains(item.name!) {
                item.isSelected = true
            } else {
                item.isSelected = false
                item.selectedVehicle = nil
                self.dataArray.append(item.name!)
            }
        }
    }
    
    func updateDataArrayForVehiclePicker(planetName:String, currentVehicle:String){
        self.dataArray.removeAll()
        let planet = self.planetsArray.filter({$0.name == planetName})
        if planet.count == 0 {
            return
        }
        let vehicleArr = self.vehiclesArray.filter({$0.maximumDistance! >= planet.first!.distance!})
        let filteredArr = vehicleArr.filter({$0.count! > $0.countUsed})
        self.dataArray = filteredArr.map({$0.name!})
        let vehicle = self.vehiclesArray.filter({$0.name == currentVehicle})
        if vehicle.count == 0 {
            return
        }
        if self.dataArray.contains(vehicle.first!.name!) {
            return
        }

        self.dataArray.insert(vehicle.first!.name!, at: 0)
    }
    
    
    func updateDataAfterPlanetSelection(newPlanetName:String, oldPlanetName:String){
        let newPlanet = self.planetsArray.filter({$0.name == newPlanetName})
        if newPlanet.count == 0 {
            return
        }
        newPlanet.first!.isSelected = true
        newPlanet.first!.selectedVehicle = nil
        
        let oldPlanet = self.planetsArray.filter({$0.name == oldPlanetName})
        if oldPlanet.count == 0 {
            return
        }
        oldPlanet.first!.isSelected = false
        oldPlanet.first!.selectedVehicle!.countUsed = oldPlanet.first!.selectedVehicle!.countUsed-1
        oldPlanet.first!.selectedVehicle = nil
    }
    
    func updateDataAfterVehicleSelection(planetName:String, newVehicleName:String, oldVehicleName:String){
        let planet = self.planetsArray.filter({$0.name == planetName})
        if planet.count == 0 {
            return
        }
        let vehicle = self.vehiclesArray.filter({$0.name == newVehicleName})
        vehicle.first!.countUsed =  vehicle.first!.countUsed + 1
        planet.first!.selectedVehicle = vehicle.first
        
        let vehicleOld = self.vehiclesArray.filter({$0.name == oldVehicleName})
        if vehicleOld.count > 0 {
            vehicleOld.first!.countUsed =  vehicleOld.first!.countUsed - 1
        }

    }
    
    func getTotalTime()->Int{
        var time = 0
        for item in self.planetsArray {
            if item.isSelected && item.selectedVehicle != nil {
                time = time + (item.distance!/item.selectedVehicle!.speed!)
            }
        }
        return time
    }
    
    // MARK: - Validation methods
    
    func validateSelection()->(Bool, String){
        var counter = 0
        for item in self.planetsArray {
            if item.isSelected {
                counter = counter + 1
            }
        }
        if counter != 4 {
            return (false, "Please choose any four planets to search.")
        }
        for item in self.planetsArray {
            if item.isSelected && item.selectedVehicle != nil{
                counter = counter - 1
            }
        }
        if counter != 0 {
            return (false, "Please choose the vehicles to use for each planet.")
        }
        return (true, "")
    }


    

    
}

