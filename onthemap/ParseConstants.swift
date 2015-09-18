//
//  ParseConstants.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/31/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constant {
        
        //URLs
        static let baseURL: String = "https://api.parse.com/1/classes/"
        
        //Parse app id and key
        static let application_id: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let api_key: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    }
    
    struct Methods {
        
        static let StudentLocations = "StudentLocation"
        
    }
    
    struct JSONResponseKeys {
    
        static let FirstName: String = "firstName"
        static let LastName: String = "lastName"
        static let Latitude: String = "latitude"
        static let Longitude: String = "longitude"
        static let MapString: String = "mapString"
        static let MediaURL: String = "mediaURL"
        static let ObjectId: String = "objectId"
        static let UniqueKey: String = "uniqueKey"
        static let Results: String = "results"
        static let Error: String = "error"
        static let UpdateAt: String = "updatedAt"

    }
}