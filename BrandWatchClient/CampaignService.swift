//
//  CampaignService.swift
//  BrandWatchClient
//
//  Created by Nabib El-RAHMAN on 10/19/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit


class CampaignService: NSObject {
    
    class var sharedInstance: CampaignService {
        
        struct Static {
            
            static let instance = CampaignService()
        }
        
        return Static.instance
    }
    
    var activeCampaign: Campaign?
    var activeWriteCampaign: Campaign?
    
    func newCampaignInstance() -> Campaign {
        return Campaign(object: PFObject())
    }
    
    func setActiveCampaign(campaign: Campaign) {
        self.activeCampaign = campaign
    }
    
    func getActiveCampaign() -> Campaign? {
        return self.activeCampaign
    }

    func setActiveWriteCampaign(campaign: Campaign) {
        self.activeWriteCampaign = campaign
    }
    
    func getActiveWriteCampaign() -> Campaign? {
        return self.activeWriteCampaign
    }

    func getCampaignById(id: String, callback: (campaign: Campaign!, error: NSError!) -> Void) {
        //check the cache
        
        var campaign = TTLCache.sharedInstance.get(id) as? Campaign
        
        if(campaign == nil) {
            ParseClient.getCampaignById(id) {
                (pfCampaign: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    var campaignObj = Campaign(object: pfCampaign)
                    
                    TTLCache.sharedInstance.put(campaignObj, forKey: id)
                    callback(campaign: campaignObj, error: nil)
                } else {
                
                    callback(campaign: nil, error: error)
                }
            }
        } else {
            callback(campaign: campaign, error: nil)
        }
    }
    
    
    func getCampaignTotalMetrics(campaign: Campaign, callback: (campaign: Campaign!, error: NSError!) -> Void) {
        
        var id = campaign.id
        var metricsTotal = TTLCache.sharedInstance.get("\(id).metricsTotal") as? Metrics
        
        if metricsTotal == nil {
        
            var videos = campaign.video_ids as NSArray!
        
            var currentVideo = Video(dictionary: NSDictionary())
        
            for (index, video) in enumerate(videos) {
            
                currentVideo.video_id = video as? String
            
                YouTubeClient.sharedInstance.queryVideoMetricsWithParams(currentVideo, start_date: campaign.start, end_date: campaign.end, completion: { (metrics, error) -> () in
                
                    if error == nil {
                        currentVideo.metrics_total = metrics
                    
                        if campaign.metrics_total == nil {
                            campaign.metrics_total = metrics
                        } else {
                            campaign.metrics_total?.addMetrics(metrics!)
                        }
                    
                        //populate cache
                        TTLCache.sharedInstance.put(metrics, forKey: "\(id).metricsTotal")
                        callback(campaign: campaign, error: nil)
                    }
                    else {
                        callback(campaign: nil, error: error)
                    }
                })
            }
        } else {
            campaign.metrics_total = metricsTotal
            callback(campaign: campaign, error: nil)
            
        }
        
    }
    
    func getCampaignDailyMetrics(campaign: Campaign, callback: (campaign: Campaign!, error: NSError!) -> Void) {
        
        var id = campaign.id
        var metricsDaily = TTLCache.sharedInstance.get("\(id).metricsDaily") as? [Metrics]
        
        if metricsDaily == nil {
            var videos = campaign.video_ids as NSArray!
        
            var currentVideo = Video(dictionary: NSDictionary())
        
            for (index, video) in enumerate(videos) {
            
                currentVideo.video_id = video as? String
            
                YouTubeClient.sharedInstance.queryDailyVideoMetricsWithParams(currentVideo, start_date: campaign.start, end_date: campaign.end, completion: { (metrics, error) -> () in
                
                    if error == nil {
                    
                        currentVideo.metrics_daily = metrics
                        
                        if campaign.metrics_daily == nil {
                            campaign.metrics_daily = metrics
                        } else {
                            for metric in metrics {
                                var newMetric = true
                                for currentMetric in campaign.metrics_daily! {
                                    if metric.dateStr! == currentMetric.dateStr! {
                                        currentMetric.addMetrics(metric)
                                        newMetric = false
                                    }
                                }
                                if newMetric == true {
                                    campaign.metrics_daily!.append(metric)
                                }
                            }
                            campaign.metrics_daily!.sort {
                                item1, item2 in
                                let date1 = item1.date! as NSDate
                                let date2 = item2.date! as NSDate
                                return date1.compare(date2) == NSComparisonResult.OrderedAscending
                            }

                        }
                        
                        TTLCache.sharedInstance.put(metrics, forKey: "\(id).metricsDaily")
                    
                        callback(campaign: campaign, error: nil)
                    } else {
                    
                        callback(campaign: nil, error: error)
                    }
                })
            }
        } else {
            campaign.metrics_daily = metricsDaily!
            callback(campaign: campaign, error: nil)
        }
    }
    
