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
    var vtr: Float?                   // View Through Rate (VTR) value
    var ctr: Float?                   // Click Through Rate (CTR) value
    var views: Int?                 // Views
    var shares: Int?                // Social Shares (LinkedIn, Twitter, Facebook, etc.) value
    var favorites: Int?             // YouTube Favorites value
    var likes: Int?                 // Facebook Likes value
    var comments: Int?              // YouTube Comment Count value
    var dictionary: NSDictionary?   // Serialized data model
    var dateStr: String?            // The Date String of metrics. Only used in daily metrics. Ignore for total metrics
    var date: NSDate?               // The Date of the Metrics, used for sorting. Only used in daily metrics

    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        score = dictionary["score"] as? Int
        vtr = dictionary["vtr"] as? Float
        ctr = dictionary["ctr"] as? Float
        views = dictionary["views"] as? Int
        shares = dictionary["shares_count"] as? Int
        favorites = dictionary["favorites_count"] as? Int
        likes = dictionary["likes_count"] as? Int
        comments = dictionary["comments_count"] as? Int
        dateStr = dictionary["date_string"] as? String
        date = dictionary["date"] as? NSDate
    }
    
    func addMetrics(metrics: Metrics) {
        
        if self.score != nil {
            self.score! += metrics.score!
        } else {
            self.score = metrics.score
        }

        if self.views != nil {
            self.views! += metrics.views!
        } else {
            self.views = metrics.views
        }
        
        if self.shares != nil {
            self.shares! += metrics.shares!
        } else {
            self.shares = metrics.shares
        }
        
        if self.favorites != nil {
            self.favorites! += metrics.favorites!
        } else {
            self.favorites = metrics.favorites
        }

        if self.likes != nil {
            self.likes! += metrics.likes!
        } else {
            self.likes = metrics.likes
        }
        
        if self.likes < 0 {
            println("likes is negative")
        }

        if self.comments != nil {
            self.comments! += metrics.comments!
        } else {
            self.comments = metrics.comments
        }

        
    }
}
