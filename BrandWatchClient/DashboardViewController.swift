//
//  DashboardViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/26/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, JBBarChartViewDataSource, JBBarChartViewDelegate {

    @IBOutlet weak var DashboardMenuButton: UIButton!
    @IBOutlet weak var GraphAreaView: UIView!
    
    var dashboardView: UIView!
    
    var engagementMagicLabel: TOMSMorphingLabel!
    var sentimentMagicLabel: TOMSMorphingLabel!
    
    var engagementLabelIndex: Int!
    var sentimentLabelIndex: Int!
    
    var engagementLabelData: [String]!
    var sentimentLabelData: [String]!
    
    @IBOutlet weak var vtrProgressLabel: KAProgressLabel!
    @IBOutlet weak var ctrProgressLabel: KAProgressLabel!
    @IBOutlet weak var viewsProgressLabel: KAProgressLabel!
    @IBOutlet weak var sharesProgressLabel: KAProgressLabel!
    @IBOutlet weak var likesProgressLabel: KAProgressLabel!
    @IBOutlet weak var favoritesProgressLabel: KAProgressLabel!
    @IBOutlet weak var commentsProgressLabel: KAProgressLabel!
    @IBOutlet weak var dislikesProgressLabel: KAProgressLabel!
    
    // Used for progress rings
    var vtrProgressValue: Float!
    var ctrProgressValue: Float!
    var viewsProgressValue: Float!
    var sharesProgressValue: Float!
    var likesProgressValue: Float!
    var favoritesProgressValue: Float!
    var commentsProgressValue: Float!
    var dislikesProgressValue: Float!
    
    let progressColors = [NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.FillColor) : UIColor.clearColor(), NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.TrackColor) : UIColor.BWRed(), NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.ProgressColor) : UIColor.BWDarkBlue()]
    
    let progressDColors = [NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.FillColor) : UIColor.clearColor(), NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.TrackColor) : UIColor.BWRed(), NSStringFromProgressLabelColorTableKey(ProgressLabelColorTable.ProgressColor) : UIColor.BWRed()]
    
    var engagementLineChartView = JBLineChartView()
    var engagementBarChartView = JBBarChartView()
    
    enum GraphTypeEnum {
        
        case Line, Bar
    }
    
    var barChartData = [23, 30, 28, 24]
    var lineChartData = [AnyObject]()
    
    // NAJ: Used for switching between graphs (testing)
    var type = GraphTypeEnum.Line
    //    var type = GraphTypeEnum.Bar
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Dashboard View NIB setup
        var dashboardNIB = UINib(nibName: "DashboardView", bundle: nil)
        
        var objects = dashboardNIB.instantiateWithOwner(self, options: nil)
        
        dashboardView = objects[0] as UIView
        
        view.addSubview(dashboardView)
        
        // Setup the charts with the correct graphs
        
        // Line Graph
        if type == .Line {
            constructLineGraph()
        }
        
        // Bar Graph
        if (type == .Bar) {
            constructBarGraph()
        }
        
        // Setup the UI
        constructUI()
        
        // Do any additional setup after loading the view.
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

    private func loadCampaign(id: String) {
        
        var currentVideo: Video!
        
        let pnf = NSNumberFormatter()
        pnf.numberStyle = NSNumberFormatterStyle.PercentStyle
        
        CampaignService.sharedInstance.getCampaignById(id){ (campaign, error) -> Void in
            if error == nil {
                
                CampaignService.sharedInstance.setActiveCampaign(campaign)
                
                // Get the total metrics to populate the labels and progress rings
                CampaignService.sharedInstance.getCampaignTotalMetrics(campaign, callback: { (campaign, error) -> Void in
                    if error == nil {
                        
                        // Set values
                        self.DashboardMenuButton.setTitle("\(campaign.name!)", forState: UIControlState.Normal)
                        
                        let score = EngagementScorer.calculateTotalScore(campaign)
                        
                        let sentiment = SentimentScorer.calculateTotalScore(campaign)
//                        println("Sentiment Score: \(sentiment)")
                        
                        self.engagementMagicLabel.text = "\(score)"
                        self.sentimentMagicLabel.text = "\(sentiment)"

                        let vtr_value = campaign.metrics_total?.vtr
                        let vtr_target = campaign.vtr_target
                        self.vtrProgressLabel.text = "VTR\n\(vtr_value!)"
                        self.vtrProgressValue = Float(vtr_value!) / Float(vtr_target!)
                        
                        
                        let ctr_value = campaign.metrics_total?.ctr
                        let ctr_target = campaign.ctr_target
                        self.ctrProgressLabel.text = "CTR\n\(ctr_value!)"
                        self.ctrProgressValue = Float(ctr_value!) / Float(ctr_target!)
                        
                        let views_value = campaign.metrics_total?.views
                        self.viewsProgressLabel.text = "V\n\(views_value!)"
                        
                        let shares_value = campaign.metrics_total?.shares
                        self.sharesProgressLabel.text = "S\n\(shares_value!)"
                        
                        let favorites_value = campaign.metrics_total?.favorites
                        self.favoritesProgressLabel.text = "F\n\(favorites_value!)"
                        
                        let likes_value = campaign.metrics_total?.likes
                        self.likesProgressLabel.text = "L\n\(likes_value!)"
                        
                        let comments_value = campaign.metrics_total?.comments
                        self.commentsProgressLabel.text = "C\n\(comments_value!)"
                        
//                        let dislikes_value = campaign.metrics_total?.dislikes
//                        self.dislikesProgressLabel.text = "\(dislikes_value!)"
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
    
    func constructUI() {
        
        // setup view and button colors
        dashboardView.backgroundColor = UIColor.clearColor()
        dashboardView.backgroundColor = UIColor.BWOffWhite()
        
        // Setup Line Graph View
        GraphAreaView.layer.borderWidth = 1
        GraphAreaView.layer.borderColor = UIColor.BWDarkBlue().CGColor
        GraphAreaView.backgroundColor = UIColor.BWOffWhite()
        
        // Setup Menu Button
        DashboardMenuButton.backgroundColor = UIColor.BWRed()
        DashboardMenuButton.setTitleColor(UIColor.BWOffWhite(), forState: UIControlState.Normal)
        DashboardMenuButton.layer.borderWidth = 2
        DashboardMenuButton.layer.borderColor = UIColor.BWDarkBlue().CGColor
//        brandLabel.textColor = UIColor.BWRed()
//        brandLabel.layer.backgroundColor = UIColor.BWOffWhite().CGColor
//        watchLabel.textColor = UIColor.BWOffWhite()
//        watchLabel.layer.backgroundColor = UIColor.BWRed().CGColor
        
//        engagementCircleButton = DKCircleButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        engagementCircleButton.center = CGPointMake(160, 380)
//        engagementCircleButton.titleLabel?.font = UIFont.systemFontOfSize(14)
//        engagementCircleButton.titleLabel?.numberOfLines = 0
//        engagementCircleButton.titleLabel?.preferredMaxLayoutWidth = 10
//        engagementCircleButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        engagementCircleButton.backgroundColor = UIColor.BWDarkBlue()
//        engagementCircleButton.borderColor = UIColor.BWRed()
//        engagementCircleButton.borderSize = 3
//        engagementCircleButton.setTitle("Engagement Score", forState: UIControlState.Normal)
//        engagementCircleButton.setTitleColor(UIColor.BWOffWhite(), forState: UIControlState.Normal)
//        engagementCircleButton.addTarget(self, action: "engagementCircleButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(engagementCircleButton)
        
        // Engagement
        self.engagementLabelIndex = 0
        self.engagementLabelData = ["Engagement Score", "90"]
        engagementMagicLabel = TOMSMorphingLabel(frame: CGRect(x: 10, y: 265, width: 140, height: 25))
        engagementMagicLabel.font = UIFont.systemFontOfSize(14)
        engagementMagicLabel.layer.borderColor = UIColor.BWRed().CGColor
        engagementMagicLabel.layer.borderWidth = 1
        engagementMagicLabel.backgroundColor = UIColor.BWDarkBlue()
        engagementMagicLabel.textAlignment = NSTextAlignment.Center
        engagementMagicLabel.textColor = UIColor.BWOffWhite()
        engagementMagicLabel.text = self.engagementLabelData[self.engagementLabelIndex]
        view.addSubview(engagementMagicLabel)
        self.toggleEngagementTextForLabel(engagementMagicLabel)
        
        // Sentiment
        self.sentimentLabelIndex = 0
        // NAJ: Update with real data
        self.sentimentLabelData = ["Sentiment Score", "30"]
        sentimentMagicLabel = TOMSMorphingLabel(frame: CGRect(x: 170, y: 265, width: 140, height: 25))
        sentimentMagicLabel.font = UIFont.systemFontOfSize(14)
        sentimentMagicLabel.layer.borderColor = UIColor.BWRed().CGColor
        sentimentMagicLabel.layer.borderWidth = 1
        sentimentMagicLabel.backgroundColor = UIColor.BWDarkBlue()
        sentimentMagicLabel.textAlignment = NSTextAlignment.Center
        sentimentMagicLabel.textColor = UIColor.BWOffWhite()
        sentimentMagicLabel.text = "Sentiment Score"
        view.addSubview(sentimentMagicLabel)
        self.toggleSentimentTextForLabel(sentimentMagicLabel)
        
        // VTR
        self.vtrProgressLabel.progressType = ProgressLableType.LabelCircle
        self.vtrProgressLabel.backBorderWidth = 10.0
        self.vtrProgressLabel.frontBorderWidth = 9.8
        self.vtrProgressLabel.startDegree = 0
        self.vtrProgressLabel.endDegree = 0
        self.vtrProgressLabel.colorTable = progressColors
        self.vtrProgressLabel.setProgress(0.7, timing: TPPropertyAnimationTimingEaseOut, duration: 1.0, delay: 0.5)
        self.vtrProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
//                label.text = "VTR\n\(progress * 100)"
            })
        }

        // CTR
        ctrProgressLabel.progressType = ProgressLableType.LabelCircle
        self.ctrProgressLabel.backBorderWidth = 10.0
        self.ctrProgressLabel.frontBorderWidth = 9.8
        self.ctrProgressLabel.startDegree = 0
        self.ctrProgressLabel.endDegree = 0
        self.ctrProgressLabel.colorTable = progressColors
        ctrProgressLabel.setProgress(0.32, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.ctrProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
//                label.text = "CTR\n\(progress * 100)"
            })
        }
        
        // NAJ: For Views, Shares, Likes, Favorites, Comments need to call set progress with value / target, but set label to only value not progress
        // Views
        viewsProgressLabel.progressType = ProgressLableType.LabelCircle
        self.viewsProgressLabel.backBorderWidth = 10.0
        self.viewsProgressLabel.frontBorderWidth = 9.8
        self.viewsProgressLabel.startDegree = 0
        self.viewsProgressLabel.endDegree = 0
        self.viewsProgressLabel.colorTable = progressColors
        viewsProgressLabel.setProgress(0.87, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.viewsProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
//                label.text = "V\n\(value!)"
//                label.text = "V\n87"

            })
        }
        
        // Shares
        sharesProgressLabel.progressType = ProgressLableType.LabelCircle
        self.sharesProgressLabel.backBorderWidth = 10.0
        self.sharesProgressLabel.frontBorderWidth = 9.8
        self.sharesProgressLabel.startDegree = 0
        self.sharesProgressLabel.endDegree = 0
        self.sharesProgressLabel.colorTable = progressColors
        sharesProgressLabel.setProgress(0.65, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.sharesProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
//                label.text = "S\n\(value!)"
//                label.text = "S\n11"

            })
        }
        
        // Likes
        likesProgressLabel.progressType = ProgressLableType.LabelCircle
        self.likesProgressLabel.backBorderWidth = 10.0
        self.likesProgressLabel.frontBorderWidth = 9.8
        self.likesProgressLabel.startDegree = 0
        self.likesProgressLabel.endDegree = 0
        self.likesProgressLabel.colorTable = progressColors
        likesProgressLabel.setProgress(0.28, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.likesProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
//                label.text = "L\n\(value!)"
//                label.text = "L\n28"
            })
        }
        
        // Favorites
        favoritesProgressLabel.progressType = ProgressLableType.LabelCircle
        self.favoritesProgressLabel.backBorderWidth = 10.0
        self.favoritesProgressLabel.frontBorderWidth = 9.8
        self.favoritesProgressLabel.startDegree = 0
        self.favoritesProgressLabel.endDegree = 0
        self.favoritesProgressLabel.colorTable = progressColors
        favoritesProgressLabel.setProgress(0.56, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.favoritesProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
//                label.text = "F\n\(value!)"
//                label.text = "F\n6"
            })
        }
        
        // Comments
        commentsProgressLabel.progressType = ProgressLableType.LabelCircle
        self.commentsProgressLabel.backBorderWidth = 10.0
        self.commentsProgressLabel.frontBorderWidth = 9.8
        self.commentsProgressLabel.startDegree = 0
        self.commentsProgressLabel.endDegree = 0
        self.commentsProgressLabel.colorTable = progressColors
        commentsProgressLabel.setProgress(0.2, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.commentsProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
//                label.text = "C\n\(value!)"
//                label.text = "C\n2"
            })
        }
        
        // Dislikes
        dislikesProgressLabel.progressType = ProgressLableType.LabelCircle
        self.dislikesProgressLabel.backBorderWidth = 10.0
        self.dislikesProgressLabel.frontBorderWidth = 9.8
        self.dislikesProgressLabel.startDegree = 0
        self.dislikesProgressLabel.endDegree = 0
        self.dislikesProgressLabel.colorTable = progressDColors
        dislikesProgressLabel.setProgress(5, timing: TPPropertyAnimationTimingEaseIn, duration: 1.0, delay: 0.5)
        self.dislikesProgressLabel.progressLabelVCBlock = { (label: KAProgressLabel!, progress: CGFloat) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                var nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                var value = nf.stringFromNumber(progress)
                label.text = "D\n\(value!)"
            })
        }
    }
    
