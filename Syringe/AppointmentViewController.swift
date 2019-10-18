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
