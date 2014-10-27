//
//  DashboardViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/26/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

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
    @IBOutlet weak var CommentsProgressLabel: KAProgressLabel!
    @IBOutlet weak var dislikesProgressLabel: KAProgressLabel!
    
//    var engagementCircleButton: DKCircleButton!
//    var sentimentCircleButton: DKCircleButton!
//    var viewsCircleButton: DKCircleButton!
//    var sharesCircleButton: DKCircleButton!
//    var likesCircleButton: DKCircleButton!
//    var favoritesCircleButton: DKCircleButton!
//    var commentsCircleButton: DKCircleButton!
//    var dislikesCircleButton: DKCircleButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Dashboard View NIB setup
        var dashboardNIB = UINib(nibName: "DashboardView", bundle: nil)
        
        var objects = dashboardNIB.instantiateWithOwner(self, options: nil)
        
        dashboardView = objects[0] as UIView
        
        view.addSubview(dashboardView)
        
        // Setup the UI
        constructUI()
        
        // Do any additional setup after loading the view.
    }

    func constructUI() {
        
        // setup view and button colors
        dashboardView.backgroundColor = UIColor.clearColor()
        dashboardView.backgroundColor = UIColor.BWOffWhite()
        
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
        
        self.engagementLabelIndex = 0
        // NAJ: Update with real data
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            
            self.toggleSentimentTextForLabel(self.engagementMagicLabel)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
