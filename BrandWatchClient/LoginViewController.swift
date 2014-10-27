//
//  LoginViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var watchLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var loginView: UIView!
    
    var loginCircleButton: DKCircleButton!
    
    // NAJ: Temporary for testing, remove
    var useDashboardView = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Login View NIB setup
        var loginNIB = UINib(nibName: "LoginView", bundle: nil)
        
        var objects = loginNIB.instantiateWithOwner(self, options: nil)
        
        loginView = objects[0] as UIView
        
        view.addSubview(loginView)
        
        // Setup the UI
        constructUI()
    }
    
    func loginCircleButtonTapped() {
        
        println("OnLoginCircleButton() pressed")
        
        var auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeyChainItemName, clientID: clientID, clientSecret: clientSecret) as GTMOAuth2Authentication
        
        if !auth.canAuthorize {
            
            var scope = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/yt-analytics.readonly"
            
            var vc = GTMOAuth2ViewControllerTouch(scope: scope, clientID: clientID, clientSecret: clientSecret, keychainItemName: kKeyChainItemName, delegate: self, finishedSelector:Selector("authentication:finishedWithAuth:error:"))
            
            self.presentViewController(vc, animated: true) { () -> Void in
                println("auth done")
            }
        } else {
            
            authentication(GTMOAuth2ViewControllerTouch(), finishedWithAuth: auth, error: NSError())
        }
    }

    func constructUI() {
        
        // setup view and button colors
        loginView.backgroundColor = UIColor.clearColor()
        loginView.backgroundColor = UIColor.BWDarkBlue()
        
//        logoImageView.hidden = true
        logoImageView.animationDuration = 1.0
        logoImageView.layer.borderColor = UIColor.BWOffWhite().CGColor
        logoImageView.layer.borderWidth = 0
        
        brandLabel.textColor = UIColor.BWRed()
        brandLabel.layer.backgroundColor = UIColor.BWOffWhite().CGColor
        watchLabel.textColor = UIColor.BWOffWhite()
        watchLabel.layer.backgroundColor = UIColor.BWRed().CGColor

        loginCircleButton = DKCircleButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loginCircleButton.center = CGPointMake(160, 380)
        loginCircleButton.titleLabel?.font = UIFont.systemFontOfSize(22)
        loginCircleButton.backgroundColor = UIColor.BWRed()
        loginCircleButton.borderColor = UIColor.BWOffWhite()
        loginCircleButton.borderSize = 3
        loginCircleButton.setTitle("Sign In", forState: UIControlState.Normal)
        loginCircleButton.setTitleColor(UIColor.BWOffWhite(), forState: UIControlState.Normal)
        loginCircleButton.addTarget(self, action: "loginCircleButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginCircleButton)
    }
    
    func authentication(viewController: GTMOAuth2ViewControllerTouch, finishedWithAuth: GTMOAuth2Authentication, error: NSError)
    {
        // TODO: Handle the error case for invalid username / password
        //        if (error != nil)
        //        {
        //            println("error")
        //
        //        }
        //        else
        //        {
        //        }
        // Authentication Succeeded
        //self.mytoken = finishedWithAuth.accessToken
        println("success oauth")
        
        service = YouTubeClient.sharedInstance
        service.authorizer = finishedWithAuth
        
        CampaignService.sharedInstance.warmupCache()
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("dismissed")
        })

        // NAJ: Remove, for testing while moving to dashboard
        if useDashboardView == true {
            
            let dashboardVC = DashboardViewController() as DashboardViewController

            self.presentViewController(dashboardVC, animated: true) { () -> Void in
                
                println("transitioning to dashboard controller")
            }
        } else {
            
            let campaignVC = CampaignViewController() as CampaignViewController
            
            self.presentViewController(campaignVC, animated: true) { () -> Void in
                
                println("transitioning to campaign controller")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
