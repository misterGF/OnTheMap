//
//  InfoPostingViewController.swift
//  onthemap
//
//  Created by Gil Ferreira on 9/14/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InfoPostingViewController: UIViewController, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!
    var session : NSURLSession!
    var lat:Double!
    var lng:Double!
    
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitInfoButton: UIButton!
    @IBOutlet var userLocationMapView: MKMapView!
    
    //Elements for initial display
    @IBOutlet weak var whereTxtLabel: UITextField!
    @IBOutlet weak var studyTxtLabel: UITextField!
    @IBOutlet weak var todayTxtLabel: UITextField!
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var findOnTheMap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    @IBAction func findOnMapButton(sender: AnyObject) {
        
        //Initialize geocoder
        var geocoder = CLGeocoder()
        
        //Get value inserted
        var address = userLocation.text
        
        //try to find
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            println(error)
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                //Hide elements for find on the map
                self.switchDisplays()
                
                //Show map and url
                let lat = CLLocationDegrees(placemark.location.coordinate.latitude)
                let long = CLLocationDegrees(placemark.location.coordinate.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                //Set a region so that we can zoom into it
                var span = MKCoordinateSpanMake(0.075, 0.075)
                var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
                self.userLocationMapView.setRegion(region, animated: true)
                
                //Add pin
                self.userLocationMapView.addAnnotation(annotation)

                
            } else {
                
                self.alertError("Unable to find \(address).")
            }
            
        })
    }
    
    @IBAction func submitInfoButton(sender: AnyObject) {
     
        if urlTextField.hasText() {
            println("Post location!")
            
            //Reload data
            
            //Display modal
            
        } else {
            self.alertError("A URL is required.")
        }
        
    }
    
    func switchDisplays(){
        
        //Flip the switch
        whereTxtLabel.hidden = !whereTxtLabel.hidden
        studyTxtLabel.hidden = !studyTxtLabel.hidden
        todayTxtLabel.hidden = !todayTxtLabel.hidden
        findOnTheMap.hidden = !findOnTheMap.hidden
        
        urlTextField.hidden = !urlTextField.hidden
        submitInfoButton.hidden = !submitInfoButton.hidden
        userLocationMapView.hidden = !userLocationMapView.hidden
        
    }
    


}


