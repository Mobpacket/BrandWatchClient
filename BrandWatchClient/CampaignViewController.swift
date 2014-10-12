//
//  CampaignViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/11/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {
    
    @IBOutlet weak var q25Label: UILabel!
    @IBOutlet weak var q50Label: UILabel!
    @IBOutlet weak var q75Label: UILabel!
    @IBOutlet weak var q100Label: UILabel!
    @IBOutlet weak var q25ValueLabel: UILabel!
    @IBOutlet weak var q50ValueLabel: UILabel!
    @IBOutlet weak var q75ValueLabel: UILabel!
    @IBOutlet weak var q100ValueLabel: UILabel!

    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var vtrValueLabel: UILabel!
    @IBOutlet weak var ctrValueLabel: UILabel!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get campaign view nib
        var nib = UINib(nibName: "CampaignView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        var campaignView = objects[0] as UIView
        view.addSubview(campaignView)
        
        // Setup line breaks according to autolayout values from campaign view
        var titleLineView = CampaignLineView(frame: CGRect(x: 10, y: 64, width: 300, height: 4))
        titleLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(titleLineView)
        
        var quartileLineView = SectionLineView(frame: CGRect(x: 10, y: 156, width: 300, height: 1))
        quartileLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(quartileLineView)
        
        var engagementLineView = SectionLineView(frame: CGRect(x: 10, y: 198, width: 300, height: 2))
        engagementLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(engagementLineView)
        
        var vtrLineView = SectionLineView(frame: CGRect(x: 10, y: 240, width: 300, height: 2))
        vtrLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(vtrLineView)
        
        var ctrLineView = SectionLineView(frame: CGRect(x: 10, y: 282, width: 300, height: 2))
        ctrLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(ctrLineView)
        
        var sharesLineView = SectionLineView(frame: CGRect(x: 10, y: 324, width: 300, height: 2))
        sharesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(sharesLineView)

        var tweetsLineView = SectionLineView(frame: CGRect(x: 10, y: 366, width: 300, height: 2))
        tweetsLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(tweetsLineView)

        var likesLineView = SectionLineView(frame: CGRect(x: 10, y: 408, width: 300, height: 2))
        likesLineView.backgroundColor = UIColor.clearColor()
        view.addSubview(likesLineView)

        // draw borders for quartile table
        q25Label.layer.borderColor = UIColor.blackColor().CGColor
        q25Label.layer.borderWidth = 1
        
        q50Label.layer.borderColor = UIColor.blackColor().CGColor
        q50Label.layer.borderWidth = 1
        
        q75Label.layer.borderColor = UIColor.blackColor().CGColor
        q75Label.layer.borderWidth = 1
        
        q100Label.layer.borderColor = UIColor.blackColor().CGColor
        q100Label.layer.borderWidth = 1
        
        q25ValueLabel.layer.borderColor = UIColor.blackColor().CGColor
        q25ValueLabel.layer.borderWidth = 1
        
        q50ValueLabel.layer.borderColor = UIColor.blackColor().CGColor
        q50ValueLabel.layer.borderWidth = 1
        
        q75ValueLabel.layer.borderColor = UIColor.blackColor().CGColor
        q75ValueLabel.layer.borderWidth = 1
        
        q100ValueLabel.layer.borderColor = UIColor.blackColor().CGColor
        q100ValueLabel.layer.borderWidth = 1
        
        // NAJ: Test
        loadTestData()
        
        var testObject = PFObject(className: "TestObject")
        
        testObject["foo"] = "bar"
        testObject.saveInBackground()
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTestData() {
        
        // NAJ: This is just a place holder to test loading values into all the labels
        let q25Count = 10
        let q50Count = 3
        let q75Count = 1
        let q100Count = 18
        
        let scoreValue = 73
        let vtrValue = 45
        let ctrValue = 0.1
        let sharesValue = 1216
        let tweetsValue = 34
        let likesValue = 239
        let commentsValue = 87
        
        // Set values
        campaignNameLabel.text = "Acme Campaign"
        
        q25ValueLabel.text = "\(q25Count)"
        q50ValueLabel.text = "\(q50Count)"
        q75ValueLabel.text = "\(q75Count)"
        q100ValueLabel.text = "\(q100Count)"
        
        scoreValueLabel.text = "\(scoreValue)"
        vtrValueLabel.text = "\(vtrValue)%"
        ctrValueLabel.text = "\(ctrValue)%"
        sharesCountLabel.text = "\(sharesValue)"
        tweetsCountLabel.text = "\(tweetsValue)"
        likesCountLabel.text = "\(likesValue)"
        commentsCountLabel.text = "\(commentsValue)"
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
