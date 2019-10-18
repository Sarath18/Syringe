//
//  ProfileViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 18/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var patientName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PATIENT TECH VIEW CONTROLLER: " + defaults.string(forKey: "userId")!)
        print(defaults.string(forKey: "blood_group")!);
        patientName.text = defaults.string(forKey: "full_name");
        print(defaults.string(forKey: "email") as Any);
        print(defaults.integer(forKey: "mobile"));
        print(defaults.string(forKey: "date_of_birth") as Any);
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
