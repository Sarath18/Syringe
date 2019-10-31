//
//  PatientViewController.swift
//  Syringe
//
//  Created by ios on 15/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
}

class PatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var defaults = UserDefaults.standard

    var reports: [String] = []
    var reportID: [String] = []
    var hospital: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reports.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportTableViewCell
        cell.cellTitle.text = self.reports[indexPath.row]
        cell.cellDescription.text = self.hospital[indexPath.row]

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(reports[indexPath.row])

        let reportVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "reportViewController") as? ReportViewController
        reportVC?.reportID = reportID[indexPath.row];
        reportVC?.reportDate = reports[indexPath.row];
        reportVC?.hospital = hospital[indexPath.row];
        self.navigationController?.pushViewController(reportVC!, animated: true)
    }
    
    func fetchAppointmentDetails(mode : Int) {
        if(mode == 1) {
            self.reports = [];
            self.reportID = [];
        }

        let userId = defaults.string(forKey: "userId")!;
        print("\(userId)")
        let reportDB = Database.database().reference(withPath: "reports/\(userId)");
        var count = 1;
        reportDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print(snap.key)
                self.reports.append(snap.childSnapshot(forPath: "date").value as! String)
                self.hospital.append(snap.childSnapshot(forPath: "hospital").value as! String)
                self.reportID.append(snap.key)
                count += 1;
            }
            for x in self.hospital {
                print(x)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        fetchAppointmentDetails(mode: 0);

        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
    }
    
    @objc func refresh(_ sender: Any) {
        fetchAppointmentDetails(mode: 1)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.defaults.set("", forKey: "userId");
         _ = self.navigationController?.popToRootViewController(animated: true)
    }

}



//class PatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    let defaults = UserDefaults.standard
//
//    var reports: [String] = []
//    var reportID: [String] = []
//    var hospital: [String] = []
//
//    var refreshControl = UIRefreshControl()
//
//    let cellReuseIdentifier = "cell"
//

//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.reports.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell:ReportTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ReportTableViewCell
//
////        cell.textLabel?.numberOfLines = 0
////        cell.textLabel?.text = self.reports[indexPath.row]
//
//
//        cell.cellTitle.text = self.reports[indexPath.row]
//        cell.cellDescription.text = self.hospital[indexPath.row]
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(reports[indexPath.row])
//
//        let reportVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "reportViewController") as? ReportViewController
//        reportVC?.reportID = reportID[indexPath.row];
//        reportVC?.reportNumber = "Report: " + reports[indexPath.row];
//        self.navigationController?.pushViewController(reportVC!, animated: true)
//    }
//
//    func fetchAppointmentDetails(mode : Int) {
//        if(mode == 1) {
//            self.reports = [];
//            self.reportID = [];
//        }
//
//        let userId = defaults.string(forKey: "userId")!;
//        print("\(userId)")
//        let reportDB = Database.database().reference(withPath: "reports/\(userId)");
//        var count = 1;
//        reportDB.observeSingleEvent(of: .value, with: { (snapshot) in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                print(snap.key)
//                self.reports.append(snap.childSnapshot(forPath: "date").value as! String)
//                self.hospital.append(snap.childSnapshot(forPath: "hospital").value as! String)
//                self.reportID.append(snap.key)
//                count += 1;
//            }
//            for x in self.hospital {
//                print(x)
//            }
//            self.tableView.reloadData()
//            self.refreshControl.endRefreshing()
//        })
//    }
//
//
//    @IBOutlet weak var tableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true;
//        self.tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        self.tableView.reloadData()
//        fetchAppointmentDetails(mode: 0);
//
//        tableView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
//    }
//
//    @objc func refresh(_ sender: Any) {
//        fetchAppointmentDetails(mode: 1)
//    }
//}
