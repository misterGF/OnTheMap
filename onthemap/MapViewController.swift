//
//  MapViewController.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/31/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    var appDelegate: AppDelegate!
    var session : NSURLSession!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add navigation buttons
        var rightRefreshButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshParseData:")
        var rightLocationButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "startEnterLocation:")
        var leftLogoutButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutUser:")
        
        self.navigationItem.setRightBarButtonItems([rightRefreshButtonItem,rightRefreshButtonItem], animated: true)
        self.navigationItem.setLeftBarButtonItem(leftLogoutButtonItem, animated: true)
        
        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
        
        //Grab data from parse about students
        ParseClient.sharedInstance().getStudentInfoFromParse() { (success, studentInfo, errorString) in
        
            if success {
                
                println("Got the student info")
                
                
            } else {
                
                println("Didn't get it")
            
            }
        
        
        }
        
    }
    
}
