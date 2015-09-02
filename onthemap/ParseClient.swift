//
//  ParseClient.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/24/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session: NSURLSession
    var studentInfo: [StudentInformation]?
    
    override init(){
        
        session = NSURLSession.sharedSession()
        super.init()
        
    }

    //Get
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
    
        let url: String = Constant.baseURL + method
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var jsonifyError: NSError? = nil
    
        request.HTTPMethod = "GET"
        request.addValue(Constant.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
  
    
        let session = NSURLSession.sharedSession()
    
        let task = session.dataTaskWithRequest(request) { data, response, error in
    
            if error != nil { // Handle error…
    
                completionHandler(result: response , error: "Network error detected.")
                return
            }
    
    
            //Serial data
            if let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
    
                //Check if response has a status. If so. Let's report back the status. Most likely network error.
                if let status = parsedResult[ParseClient.JSONResponseKeys.Error] as? String  {
    
                    completionHandler(result: parsedResult, error: status)
    
                } else {
    
                    completionHandler(result: parsedResult, error: nil)
    
                }
            }
        }
    
        task.resume()
    
        return task

    }
    
    //Post
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let url: String = Constant.baseURL + method
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constant.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                
                completionHandler(result: response , error: "Network error detected.")
                return
            }
            
            
            //Serial data
            if let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
                
                println(parsedResult)
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
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }

}