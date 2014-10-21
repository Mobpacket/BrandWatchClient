//
//  YouTubeClient.swift
//  BrandWatchClient
//
//  Created by AbdurR on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

// CONSTANTS
var clientID = "404415981542-mm1ttug2evkg2je5bhg5fef2bsddkk9a.apps.googleusercontent.com"
var clientSecret = "lQZuQS4OfWGxCIYphaYFFqei"
// Keychain item name for saving the user's authentication information.
var kKeyChainItemName = "BrandWatch Client: YouTube"
var service: GTLServiceYouTubeAnalytics!
var scope = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/yt-analytics.readonly"
var kChannelBrandWatchID = "channel==UC7xk1Zi1q1MnmK-7fXkSzSw"
var kChannelID = "channel==MINE"
var kVideoMetrics = "views,shares,favoritesAdded,likes,comments,averageViewPercentage,annotationClickThroughRate"


class YouTubeClient: GTLServiceYouTubeAnalytics {
    
    class var sharedInstance: YouTubeClient {
        
        struct Static {
        
            static let instance = YouTubeClient()
        }
        
        return Static.instance
    }
    
    func queryVideoList(completion: (videos: [Video]?, error: NSError?) -> ()) {
        
        var dataService = GTLServiceYouTube()
        dataService.authorizer = self.authorizer
        
        //var videoQuery = GTLQueryYouTube.queryForVideosListWithPart("id,snippet") as GTLQueryYouTube
        
        
        var channelQuery = GTLQueryYouTube.queryForChannelsListWithPart("contentDetails") as GTLQueryYouTube!
        channelQuery.mine = true
        channelQuery.maxResults = 50
        
        var videos = [Video]()
        
        var ticket = GTLServiceTicket()
        ticket = dataService.executeQuery(channelQuery, completionHandler: { (ticket: GTLServiceTicket!, object: AnyObject!, error: NSError!) -> Void in
            
            if error == nil {
                println("Channel: \(object)")
                
                var channelResults = object as? GTLYouTubeChannelListResponse!
                
                var channelResult = channelResults?.items()[0] as GTLYouTubeChannel!
                
                var playlistID = channelResult.contentDetails.relatedPlaylists.uploads
                
                var playlistQuery = GTLQueryYouTube.queryForPlaylistItemsListWithPart("snippet") as GTLQueryYouTube
                playlistQuery.playlistId = playlistID
                playlistQuery.maxResults = 50
                
                var ticket = GTLServiceTicket()
                ticket = dataService.executeQuery(playlistQuery, completionHandler: { (ticket: GTLServiceTicket!, object: AnyObject!, error: NSError!) -> Void in
                    
                    if error == nil {
                        println("Playlist: \(object)")
                        
                        var playlistResults = object as? GTLYouTubePlaylistItemListResponse

                        var playlistResultCount = playlistResults?.pageInfo.totalResults.integerValue as Int!
                        
                        for var index = 0; index < playlistResultCount; ++index {

                            var videoResult = playlistResults?.items()[index] as GTLYouTubePlaylistItem
                        
                            var video = Video(dictionary: NSDictionary())
                            
                            video.video_id        = videoResult.identifier
                            video.name            = videoResult.snippet.title
                            video.summary         = videoResult.snippet.description
                            video.channel_id      = videoResult.snippet.channelId
                            
                            var thumbnails        = videoResult.snippet.thumbnails as GTLYouTubeThumbnailDetails!
                            var thumbnail         = thumbnails.high as GTLYouTubeThumbnail!
                            video.thumbnailUrl    = thumbnail.url
                            video.thumbnailWidth  = thumbnail.width.integerValue as Int
                            video.thumbnailHeight = thumbnail.height.integerValue as Int

                            var x = 5 as NSNumber!
                            
                            videos.append(video)
                        }
                    

                
                        completion(videos: videos, error: error)
                    }
                    else {
                        println("VideoList Error: \(error)")
                        
                        completion(videos: nil, error: error)
                    }
            
                })
            }
            
        })

    }
    
