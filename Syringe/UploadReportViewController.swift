//
//  ViewController.swift
//  blood test 1
//
//  Created by Rishabh Raj Jaiswal on 22/09/19.
//  Copyright © 2019 Deliberate Think. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var valuesInRange = [[11.0, 16.0], [3.5, 5.50], [4.5, 11], [150, 450], [0, 2], [40, 70], [20, 45], [2, 10]]
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageLabel.text = ""
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
                messageLabel.text = "CRITICAL VALUES HERE" // text message and NOTIFICATION TO DOCTOR
                // if doctor reads the message then notification to lab that doc has read the notification
            }
        }
        
        
    }
    
}

