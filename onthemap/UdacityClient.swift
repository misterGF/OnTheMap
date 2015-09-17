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
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var lat: Double
    var lng: Double
    
    override init() {
        session = NSURLSession.sharedSession()
        userKey = ""
        sessionID = ""
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        lat = 0.0
        lng = 0.0
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
                
                completionHandler(result: response , error: "Network error detected.")
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
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let url: String = Constants.BaseURL + method
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "GET"
 
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                
                completionHandler(result: response , error: "Network error detected.")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
    
             if let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
                    
                    completionHandler(result: parsedResult, error: nil)
                    
            } else {
                    
                completionHandler(result: nil, error: "Unable to get data")
                    
            }
        
        }
        
        task.resume()
        
        return task
        
    }
    
    //DELETEs
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let url: String = Constants.BaseURL + method
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            
        }
        
        if let xsrfCookie = xsrfCookie {
            
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
            
        }
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                
                completionHandler(result: response , error: "Network error detected.")
                return
                
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            completionHandler(result: newData, error: nil)
            
        }
 
        
        task.resume()
        
        return task
    }
    
    //Singleton
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}