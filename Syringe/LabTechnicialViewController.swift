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
    var userIds: [String] = []
    
    var refreshControl = UIRefreshControl()
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = self.appointments[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(userIds[indexPath.row])
        let appointmentVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointmentDetailsViewController") as? AppointmentDetailsViewController
        appointmentVC?.userId = userIds[indexPath.row];
        self.navigationController?.pushViewController(appointmentVC!, animated: true)
    }
    
    func fetchAppointmentDetails(mode : Int) {
        if(mode == 1) {
            self.appointments = [];
            self.userIds = [];
        }
        let appointmentDB = Database.database().reference(withPath: "appointments/1");
        
        appointmentDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.appointments.append(snap.childSnapshot(forPath: "full_name").value as! String);
                self.userIds.append(snap.key);
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
