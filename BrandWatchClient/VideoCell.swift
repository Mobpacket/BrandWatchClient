//
//  VideoCell.swift
//  BrandWatchClient
//
//  Created by Nabib El-RAHMAN on 10/28/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
