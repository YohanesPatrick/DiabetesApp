//
//  TableViewController.swift
//  DiabetesMU
//
//  Created by Yohanes Patrik Handrianto on 1/23/18.
//  Copyright © 2018 Yohanes Patrik Handrianto. All rights reserved.
//

import UIKit

var StatusList = ["Weight","Blood Glucose", "Mood", "Activity"]
var StatusSub = ["CurrentWeight","CurrentBLoodGlucose", "CurrentMood", "CurrentActivity"]
var SegueId = ["segue","segue1","segue2","segue3"]
var StatusImages = ["","","","",""]
var myIndex = 0

class TableViewController: UITableViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return StatusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = StatusList[indexPath.row]
        cell.detailTextLabel?.text = StatusSub[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        performSegue(withIdentifier: SegueId[indexPath.row] , sender: self)
        
    }
    
}

