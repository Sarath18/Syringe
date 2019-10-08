//
//  RegisterViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 05/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return bloodGroupPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return bloodGroupPickerData[row]
    }
    

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var bloodGroupPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    
    var bloodGroupPickerData: [String] = [String]()
    
    func updateUserDetails() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let name = nameTextField.text else { return };
        guard let email = emailTextField.text else { return };
        let blood_group = bloodGroupPickerData[bloodGroupPicker.selectedRow(inComponent: 0)]
        guard let mobile = mobileNumberTextField.text else { return };
        guard let pass = passwordTextField.text else { return };
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dob = dateFormatter.string(from: datePicker.date);
        
        
        
        
        
        ref.child("users").child(name+pass).setValue(["email": email, "full_name": name, "date_of_birth": dob, "blood_group": blood_group, "mobile": mobile]);
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if(confirmPasswordTextField.text == passwordTextField.text) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (userInfo, err) in
                if err != nil {
                    print(err!)
                    self.updateUserDetails();
                } else {
                    print("Successful Registration!")
                    self.updateUserDetails();
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding custom border to text fields
        passwordTextField.setBorder()
        confirmPasswordTextField.setBorder()
        emailTextField.setBorder()
        nameTextField.setBorder()
        mobileNumberTextField.setBorder()
        
        // Initializing the blood group picker
        bloodGroupPicker.delegate = self
        bloodGroupPicker.dataSource = self
        bloodGroupPickerData = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
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
