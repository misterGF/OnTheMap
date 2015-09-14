//
//  ListViewController.swift
//  onthemap
//
//  Created by Gil Ferreira on 9/2/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var appDelegate: AppDelegate!
    var session : NSURLSession!
    var locations = [StudentInformation]()
    
    @IBOutlet weak var studentsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
        
        //Add navigation buttons
        customizeNavBar()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Grab data from parse about students
        if let locations = ParseClient.sharedInstance().studentInfo {
            
            self.locations = locations
            dispatch_async(dispatch_get_main_queue()) {
                self.studentsTableView.reloadData()
            }
            
        } else {
            
            //Not saved let's grab it
            ParseClient.sharedInstance().getStudentInfoFromParse() { (success, studentInfo, errorString) in
                
                if success {
                    
                    if let locations = ParseClient.sharedInstance().studentInfo {
                        
                        self.locations = locations
                        dispatch_async(dispatch_get_main_queue()) {
                            self.studentsTableView.reloadData()
                        }
                        
                    }  else {
                        
                        println("Didn't unwrap")
                        
                    }
                    
                } else {
                    
                    println("Didn't get")
                }
                
            }
            
        }

    }
    
    //What is in the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        let cellReuseIdentity = "studentTableViewCell"
        let location = locations[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentity) as! UITableViewCell
        
        //Fill in the cell defaults
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)"
        
        return cell
    }
    

    //Row selected. What to do
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: locations[indexPath.row].mediaURL!)!)
        
    }
    
    //Number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
}