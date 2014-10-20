//
//  SettingsViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/14/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsMenuButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var videosLabel: UILabel!
    @IBOutlet weak var metricsTitleLabel: UILabel!
    @IBOutlet weak var vtrLabel: UILabel!
    @IBOutlet weak var ctrLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var nameData: UITextField!
    @IBOutlet weak var startData: UITextField!
    @IBOutlet weak var endData: UITextField!
    @IBOutlet weak var videosDataLabel: UILabel!
    @IBOutlet weak var vtrTarget: UITextField!
    @IBOutlet weak var vtrViewSeperatorLabel: UILabel!
    @IBOutlet weak var viewsTarget: UITextField!
    @IBOutlet weak var ctrTarget: UITextField!
    @IBOutlet weak var sharesTarget: UITextField!
    @IBOutlet weak var favoritesTarget: UITextField!
    @IBOutlet weak var likesTarget: UITextField!
    @IBOutlet weak var commentsTarget: UITextField!
    
    var settingsView: UIView!
    var campaign: Campaign!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Get campaign view nib
        var nib = UINib(nibName: "SettingsView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        settingsView = objects[0] as UIView
        view.addSubview(settingsView)
        
        // set up UI
        constructUI()
        
        // Do any additional setup after loading the view.
        loadCampaignValues()
        // create function to assign label values from self.campaign.*
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    private func constructUI() {
        
        // Setup color scheme for view
        settingsMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        settingsView.backgroundColor = UIColor.clearColor()
        settingsView.backgroundColor = UIColor.blackColor()
        
        nameLabel.textColor = UIColor.whiteColor()
        startLabel.textColor = UIColor.whiteColor()
        endLabel.textColor = UIColor.whiteColor()
        videosLabel.textColor = UIColor.whiteColor()
        
        // NAJ: video(s) counter text for campaign < 1 red, > 0 green
        videosDataLabel.layer.borderWidth = 1
        videosDataLabel.layer.borderColor = UIColor.blackColor().CGColor
        videosDataLabel.layer.backgroundColor = UIColor.blackColor().CGColor
        videosDataLabel.textColor = UIColor.redColor()
        //        videosDataLabel.textColor = UIColor.greenColor()
        
        metricsTitleLabel.textColor = UIColor.orangeColor()
        vtrLabel.textColor = UIColor.orangeColor()
        vtrViewSeperatorLabel.textColor = UIColor.orangeColor()
        ctrLabel.textColor = UIColor.orangeColor()
        sharesLabel.textColor = UIColor.orangeColor()
        favoritesLabel.textColor = UIColor.orangeColor()
        likesLabel.textColor = UIColor.orangeColor()
        commentsLabel.textColor = UIColor.orangeColor()
    }
    
    private func loadCampaignValues() {
        
        // When loading campaign for edit, set the color to black
        self.nameData.text = self.campaign.name
        self.startData.textColor = UIColor.blackColor()
        self.startData.text = self.campaign.start
        self.endData.textColor = UIColor.blackColor()
        self.endData.text = self.campaign.end
        
        self.vtrTarget.text = "\(self.campaign.vtr_target!)"
        self.viewsTarget.text = "\(self.campaign.views_target!)"
        self.ctrTarget.text = "\(self.campaign.ctr_target!)"
        self.sharesTarget.text = "\(self.campaign.shares_target!)"
        self.favoritesTarget.text = "\(self.campaign.favorites_target!)"
        self.likesTarget.text = "\(self.campaign.likes_target!)"
        self.commentsTarget.text = "\(self.campaign.comments_target!)"
    }
    
    func cancelSettings() {
        
        println("Cancelling...")
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            println("going to campaign screen")
        })
    }

    @IBAction func settingsMenuButtonTapped(sender: UIButton) {
    
        var styleItems = NSArray(objects:
            RWDropdownMenuItem(text:"Create/Save", image:nil, action:{
                println("creating campaign")
                // populate objects from labels (make a private function)
                self.campaign.ctr_target = self.ctrLabel.text?.toInt()
                CampaignService.saveCampaign(self.campaign, callback: { (succeeded, error) -> Void in
                    
                    println("Succeeded")
                })
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }),
            RWDropdownMenuItem(text:"Cancel", image:nil, action:{
                println("cancelling...")
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        )
        
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
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
