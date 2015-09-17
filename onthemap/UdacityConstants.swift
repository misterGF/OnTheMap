//
//  UdacityConstants.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/24/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        //FB info
        static let fbAppId: String = "365362206864879"
        
        //URLs
        static let BaseURL: String = "https://www.udacity.com/api/"
    }
    
    struct ParameterKeys {
        
        static let Udacity: String = "udacity"
        static let Username: String = "username"
        static let Password:String = "password"
        static let Facebook:String = "facebook_mobile"
        static let AccessToken:String = "access_token"
    }
    
    struct Methods {
        
        static let Session: String = "session"
        static let UserData: String = "users/{id}"
    }
    
    struct JSONResponseKeys {
        
        static let Session: String = "session"
        static let SessionID: String = "id"
        static let Account: String = "account"
        static let Key: String = "key"
        static let User: String = "user"
        static let FirstName: String = "nickname"
        static let LastName: String = "last_name"
        
    }
    
}