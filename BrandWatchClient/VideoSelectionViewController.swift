//
//  VideoSelectionViewController.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/21/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class VideoSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var VideoSelectionTitleMenuButton: UIButton!
    @IBOutlet weak var videoSelectionTableView: UITableView!
    
    var videoSelectionView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        var nib = UINib(nibName: "VideoSelectionView", bundle: nil)
        
        var objects = nib.instantiateWithOwner(self, options: nil)
        
        videoSelectionView = objects[0] as UIView
        view.addSubview(videoSelectionView)
        
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
