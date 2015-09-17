//
//  UdacityConvenience.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/24/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    func authenticateWithViewController(userCredentials: [String: AnyObject], parameterKey: String!, completionHandler: (success: Bool, errorString: String?) -> Void){
    
        self.getSession(userCredentials, parameterKey: parameterKey) { (success, sessionID, userKey, errorString) in
            
            if success {
                
                //Completed successfully!
                self.sessionID = sessionID!
                self.userKey = userKey!
                
                completionHandler(success: true, errorString: nil)
                
            } else {
                
                //Failed. Lets update our view
                completionHandler(success: false, errorString: errorString)
            }
        }
        
    }

    func getSession(usernameCredentials: [String: AnyObject], parameterKey: String!, completionHandler: (success: Bool, sessionID: String?, userKey: String?, errorString: String?) -> Void){
        
        //Setup jsonBody
        var jsonBody = [parameterKey : usernameCredentials]
        
        //Submit to POST method
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) {
            JSONResult, error in
            
            //Check for errors
            if let error = error {

                completionHandler(success: false, sessionID: nil, userKey: nil, errorString: error)
            
            } else {
                
                //Try grabbing the sessionID
                if let session: AnyObject = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.Session) {
                    
                    let sessionID = session.valueForKey(UdacityClient.JSONResponseKeys.SessionID) as! String
                    
                    //Try grabbing the usrekey
                    if let account: AnyObject = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.Account) {
                        
                        let userKey = account.valueForKey(UdacityClient.JSONResponseKeys.Key) as! String
                        
                        completionHandler(success: true, sessionID: sessionID, userKey: userKey, errorString: nil)
                        
                    } else {
                        
                        completionHandler(success: true, sessionID: sessionID, userKey: nil, errorString: nil)
                    }
    
                } else {
                    
                    completionHandler(success: false, sessionID: nil, userKey: nil, errorString: error)
                    
                }
            }
            
        }
        
    }
    
    func getUserData(completionHandler: (success:Bool, errorString: String?) -> Void){
        
        //Construct URL with userkey
        var userSlug = Methods.UserData.stringByReplacingOccurrencesOfString("{id}", withString: self.userKey, options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //Submit to GET method
        taskForGETMethod(userSlug) {
            JSONResult, error in
 
            if let error = error {
                
                completionHandler(success: false, errorString: error)
            
            } else {
                
                //Grab the json value
                if let userResponse : AnyObject = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.User) {
                    
                    //Fill in Udacity values
                    self.firstName = userResponse.valueForKey(UdacityClient.JSONResponseKeys.FirstName) as! String
                    
                    self.lastName = userResponse.valueForKey(UdacityClient.JSONResponseKeys.LastName) as! String
                    
                    
                    //Send a successful message
                    completionHandler(success: true, errorString: nil)
                    
                    
                } else {
                    
                    completionHandler(success: false, errorString: "Unable to get user data")
                    
                }
                
            }
            
        }
        
        
    }
    
    func logoutOfUdacity(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        taskForDELETEMethod(Methods.Session) {
            JSONResult, error in
            
            //Check for errors
            if let error = error {
                
                completionHandler(success: false, errorString: error)
                
            } else {
                
                completionHandler(success: true, errorString: nil)
                
            }
           
        }
    
    }
}
