//
//  ViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 05/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    func setBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var usernameEditField: UITextField!
    @IBOutlet weak var passwordEditField: UITextField!
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameEditField.setBorder()
        passwordEditField.setBorder()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: usernameEditField.text!, password: passwordEditField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Login Successul")
                self.userId = (Auth.auth().currentUser?.uid)!
                let labTechniciansDB = Database.database().reference(withPath: "lab_technicians/\(self.userId)")
                
                labTechniciansDB.observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if snapshot.exists() {
                        print("Lab Tech")
                        self.performSegue(withIdentifier: "labTechnicianDashboard", sender: self)
                        
                    } else {
                        
                        print("User")
                        self.performSegue(withIdentifier: "patientDashboard", sender: self)
                    }
                 })
                
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // you made a typo here
        if segue.identifier == "labTechnicianDashboard" {
            let destinationVC = segue.destination as! LabTechnicialViewController
            destinationVC.userId = userId // forced unwrap

        }
        
        if segue.identifier == "patientDashboard" {
            let destinationVC = segue.destination as! PatientViewController
            destinationVC.userId = userId // forced unwrap

        }
    }
    
    
    
    
    
    
    
    
}

