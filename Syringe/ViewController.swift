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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true;

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
                        let labtechVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "labtechVC") as? LabTechnicialViewController
                        self.navigationController?.pushViewController(labtechVC!, animated: true)
                    } else {
                        print("User")
                        let userDB = Database.database().reference(withPath: "users/\(self.userId)");

                        userDB.observeSingleEvent(of: .value, with: {
                            (snapshot) in
                            if snapshot.exists() {
                                self.defaults.set(self.userId, forKey: "userId");
                                self.defaults.set(snapshot.childSnapshot(forPath: "blood_group").value, forKey: "blood_group")
                                self.defaults.set(snapshot.childSnapshot(forPath: "date_of_birth").value, forKey: "date_of_birth");
                                self.defaults.set(snapshot.childSnapshot(forPath: "email").value, forKey: "email");
                                self.defaults.set(snapshot.childSnapshot(forPath: "mobile").value, forKey: "mobile");
                                self.defaults.set(snapshot.childSnapshot(forPath: "full_name").value, forKey: "full_name");
                            }
                            else { }
                        });
                        let patientVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "patientDashboard") as? UITabBarController
                        self.navigationController?.pushViewController(patientVC!, animated: true)
                    }
                 })
            }
        }
    }
}

