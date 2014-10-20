//
//  YouTubeClient.swift
//  BrandWatchClient
//
//  Created by AbdurR on 10/18/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

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
    
    func queryVideoMetricsWithParams(video_id: Video?, start_date: String?, end_date: String?, completion: (metrics: Metrics?, error: NSError?) -> ()) {
        
        var videoMetrics = Metrics(dictionary: NSDictionary())
        
        var newQuery: GTLQueryYouTubeAnalytics = GTLQueryYouTubeAnalytics.queryForReportsQueryWithIds(kChannelID, startDate: start_date, endDate: end_date, metrics: kVideoMetrics) as GTLQueryYouTubeAnalytics
        
        newQuery.filters = "video==\(video_id!.video_id!)"
        println("Query: \(newQuery)")
        
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
    
    func queryDailyVideoMetricsWithParams(video_id: Video?, start_date: String?, end_date: String?, completion: [Metrics]?, errros: NSError?) -> () {
        
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
