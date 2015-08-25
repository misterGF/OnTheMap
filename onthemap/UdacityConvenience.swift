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
    
    func authenticateWithViewController(userCredentials: [String: AnyObject], completionHandler: (success: Bool, ErrorString: String?) -> Void){
    
        self.getSession(userCredentials) { (success, sessionID, userKey, errorString) in
            
            if success {
                
                //Completed successfully!
                self.sessionID = sessionID!
                self.userKey = userKey!
                
                println("Fix user key and segue from here!")
                
            } else {
                
                //Failed. Lets update our view
                completionHandler(success: success, ErrorString: errorString)
            }
        }
        
    }

    func getSession(usernameCredentials: [String: AnyObject], completionHandler: (success: Bool, sessionID: String?, userKey: String?, errorString: String?) -> Void){
        
        //Setup jsonBody
        var jsonBody = [UdacityClient.ParameterKeys.Udacity : usernameCredentials]
        
        //Submit to post method
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
                    if let userKey = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.Account) as? String {
                        
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
}
