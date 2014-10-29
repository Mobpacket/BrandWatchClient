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
    @IBOutlet weak var vtrLabel: UILabel!
    @IBOutlet weak var ctrLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var nameData: UITextField!
    @IBOutlet weak var startData: VMaskTextField!
    @IBOutlet weak var endData: VMaskTextField!
    @IBOutlet weak var videoNameMenuButton: UIButton!
    
    @IBOutlet weak var vtrTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var ctrTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var viewsTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var sharesTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var favoritesTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var likesTargetSlider: ASValueTrackingSlider!
    @IBOutlet weak var commentsTargetSlider: ASValueTrackingSlider!

    var vtrTargetF: Float!
    var ctrTargetF: Float!
    var viewsTargetF: Float!
    var sharesTargetF: Float!
    var favoritesTargetF: Float!
    var likesTargetF: Float!
    var commentsTargetF: Float!
    var settingsView: UIView!
    
    let defaultVTR: Float = 0.7
    let defaultCTR: Float = 0.0002
    let defaultViews: Int = 100
    let defaultShares: Int = 50
    let defaultFavorites: Int = 50
    let defaultLikes: Int = 50
    let defaultComments: Int = 25
    
    var campaignVC: CampaignViewController!
    var dashboardVC: DashboardViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Get campaign view nib
        var nib = UINib(nibName: "SettingsView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        settingsView = objects[0] as UIView
        view.addSubview(settingsView)
        
        self.nameData.delegate  = self
        self.startData.mask = "####-##-##"
        self.startData.delegate = self
        self.endData.mask = "####-##-##"
        self.endData.delegate   = self
        
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
        
        // Setup custom line for Targets
        var targetsLineView = TargetLineView(frame: CGRect(x: 5, y: 226, width: 300, height: 4))
        targetsLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(targetsLineView)
        
        // Setup color scheme for view
        settingsMenuButton.backgroundColor = UIColor.BWRed()
        settingsMenuButton.layer.borderWidth = 2
        settingsMenuButton.layer.borderColor = UIColor.BWDarkBlue().CGColor
        settingsMenuButton.setTitleColor(UIColor.BWOffWhite(), forState: UIControlState.Normal)
        
        settingsView.backgroundColor = UIColor.clearColor()
        settingsView.backgroundColor = UIColor.BWOffWhite()
        
        nameLabel.font = fBWMenloBold16
        nameLabel.textColor = UIColor.BWDarkBlue()
        startLabel.font = fBWMenloBold16
        startLabel.textColor = UIColor.BWDarkBlue()
        endLabel.font = fBWMenloBold16
        endLabel.textColor = UIColor.BWDarkBlue()
        videosLabel.font = fBWMenloBold16
        videosLabel.textColor = UIColor.BWDarkBlue()
        
        // NAJ: video(s) counter text for campaign < 1 red, > 0 green
        videoNameMenuButton.titleLabel?.font = fBWMenloBold18
        videoNameMenuButton.layer.borderWidth = 1
        videoNameMenuButton.layer.borderColor = UIColor.BWDarkBlue().CGColor
        videoNameMenuButton.layer.backgroundColor = UIColor.BWOffWhite().CGColor
        videoNameMenuButton.setTitleColor(UIColor.BWRed(), forState: UIControlState.Normal)
        videoNameMenuButton.setTitle("\(campaign!.getVideoIDsCount()) Videos", forState: UIControlState.Normal)
        
        vtrLabel.font = fBWMenloBold16
        vtrLabel.textColor = UIColor.BWRed()
        ctrLabel.font = fBWMenloBold16
        ctrLabel.textColor = UIColor.BWRed()
        viewsLabel.font = fBWMenloBold16
        viewsLabel.textColor = UIColor.BWRed()
        sharesLabel.font = fBWMenloBold16
        sharesLabel.textColor = UIColor.BWRed()
        favoritesLabel.font = fBWMenloBold16
        favoritesLabel.textColor = UIColor.BWRed()
        likesLabel.font = fBWMenloBold16
        likesLabel.textColor = UIColor.BWRed()
        commentsLabel.font = fBWMenloBold16
        commentsLabel.textColor = UIColor.BWRed()
        
        // Setup the Target Sliders
        
        // For Percentage Values
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        
        // VTR Target Slider (showed as %)
        self.vtrTargetSlider.numberFormatter = formatter
        self.vtrTargetSlider.maximumValue = 1.0
        self.vtrTargetSlider.value = defaultVTR
        self.vtrTargetSlider.popUpViewCornerRadius = 12.0
        self.vtrTargetSlider.showPopUpViewAnimated(true)
        self.vtrTargetSlider.setMaxFractionDigitsDisplayed(1)
        self.vtrTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.vtrTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.vtrTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // CTR Target Slider (showed as %)
        self.ctrTargetSlider.numberFormatter = formatter
        self.ctrTargetSlider.maximumValue = 1.00
        self.ctrTargetSlider.value = defaultCTR
        self.ctrTargetSlider.popUpViewCornerRadius = 12.0
        self.ctrTargetSlider.showPopUpViewAnimated(true)
        self.ctrTargetSlider.setMaxFractionDigitsDisplayed(2)
        self.ctrTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.ctrTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.ctrTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // Views Target Slider
        self.viewsTargetSlider.maximumValue = 1000
        self.viewsTargetSlider.value = Float(defaultViews)
        self.viewsTargetSlider.popUpViewCornerRadius = 12.0
        self.viewsTargetSlider.showPopUpViewAnimated(true)
        self.viewsTargetSlider.setMaxFractionDigitsDisplayed(0)
        self.viewsTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.viewsTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.viewsTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // Shares Target Slider
        self.sharesTargetSlider.maximumValue = 500
        self.sharesTargetSlider.value = Float(defaultShares)
        self.sharesTargetSlider.popUpViewCornerRadius = 12.0
        self.sharesTargetSlider.showPopUpViewAnimated(true)
        self.sharesTargetSlider.setMaxFractionDigitsDisplayed(0)
        self.sharesTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.sharesTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.sharesTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // Favorites Target Slider
        self.favoritesTargetSlider.maximumValue = 500
        self.favoritesTargetSlider.value = Float(defaultFavorites)
        self.favoritesTargetSlider.popUpViewCornerRadius = 12.0
        self.favoritesTargetSlider.showPopUpViewAnimated(true)
        self.favoritesTargetSlider.setMaxFractionDigitsDisplayed(0)
        self.favoritesTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.favoritesTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.favoritesTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // Likes Target Slider
        self.likesTargetSlider.maximumValue = 500
        self.likesTargetSlider.value = Float(defaultLikes)
        self.likesTargetSlider.popUpViewCornerRadius = 12.0
        self.likesTargetSlider.showPopUpViewAnimated(true)
        self.likesTargetSlider.setMaxFractionDigitsDisplayed(0)
        self.likesTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.likesTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.likesTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
        
        // Comments Target Slider
        self.commentsTargetSlider.maximumValue = 500
        self.commentsTargetSlider.value = Float(defaultComments)
        self.commentsTargetSlider.popUpViewCornerRadius = 12.0
        self.commentsTargetSlider.showPopUpViewAnimated(true)
        self.commentsTargetSlider.setMaxFractionDigitsDisplayed(0)
        self.commentsTargetSlider.popUpViewColor = UIColor(hue: 0.55, saturation: 0.8, brightness: 0.9, alpha: 0.7)
        self.commentsTargetSlider.font = UIFont(name: "GillSans-Bold", size: 15)
        self.commentsTargetSlider.textColor = UIColor(hue: 0.55, saturation: 1.0, brightness: 0.5, alpha: 1.0)
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
        self.videoNameMenuButton.titleLabel?.font = fBWMenloBold18
        self.videoNameMenuButton.layer.borderWidth = 1
        self.videoNameMenuButton.layer.borderColor = UIColor.BWDarkBlue().CGColor
        self.videoNameMenuButton.layer.backgroundColor = UIColor.BWOffWhite().CGColor
        self.videoNameMenuButton.setTitleColor(UIColor.BWGreen(), forState: UIControlState.Normal)
        self.videoNameMenuButton.setTitle("\(campaign!.getVideoIDsCount())", forState: UIControlState.Normal)

        
        self.vtrTargetSlider.value       = campaign!.vtr_target ?? defaultVTR
        self.ctrTargetSlider.value       = campaign!.ctr_target ?? defaultCTR
        self.viewsTargetSlider.value     = Float(campaign!.views_target!) ?? Float(defaultViews)
        self.sharesTargetSlider.value    = Float(campaign!.shares_target!) ?? Float(defaultShares)
        self.favoritesTargetSlider.value = Float(campaign!.favorites_target!) ?? Float(defaultFavorites)
        self.likesTargetSlider.value     = Float(campaign!.likes_target!) ?? Float(defaultLikes)
        self.commentsTargetSlider.value  = Float(campaign!.comments_target!) ?? Float(defaultComments)
    }
    
    private func loadDefaultCampaignTargets() {
        
        // When loading campaign for create, set the color to lightgray
        
        self.nameData.text = ""
        
        self.startData.textColor = UIColor.lightGrayColor()
        self.startData.text = "YYYY-MM-DD"
        
        self.endData.textColor = UIColor.lightGrayColor()
        self.endData.text = "YYYY-MM-DD"
        
        self.videoNameMenuButton.titleLabel?.font = fBWMenloBold18
        self.videoNameMenuButton.layer.borderWidth = 1
        self.videoNameMenuButton.layer.borderColor = UIColor.BWDarkBlue().CGColor
        self.videoNameMenuButton.layer.backgroundColor = UIColor.BWOffWhite().CGColor
        self.videoNameMenuButton.setTitleColor(UIColor.BWRed(), forState: UIControlState.Normal)
        self.videoNameMenuButton.setTitle("0", forState: UIControlState.Normal)
        
        self.vtrTargetSlider.value       = defaultVTR
        self.ctrTargetSlider.value       = defaultCTR
        self.viewsTargetSlider.value     = Float(defaultViews)
        self.sharesTargetSlider.value    = Float(defaultShares)
        self.favoritesTargetSlider.value = Float(defaultFavorites)
        self.likesTargetSlider.value     = Float(defaultLikes)
        self.commentsTargetSlider.value  = Float(defaultComments)
    }
    
    private func assignCampaignTargets() {
        
        var campaign = CampaignService.sharedInstance.getActiveWriteCampaign()
        
        YouTubeClient.sharedInstance.authorizer.userEmail
        campaign!.user_id = YouTubeClient.sharedInstance.authorizer.userEmail
        campaign!.name = self.nameData.text
        campaign!.start = self.startData.text
        campaign!.end = self.endData.text
        
        campaign!.vtr_target = vtrTargetF
        campaign!.ctr_target = ctrTargetF
        campaign!.views_target = Int(viewsTargetF)
        campaign!.shares_target = Int(sharesTargetF)
        campaign!.favorites_target = Int(favoritesTargetF)
        campaign!.likes_target = Int(likesTargetF)
        campaign!.comments_target = Int(commentsTargetF)
        
        println("CAMPAIGN ASSIGNMENTS: \(campaign!)")
    }
        
    func cancelSettings() {
        
        println("Cancelling...")
        
        self.dashboardVC.reloadCampaigns()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            println("going to campaign screen")
        })
    }
    
    
    @IBAction func onSliderValueChanged(sender: AnyObject) {
        
        var mySlider = sender as ASValueTrackingSlider
        
        
        switch(mySlider) {
        
            case vtrTargetSlider:
                self.vtrTargetSlider.value = mySlider.value
                vtrTargetF = self.vtrTargetSlider.value
            
            case ctrTargetSlider:
                self.ctrTargetSlider.value = mySlider.value
                ctrTargetF = self.ctrTargetSlider.value

            case viewsTargetSlider:
                self.viewsTargetSlider.value = mySlider.value
                viewsTargetF = self.viewsTargetSlider.value
            
            case sharesTargetSlider:
                self.sharesTargetSlider.value = mySlider.value
                sharesTargetF = self.sharesTargetSlider.value
            
            case favoritesTargetSlider:
                self.favoritesTargetSlider.value = mySlider.value
                favoritesTargetF = self.favoritesTargetSlider.value
            
            case likesTargetSlider:
                self.likesTargetSlider.value = mySlider.value
                likesTargetF = self.likesTargetSlider.value
            
            case commentsTargetSlider:
                self.commentsTargetSlider.value = mySlider.value
                commentsTargetF = self.commentsTargetSlider.value
            
            default:
                println("")

        }
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
            
            case self.startData:
                return startData.shouldChangeCharactersInRange(range, replacementString: string)
            
            case self.endData:
                return endData.shouldChangeCharactersInRange(range, replacementString: string)


            default:
                ret = true
        }
        
        return ret
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch(textField)
        {
            
            case self.nameData, self.startData, self.endData:
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
                        
                        self.dashboardVC.reloadCampaigns()
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
