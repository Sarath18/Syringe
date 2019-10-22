//
//  AppointmentViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 18/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class AppointmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard;
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hospitalPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hospitalPickerData[row]
    }
    
    func fetchHospitalDetails() {
        let userDB = Database.database().reference(withPath: "hospitals/");

        userDB.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.exists() {
                let count = snapshot.childrenCount
                print(count)
                for i in 1...count {
                    self.hospitalPickerData.append(snapshot.childSnapshot(forPath: "\(i)/name").value as! String)
                }
                self.hospitalPicker.reloadAllComponents()
            }
            else { }
        });
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        
        //let selected_hospital = hospitalPickerData[hospitalPicker.selectedRow(inComponent: 0)]
        let hospital_id = hospitalPicker.selectedRow(inComponent: 0)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let appointment_date = dateFormatter.string(from: dateTimePicker.date)
        
        let userId = defaults.string(forKey: "userId")!
        let name = defaults.string(forKey: "full_name")!
        var selected_blood_tests : [String] = [];
        
        for i in 0...bloodTestButtonState.count-1 {
            if(bloodTestButtonState[i]) {
                selected_blood_tests.append(bloodTests[i]);
            }
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("appointments").child("\(hospital_id + 1)").childByAutoId().setValue(["userId": userId, "full_name": name, "appointment_date": appointment_date, "tests": selected_blood_tests])

    }

    @IBAction func glucoseTestClicked(_ sender: Any) {
        bloodTestButtonState[0] = !bloodTestButtonState[0];
        if(bloodTestButtonState[0]) {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-selected"), for: UIControl.State.normal)
        }
        else {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-unselected"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func calciumTestClicked(_ sender: Any) {
        bloodTestButtonState[1] = !bloodTestButtonState[1];
        if(bloodTestButtonState[1]) {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-selected"), for: UIControl.State.normal)
        }
        else {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-unselected"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func cholestrolTestClicked(_ sender: Any) {
        bloodTestButtonState[2] = !bloodTestButtonState[2];
        if(bloodTestButtonState[2]) {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-selected"), for: UIControl.State.normal)
        }
        else {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-unselected"), for: UIControl.State.normal)
        }
        
    }
    
    @IBAction func dimerTestClicked(_ sender: Any) {
        bloodTestButtonState[3] = !bloodTestButtonState[3];
        if(bloodTestButtonState[3]) {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-selected"), for: UIControl.State.normal)
        }
        else {
            (sender as AnyObject).setBackgroundImage(UIImage(named: "radio-button-unselected"), for: UIControl.State.normal)
        }
        
    }

    var bloodTestButtonState : [Bool] = [false, false, false, false];
    var bloodTests : [String] = ["Glucose", "Calcium", "Cholestrol", "D-dimer"]
    
    @IBOutlet weak var hospitalPicker: UIPickerView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var hospitalPickerData: [String] = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing the Hospitals into hospital picker
        hospitalPicker.delegate = self
        hospitalPicker.dataSource = self
        fetchHospitalDetails();
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
