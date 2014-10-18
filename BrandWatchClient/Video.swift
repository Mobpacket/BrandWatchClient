//
//  Video.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var video_id: String?           // Video ID
    var name: String?               // Video Name
    var summary: String?            // Video Description
    var metrics_total: Metrics?     // Aggregated summary of video metrics
    var metrics_daily: Dictionary <NSDate, Metrics>? // Aggregated dictionary of daily video metrics
    var dictionary: NSDictionary?   // Serialized data model
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        video_id = dictionary["video_id"] as? String
        name = dictionary["name"] as? String
        summary = dictionary["summary"] as? String
        metrics_total = dictionary["metrics_total"] as? Metrics
        metrics_daily = dictionary["metrics_daily"] as? Dictionary
    }
}
