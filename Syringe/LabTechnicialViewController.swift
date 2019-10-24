//
//  LabTechnicialViewController.swift
//  Syringe
//
//  Created by ios on 15/10/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class LabTechnicialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var appointments: [String] = []
    var refreshControl = UIRefreshControl()
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointments.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.appointments[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func fetchAppointmentDetails(mode : Int) {
        if(mode == 1) {
            self.appointments = [];
        }
        let appointmentDB = Database.database().reference(withPath: "appointments/1");
        
        appointmentDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.appointments.append(snap.childSnapshot(forPath: "full_name").value as! String);
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    //var userId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

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
    
}
