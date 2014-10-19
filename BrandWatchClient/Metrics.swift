//
//  Metrics.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class Metrics: NSObject {

    /* YouTube Analytics Metrics
     *
     * VTR: averageViewPercentage
     * CTR: annotationClickThroughRate
     * shares: shares
     * favorites: favorites
     * likes: likes
     * comments: comments
     */
    var score: Int?                 // Engagement Score
    var vtr: Int?                   // View Through Rate (VTR) value
    var ctr: Int?                   // Click Through Rate (CTR) value
    var views: Int?                 // Views
    var shares: Int?                // Social Shares (LinkedIn, Twitter, Facebook, etc.) value
    var favorites: Int?             // YouTube Favorites value
    var likes: Int?                 // Facebook Likes value
    var comments: Int?              // YouTube Comment Count value
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        score = dictionary["score"] as? Int
        vtr = dictionary["vtr"] as? Int
        ctr = dictionary["ctr"] as? Int
        views = dictionary["views"] as? Int
        shares = dictionary["shares_count"] as? Int
        favorites = dictionary["favorites_count"] as? Int
        likes = dictionary["likes_count"] as? Int
        comments = dictionary["comments_count"] as? Int
    }
}
