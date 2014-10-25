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
    var start: String?              // Start Date
    var end: String?                // End Date
    
    var score: Int?                 // Engagement Score
    var vtr_target: Float?          // View Through Rate (VTR) target
    var ctr_target: Float?          // Click Through Rate (CTR) target
    var views_target: Int?          // Views target
    var shares_target: Int?         // Social Shares (LinkedIn, Twitter, Facebook, etc.) target
    var favorites_target: Int?      // YouTube Favorites target
    var likes_target: Int?          // Facebook Likes target
    var comments_target: Int?       // YouTube Comment Count target

    var video_ids: [String]?         // Video IDs part of the campaign
    var metrics_total: Metrics?     // Aggregated campaign metrics values
    var metrics_daily: [Metrics]? // Aggregated dictionary of daily metrics
    
    private var pfObject: PFObject?   // Serialized data model
    
    init(object: PFObject) {
        
        self.pfObject = object
        
        id = object.objectId
        user_id = object["user_id"] as? String
        name = object["name"] as? String
        start = object["start"] as? String
        end = object["end"] as? String
    
        score = object["score"] as? Int
        vtr_target = object["vtr_target"] as? Float
        ctr_target = object["ctr_target"] as? Float
        views_target = object["views_target"] as? Int
        shares_target = object["shares_target"] as? Int
        favorites_target = object["favorites_target"] as? Int
        likes_target = object["likes_target"] as? Int
        comments_target = object["comments_target"] as? Int

        video_ids = object["video_ids"] as? [String]
    }
    
    func isNewRecord() -> Bool {
        return (self.getPFObject().objectId == nil) ? true : false
    }
    
    func getPFObject() -> PFObject {
        if(self.pfObject == nil) {
            self.pfObject = PFObject()
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
        
        if let end = self.end? {
            self.pfObject?["end"] = end
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
        
        if let views_target = self.views_target? {
            self.pfObject?["views_target"] = views_target
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
        
        if let comments_target = self.comments_target? {
            self.pfObject?["comments_target"] = comments_target
        }
        
        if let video_ids = self.video_ids? {
            self.pfObject?["video_ids"] = video_ids
        }
        
        return self.pfObject!
    }
    
}
