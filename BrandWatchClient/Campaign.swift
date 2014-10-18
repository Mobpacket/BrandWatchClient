//
//  Campaign.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class Campaign: NSObject {
    
    var id: String?                 // Campaign ID
    var name: String?               // Campaign Name
    var start: NSDate?              // Start Date
    var end: NSDate?                // End Date
    
    // NAJ: To be removed
    var quartile25Count: Int?       // Count for 25% viewing completion rate
    var quartile50Count: Int?       // Count for 50% viewing completion rate
    var quartile75Count: Int?       // Count for 75% viewing completion rate
    var quartile100Count: Int?      // Count for 100% viewing completion rate
    
    var score: Int?                 // Engagement Score
    var vtr_target: Int?            // View Through Rate (VTR) target
    var ctr_target: Int?            // Click Through Rate (CTR) target
    var shares_target: Int?         // Social Shares (LinkedIn, Twitter, Facebook, etc.) target
    var favorites_target: Int?      // YouTube Favorites target
    var likes_target: Int?          // Facebook Likes target
    var comments_target: Int?       // YouTube Comment Count target

    var video_ids: NSArray?         // Video IDs part of the campaign
    var metrics_total: Metrics?     // Aggregated campaign metrics values
    var metrics_daily: Dictionary <NSDate, Metrics>? // Aggregated dictionary of daily metrics
    
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        start = dictionary["start_date"] as? NSDate
        end = dictionary["end_date"] as? NSDate
    
        // NAJ: To be removed
        quartile25Count = dictionary["q25"] as? Int
        quartile50Count = dictionary["q50"] as? Int
        quartile75Count = dictionary["q75"] as? Int
        quartile100Count = dictionary["q100"] as? Int
        
        score = dictionary["score"] as? Int
        vtr_target = dictionary["vtr_target"] as? Int
        ctr_target = dictionary["ctr_target"] as? Int
        shares_target = dictionary["shares_target"] as? Int
        favorites_target = dictionary["favorites_target"] as? Int
        likes_target = dictionary["likes_target"] as? Int

        video_ids = dictionary["video_ids"] as? NSArray
        
        metrics_total = dictionary["metrics_total"] as? Metrics
        metrics_daily = dictionary["metrics_daily"] as? Dictionary
    }
}
