//
//  RegisterViewController.swift
//  Syringe
//
//  Created by student on 05/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if(confirmPasswordTextField.text == passwordTextField.text) {
            print("here")
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (userInfo, err) in
                if err != nil {
                    print(err!)
                } else {
                    print("Successful Registration!")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
