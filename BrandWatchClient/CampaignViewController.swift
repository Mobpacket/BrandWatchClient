//
//  CampaignViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/11/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {

    @IBOutlet weak var engagementLineChartView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var vtrLabel: UILabel!
    @IBOutlet weak var ctrLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var vtrValueLabel: UILabel!
    @IBOutlet weak var ctrValueLabel: UILabel!
    @IBOutlet weak var viewsValueLabel: UILabel!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    @IBOutlet weak var campaignTitleButton: UIButton!
    
    var campaignView: UIView!
    var campaigns: [Campaign]!
    var activeCampaign: Campaign!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get campaign view nib
        var nib = UINib(nibName: "CampaignView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        campaignView = objects[0] as UIView
        view.addSubview(campaignView)
        
        // setup all the UI before pulling data to view
        constructUI()
        
        // Use our campaign service to load active campaigns for this user
        var user_id = YouTubeClient.sharedInstance.authorizer.userEmail

        CampaignService.getCampaignsByUserId(user_id) { (campaigns, error) -> Void in
            
            if error == nil {
                
                self.campaigns = campaigns
                
                //NAB: Since its loading for the first time, set active campaign to
                //first campaign returned.  We should store this data in the user
                self.activeCampaign = self.campaigns[0]
                
                self.loadCampaign(self.activeCampaign.id!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func constructUI() {
        
        // Setup Line Chart View
        engagementLineChartView.layer.borderWidth = 1
        engagementLineChartView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Setup line breaks according to autolayout values from campaign view
        var titleLineView = CampaignLineView(frame: CGRect(x: 10, y: 64, width: 300, height: 4))
        titleLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(titleLineView)
        
        var chartLineView = SectionLineView(frame: CGRect(x: 10, y: 230, width: 300, height: 2))
        chartLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(chartLineView)
        
        var engagementLineView = SectionLineView(frame: CGRect(x: 10, y: 270, width: 300, height: 2))
        engagementLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(engagementLineView)
        
        var vtrLineView = SectionLineView(frame: CGRect(x: 10, y: 310, width: 300, height: 2))
        vtrLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(vtrLineView)
        
        var ctrLineView = SectionLineView(frame: CGRect(x: 10, y: 350, width: 300, height: 2))
        ctrLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(ctrLineView)
        
        var viewsLineView = SectionLineView(frame: CGRect(x: 10, y: 395, width: 300, height: 2))
        viewsLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(viewsLineView)
        
        var sharesLineView = SectionLineView(frame: CGRect(x: 10, y: 435, width: 300, height: 2))
        sharesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(sharesLineView)
        
        var favoritesLineView = SectionLineView(frame: CGRect(x: 10, y: 475, width: 300, height: 2))
        favoritesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(favoritesLineView)
        
        var likesLineView = SectionLineView(frame: CGRect(x: 10, y: 520, width: 300, height: 2))
        likesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(likesLineView)
        
        // setup color scheme
        campaignView.backgroundColor = UIColor.clearColor()
        campaignView.backgroundColor = UIColor.orangeColor()
        
        campaignTitleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        scoreLabel.textColor = UIColor.whiteColor()
        vtrLabel.textColor = UIColor.whiteColor()
        ctrLabel.textColor = UIColor.whiteColor()
        viewsLabel.textColor = UIColor.whiteColor()
        sharesLabel.textColor = UIColor.whiteColor()
        favoritesLabel.textColor = UIColor.whiteColor()
        likesLabel.textColor = UIColor.whiteColor()
        commentsLabel.textColor = UIColor.whiteColor()
        
        scoreValueLabel.textColor = UIColor.whiteColor()
        vtrValueLabel.textColor = UIColor.whiteColor()
        ctrValueLabel.textColor = UIColor.whiteColor()
        viewsValueLabel.textColor = UIColor.whiteColor()
        sharesCountLabel.textColor = UIColor.whiteColor()
        favoritesCountLabel.textColor = UIColor.whiteColor()
        likesCountLabel.textColor = UIColor.whiteColor()
        commentsCountLabel.textColor = UIColor.whiteColor()
    }

    private func loadCampaign(id: String) {
        
        var currentVideo: Video!
        

        CampaignService.getCampaignById(id){ (campaign, error) -> Void in
            if error == nil {
                
                self.activeCampaign = campaign
                
                // Set values
                self.campaignTitleButton.setTitle("\(campaign.name!)", forState: UIControlState.Normal)

                let score = EngagementScorer.calculateTotalScore(campaign)
                self.scoreValueLabel.text = "\(score)"
                
                let vtr_value = self.activeCampaign.metrics_total?.vtr
                self.vtrValueLabel.text = "\(vtr_value!)" + "%"
                
                let ctr_value = self.activeCampaign.metrics_total?.ctr
                self.ctrValueLabel.text = "\(ctr_value!)" + "%"
                
                let views_value = self.activeCampaign.metrics_total?.views
                self.viewsValueLabel.text = "\(views_value!)"

                let shares_value = self.activeCampaign.metrics_total?.shares
                self.sharesCountLabel.text = "\(shares_value!)"
                
                let favorites_value = self.activeCampaign.metrics_total?.favorites
                self.favoritesCountLabel.text = "\(favorites_value!)"
                
                let likes_value = self.activeCampaign.metrics_total?.likes
                self.likesCountLabel.text = "\(likes_value!)"
                
                let comments_value = self.activeCampaign.metrics_total?.comments
                self.commentsCountLabel.text = "\(comments_value!)"
            } else {
                
                NSLog("%@", error)
            }
        }
        
        // Get the daily metrics to pouplate the graph
        CampaignService.getCampaignDailyMetricsById(id, callback: { (campaign, error) -> Void in
            if error == nil {
                println("Daily Metrics: \(campaign.metrics_daily)")
                
                // TODO: Populate the Graph
            }
        })
    }
    
    func signOut() {
        
        println("Signing out...")
        
        // kKeyChainItemName will move to the User Model
        var kKeyChainItemName = "BrandWatch Client: YouTube"
        
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychainForName(kKeyChainItemName)
        YouTubeClient.sharedInstance.authorizer = nil
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            println("going to the login screen")
        })
    }
    
    @IBAction func onCampaignMenuDropdownTapped(sender: UIButton) {
        
        var styleItems = [RWDropdownMenuItem]()
        
        styleItems.append(
            RWDropdownMenuItem(text:"Create Campaign", image:nil, action:{
                
                println("loading settings view (create)")
                
                self.loadSettingsView(false)
            })
        )
        
        styleItems.append(
            RWDropdownMenuItem(text:"Edit Campaign", image:nil, action:{
                
                println("loading settings view (edit)")
                
                self.loadSettingsView(true)
            })
        )
        
        for campaign in self.campaigns {
            styleItems.append(
                RWDropdownMenuItem(text:campaign.name!, image:nil, action:{
                
                println("loading campaign \(campaign.name!)")
                    
                self.loadCampaign(campaign.id!)
                    
                self.campaignTitleButton.setTitle(campaign.name!, forState: UIControlState.Normal)
               })
            )
        }
        
        styleItems.append(
            RWDropdownMenuItem(text:"Sign Out", image:nil, action:{
                
                self.signOut()
            })
        )
       
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
    }
    
    func loadSettingsView(edit: Bool) {
        
        var settingsVC = SettingsViewController() as SettingsViewController
        
        // Check for edit or create to pass correct data model
        if edit == true {
        
            settingsVC.campaign = self.activeCampaign
        } else {
            
            settingsVC.campaign = Campaign(object: PFObject(className: "Campaign"))
        }
        
        println("loadSettingsView() pressed")
        
        self.presentViewController(settingsVC, animated: true) { () -> Void in
            
            println("transitioning to settings controller")
        }
    }
}