    func getCampaigns(callback: (campaigns: [Campaign]!, error: NSError!) -> Void)  {
        
        YouTubeClient.sharedInstance.authorizer.userEmail
        var userId = YouTubeClient.sharedInstance.authorizer.userEmail
        getCampaignsByUserId(userId, callback: callback)
    }
    
    func getCampaignsByUserId(userId: String, callback: (campaigns: [Campaign]!, error: NSError!) -> Void) {
        
        var campaigns = TTLCache.sharedInstance.get("campaigns") as? [Campaign]
        
        if campaigns == nil {
            ParseClient.getCampaignsByUserId(userId) { (pfObjects: [PFObject]!, error: NSError!) -> Void in
                if error == nil {
                
                    var campaignArr = [Campaign]()
                
                    for pfObject in pfObjects {
                    
                        campaignArr.append(Campaign(object: pfObject))
                    }
                    TTLCache.sharedInstance.put(campaignArr, forKey: "campaigns")
                    callback(campaigns: campaignArr, error: nil)
                } else {
                
                    callback(campaigns: nil, error: error)
                }
            }
        } else {
            callback(campaigns: campaigns, error: nil)
            
        }
    }
    
    func saveCampaign(campaign: Campaign, callback: (succeeded: Bool, error: NSError!) -> Void) {
        ParseClient.saveCampaign( campaign) { (succeeded, error) -> Void in
            if(error == nil) {
                self.invalidateCampaignEntry(campaign)
                callback(succeeded: true, error: nil)
            } else {
                callback(succeeded: false, error: error)
            }
        }
    }
    
    func deleteCampaign(campaign: Campaign, callback: (succeeded: Bool, error: NSError!) -> Void) {
        ParseClient.deleteCampaign(campaign) { (succeeded, error) -> Void in
            if(error == nil) {
                self.invalidateCampaignEntry(campaign)
                callback(succeeded: true, error: nil)
            } else {
                callback(succeeded: false, error: error)
            }
        }
    }

    func getVideos(callback: (videos: [Video]!, error: NSError!) -> Void) {
        
        var videos = TTLCache.sharedInstance.get("videos") as? [Video]
        if(videos == nil) {
            YouTubeClient.sharedInstance.queryVideoList { (videos, error) -> () in
                if error == nil {
                
                    TTLCache.sharedInstance.put(videos, forKey: "videos")
                    callback(videos: videos, error: nil)
                }
                else {
                    callback(videos: nil, error: error)
                }
            }
        } else {
            callback(videos: videos, error: nil)
        }
    }
    
    func warmupCache() {
        getVideos { (videos, error) -> Void in
            println("warmup cache")
        }
    }

    
    private func invalidateCampaignEntry(campaign: Campaign) {
        if campaign.id != nil {
            var id = campaign.id!
            TTLCache.sharedInstance.remove(id)
            TTLCache.sharedInstance.remove("\(id).metricsTotal")
            TTLCache.sharedInstance.remove("\(id).metricsDaily")
            TTLCache.sharedInstance.remove("campaigns")
        } else {
            TTLCache.sharedInstance.remove("campaigns")
        }

        
    }
   
}
