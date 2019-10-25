//
//  ViewController.swift
//  blood test 1
//
//  Created by Rishabh Raj Jaiswal on 22/09/19.
//  Copyright © 2019 Deliberate Think. All rights reserved.
//

import UIKit
import Firebase

class UploadReportViewController: UIViewController {
    
    var valuesInRange = [[11.0, 16.0], [3.5, 5.50], [4.5, 11], [150, 450], [0, 2], [40, 70], [20, 45], [2, 10]]
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    var userId : String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func uploadReportButtonPressed(_ sender: Any) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()

        ref.child("reports").child("\(userId)").childByAutoId().setValue(["HGB": textFields[0].text!, "RBC": textFields[1].text!, "WBC": textFields[2].text!, "PLT": textFields[3].text!, "BAS": textFields[4].text!, "NEU": textFields[5].text!, "LYM": textFields[6].text!, "MON": textFields[7].text!])
    }
    @IBAction func valueChanged(_ sender: UITextField) {
        
        if let currIndex = textFields.firstIndex(of: sender) {
            let currRange = valuesInRange[currIndex]
            let currLabel = labels[currIndex]
            
            let currTextField = textFields[currIndex]
            let valueEntered: Double = (currTextField.text! as NSString).doubleValue
            if (currRange[0]...currRange[1]).contains(valueEntered) {
                currLabel.textColor = UIColor.green
            } else {
                currLabel.textColor = UIColor.red
            }
        }
    }
    
}

