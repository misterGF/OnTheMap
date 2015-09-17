//
//  viewHelper.swift
//  onthemap
//
//  Created by Gil Ferreira on 9/10/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension UIViewController {
    
    //Function for setting our nav bar
    func customizeNavBar() {
        
        //Add navigation buttons
        var rightRefreshButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshBtnClicked:")
        var rightLocationButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin")!, style: UIBarButtonItemStyle.Plain, target: self, action: "startEnterLocation:")
        var leftLogoutButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutUser:")
        
        navigationItem.setRightBarButtonItems([rightRefreshButtonItem,rightLocationButtonItem], animated: true)
        navigationItem.setLeftBarButtonItem(leftLogoutButtonItem, animated: true)
        
    }
    
    func refreshBtnClicked(sender: UIBarButtonItem) {
        
        refreshParseData()
    }
    
    func refreshParseData() {
        
        //Reload data by clearing out the locations and calling the mapview controller
        ParseClient.sharedInstance().studentInfo = nil
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AppTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: false, completion: nil)
            
        })
    }
    
    func startEnterLocation(sender: UIBarButtonItem) {
        
        //Segue to gotoPostView
        self.performSegueWithIdentifier("gotoPostView", sender: self)
    }
    
    func logoutUser(sender: UIBarButtonItem) {
      println("Logout")
        
        UdacityClient.sharedInstance().logoutOfUdacity() {
            (success, errorString) in
            
            if success {
                
                //Logout of FB if logged in
                if (FBSDKAccessToken.currentAccessToken() !== nil)
                {
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    println("Logout of FB")
                }
                
                //Segue to beginning
                self.completedLogout()
            }
            else {
                //Alert of failure
                self.alertError(errorString)
            }
        
        }
    }
    
    func completedLogin(){
        
        //Reset value on login to make sure we refresh when a new login happens
        ParseClient.sharedInstance().studentInfo = nil
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AppTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            
        })
        
        //Grab user data and save it
        UdacityClient.sharedInstance().getUserData(){ success, error in
            
            if success {
                println("Got user data!")
            } else {
                println("Failed", error)
            }
            
        }
        
    }

    func completedLogout(){
        
        dispatch_async(dispatch_get_main_queue(), {
            
             self.performSegueWithIdentifier("logOutSegue", sender: self)
            
        })
        
    }
    
    func alertError(errorString: String?){
        
        let alertController = UIAlertController(title: "Error Detected", message:
            errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

}