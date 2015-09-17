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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add navigation buttons
        customizeNavBar()
        
        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
      
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startMap()
        
    }
    
    func startMap(){
        //Start activity indicator
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
        
        //Grab data from parse about students
        if let locations = ParseClient.sharedInstance().studentInfo {
            
            self.addToMap(locations)
            
        } else {
            
            ParseClient.sharedInstance().getStudentInfoFromParse() { (success, studentInfo, errorString) in
                
                if success {
                    
                    self.addToMap(studentInfo)
                    
                } else {
                    
                    println("Didn't get it")
                    
                }
                
            }
        }
        
        self.activityIndicator.alpha = 0.0
        self.activityIndicator.stopAnimating()
    }
    
    func addToMap(studentInfo:[StudentInformation]?) {
        
        var annotations = [MKPointAnnotation]()
        
        if let locations = studentInfo {
            
            for info in locations {
                
                //Our GEO related items
                let lat = CLLocationDegrees(info.latitude)
                let long = CLLocationDegrees(info.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                //User info
                let first = info.firstName
                let last = info.lastName
                let mediaURL = info.mediaURL
                
                //Create our annotation with everything
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(annotations)
            }
            
        } else {
            println("Unable to unwrap studentInfo")
        }
        
    }
    
    //Create a view with the callout accessory view
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Green
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //Respond to taps
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control == annotationView.rightCalloutAccessoryView {
            
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
            
        }
    }
    
}
