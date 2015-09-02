//
//  ParseConvenience.swift
//  onthemap
//
//  Created by Gil Ferreira on 9/1/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentInfoFromParse(completionHandler: (success: Bool, studentInfo: [StudentInformation]?, errorString: String?) -> Void) {
        
        taskForGETMethod(Methods.StudentLocations) {
            JSONResult, error in
            
            if let error = error {
                
                completionHandler(success: false, studentInfo: nil, errorString: error)
                
            } else {
                
                //Convert json
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.Results) as? [[String : AnyObject]] {
                  
                    var studentInfo = StudentInformation.studentLocationsFromResults(results)
                    self.studentInfo = studentInfo
                    
                    println(self.studentInfo)
                    completionHandler(success: true, studentInfo: studentInfo, errorString: error)
                    
                } else {
                    
                    completionHandler(success: false, studentInfo: nil, errorString: "Could not retrieve results")
                }
            
            }
            
        }
    }
    
    
    
   }
