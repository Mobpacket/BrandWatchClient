//
//  SettingsViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/14/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var videoNameMenuButton: UIButton!
    @IBOutlet weak var vtrTarget: UITextField!
    @IBOutlet weak var vtrViewSeperatorLabel: UILabel!
    @IBOutlet weak var viewsTarget: UITextField!
    @IBOutlet weak var ctrTarget: UITextField!
    @IBOutlet weak var sharesTarget: UITextField!
    @IBOutlet weak var favoritesTarget: UITextField!
    @IBOutlet weak var likesTarget: UITextField!
    @IBOutlet weak var commentsTarget: UITextField!
    
    var settingsView: UIView!
    
    var campaignVC: CampaignViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Get campaign view nib
        var nib = UINib(nibName: "SettingsView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        settingsView = objects[0] as UIView
        view.addSubview(settingsView)
        
        self.nameData.delegate  = self
        self.startData.delegate = self
        self.endData.delegate   = self
        self.vtrTarget.delegate = self
        self.ctrTarget.delegate = self
        
        self.viewsTarget.delegate     = self
        self.sharesTarget.delegate    = self
        self.commentsTarget.delegate  = self
        self.likesTarget.delegate     = self
        self.favoritesTarget.delegate = self
        
        // Set up UI
        constructUI()
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        if campaign!.isNewRecord() {
            // Create
            loadDefaultCampaignTargets()
        } else {
            // Edit
            loadCampaignTargets()
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    private func constructUI() {
        
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        
        // Setup color scheme for view
        settingsMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        settingsView.backgroundColor = UIColor.clearColor()
        settingsView.backgroundColor = UIColor.blackColor()
        
        nameLabel.textColor = UIColor.whiteColor()
        startLabel.textColor = UIColor.whiteColor()
        endLabel.textColor = UIColor.whiteColor()
        videosLabel.textColor = UIColor.whiteColor()
        
        // NAJ: video(s) counter text for campaign < 1 red, > 0 green
        videoNameMenuButton.layer.borderWidth = 1
        videoNameMenuButton.layer.borderColor = UIColor.blackColor().CGColor
        videoNameMenuButton.layer.backgroundColor = UIColor.blackColor().CGColor
        videoNameMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        videoNameMenuButton.setTitle("\(campaign!.getVideoIDsCount()) Videos", forState: UIControlState.Normal)
        
        metricsTitleLabel.textColor = UIColor.orangeColor()
        vtrLabel.textColor = UIColor.orangeColor()
        vtrViewSeperatorLabel.textColor = UIColor.orangeColor()
        ctrLabel.textColor = UIColor.orangeColor()
        sharesLabel.textColor = UIColor.orangeColor()
        favoritesLabel.textColor = UIColor.orangeColor()
        likesLabel.textColor = UIColor.orangeColor()
        commentsLabel.textColor = UIColor.orangeColor()
        
    }
    
    func loadCampaignTargets() {
        
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        
        // When loading campaign for edit, set the color to black
        
        self.nameData.textColor = UIColor.blackColor()
        self.nameData.text = campaign!.name
        
        self.startData.textColor = UIColor.blackColor()
        self.startData.text = campaign!.start
        
        self.endData.textColor = UIColor.blackColor()
        self.endData.text = campaign!.end

        // Setting up video title
        self.videoNameMenuButton.layer.borderWidth = 1
        self.videoNameMenuButton.layer.borderColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.layer.backgroundColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        self.videoNameMenuButton.setTitle("\(campaign!.getVideoIDsCount()) Videos", forState: UIControlState.Normal)
        
        self.vtrTarget.textColor = UIColor.blackColor()
        self.vtrTarget.text = "\(campaign!.vtr_target ?? 70)"
        
        self.viewsTarget.textColor = UIColor.blackColor()
        self.viewsTarget.text = "\(campaign!.views_target ?? 100)"
        
        self.ctrTarget.textColor = UIColor.blackColor()
        self.ctrTarget.text = "\(campaign!.ctr_target ?? 0.2)"
        
        self.sharesTarget.textColor = UIColor.blackColor()
        self.sharesTarget.text = "\(campaign!.shares_target ?? 50)"
        
        self.favoritesTarget.textColor = UIColor.blackColor()
        self.favoritesTarget.text = "\(campaign!.favorites_target ?? 50)"
        
        self.likesTarget.textColor = UIColor.blackColor()
        self.likesTarget.text = "\(campaign!.likes_target ?? 50)"
        
        self.commentsTarget.textColor = UIColor.blackColor()
        self.commentsTarget.text = "\(campaign!.comments_target ?? 25)"
    }
    
    private func loadDefaultCampaignTargets() {
        
        // When loading campaign for create, set the color to lightgray
        
        self.nameData.text = ""
        
        self.startData.textColor = UIColor.lightGrayColor()
        self.startData.text = "YYYY-MM-DD"
        
        self.endData.textColor = UIColor.lightGrayColor()
        self.endData.text = "YYYY-MM-DD"
        
        self.videoNameMenuButton.layer.borderWidth = 1
        self.videoNameMenuButton.layer.borderColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.layer.backgroundColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.videoNameMenuButton.setTitle("0 Videos", forState: UIControlState.Normal)
        
        self.vtrTarget.textColor = UIColor.lightGrayColor()
        self.vtrTarget.text = "70"
        
        self.viewsTarget.textColor = UIColor.lightGrayColor()
        self.viewsTarget.text = "100"
        
        self.ctrTarget.textColor = UIColor.lightGrayColor()
        self.ctrTarget.text = "0.2"
        
        self.sharesTarget.textColor = UIColor.lightGrayColor()
        self.sharesTarget.text = "50"
        
        self.favoritesTarget.textColor = UIColor.lightGrayColor()
        self.favoritesTarget.text = "50"
        
        self.likesTarget.textColor = UIColor.lightGrayColor()
        self.likesTarget.text = "50"
        
        self.commentsTarget.textColor = UIColor.lightGrayColor()
        self.commentsTarget.text = "25"
    }
    
    private func assignCampaignTargets() {
        
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        
        YouTubeClient.sharedInstance.authorizer.userEmail
        campaign!.user_id = YouTubeClient.sharedInstance.authorizer.userEmail
        campaign!.name = self.nameData.text
        campaign!.start = self.startData.text
        campaign!.end = self.endData.text
        
        campaign!.vtr_target = (self.vtrTarget.text as NSString).floatValue
        campaign!.ctr_target = (self.ctrTarget.text as NSString).floatValue
        campaign!.views_target = self.viewsTarget.text.toInt()
        campaign!.shares_target = self.sharesTarget.text.toInt()
        campaign!.favorites_target = self.favoritesTarget.text.toInt()
        campaign!.likes_target = self.likesTarget.text.toInt()
        campaign!.comments_target = self.commentsTarget.text.toInt()
        
        println("CAMPAIGN ASSIGNMENTS: \(campaign!)")
    }
        
    func cancelSettings() {
        
        println("Cancelling...")
        self.campaignVC.reloadCampaigns()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            println("going to campaign screen")
        })
    }
    
    func validateInputs() -> String {
        
        var errorMessage: String = String()
        
        // Name Validation: Cannot be empty
        if self.nameData.text == "" {
            errorMessage = errorMessage + "- The Name of the Campaign cannot be empty.\n"
        }
        
        // Date Validation for the format YYYY-MM-DD
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let startDate = dateFormatter.dateFromString(self.startData.text)
        if startDate == nil {
            errorMessage = errorMessage + "- The Start Date must be a valid date in the format YYYY-MM-DD.\n"
        }
        let endDate = dateFormatter.dateFromString(self.endData.text)
        if endDate == nil {
            errorMessage = errorMessage + "- The End Date must be a valid date in the format YYYY-MM-DD.\n"
        }
        
        return errorMessage
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        var ret = true

        let newLength = countElements(textField.text!) + countElements(string!) - range.length
        switch(textField)
        {
            case self.nameData:
                ret = newLength <= 20
            
            case self.startData, self.endData:
                ret = newLength <= 10

            case self.vtrTarget, self.ctrTarget:
                ret = newLength <= 5

            case self.viewsTarget, self.sharesTarget, self.likesTarget, self.commentsTarget, self.favoritesTarget:
                ret = newLength <= 4

            default:
                ret = true
        }
        
        return ret
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch(textField)
        {
            
            case self.startData, self.endData, self.vtrTarget, self.ctrTarget, self.viewsTarget, self.sharesTarget, self.likesTarget, self.commentsTarget, self.favoritesTarget:
                textField.textColor = UIColor.blackColor()
            
            default:
                println("")
        }
        
    }

    @IBAction func settingsMenuButtonTapped(sender: UIButton) {
    
        var styleItems = NSArray(objects:
            RWDropdownMenuItem(text:"Create/Save", image:nil, action:{
                
                println("creating campaign")
                
                var message: String = self.validateInputs()
                
                if message != "" {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Alert!"
                    alertView.message = message
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    
                    alertView.show()
                } else {
                
                    // populate objects from labels (make a private function)
                    self.assignCampaignTargets()
                    var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
                    
                    CampaignService.sharedInstance.saveCampaign(campaign!, callback: { (succeeded, error) -> Void in
                        
                        self.campaignVC.reloadCampaigns()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
                
            }),
            
            RWDropdownMenuItem(text:"Cancel", image:nil, action:{
                self.cancelSettings()
            })
        )
        
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
    }
    
    @IBAction func videoNameButtonPressed(sender: UIButton) {
        
        println("moving to video selection view...")
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        
        self.videoNameMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.videoNameMenuButton.setTitle("\(campaign!.getVideoIDsCount()) Videos", forState: UIControlState.Normal)
        
        self.loadVideoSelectionView()

    }
    
    func loadVideoSelectionView() {
        
        var videoSelectionVC = VideoSelectionViewController() as VideoSelectionViewController
        videoSelectionVC.settingsVC = self
        
        println("videoSelectionView() pressed")
        
        self.presentViewController(videoSelectionVC, animated: true) { () -> Void in
            
            println("transitioning to video selection controller")
        }
    }
}
