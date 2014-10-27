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
    
    var engagementCircleButton: DKCircleButton!
    var sentimentCircleButton: DKCircleButton!
    var viewsCircleButton: DKCircleButton!
    var sharesCircleButton: DKCircleButton!
    var likesCircleButton: DKCircleButton!
    var favoritesCircleButton: DKCircleButton!
    var commentsCircleButton: DKCircleButton!
    var dislikesCircleButton: DKCircleButton!
    
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
        
        engagementCircleButton = DKCircleButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        engagementCircleButton.center = CGPointMake(160, 380)
        engagementCircleButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        engagementCircleButton.titleLabel?.numberOfLines = 0
        engagementCircleButton.titleLabel?.preferredMaxLayoutWidth = 10
        engagementCircleButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        engagementCircleButton.backgroundColor = UIColor.BWDarkBlue()
        engagementCircleButton.borderColor = UIColor.BWRed()
        engagementCircleButton.borderSize = 3
        engagementCircleButton.setTitle("Engagement Score", forState: UIControlState.Normal)
        engagementCircleButton.setTitleColor(UIColor.BWOffWhite(), forState: UIControlState.Normal)
        engagementCircleButton.addTarget(self, action: "engagementCircleButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(engagementCircleButton)
    }
    
    func engagementCircleButtonTapped() {
        

    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
