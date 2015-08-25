//
//  UdacityClient.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/24/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject {
    
    var session: NSURLSession
    var userKey: String
    var sessionID: String
    
    override init() {
        session = NSURLSession.sharedSession()
        userKey = ""
        sessionID = ""
        super.init()
    }
    
    //POSTs
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
 
        let url: String = Constants.BaseURL + method
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
  
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                
                // TODO
                println("Implement alerts view controller for failed connection vs wrong creds")
                return
                
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            //Serial data 
            if let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
                
                //Check if response has a status. If so. Let's report back the status. Most likely network error.
                if var status: Int = parsedResult["status"] as? Int  {
                    
                    completionHandler(result: parsedResult, error: parsedResult["error"] as? String)
                    
                
                } else {
                
                    completionHandler(result: parsedResult, error: nil)
                
                }
            }
            
            
        }
        
        task.resume()
        
        return task
    }
    
    
    //GETs
    
    
    //Singleton
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}