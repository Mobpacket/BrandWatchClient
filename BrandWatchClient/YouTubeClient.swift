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

class YouTubeClient: GTLServiceYouTubeAnalytics {
    
    class var sharedInstance: YouTubeClient {
        
    struct Static {
        
        static let instance = YouTubeClient()
        
        }
        
        return Static.instance
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
