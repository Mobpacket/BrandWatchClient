//
//  Campaign.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class Campaign: NSObject {
    
    var name: String?               // Campaign Name
    var quartile25Count: Int?       // Count for 25% viewing completion rate
    var quartile50Count: Int?       // Count for 50% viewing completion rate
    var quartile75Count: Int?       // Count for 75% viewing completion rate
    var quartile100Count: Int?      // Count for 100% viewing completion rate
    var score: Int?                 // Engagement Score
    var vtr: Int?                // View Through Rate (VTR)
    var ctr: Int?                // Click Through Rate (CTR)
    var shares: Int?                // Social Shares (LinkedIn, Twitter, Facebook, etc.)
    var tweets: Int?                // Twitter Tweets
    var likes: Int?                 // Facebook Likes
    var comments: Int?              // YouTube Comment Count
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        quartile25Count = dictionary["q25"] as? Int
        quartile50Count = dictionary["q50"] as? Int
        quartile75Count = dictionary["q75"] as? Int
        quartile100Count = dictionary["q100"] as? Int
        score = dictionary["score"] as? Int
        vtr = dictionary["vtr"] as? Int
        ctr = dictionary["ctr"] as? Int
        shares = dictionary["shares_count"] as? Int
        tweets = dictionary["tweet_count"] as? Int
        likes = dictionary["likes_count"] as? Int
        comments = dictionary["comments_count"] as? Int
    }
}
