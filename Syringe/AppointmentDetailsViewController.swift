//
//  AppointmentDetailsViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 24/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class AppointmentDetailsViewController: UIViewController {
    var userId : String = ""

    @IBOutlet weak var bloodTestsTextArea: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var bloodTests : [String] = [];

    func fetchAppointmentDetails() {

        let appointmentDB = Database.database().reference(withPath: "appointments/1/\(userId)");
        
        appointmentDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if(snap.key == "full_name") {
                    self.nameLabel.text = snap.value as? String;
                }
                else if (snap.key == "appointment_date") {
                    self.dateTimeLabel.text = snap.value as? String;
                }
                else if(snap.key == "tests") {
                    self.bloodTestsTextArea.text = "Tests:"
                    for i in 0...snap.childrenCount - 1 {
                        self.bloodTestsTextArea.text += "\n" + (snap.childSnapshot(forPath: "\(i)").value! as? String)!
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false;
        fetchAppointmentDetails()
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            self.navigationController?.isNavigationBarHidden = true;
        }
    }
}
