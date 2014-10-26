//
//  DataProcessor.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/25/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

enum MetricTypeEnum {
    case Views, Likes, Favorites, Comments
}

class DataProcessor: NSObject {
    
    class func getMetricDailyData(campaign: Campaign, type: MetricTypeEnum) -> [Int] {
        
        var data = [Int]()
        
        for metrics in campaign.metrics_daily! {
            
            switch type {
                
            case .Views:
                var viewCount = metrics.views == nil ? 0 : metrics.views
                data.append(viewCount!)
            case .Likes:
                var likeCount = metrics.likes == nil ? 0 : metrics.likes
                data.append(likeCount!)
            case .Favorites:
                var favoriteCount = metrics.favorites == nil ? 0 : metrics.favorites
                data.append(favoriteCount!)
            case .Comments:
                var commentCount = metrics.comments == nil ? 0 : metrics.comments
                data.append(commentCount!)
            }
        }
        
        return data
    }
}

