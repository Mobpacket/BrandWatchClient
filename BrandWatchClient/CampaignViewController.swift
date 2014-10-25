//
//  CampaignViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/11/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, JBBarChartViewDataSource, JBBarChartViewDelegate {
    
    @IBOutlet weak var chartAreaView: UIView!
    
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
    var engagementLineChartView = JBLineChartView()
    var engagementBarChartView = JBBarChartView()
    
    // NAJ: Test Data for Graph
    var testArray1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var testArray2 = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var testArray3 = [6, 4, 15, 2, 0, 13, 12, 11, 7, 12]
    var testArray4 = [0, 8, 1, 21, 11, 16, 4, 7, 0, 9]
    var barChartData = [23, 30, 28, 24]
    
    var lineChartData = [AnyObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.lineChartData.append(testArray1)
        self.lineChartData.append(testArray2)
        self.lineChartData.append(testArray3)
        self.lineChartData.append(testArray4)
        
        // Get campaign view nib
        var nib = UINib(nibName: "CampaignView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        campaignView = objects[0] as UIView
        view.addSubview(campaignView)
        
        // Setup the charts with the correct graphs
        // Line Graph
//        engagementLineChartView = JBLineChartView(frame: CGRect(x: 15, y: 72, width: 290, height: 150))
//        engagementLineChartView.dataSource = self
//        engagementLineChartView.delegate = self
//        engagementLineChartView.backgroundColor = UIColor.blackColor()
//        engagementLineChartView.showsVerticalSelection = false
//        self.view.addSubview(engagementLineChartView)
        
        var headerView = JBChartHeaderView(frame: CGRect(x: self.engagementLineChartView.bounds.size.height * 0.5, y: ceil(75.0 * 0.5), width: self.engagementLineChartView.bounds.size.width - (10.0 * 2), height: 75.0))
        headerView.titleLabel.text = "Daily Metrics"
        headerView.titleLabel.textColor = UIColor.orangeColor()
        headerView.titleLabel.shadowColor = UIColor(white: 1.0, alpha: 0.25)
        headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
        headerView.subtitleLabel.text = "Oct 20 - Oct 30"
        headerView.subtitleLabel.textColor = UIColor.whiteColor()
        headerView.subtitleLabel.shadowColor = UIColor(white: 1.0, alpha: 0.25)
        headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        headerView.separatorColor = UIColor.orangeColor()
//        self.engagementLineChartView.headerView = headerView;
        
//        var lineChartfooterView = JBLineChartFooterView(frame: CGRect(x: 10.0, y: ceil(self.engagementLineChartView.bounds.size.height * 0.5) - ceil(20.0 * 0.5), width: self.engagementLineChartView.bounds.size.width - (10.0 * 2), height: 20.0))
//        lineChartfooterView.backgroundColor = UIColor.clearColor()
//        lineChartfooterView.leftLabel.text = "Sunday"
//        lineChartfooterView.leftLabel.textColor = UIColor.whiteColor()
//        lineChartfooterView.rightLabel.text = "Saturday"
//        lineChartfooterView.rightLabel.textColor = UIColor.whiteColor()
//        lineChartfooterView.sectionCount = 10
//        self.engagementLineChartView.footerView = lineChartfooterView;
        
        // Bar Graph
        engagementBarChartView = JBBarChartView(frame: CGRect(x: 15, y: 72, width: 290, height: 150))
        engagementBarChartView.dataSource = self
        engagementBarChartView.delegate = self
        engagementBarChartView.headerPadding = 20.0
        engagementBarChartView.minimumValue = 0.0
        engagementBarChartView.inverted = false
        engagementBarChartView.backgroundColor = UIColor.blackColor()
        engagementBarChartView.showsVerticalSelection = true
        self.view.addSubview(engagementBarChartView)
        self.engagementBarChartView.headerView = headerView;
        
        var barChartfooterView = JBBarChartFooterView(frame: CGRect(x: 10.0, y: ceil(self.engagementBarChartView.bounds.size.height * 0.5) - ceil(20.0 * 0.5), width: self.engagementBarChartView.bounds.size.width - (10.0 * 2), height: 20.0))
        barChartfooterView.padding = 10.0
        barChartfooterView.leftLabel.text = "Views"
        barChartfooterView.leftLabel.textColor = UIColor.whiteColor()
        barChartfooterView.rightLabel.text = "favorites"
        barChartfooterView.rightLabel.textColor = UIColor.whiteColor()
        self.engagementBarChartView.footerView = barChartfooterView;
        
        // setup all the UI before pulling data to view
        constructUI()
        
        // pull data
        reloadCampaigns()
        
//        engagementLineChartView.reloadData()
        engagementBarChartView.reloadData()
    }
    
    func reloadCampaigns() {
        // Use our campaign service to load active campaigns for this user
        var user_id = YouTubeClient.sharedInstance.authorizer.userEmail

        CampaignService.getCampaignsByUserId(user_id) { (campaigns, error) -> Void in
            
            if error == nil {
                
                self.campaigns = campaigns
                
                //NAB: Since its loading for the first time, set active campaign to
                //first campaign returned.  We should store this data in the user
                if(self.activeCampaign == nil) {
                    self.activeCampaign = self.campaigns[0]
                }
                
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
        chartAreaView.layer.borderWidth = 1
        chartAreaView.layer.borderColor = UIColor.blackColor().CGColor
        
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

    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        
        return UInt(self.lineChartData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(self.lineChartData[Int(lineIndex)].count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        var line = self.lineChartData[Int(lineIndex)] as [Int]
        var value = line[Int(horizontalIndex)]
        return CGFloat(value)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.redColor()
        } else if lineIndex == 1 {
            
            return UIColor.whiteColor()
        } else if lineIndex == 2 {
            
            return UIColor.yellowColor()
        } else if lineIndex == 3 {
            
            return UIColor.greenColor()
        }
        
        return UIColor.blackColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.redColor()
        } else if lineIndex == 1 {
            
            return UIColor.whiteColor()
        } else if lineIndex == 2 {
            
            return UIColor.yellowColor()
        } else if lineIndex == 3 {
            
            return UIColor.greenColor()
        }
        
        return UIColor.blackColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 1.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        
        return JBLineChartViewLineStyle.Solid
    }
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        
        return UInt(self.barChartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        
        return CGFloat(self.barChartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        
        if index == 0 {
            
            return UIColor.redColor()
        } else if index == 1 {
            
            return UIColor.whiteColor()
        } else if index == 2 {
            
            return UIColor.yellowColor()
        } else if index == 3 {
            
            return UIColor.greenColor()
        }
        
        return UIColor.whiteColor()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        
        return 0.5
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
//        CampaignService.getCampaignDailyMetricsById(id, callback: { (campaign, error) -> Void in
//            if error == nil {
//                println("Daily Metrics: \(campaign.metrics_daily)")
//                
//                // TODO: Populate the Graph
//            }
//        })
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
        settingsVC.campaignVC = self
        
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
    
    func topViewController(rootViewController: UIViewController) -> UIViewController {
       
        if (rootViewController.presentedViewController == nil) {
            return rootViewController;
        }
            
        return rootViewController.presentedViewController!
    }
}
