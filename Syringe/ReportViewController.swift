//
//  ReportViewController.swift
//  Syringe
//
//  Created by Sarathkrishnan Ramesh on 25/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class ReportDataCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellValue: UILabel!
    @IBOutlet weak var cellRange: UILabel!
}

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reportValue: [Double] = []
    var xval : [Double] = []
    
    var defaults = UserDefaults.standard;
    var reportID : String = "";
    var reportDate : String = "";
    var hospital : String = ""
    var dataName : [String] = []//["HGB", "RBC", "WBC", "PLT", "BAS", "NEU", "LYM", "MON"]
    var rangeValueDict = ["HGB": [11.0, 16.0],
                          "RBC": [3.5, 5.50],
                          "WBC": [4.5, 11],
                          "PLT": [150, 450],
                          "BAS": [0, 2],
                          "NEU": [40, 70],
                          "LYM": [20, 45],
                          "MON": [2, 10]]
    
    @IBOutlet var testLabels: [UILabel]!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var testValues: [UITextField]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hospitalLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataName.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDataCell") as! ReportDataCell
        let name = self.dataName[indexPath.row];
        let lower_limit : Double = rangeValueDict[name]![0]
        let upper_limit : Double = rangeValueDict[name]![1]
        let value_range = "[ " + lower_limit.description + "-" + upper_limit.description + "]";
        cell.cellTitle.text = name;
        cell.cellValue.text = self.reportValue[indexPath.row].description;
        cell.cellRange.text = value_range;
        
        if(reportValue[indexPath.row] < lower_limit || reportValue[indexPath.row] > upper_limit) {
            cell.cellValue.textColor = UIColor.red;
            cell.cellValue.font = UIFont.boldSystemFont(ofSize: 20.0)
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dataName[indexPath.row])
        
    }
    
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
                self.dataName.append(snap.key);
                let value = (snap.value as! NSString).doubleValue;
                self.reportValue.append(value)
                count += 1;
            }
            self.tableView.reloadData()
        })
    }


    func fetchLabelValues(val:String)
    {
        let userId = defaults.string(forKey: "userId")!;
        let ref = Database.database().reference(withPath: "reports/\(userId)/");
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let ch = child as! DataSnapshot;
                for c in ch.children {
                    let snap = c as! DataSnapshot
                    if(snap.key == val) {
                        let value = (snap.value as! NSString).doubleValue;
                        self.xval.append(value)
                    }
                }
            }
            print(self.xval)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false;
        self.title = "Report: " + reportDate;
        self.dateLabel.text = reportDate;
        self.hospitalLabel.text = hospital;
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchReportDetails();
        print(fetchLabelValues(val: "HGB"));
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
