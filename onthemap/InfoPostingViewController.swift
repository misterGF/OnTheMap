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

class InfoPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    var appDelegate: AppDelegate!
    var session : NSURLSession!
    var lat:Double!
    var lng:Double!
    var address:String!
    
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitInfoButton: UIButton!
    @IBOutlet var userLocationMapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        
        //Setup delegates to dismiss keyboard
        userLocation.delegate = self
        urlTextField.delegate = self
  
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func cancelButton(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    @IBAction func findOnMapButton(sender: AnyObject) {
        
        //Initialize geocoder
        var geocoder = CLGeocoder()
        
        //Get value inserted
        address = userLocation.text
        
        //Start loader
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
        
        //try to find
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            println(error)
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                //Hide elements for find on the map
                self.switchDisplays()
                
                //Show map and url
                let lat = CLLocationDegrees(placemark.location.coordinate.latitude)
                let long = CLLocationDegrees(placemark.location.coordinate.longitude)
                
                //Save values to Udacity client
                UdacityClient.sharedInstance().lat = lat
                UdacityClient.sharedInstance().lng = long
                UdacityClient.sharedInstance().mapString = self.address
                
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
                
                self.alertError("Unable to find \(self.address).")
            }
            
        })
        
        //Stop loader
        self.activityIndicator.alpha = 0.0
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func submitInfoButton(sender: AnyObject) {
     
        if urlTextField.hasText() {
            println("Post location!")
            
            var userLocation: [String:AnyObject] = [
                ParseClient.JSONResponseKeys.UniqueKey : UdacityClient.sharedInstance().userKey,
                ParseClient.JSONResponseKeys.FirstName : UdacityClient.sharedInstance().firstName,
                ParseClient.JSONResponseKeys.LastName : UdacityClient.sharedInstance().lastName,
                ParseClient.JSONResponseKeys.MapString : address,
                ParseClient.JSONResponseKeys.MediaURL : urlTextField.text,
                ParseClient.JSONResponseKeys.Latitude : UdacityClient.sharedInstance().lat,
                ParseClient.JSONResponseKeys.Longitude : UdacityClient.sharedInstance().lng
            ]
            
            ParseClient.sharedInstance().postStudentInfo(userLocation) {
                (success, errorstring) in
                
                if success {
                  println("Success")
                    self.refreshParseData()
                    
                 // self.dismissViewControllerAnimated(false, completion: nil)
                } else {
                    println("Failed : \(errorstring)")
                }
                
            }

            
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


