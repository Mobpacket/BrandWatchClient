//
//  LoginViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Login View NIB setup
        var loginNIB = UINib(nibName: "LoginView", bundle: nil)
        
        var objects = loginNIB.instantiateWithOwner(self, options: nil)
        
        var loginView = objects[0] as UIView
        
        // setup view and button colors
        loginView.backgroundColor = UIColor.clearColor()
        loginView.backgroundColor = UIColor.blackColor()
        loginButton.layer.backgroundColor = UIColor.clearColor().CGColor
        loginButton.layer.borderColor = UIColor.orangeColor().CGColor
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 2
        loginButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        loginButton.setTitle("Sign In", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        loginButton.clipsToBounds = true
        
        view.addSubview(loginView)
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
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("dismissed")
        })
        
        let campaignVC = CampaignViewController() as CampaignViewController
        
        self.presentViewController(campaignVC, animated: true) { () -> Void in
            
            println("transitioning to campaign controller")
        }

    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        
        let campaignVC = CampaignViewController() as CampaignViewController
        
        println("OnLogin() pressed")
        
        var auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeyChainItemName, clientID: clientID, clientSecret: clientSecret) as GTMOAuth2Authentication
        
        if !auth.canAuthorize {
            
            var scope = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/yt-analytics.readonly"
            
            var vc = GTMOAuth2ViewControllerTouch(scope: scope, clientID: clientID, clientSecret: clientSecret, keychainItemName: kKeyChainItemName, delegate: self, finishedSelector:Selector("authentication:finishedWithAuth:error:"))
            
            self.presentViewController(vc, animated: true) { () -> Void in
                println("auth done")
            }
        }
        else
        {
            authentication(GTMOAuth2ViewControllerTouch(), finishedWithAuth: auth, error: NSError())
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
