//
//  ViewController.swift
//  FindingFalcone
//
//  Created by srinivasan on 18/07/17.
//  Copyright © 2017 srinivasan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    let model = FindFalconeModel()
    
    var selectedPlanetButton: UIButton?
    var selectedVehicleButton: UIButton?

    @IBOutlet weak var planet1Button: UIButton!
    @IBOutlet weak var planet2Button: UIButton!
    @IBOutlet weak var planet3Button: UIButton!
    @IBOutlet weak var planet4Button: UIButton!

    @IBOutlet weak var vehicle1Button: UIButton!
    @IBOutlet weak var vehicle2Button: UIButton!
    @IBOutlet weak var vehicle3Button: UIButton!
    @IBOutlet weak var vehicle4Button: UIButton!

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var holdingView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var activityInidcator: UIActivityIndicatorView!
    
    // MARK: - Action methods
    @IBAction func findFalconeClicked(_ sender: UIButton) {
        let validator = self.model.validateSelection()
        if !validator.0 {
            self.showAlert(message: validator.1)
        }else{
            self.screenBusy()
            if self.model.token == nil {
                self.getToken()
            } else {
                self.getFindFalconeResult()
            }
        }
    }
    
    @IBAction func planetButtonClicked(_ sender: UIButton) {
        self.selectedPlanetButton = sender
        self.model.updateDataArrayForPlanetPicker(titleArray: [self.planet1Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), self.planet2Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), self.planet3Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), self.planet4Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil)])
        self.showPickerView(val: true)

    }
    
    @IBAction func vehicleButtonClicked(_ sender: UIButton) {
        var title = ""
        switch sender {
        case self.vehicle1Button:
            if (planet1Button.titleLabel!.text?.contains("Planet1 ▼"))! {
                self.showAlert(message: "Please select the planet before selecting the vehicle")
                return
            }
            title = self.planet1Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil)
            self.model.updateDataArrayForVehiclePicker(planetName: title, currentVehicle:self.vehicle1Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
        case self.vehicle2Button:
            if (planet2Button.titleLabel!.text?.contains("Planet2 ▼"))! {
                self.showAlert(message: "Please select the planet before selecting the vehicle")
                return
            }
            title = self.planet2Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil)
            self.model.updateDataArrayForVehiclePicker(planetName: title, currentVehicle:self.vehicle2Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
        case self.vehicle3Button:
            if (planet3Button.titleLabel!.text?.contains("Planet3 ▼"))! {
                self.showAlert(message: "Please select the planet before selecting the vehicle")
                return
            }
            title = self.planet3Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil)
            self.model.updateDataArrayForVehiclePicker(planetName: title, currentVehicle:self.vehicle3Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
        case self.vehicle4Button:
            if (planet4Button.titleLabel!.text?.contains("Planet4 ▼"))! {
                self.showAlert(message: "Please select the planet before selecting the vehicle")
                return
            }
            title = self.planet4Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil)
            self.model.updateDataArrayForVehiclePicker(planetName: title, currentVehicle:self.vehicle4Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))

        default:
            break
        }
        self.selectedVehicleButton = sender
        if self.model.dataArray.count == 0 {
            self.showAlert(message: "No suitable vehicle is available to search this planet. Please change your slection for other planets appropriately to proceed further.")
        }else{
            self.showPickerView(val: true)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        if let button = self.selectedPlanetButton {
             self.model.updateDataAfterPlanetSelection(newPlanetName: self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)], oldPlanetName: button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
            button.setTitle(self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)]+" ▼", for: .normal)
            switch button {
            case self.planet1Button:
                self.vehicle1Button.setTitle("Vehicle1"+" ▼", for: .normal)
            case self.planet2Button:
                self.vehicle2Button.setTitle("Vehicle2"+" ▼", for: .normal)
            case self.planet3Button:
                self.vehicle3Button.setTitle("Vehicle3"+" ▼", for: .normal)
            case self.planet4Button:
                self.vehicle4Button.setTitle("Vehicle4"+" ▼", for: .normal)
            default:
                break
            }
        } else {
            switch self.selectedVehicleButton! {
            case self.vehicle1Button:
                self.model.updateDataAfterVehicleSelection(planetName: self.planet1Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), newVehicleName: self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)], oldVehicleName: self.vehicle1Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
            case self.vehicle2Button:
                self.model.updateDataAfterVehicleSelection(planetName: self.planet2Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), newVehicleName: self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)], oldVehicleName: self.vehicle2Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
            case self.vehicle3Button:
                self.model.updateDataAfterVehicleSelection(planetName: self.planet3Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), newVehicleName: self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)], oldVehicleName: self.vehicle3Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
            case self.vehicle4Button:
                self.model.updateDataAfterVehicleSelection(planetName: self.planet4Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil), newVehicleName: self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)], oldVehicleName: self.vehicle4Button.titleLabel!.text!.replacingOccurrences(of: " ▼", with: "", options: .literal, range: nil))
            default:
                break
            }
            self.selectedVehicleButton?.setTitle(self.model.dataArray[self.pickerView.selectedRow(inComponent: 0)]+" ▼", for: .normal)

        }
        self.selectedVehicleButton = nil
        self.selectedPlanetButton = nil
        self.showPickerView(val: false)
        self.updateTimeLabel()
    }
    
    func holdingViewTapped(_ sender: UITapGestureRecognizer){
        self.holdingView.isHidden = true
    }
    
    // MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.holdingViewTapped(_:)))
        self.holdingView.addGestureRecognizer(tapGesture)

       self.screenBusy()
        self.getPlanetsList()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - API calls
    
    func getPlanetsList(){
        self.model.getPlanetsList(success: { (data) in
            DispatchQueue.main.async(execute: {
                self.model.planetsArray = data as! [Planet]
                self.getVehiclesList()
            })
        }) { (error) in
            print(error)
        }
    }

    func getVehiclesList(){
        self.model.getVehiclesList(success: { (data) in
            DispatchQueue.main.async(execute: {
                self.model.vehiclesArray = data as! [Vehicle]
                self.screenReady()
                self.updateTimeLabel()
            })
        }) { (error) in
            print(error)
        }

    }
    
    func getToken(){
        self.model.getToken(success: { (data) in
            DispatchQueue.main.async(execute: {
               self.getFindFalconeResult()
            })
        }) { (error) in
            self.screenReady()
            print(error)
        }
    }
    
    func getFindFalconeResult(){
        self.model.getFindFalconeResult(success: { (data) in
            DispatchQueue.main.async(execute: {
                self.screenReady()
                if  data["status"] == nil{
                    self.model.token = nil
                    self.showAlert(message: "Something went wrong. Please try again.")
                }
                if data["status"] as! String == "false"{
                    self.showAlert(title: "Mission Failure", message: "Better luck next time!")
                }else{
                    self.showAlert(title: "Mission Success!!!", message: "Falcone is found in Planet \(data["planet_name"] as! String). King Shah is mighty pleased with your strategy")
                }
            })
        }) { (error) in
            self.screenReady()
            print(error)
        }
    }
    
    // MARK: - UI updation methods
    func screenReady(){
        self.showActivityIndicator(val: false)
    }
    
    
    func screenBusy(){
        self.showActivityIndicator(val: true)
    }
    
    
    func showActivityIndicator(val:Bool){
        self.holdingView.isHidden = !val
        self.activityInidcator.isHidden = !val
        if val {
            self.activityInidcator.startAnimating()
        } else {
            self.activityInidcator.stopAnimating()
        }
        self.doneButton.isHidden = true
        self.pickerView.isHidden = true
    }
    
    func showPickerView(val:Bool){
        self.holdingView.isHidden = !val
        self.doneButton.isHidden = !val
        self.activityInidcator.isHidden = true
        self.pickerView.isHidden = !val
        self.pickerView.reloadAllComponents()
    }
    
    func updateTimeLabel(){
        self.timeLabel.text = "Time Taken: \(self.model.getTotalTime())"
    }
    
    
    // MARK: - Alert methods
    func showAlert(message:String){
       self.showAlert(title: "", message: message)
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    

}

// MARK: - PickerView delegates

extension LandingViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.model.dataArray[row]
    }
}
