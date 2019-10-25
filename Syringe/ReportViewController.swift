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

    func fetchReportDetails() {
        let userId = defaults.string(forKey: "userId")!;
        let reportDB = Database.database().reference(withPath: "reports/\(userId)/\(reportID)");
        var count = 1;
        reportDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print(snap.key)
                print(snap.value)
                count += 1;
            }
        })
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
