//
//  User.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var authId: String?             // Authorization ID
    var name: String?               // User Name
    var email: String?              // User Email
    var activeCampaignId: String?   // Current active campaign
    var campaignIds: NSArray?      // Array Campaign IDs
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        authId = dictionary["auth_id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        activeCampaignId = dictionary["active_campaign_id"] as? String
        campaignIds = dictionary["campaign_ids"] as? NSArray
    }
}
