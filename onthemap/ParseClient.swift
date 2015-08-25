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
    
    override init(){
        
        session = NSURLSession.sharedSession()
        super.init()
        
    }
}