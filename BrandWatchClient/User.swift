//
//  User.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var auth_id: String?            // Authorization ID
    var name: String?               // User Name
    var email: String?              // User Email
    var campaign_ids: NSArray?      // Array Campaign IDs
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        auth_id = dictionary["auth_id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        campaign_ids = dictionary["campaign_ids"] as? NSArray
    }
}
