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
    var engagementLineChartView = JBLineChartView()
    var engagementBarChartView = JBBarChartView()
    
   // var campaigns: [Campaign]!
    
    enum GraphTypeEnum {
        
        case Line, Bar
    }
    
    // NAJ: Test Data for Graph
//    var testArray1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//    var testArray2 = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
//    var testArray3 = [6, 4, 15, 2, 0, 13, 12, 11, 7, 12]
//    var testArray4 = [0, 8, 1, 21, 11, 16, 4, 7, 0, 9]
    var barChartData = [23, 30, 28, 24]
    
    var lineChartData = [AnyObject]()
    
    // NAJ: Used for switching between graphs (testing)
    var type = GraphTypeEnum.Line
//    var type = GraphTypeEnum.Bar
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get campaign view nib
        var nib = UINib(nibName: "CampaignView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        campaignView = objects[0] as UIView
        view.addSubview(campaignView)
        
        // Setup the charts with the correct graphs
        
        // Line Graph
        if type == .Line {
            constructLineGraph()
        }

        // Bar Graph
        if (type == .Bar) {
            constructBarGraph()
        }
        
        // setup all the UI before pulling data to view
        constructUI()
        
//         pull data
        reloadCampaigns()
        
        if type == .Line {
            engagementLineChartView.reloadData()
        } else if type == .Bar {
            engagementBarChartView.reloadData()
        }
    }
    
    func reloadCampaigns() {
        // Use our campaign service to load active campaigns for this user
        var userId = YouTubeClient.sharedInstance.authorizer.userEmail

        CampaignService.sharedInstance.getCampaignsByUserId(userId) { (campaigns, error) -> Void in
            
            if error == nil {
                

                var activeCampaign = CampaignService.sharedInstance.getActiveCampaign()
                
                //NAB: Since its loading for the first time, set active campaign to
                //first campaign returned.  We should store this data in the user
                if(activeCampaign == nil) {
                    CampaignService.sharedInstance.setActiveCampaign(campaigns[0])
                }
                
                activeCampaign = CampaignService.sharedInstance.getActiveCampaign()
                var id = activeCampaign?.id
                self.loadCampaign(id!)
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
    
    func constructGraphHeader(type: GraphTypeEnum) {
        
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
        
        switch type {
            case .Line:
                self.engagementLineChartView.headerView = headerView;
            case .Bar:
                self.engagementBarChartView.headerView = headerView;
        }
    }
    
    func constructLineGraph() {
        
        engagementLineChartView = JBLineChartView(frame: CGRect(x: 15, y: 72, width: 290, height: 150))
        engagementLineChartView.dataSource = self
        engagementLineChartView.delegate = self
        engagementLineChartView.backgroundColor = UIColor.blackColor()
        engagementLineChartView.showsVerticalSelection = false
        self.view.addSubview(engagementLineChartView)

        constructGraphHeader(CampaignViewController.GraphTypeEnum.Line)
        
        var lineChartfooterView = JBLineChartFooterView(frame: CGRect(x: 10.0, y: ceil(self.engagementLineChartView.bounds.size.height * 0.5) - ceil(20.0 * 0.5), width: self.engagementLineChartView.bounds.size.width - (10.0 * 2), height: 20.0))
        lineChartfooterView.backgroundColor = UIColor.clearColor()
        lineChartfooterView.leftLabel.text = "Sunday"
        lineChartfooterView.leftLabel.textColor = UIColor.whiteColor()
        lineChartfooterView.rightLabel.text = "Saturday"
        lineChartfooterView.rightLabel.textColor = UIColor.whiteColor()
        lineChartfooterView.sectionCount = 10
        self.engagementLineChartView.footerView = lineChartfooterView;
    }
    
    func constructBarGraph() {
        
        engagementBarChartView = JBBarChartView(frame: CGRect(x: 15, y: 72, width: 290, height: 150))
        engagementBarChartView.dataSource = self
        engagementBarChartView.delegate = self
        engagementBarChartView.headerPadding = 20.0
        engagementBarChartView.minimumValue = 0.0
        engagementBarChartView.inverted = false
        engagementBarChartView.backgroundColor = UIColor.blackColor()
        engagementBarChartView.showsVerticalSelection = true
        self.view.addSubview(engagementBarChartView)
        
        constructGraphHeader(CampaignViewController.GraphTypeEnum.Bar)
        
        var barChartfooterView = JBBarChartFooterView(frame: CGRect(x: 10.0, y: ceil(self.engagementBarChartView.bounds.size.height * 0.5) - ceil(20.0 * 0.5), width: self.engagementBarChartView.bounds.size.width - (10.0 * 2), height: 20.0))
        barChartfooterView.padding = 10.0
        barChartfooterView.leftLabel.text = "Views"
        barChartfooterView.leftLabel.textColor = UIColor.whiteColor()
        barChartfooterView.rightLabel.text = "Comments"
        barChartfooterView.rightLabel.textColor = UIColor.whiteColor()
        self.engagementBarChartView.footerView = barChartfooterView;
    }

    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        
//        println("LINE CHART: number of lines = \(self.lineChartData.count)")
        
        return UInt(self.lineChartData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
//        println("LINE CHART: number of values = \(self.lineChartData[Int(lineIndex)].count)")

        return UInt(self.lineChartData[Int(lineIndex)].count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {

        var line = self.lineChartData[Int(lineIndex)] as [Int]
        var value = line[Int(horizontalIndex)]
        
//        println("LINE CHART: value = \(value)")
        //For plotting don't plot valid negative values. Youtube can return negative metrics based on date range. 
        return CGFloat(value < 0 ? 0 : value)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.greenColor()
        } else if lineIndex == 1 {
            
            return UIColor.redColor()
        } else if lineIndex == 2 {
            
            return UIColor.yellowColor()
        } else if lineIndex == 3 {
            
            return UIColor.whiteColor()
        } else if lineIndex == 4 {
            
            return UIColor.cyanColor()
        }
        
        return UIColor.blackColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.greenColor()
        } else if lineIndex == 1 {
            
            return UIColor.redColor()
        } else if lineIndex == 2 {
            
            return UIColor.yellowColor()
        } else if lineIndex == 3 {
            
            return UIColor.whiteColor()
        } else if lineIndex == 4 {
            
            return UIColor.cyanColor()
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
            
            return UIColor.greenColor()
        } else if index == 1 {
            
            return UIColor.redColor()
        } else if index == 2 {
            
            return UIColor.yellowColor()
        } else if index == 3 {
            
            return UIColor.whiteColor()
        } else if index == 4 {
            
            return UIColor.cyanColor()
        }
        
        return UIColor.whiteColor()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        
        return 0.5
    }
    
    private func loadCampaign(id: String) {
        
        var currentVideo: Video!
        
        CampaignService.sharedInstance.getCampaignById(id){ (campaign, error) -> Void in
            if error == nil {
                
                CampaignService.sharedInstance.setActiveCampaign(campaign)
                
                // Get the daily metrics to pouplate the graph
                CampaignService.sharedInstance.getCampaignTotalMetrics(campaign, callback: { (campaign, error) -> Void in
                    if error == nil {
                        
                        // Set values
                        self.campaignTitleButton.setTitle("\(campaign.name!)", forState: UIControlState.Normal)
                        
                        let score = EngagementScorer.calculateTotalScore(campaign)
                        self.scoreValueLabel.text = "\(score)"
                        
                        let vtr_value = campaign.metrics_total?.vtr
                        self.vtrValueLabel.text = "\(vtr_value!)" + "%"
                        
                        let ctr_value = campaign.metrics_total?.ctr
                        self.ctrValueLabel.text = "\(ctr_value!)" + "%"
                        
                        let views_value = campaign.metrics_total?.views
                        self.viewsValueLabel.text = "\(views_value!)"
                        
                        let shares_value = campaign.metrics_total?.shares
                        self.sharesCountLabel.text = "\(shares_value!)"
                        
                        let favorites_value = campaign.metrics_total?.favorites
                        self.favoritesCountLabel.text = "\(favorites_value!)"
                        
                        let likes_value = campaign.metrics_total?.likes
                        self.likesCountLabel.text = "\(likes_value!)"
                        
                        let comments_value = campaign.metrics_total?.comments
                        self.commentsCountLabel.text = "\(comments_value!)"
                    } else {
                        println("<TOTAL METRICS> Error: \(error)")
                    }

                })

                
                // Get the daily metrics to pouplate the graph
                CampaignService.sharedInstance.getCampaignDailyMetrics(campaign, callback: { (campaign, error) -> Void in
                    if error == nil {
                        
                        println("Daily Metrics: \(campaign.metrics_daily)")
                        
                        // Populate Graphs
                        if self.type == .Line {
                            
                            self.lineChartData = [Int]()
                            
                            var views = DataProcessor.getMetricDailyData(campaign, type: .Views)
                            self.lineChartData.append(views)
                            
                            var shares = DataProcessor.getMetricDailyData(campaign, type: .Shares)
                            self.lineChartData.append(views)
                            
                            var likes = DataProcessor.getMetricDailyData(campaign, type: .Likes)
                            self.lineChartData.append(likes)
                            
                            var favorites = DataProcessor.getMetricDailyData(campaign, type: .Favorites)
                            self.lineChartData.append(favorites)
                            
                            var comments = DataProcessor.getMetricDailyData(campaign, type: .Comments)
                            self.lineChartData.append(comments)
                            
                            self.engagementLineChartView.reloadData()
                        } else if self.type == .Bar {
                            
                            var views = campaign.metrics_total?.views! as Int!
                            var shares = campaign.metrics_total?.views! as Int!
                            var likes = campaign.metrics_total?.likes! as Int!
                            var favorites = campaign.metrics_total?.favorites! as Int!
                            var comments = campaign.metrics_total?.comments! as Int!
                            
                            self.barChartData = [views, likes, favorites, comments]
                            
                            self.engagementBarChartView.reloadData()
                        }
                    } else {
                        
                        println("<DAILY METRICS> Error: \(error)")
                    }
                })
            } else {
                
                NSLog("%@", error)
            }
        }
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
        
        CampaignService.sharedInstance.getCampaigns { (campaigns, error) -> Void in
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
            
            for campaign in campaigns {
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
        
       
    }
    
    func loadSettingsView(edit: Bool) {
        
        var settingsVC = SettingsViewController() as SettingsViewController
        settingsVC.campaignVC = self
        
        // Check for edit or create to pass correct data model
        if edit == true {
            var activeCampaign = CampaignService.sharedInstance.getActiveCampaign()
            CampaignService.sharedInstance.setActiveWriteCampaign(activeCampaign!)
        } else {
            var newCampaign = Campaign(object: PFObject(className: "Campaign"))
            CampaignService.sharedInstance.setActiveWriteCampaign(newCampaign)
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
