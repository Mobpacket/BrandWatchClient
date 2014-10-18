//
//  LoginViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController/*, GPPSignInDelegate*/ {

//    var signIn: GPPSignIn!
    
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
        
        // Google Plus OAuth2 setup
//        signIn = GPPSignIn.sharedInstance() as GPPSignIn
//        
//        signIn.trySilentAuthentication()
//        
//        signIn.shouldFetchGooglePlusUser = true
//        
//        signIn.shouldFetchGoogleUserEmail = true
//        
//        signIn.delegate = self
        
        // Do any additional setup after loading the view.
    }

//    func finishedWithAuth(auth: GTMOAuth2Authentication,  error: NSError ) -> Void {
//        
//        println("finishWithAuth()")
//    }
    
    func didDisconnectWithError ( error: NSError) -> Void {
        
        println("didDisconnectWithError()")
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        
        let campaignVC = CampaignViewController() as CampaignViewController
        
        println("OnLogin() pressed")
        
//        GPPSignIn.sharedInstance().authenticate()
        
        self.presentViewController(campaignVC, animated: true) { () -> Void in
            
            println("transitioning to campaign controller")
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