    func queryVideoMetricsWithParams(video_id: Video?, start_date: String?, end_date: String?, completion: (metrics: Metrics?, error: NSError?) -> ()) {
        
        var videoMetrics = Metrics(dictionary: NSDictionary())
        
        var newQuery: GTLQueryYouTubeAnalytics = GTLQueryYouTubeAnalytics.queryForReportsQueryWithIds(kChannelID, startDate: start_date, endDate: end_date, metrics: kVideoMetrics) as GTLQueryYouTubeAnalytics
        
        newQuery.filters = "video==\(video_id!.video_id!)"
        
        var ticket = GTLServiceTicket()
        ticket = self.executeQuery(newQuery, completionHandler: { (ticket: GTLServiceTicket!, object: AnyObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                println("Analytics: \(object)")
                
                var results = object as GTLYouTubeAnalyticsResultTable
                
                var columns = results.columnHeaders
                
                var rows = results.rows as NSArray
                println("column: \(columns), rows: \(rows)")
                
                for (index, column) in enumerate(columns) {
                    
                    var columnHeader = column as GTLYouTubeAnalyticsResultTableColumnHeadersItem
                    
                    println("Name: \(columnHeader.name), Index: \(index) Value: \(rows[0].objectAtIndex(index))")

                    // Retrieve single row of data (first row)
                    var row = rows[0] as NSArray
                    
                    switch(columnHeader.name) {
                        case "views":
                            videoMetrics.views = row.objectAtIndex(index) as? Int
                        case "shares":
                            videoMetrics.shares = row.objectAtIndex(index) as? Int
                        case "favoritesAdded":
                            videoMetrics.favorites = row.objectAtIndex(index) as? Int
                        case "likes":
                            videoMetrics.likes = row[index] as? Int
                        case "comments":
                            videoMetrics.comments = row[index] as? Int
                        case "averageViewPercentage":
                            var vtr_float = row[index] as Float
                            var vtr_val = vtr_float.format(".1")
                            videoMetrics.vtr = vtr_val
                        case "annotationClickThroughRate":
                            var ctr_float = row[index] as Float
                            var ctr_val = ctr_float.format(".1")
                            videoMetrics.ctr = ctr_val
                        default:
                            println("Do nothing")
                    }
                }
                
                completion(metrics: videoMetrics, error: nil)
            }
                
            else {

                println("Analytics Error: \(error)")
                
                completion(metrics: nil, error: error)
            }
        })
    }
    
    func queryDailyVideoMetricsWithParams(video_id: Video?, start_date: String?, end_date: String?, completion: (metrics_daily: [Metrics], error: NSError?) -> () ) {
        
        // Check if the end_date is earlier or later than today. If later than today, use today
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let today = NSDate()
//        let endDate = dateFormatter.dateFromString(end_date!)
//        var dateComparisionResult:NSComparisonResult = today.compare(endDate!)
//        if dateComparisionResult == NSComparisonResult.OrderedAscending
//        {
//            // Current date is smaller than end date.
//            //endDateStr = dateFormatter.stringFromDate(today)
//            println("Today: \(end_date)")
//        }
        
        var metricsDaily : [Metrics] = []
        
        var videoMetrics = Metrics(dictionary: NSDictionary())
        
        var newQuery: GTLQueryYouTubeAnalytics = GTLQueryYouTubeAnalytics.queryForReportsQueryWithIds(kChannelID, startDate: start_date, endDate: end_date, metrics: kVideoMetrics) as GTLQueryYouTubeAnalytics
        
        newQuery.filters = "video==\(video_id!.video_id!)"
        newQuery.dimensions = "day"
        println("Query: \(newQuery)")
        
        var ticket = GTLServiceTicket()
        ticket = self.executeQuery(newQuery, completionHandler: { (ticket: GTLServiceTicket!, object: AnyObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                println("Analytics: \(object)")
                
                var results = object as GTLYouTubeAnalyticsResultTable
                
                var columns = results.columnHeaders
                var rows = results.rows as NSArray
                var dayStr : String!
                println("column: \(columns), rows: \(rows)")
                
                for row in rows {
                    
                    videoMetrics = Metrics(dictionary: NSDictionary())
                    
                    for (index, column) in enumerate(columns) {
                        
                        var columnHeader = column as GTLYouTubeAnalyticsResultTableColumnHeadersItem
                        
                        println("Name: \(columnHeader.name), Index: \(index) Value: \(row.objectAtIndex(index))")
                        
                        //var row = rows[0] as NSArray
                        
                        switch(columnHeader.name) {
                        case "views":
                            videoMetrics.views = row.objectAtIndex(index) as? Int
                        case "shares":
                            videoMetrics.shares = row.objectAtIndex(index) as? Int
                        case "favoritesAdded":
                            videoMetrics.favorites = row.objectAtIndex(index) as? Int
                        case "likes":
                            videoMetrics.likes = row.objectAtIndex(index) as? Int
                        case "comments":
                            videoMetrics.comments = row.objectAtIndex(index) as? Int
                        case "averageViewPercentage":
                            videoMetrics.vtr = row.objectAtIndex(index) as? String
                        case "annotationClickThroughRate":
                            videoMetrics.ctr = row.objectAtIndex(index) as? String
                        case "day":
                            //dayStr = row.objectAtIndex(index) as? String
                            //let index1: String.Index = advance(dayStr.startIndex, 8)
                            // var strday = dayStr.substringFromIndex(index1)
                            videoMetrics.dateStr = row.objectAtIndex(index) as? String
                            videoMetrics.date = dateFormatter.dateFromString(videoMetrics.dateStr!)
                        default:
                            println("Do nothing")
                        }
                    }
                    
                    metricsDaily.insert(videoMetrics, atIndex: 0)
                    
                }
                
                metricsDaily.sort {
                    item1, item2 in
                    let date1 = item1.date! as NSDate
                    let date2 = item2.date! as NSDate
                    return date1.compare(date2) == NSComparisonResult.OrderedAscending
                }
                
                println("before completion: \(metricsDaily)")
                
                completion(metrics_daily: metricsDaily, error: nil)
            }
                
            else {
                
                println("Daily Analytics Error: \(error)")
                
                completion(metrics_daily: [], error: error)
            }
        })
        
        
        
    }
}
