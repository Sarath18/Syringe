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
    @IBOutlet weak var bloodGroupLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PATIENT TECH VIEW CONTROLLER: " + defaults.string(forKey: "userId")!)
        bloodGroupLabel.text = defaults.string(forKey: "blood_group");
        patientName.text = defaults.string(forKey: "full_name");
        emailLabel.text = defaults.string(forKey: "email");
        mobileLabel.text = String(defaults.integer(forKey: "mobile"));
        dobLabel.text = defaults.string(forKey: "date_of_birth");
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
