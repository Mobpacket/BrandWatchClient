//
//  ViewController.swift
//  BrandWatchClient
//
//  Created by Nabib El-Rahman on 10/9/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var testObject = PFObject(className: "TestObject");
        
        testObject["foo"] = "bar";
        testObject.saveInBackground();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

