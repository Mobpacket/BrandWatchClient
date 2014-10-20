//
//  CampaignService.swift
//  BrandWatchClient
//
//  Created by Nabib El-RAHMAN on 10/19/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class CampaignService: NSObject {
    
    class func newCampaignInstance() -> Campaign {
        return Campaign(object: PFObject())
    }
    
    class func getCampaignById(id: String, callback: (campaign: Campaign!, error: NSError!) -> Void) {
        ParseClient.getCampaignById(id) {
            (pfCampaign: PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                var campaignObj = Campaign(object: pfCampaign)
                
                var videos = campaignObj.video_ids as NSArray!
                
                var currentVideo = Video(dictionary: NSDictionary())
                
                for (index, video) in enumerate(videos) {
                    
                    currentVideo.video_id = video as? String
                    
                    YouTubeClient.sharedInstance.queryVideoMetricsWithParams(currentVideo, start_date: campaignObj.start, end_date: campaignObj.end, completion: { (metrics, error) -> () in
                        
                        if error == nil {
                            currentVideo.metrics_total = metrics
                            
                            campaignObj.metrics_total = currentVideo.metrics_total

                            callback(campaign: campaignObj, error: nil)
                        }
                        else {
                            callback(campaign: nil, error: error)
                        }
                    })
                }
            } else {
                callback(campaign: nil, error: error)
            }
        }
    }
    
    class func getCampaignDailyMetricsById(id: String, callback: (campaign: Campaign!, error: NSError!) -> Void) {
        ParseClient.getCampaignById(id) {
            (pfCampaign: PFObject!, error: NSError!) -> Void in
            
            if error == nil {
        
                var campaignObj = Campaign(object: pfCampaign)
        
                var videos = campaignObj.video_ids as NSArray!
                
                var currentVideo = Video(dictionary: NSDictionary())
                
                for (index, video) in enumerate(videos) {
                    
                    currentVideo.video_id = video as? String
                    
                    YouTubeClient.sharedInstance.queryDailyVideoMetricsWithParams(currentVideo, start_date: campaignObj.start, end_date: campaignObj.end, completion: { (metrics, error) -> () in
                        
                        if error == nil {
                            currentVideo.metrics_daily = metrics
                            
                            campaignObj.metrics_daily = currentVideo.metrics_daily
                            
                            callback(campaign: campaignObj, error: nil)
                            
                        }
                        else {
                            callback(campaign: campaignObj, error: nil)
                        }
                    })
                }
            }
        }
    }
    
    class func getCampaignsByUserId(userId: String, callback: (campaigns: [Campaign]!, error: NSError!) -> Void) {
        ParseClient.getCampaignsByUserId(userId) { (pfObjects: [PFObject]!, error: NSError!) -> Void in
            if error == nil {
                var campaignArr = [Campaign]()
                for pfObject in pfObjects {
                    campaignArr.append(Campaign(object: pfObject))
                }
                callback(campaigns: campaignArr, error: nil)
            } else {
                callback(campaigns: nil, error: error)
            }
        }
    }
    
    class func getCampaigns(callback: (campaigns: [Campaign]!, error: NSError!) -> Void) {
        ParseClient.getCampaigns() { (pfObjects: [PFObject]!, error: NSError!) -> Void in
            if error == nil {
                var campaignArr = [Campaign]()
                for pfObject in pfObjects {
                    campaignArr.append(Campaign(object: pfObject))
                }
                callback(campaigns: campaignArr, error: nil)
            } else {
                callback(campaigns: nil, error: error)
            }
        }
    }


    
    class func saveCampaign(campaign: Campaign, callback: (succeeded: Bool, error: NSError!) -> Void) {
        ParseClient.saveCampaign(campaign, callback: callback)
    }
    
    class func deleteCampaign(campaign: Campaign, callback: (succeeded: Bool, error: NSError!) -> Void) {
        ParseClient.deleteCampaign(campaign, callback: callback)
    }

   
}
