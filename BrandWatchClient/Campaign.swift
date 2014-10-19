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
    var user_id: String?            // User ID
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
    
    private var pfObject: PFObject?   // Serialized data model
    
    init(object: PFObject) {
        
        self.pfObject = object
        
        id = object["id"] as? String
        user_id = object["user_id"] as? String
        name = object["name"] as? String
        start = object["start_date"] as? NSDate
        end = object["end_date"] as? NSDate
    
        score = object["score"] as? Int
        vtr_target = object["vtr_target"] as? Int
        ctr_target = object["ctr_target"] as? Int
        shares_target = object["shares_target"] as? Int
        favorites_target = object["favorites_target"] as? Int
        likes_target = object["likes_target"] as? Int

        video_ids = object["video_ids"] as? NSArray
    }
    
    func getPFObject() -> PFObject {
        if(self.pfObject == nil) {
            self.pfObject = PFObject()
        }
        
        if let id = self.id? {
            self.pfObject?["id"] = id
        }
        
        if let user_id = self.user_id? {
            self.pfObject?["user_id"] = user_id
        }
        
        if let name = self.name? {
            self.pfObject?["name"] = name
        }
        
        if let start = self.start? {
            self.pfObject?["start"] = start
        }
        
        if let score = self.score? {
            self.pfObject?["score"] = score
        }
        
        if let vtr_target = self.vtr_target? {
            self.pfObject?["vtr_target"] = vtr_target
        }
        
        if let ctr_target = self.ctr_target? {
            self.pfObject?["ctr_target"] = ctr_target
        }
        
        if let shares_target = self.shares_target? {
            self.pfObject?["shares_target"] = shares_target
        }
        
        if let favorites_target = self.favorites_target? {
            self.pfObject?["favorites_target"] = favorites_target
        }
        
        if let likes_target = self.likes_target? {
            self.pfObject?["likes_target"] = likes_target
        }
        
        if let video_ids = self.video_ids? {
            self.pfObject?["video_ids"] = video_ids
        }
        
        return self.pfObject!
        
    }
    
}
