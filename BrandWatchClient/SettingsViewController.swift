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
    var campaign: Campaign!
    var currentVideoName: String!
    var currentVideoID: String!
    var videos: [Video] = []
    var campaignVC: CampaignViewController!
    
    
    // NAJ: Remove when video selection is fixed
    let kVideoTweedy = "C4ss_bScVTc"
    let kVideoTweedyLive = "-XY9DbQc_9c"
    let kVideoApple = "4ar6S_D_keM"
    let kVideoPepsi = "ImkNOCTs_a8"
    let kVideoDestiny = "_7pWxOmgVss"
    let kVideoNandos = "eomKb2UWyP0"
    let kVideoFantasyFootball = "DOF-CPpQnL0"
    let kVideoNone = "XXXX-XXXX"

    let sVideoTweedy = "Tweedy Song"
    let sVideoTweedyLive = "Tweedy Live Performance"
    let sVideoApple = "Apple Commercial"
    let sVideoPepsi = "Pepsi vs Coke"
    let sVideoDestiny = "Destiny Commercial"
    let sVideoNandos = "Nandos Commercial"
    let sVideoFantasyFootball = "Fantasy Football Commercial"
    let sVideoNone = "None"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Get campaign view nib
        var nib = UINib(nibName: "SettingsView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        settingsView = objects[0] as UIView
        view.addSubview(settingsView)
        
        // Set up UI
        constructUI()
            
        if self.campaign.isNewRecord() {
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
        videoNameMenuButton.setTitle("None", forState: UIControlState.Normal)
        
        metricsTitleLabel.textColor = UIColor.orangeColor()
        vtrLabel.textColor = UIColor.orangeColor()
        vtrViewSeperatorLabel.textColor = UIColor.orangeColor()
        ctrLabel.textColor = UIColor.orangeColor()
        sharesLabel.textColor = UIColor.orangeColor()
        favoritesLabel.textColor = UIColor.orangeColor()
        likesLabel.textColor = UIColor.orangeColor()
        commentsLabel.textColor = UIColor.orangeColor()
        
        currentVideoID = kVideoNone
        currentVideoName = sVideoNone
    }
    
    private func loadCampaignTargets() {
        
        // When loading campaign for edit, set the color to black
        self.nameData.textColor = UIColor.blackColor()
        self.nameData.text = self.campaign.name
        
        self.startData.textColor = UIColor.blackColor()
        self.startData.text = self.campaign.start
        
        self.endData.textColor = UIColor.blackColor()
        self.endData.text = self.campaign.end

        // Setting up video title
        self.videoNameMenuButton.layer.borderWidth = 1
        self.videoNameMenuButton.layer.borderColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.layer.backgroundColor = UIColor.blackColor().CGColor
        self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        var videos: [String]!
        videos = self.campaign.video_ids
        var currVideoID = videos[0] as String
        var currVideoName = getVideoString(currVideoID)
        self.currentVideoID = currVideoID
        self.currentVideoName = currVideoName
        
        self.videoNameMenuButton.setTitle(currVideoName, forState: UIControlState.Normal)
        
        self.vtrTarget.textColor = UIColor.blackColor()
        self.vtrTarget.text = "\(self.campaign.vtr_target!)"
        
        self.viewsTarget.textColor = UIColor.blackColor()
        self.viewsTarget.text = "\(self.campaign.views_target!)"
        
        self.ctrTarget.textColor = UIColor.blackColor()
        self.ctrTarget.text = "\(self.campaign.ctr_target!)"
        
        self.sharesTarget.textColor = UIColor.blackColor()
        self.sharesTarget.text = "\(self.campaign.shares_target!)"
        
        self.favoritesTarget.textColor = UIColor.blackColor()
        self.favoritesTarget.text = "\(self.campaign.favorites_target!)"
        
        self.likesTarget.textColor = UIColor.blackColor()
        self.likesTarget.text = "\(self.campaign.likes_target!)"
        
        self.commentsTarget.textColor = UIColor.blackColor()
        self.commentsTarget.text = "\(self.campaign.comments_target!)"
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
        self.videoNameMenuButton.setTitle("None", forState: UIControlState.Normal)
        
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
        
        // NAJ: Where should we get this value from for creating campaigns?
        self.campaign.user_id = "brandwatch123@gmail.com"
        self.campaign.name = self.nameData.text
        self.campaign.start = self.startData.text
        self.campaign.end = self.endData.text
        
        var videoList: [String] = [String]()
        videoList.append(self.getVideoID(self.currentVideoName))
        self.campaign.video_ids = videoList
        
        self.campaign.vtr_target = (self.vtrTarget.text as NSString).floatValue
        self.campaign.ctr_target = (self.ctrTarget.text as NSString).floatValue
        self.campaign.views_target = self.viewsTarget.text.toInt()
        self.campaign.shares_target = self.sharesTarget.text.toInt()
        self.campaign.favorites_target = self.favoritesTarget.text.toInt()
        self.campaign.likes_target = self.likesTarget.text.toInt()
        self.campaign.comments_target = self.commentsTarget.text.toInt()
        
        println("CAMPAIGN ASSIGNMENTS: \(self.campaign)")
    }
    
    private func getVideoID(name: String) -> String {
        
        if name == sVideoApple {
            
            return kVideoApple
        } else if name == sVideoDestiny {
            
            return kVideoDestiny
        } else if name == sVideoFantasyFootball {
            
            return kVideoFantasyFootball
        } else if name == sVideoNandos {
        
            return kVideoNandos
        } else if name == sVideoPepsi {
            
            return kVideoPepsi
        } else if name == sVideoTweedy {
            
            return kVideoTweedy
        } else if name == sVideoTweedyLive {
            
            return kVideoTweedyLive
        } else {
            
            return "None"
        }
    }
    
    private func getVideoString(id: String) -> String {
        
        if id == kVideoApple {
            
            return sVideoApple
        } else if id == kVideoDestiny {
            
            return sVideoDestiny
        } else if id == kVideoFantasyFootball {
            
            return sVideoFantasyFootball
        } else if id == kVideoNandos {
            
            return sVideoNandos
        } else if id == kVideoPepsi {
            
            return sVideoPepsi
        } else if id == kVideoTweedy {
            
            return sVideoTweedy
        } else if id == kVideoTweedyLive {
            
            return sVideoTweedyLive
        } else {
            
            return "None"
        }
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
                self.assignCampaignTargets()
                
                CampaignService.saveCampaign(self.campaign, callback: { (succeeded, error) -> Void in
                    
                    self.campaignVC.reloadCampaigns()
                    var id = self.campaign.getPFObject().objectId!
                    CampaignService.getCampaignById(id, callback: { (campaign, error) -> Void in
                        self.campaignVC.activeCampaign = campaign
                        self.campaignVC.viewDidLoad()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                })
                
            }),
            
            RWDropdownMenuItem(text:"Cancel", image:nil, action:{
                
                println("cancelling...")
                self.campaignVC.reloadCampaigns()
                var id = self.campaign.getPFObject().objectId!
                CampaignService.getCampaignById(id, callback: { (campaign, error) -> Void in
                    self.campaignVC.activeCampaign = campaign
                    self.campaignVC.viewDidLoad()
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
        
            })
        )
        
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
    }
    
    @IBAction func videoNameButtonPressed(sender: UIButton) {
        
        // Retrieve a list of uploaded videos for the User's channel
//        CampaignService.getVideos(){ (videos, error) -> Void in
//            if error == nil {
//                self.videos = videos
//            }
//        }

        var styleItems = NSArray(objects:
            RWDropdownMenuItem(text: sVideoApple, image:nil, action:{
                
                println("Apple Commercial selected")
                
                self.currentVideoName = self.sVideoApple
                
                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoApple, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoDestiny, image:nil, action:{
                
                println("Destiny Commercial selected")
                
                self.currentVideoName = self.sVideoDestiny

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
            self.videoNameMenuButton.setTitle(self.sVideoDestiny, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoFantasyFootball, image:nil, action:{
                
                println("Fantasy Football Commercial selected")
                
                self.currentVideoName = self.sVideoFantasyFootball

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoFantasyFootball, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoNandos, image:nil, action:{
                
                println("Nandos Commercial selected")
                
                self.currentVideoName = self.sVideoNandos

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoNandos, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoPepsi, image:nil, action:{
                
                println("Pepsi Commercial selected")
                
                self.currentVideoName = self.sVideoPepsi

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoPepsi, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoTweedy, image:nil, action:{
                
                println("Tweedy Song selected")
                
                self.currentVideoName = self.sVideoTweedy

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoTweedy, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text: sVideoTweedyLive, image:nil, action:{
                
                println("Tweedy Live selected")
                
                self.currentVideoName = self.sVideoTweedyLive

                self.videoNameMenuButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoTweedyLive, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text:"Cancel", image:nil, action:{
                
                println("cancelling...")
                
                self.currentVideoName = self.sVideoNone
                
                self.videoNameMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoNone, forState: UIControlState.Normal)
            }),
            RWDropdownMenuItem(text:"Video Selection", image:nil, action:{
                
                println("moving to video selection view...")
                
                self.currentVideoName = self.sVideoNone
                
                self.videoNameMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                
                self.videoNameMenuButton.setTitle(self.sVideoNone, forState: UIControlState.Normal)
                
                self.loadVideoSelectionView()
            })
        )
        
        RWDropdownMenu.presentFromViewController(self, withItems: styleItems, align: RWDropdownMenuCellAlignment.Center, style: RWDropdownMenuStyle.Translucent, navBarImage: nil, completion: nil)
    }
    
    func loadVideoSelectionView() {
        
        var videoSelectionVC = VideoSelectionViewController() as VideoSelectionViewController
        
        println("videoSelectionView() pressed")
        
        self.presentViewController(videoSelectionVC, animated: true) { () -> Void in
            
            println("transitioning to video selection controller")
        }
    }
}
