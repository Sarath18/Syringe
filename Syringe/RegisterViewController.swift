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
    
    func goBackToLogin() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateUserDetails() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let name = nameTextField.text else { return };
        guard let email = emailTextField.text else { return };
        let blood_group = bloodGroupPickerData[bloodGroupPicker.selectedRow(inComponent: 0)]
        guard let mobile = mobileNumberTextField.text else { return };
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dob = dateFormatter.string(from: datePicker.date);
        
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("users").child(userID).setValue(["email": email, "full_name": name, "date_of_birth": dob, "blood_group": blood_group, "mobile": mobile]);
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let errorAlert = UIAlertController(title: "Error", message: "Account successfully created", preferredStyle: .alert)
        let okErrorAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default:
                print("unknown")
            }});
        errorAlert.addAction(okErrorAction);
        
        let successAlert = UIAlertController(title: "Success", message: "Account successfully created", preferredStyle: .alert)
        
        let okSuccessAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                self.goBackToLogin()
            @unknown default:
                print("unknown")
            }});
        successAlert.addAction(okSuccessAction)
        
        if(confirmPasswordTextField.text == passwordTextField.text) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (userInfo, err) in
                if err != nil {
                    print(err!)
                    errorAlert.message = "Check you details and try again."
                    self.present(errorAlert, animated: true, completion: nil)
                } else {
                    self.updateUserDetails();
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
        } else {
            errorAlert.message = "Passwords do not match"
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true;
        
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
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            self.navigationController?.navigationBar.prefersLargeTitles = false;
        }
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
