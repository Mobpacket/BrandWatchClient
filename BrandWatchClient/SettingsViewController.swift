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
    @IBOutlet weak var vtrTarget: UITextField!
    @IBOutlet weak var ctrTarget: UITextField!
    @IBOutlet weak var sharesTarget: UITextField!
    @IBOutlet weak var favoritesTarget: UITextField!
    @IBOutlet weak var likesTarget: UITextField!
    @IBOutlet weak var commentsTarget: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Get campaign view nib
        var nib = UINib(nibName: "SettingsView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        var settingsView = objects[0] as UIView
        view.addSubview(settingsView)
        
        // Setup line breaks according to autolayout values from campaign view
        var settingsLineView = SettingsLineView(frame: CGRect(x: 10, y: 64, width: 300, height: 4))
        settingsLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(settingsLineView)
        
        var metricsLineView = TargetLineView(frame: CGRect(x: 10, y: 262, width: 300, height: 4))
        metricsLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(metricsLineView)
        
        // Setup color scheme for view
        settingsMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        settingsView.backgroundColor = UIColor.clearColor()
        settingsView.backgroundColor = UIColor.blackColor()

        nameLabel.textColor = UIColor.whiteColor()
        startLabel.textColor = UIColor.whiteColor()
        endLabel.textColor = UIColor.whiteColor()
        
        metricsTitleLabel.textColor = UIColor.orangeColor()
        vtrLabel.textColor = UIColor.orangeColor()
        ctrLabel.textColor = UIColor.orangeColor()
        sharesLabel.textColor = UIColor.orangeColor()
        favoritesLabel.textColor = UIColor.orangeColor()
        likesLabel.textColor = UIColor.orangeColor()
        commentsLabel.textColor = UIColor.orangeColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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
