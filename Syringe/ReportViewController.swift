//
//  ReportViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 25/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class ReportViewController: UIViewController {
    var defaults = UserDefaults.standard;
    var reportID : String = "";
    var reportNumber : String = "";
    var rangeValueDict = ["HGB": [11.0, 16.0],
                          "RBC": [3.5, 5.50],
                          "WBC": [4.5, 11],
                          "PLT": [150, 450],
                          "BAS": [0, 2],
                          "NEU": [40, 70],
                          "LYM": [20, 45],
                          "MON": [2, 10]]
    
    @IBOutlet var testLabels: [UILabel]!
    
    @IBOutlet var testValues: [UITextField]!
    
    func fetchReportDetails() {
        let userId = defaults.string(forKey: "userId")!;
        let reportDB = Database.database().reference(withPath: "reports/\(userId)/\(reportID)");
        var count = 0;
        reportDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if(snap.key == "date" || snap.key == "hospital") {
                    continue;
                }
                self.testLabels[count].text = snap.key;
                self.testValues[count].text = (snap.value as! String);
                let value = (snap.value as! NSString).doubleValue;
                if(value >= self.rangeValueDict[snap.key]![0] && value <= self.rangeValueDict[snap.key]![1]) {
                    self.testLabels[count].textColor = UIColor.green;
                }
                else {
                    self.testLabels[count].textColor = UIColor.red;
                }
                count += 1;
            }
        })
    }


    func fetchLabelValues(val:String) -> [Double]
    {
        let userId = defaults.string(forKey:"userId");
        let ref = Database.database().reference();
        var xval : [Double] = []

        ref.child("Reports").child("\(String(describing: userId))").observe(.childAdded,with:{(snapshot) in
            if let temp = snapshot.childSnapshot(forPath:val).value as? String {
                let tempD = Double(temp);
                xval.append(tempD!);
            }
        });

        return xval;

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false;
        self.title = reportNumber;
        
        
        
        fetchReportDetails();
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