//    func engagementLabelValues() -> [String] {
//        
//        if engagementLabelData == nil {
//            
//            engagementLabelData = ["Engagement Score", "90.0"]
//        }
//        
//        return engagementLabelData
//    }
//    
//    func engagementLabelSetIndex(index: Int) {
//        
//        engagementLabelIndex = max(0, min(index, index % [self.engagementLabelData.count]))
//    }
    
    func toggleEngagementTextForLabel(label: TOMSMorphingLabel) {
        
        if self.engagementLabelIndex == 0 {
            self.engagementLabelIndex = 1
            self.engagementMagicLabel.text = self.engagementLabelData[self.engagementLabelIndex]
        } else {
            self.engagementLabelIndex = 0
            self.engagementMagicLabel.text = self.engagementLabelData[self.engagementLabelIndex]
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            
            self.toggleEngagementTextForLabel(self.engagementMagicLabel)
        }
    }
    
    func toggleSentimentTextForLabel(label: TOMSMorphingLabel) {
        
        if self.sentimentLabelIndex == 0 {
            self.sentimentLabelIndex = 1
            self.sentimentMagicLabel.text = self.sentimentLabelData[self.sentimentLabelIndex]
        } else {
            self.sentimentLabelIndex = 0
            self.sentimentMagicLabel.text = self.sentimentLabelData[self.sentimentLabelIndex]
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            
            self.toggleSentimentTextForLabel(self.engagementMagicLabel)
        }
    }

    func constructGraphHeader(type: GraphTypeEnum) {
        
        var headerView = JBChartHeaderView(frame: CGRect(x: self.engagementLineChartView.bounds.size.height * 0.5, y: ceil(75.0 * 0.5), width: self.engagementLineChartView.bounds.size.width - (10.0 * 2), height: 75.0))
        headerView.titleLabel.text = "Daily Metrics"
        headerView.titleLabel.textColor = UIColor.BWDarkBlue()
        headerView.titleLabel.shadowColor = UIColor(white: 1.0, alpha: 0.25)
        headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
        headerView.subtitleLabel.text = "October"
        headerView.subtitleLabel.textColor = UIColor.BWRed()
        headerView.subtitleLabel.shadowColor = UIColor(white: 1.0, alpha: 0.25)
        headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        headerView.separatorColor = UIColor.BWDarkBlue()
        
        switch type {
        case .Line:
            self.engagementLineChartView.headerView = headerView;
        case .Bar:
            self.engagementBarChartView.headerView = headerView;
        }
    }
    
    func constructLineGraph() {
        
        engagementLineChartView = JBLineChartView(frame: CGRect(x: 10, y: 55, width: 300, height: 200))
        engagementLineChartView.dataSource = self
        engagementLineChartView.delegate = self
        engagementLineChartView.backgroundColor = UIColor.BWOffWhite()
        engagementLineChartView.layer.borderColor = UIColor.BWDarkBlue().CGColor
        engagementLineChartView.layer.borderWidth = 2
        engagementLineChartView.showsVerticalSelection = false
        self.view.addSubview(engagementLineChartView)
        constructGraphHeader(DashboardViewController.GraphTypeEnum.Line)
        
        var lineChartfooterView = JBLineChartFooterView(frame: CGRect(x: 10.0, y: ceil(self.engagementLineChartView.bounds.size.height * 0.5) - ceil(20.0 * 0.5), width: self.engagementLineChartView.bounds.size.width - (10.0 * 2), height: 20.0))
        lineChartfooterView.backgroundColor = UIColor.BWRed()
        lineChartfooterView.leftLabel.text = " 18 "
        lineChartfooterView.leftLabel.textColor = UIColor.BWOffWhite()
        lineChartfooterView.rightLabel.text = " 28 "
        lineChartfooterView.rightLabel.textColor = UIColor.BWOffWhite()
        lineChartfooterView.sectionCount = 10 // NAJ: replace with number of days
        self.engagementLineChartView.footerView = lineChartfooterView;
    }
    
    func constructBarGraph() {
        
        engagementBarChartView = JBBarChartView(frame: CGRect(x: 10, y: 55, width: 300, height: 200))
        engagementBarChartView.dataSource = self
        engagementBarChartView.delegate = self
        engagementBarChartView.headerPadding = 20.0
        engagementBarChartView.minimumValue = 0.0
        engagementBarChartView.inverted = false
        engagementBarChartView.backgroundColor = UIColor.BWOffWhite()
        engagementBarChartView.showsVerticalSelection = true
        self.view.addSubview(engagementBarChartView)
        
        constructGraphHeader(DashboardViewController.GraphTypeEnum.Bar)
        
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
            
            return UIColor.blackColor()
        } else if lineIndex == 1 {
            
            return UIColor.BWRed()
        } else if lineIndex == 2 {
            
            return UIColor.BWDarkBlue()
        } else if lineIndex == 3 {
            
            return UIColor.orangeColor()
        } else if lineIndex == 4 {
            
            return UIColor.greenColor()
        } else if lineIndex == 5 {
            
            return UIColor.magentaColor()
        }
        
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.blackColor()
        } else if lineIndex == 1 {
            
            return UIColor.BWRed()
        } else if lineIndex == 2 {
            
            return UIColor.BWDarkBlue()
        } else if lineIndex == 3 {
            
            return UIColor.orangeColor()
        } else if lineIndex == 4 {
            
            return UIColor.greenColor()
        }
        
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 2.0
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
            
            return UIColor.blackColor()
        } else if index == 1 {
            
            return UIColor.BWRed()
        } else if index == 2 {
            
            return UIColor.BWDarkBlue()
        } else if index == 3 {
            
            return UIColor.orangeColor()
        } else if index == 4 {
            
            return UIColor.greenColor()
        }
        
        return UIColor.whiteColor()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        
        return 0.5
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
                        
                        self.DashboardMenuButton.setTitle(campaign.name!, forState: UIControlState.Normal)
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
        
        var load = true
        
        var settingsVC = SettingsViewController() as SettingsViewController
        settingsVC.dashboardVC = self
        
        // Check for edit or create to pass correct data model
        if edit == true {
            var activeCampaign = CampaignService.sharedInstance.getActiveCampaign()
            if activeCampaign?.name == "ACME" {
                load = false
            }
            CampaignService.sharedInstance.setActiveWriteCampaign(activeCampaign!)
        } else {
            var newCampaign = Campaign(object: PFObject(className: "Campaign"))
            CampaignService.sharedInstance.setActiveWriteCampaign(newCampaign)
        }
        
        if load == true {
            
            println("loadSettingsView() pressed")
            
            self.presentViewController(settingsVC, animated: true) { () -> Void in
                
                println("transitioning to settings controller")
            }
        }
    }
    
    func topViewController(rootViewController: UIViewController) -> UIViewController {
        
        if (rootViewController.presentedViewController == nil) {
            return rootViewController;
        }
        
        return rootViewController.presentedViewController!
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
