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
                
                
                callback(campaign: campaignObj, error: nil)
            } else {
                callback(campaign: nil, error: error)
            }
        
        }
    }
    
    class func getCampaignByUserId(userId: String, callback: (campaigns: [Campaign]!, error: NSError!) -> Void) {
        ParseClient.getCampaignsByUserId(userId) { (pfObjects: [PFObject]!, error: NSError!) -> Void in
            if(error != nil) {
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
