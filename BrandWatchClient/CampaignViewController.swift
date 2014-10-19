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
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var vtrValueLabel: UILabel!
    @IBOutlet weak var ctrValueLabel: UILabel!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    @IBOutlet weak var campaignTitleButton: UIButton!
    
    var campaignTitleA: String!
    var campaignTitleB: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get campaign view nib
        var nib = UINib(nibName: "CampaignView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        var campaignView = objects[0] as UIView
        view.addSubview(campaignView)
        
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
        
        var sharesLineView = SectionLineView(frame: CGRect(x: 10, y: 395, width: 300, height: 2))
        sharesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(sharesLineView)

        var favoritesLineView = SectionLineView(frame: CGRect(x: 10, y: 435, width: 300, height: 2))
        favoritesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(favoritesLineView)

        var likesLineView = SectionLineView(frame: CGRect(x: 10, y: 480, width: 300, height: 2))
        likesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(likesLineView)
   
        // setup view and button colors
        campaignView.backgroundColor = UIColor.clearColor()
        campaignView.backgroundColor = UIColor.orangeColor()
        
        campaignTitleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        scoreLabel.textColor = UIColor.whiteColor()
        vtrLabel.textColor = UIColor.whiteColor()
        ctrLabel.textColor = UIColor.whiteColor()
        sharesLabel.textColor = UIColor.whiteColor()
        favoritesLabel.textColor = UIColor.whiteColor()
        likesLabel.textColor = UIColor.whiteColor()
        commentsLabel.textColor = UIColor.whiteColor()
        
        scoreValueLabel.textColor = UIColor.whiteColor()
        vtrValueLabel.textColor = UIColor.whiteColor()
        ctrValueLabel.textColor = UIColor.whiteColor()
        sharesCountLabel.textColor = UIColor.whiteColor()
        favoritesCountLabel.textColor = UIColor.whiteColor()
        likesCountLabel.textColor = UIColor.whiteColor()
        commentsCountLabel.textColor = UIColor.whiteColor()
        
        loadTestCampaignA()
        setCampaignTitles()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTestCampaignA() {
            
        loadCampaign("a8Q44sVMSJ")
    }
    
    func loadTestCampaignB() {
    
        loadCampaign("1edruSK9m1")
    }
    
    func setCampaignTitles() {
        
        setCampaignATitle()
        setCampaignBTitle()
    }
    
    private func loadCampaign(id: String) {
        
        CampaignService.getCampaignById(id) { (campaign, error) -> Void in
            if error == nil {
                
                NSLog("%@", campaign)
                
                // Set values
                self.campaignTitleButton.setTitle("\(campaign.name!)", forState: UIControlState.Normal)
//                
//                let score = pfCampaign["score"] as Int
                self.scoreValueLabel.text = "\(campaign.score!)"
                
//                let vtrF = pfCampaign["vtr"] as Float
//                let vtr = vtrF.format(".1")
//                self.vtrValueLabel.text = "\(vtr)%"
//                
//                let ctrF = pfCampaign["ctr"] as Float
//                let ctr = ctrF.format(".1")
//                self.ctrValueLabel.text = "\(ctr)%"
//                
//                let shares = pfCampaign["score"] as Int
//                self.sharesCountLabel.text = "\(shares)"
//                
//                // NAJ: Update tweets to favorites in PARSE
//                let favorites = pfCampaign["tweets"] as Int
//                self.favoritesCountLabel.text = "\(favorites)"
//                
//                let likes = pfCampaign["likes"] as Int
//                self.likesCountLabel.text = "\(likes)"
//                
//                let comments = pfCampaign["comments"] as Int
//                self.commentsCountLabel.text = "\(comments)"
            } else {
                
                NSLog("%@", error)
            }

        }
        
    }
    
    private func setCampaignATitle() {
        
        CampaignService.getCampaignById("a8Q44sVMSJ") { (campaign, error) -> Void in
            if error == nil {
                
                NSLog("%@", campaign)
                
                // Set button name
                self.campaignTitleA = campaign.name!
            } else {
                
                NSLog("%@", error)
            }

        }
    
    }
    
    private func setCampaignBTitle() {
        
        CampaignService.getCampaignById("1edruSK9m1") { (campaign, error) -> Void in
            if error == nil {
                
                NSLog("%@", campaign)
                
                // Set button name
                self.campaignTitleB = campaign.name!
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
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            println("going to the login screen")
        })
    }
    
    @IBAction func onCampaignMenuDropdownTapped(sender: UIButton) {
        
        var styleItems = NSArray(objects:
            RWDropdownMenuItem(text:"Create Campaign", image:nil, action:{
                println("loading settings view (create)")
                self.loadSettingsView()
            }),
            RWDropdownMenuItem(text:"Edit Campaign", image:nil, action:{
                println("loading settings view (edit)")
                self.loadSettingsView()
            }),
            RWDropdownMenuItem(text:campaignTitleA, image:nil, action:{
                println("loading campaign \(self.campaignTitleA)")
                self.loadTestCampaignA()
                self.campaignTitleButton.setTitle(self.campaignTitleA, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text:campaignTitleB, image:nil, action:{
                println("loading campaign \(self.campaignTitleB)")
                self.loadTestCampaignB()
                self.campaignTitleButton.setTitle(self.campaignTitleB, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text:"Sign Out", image:nil, action:{
                self.signOut()
            })
        )
        
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
    }
    
    func loadSettingsView() {
        
        let settingsVC = SettingsViewController() as SettingsViewController
        
        println("loadSettingsView() pressed")
        
        self.presentViewController(settingsVC, animated: true) { () -> Void in
            
            println("transitioning to settings controller")
        }
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
