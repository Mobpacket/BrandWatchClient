//
//  CampaignLineView.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/11/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class CampaignLineView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        
        var context = UIGraphicsGetCurrentContext()
        
//        CGContextSetStrokeColor(context, [1, 0, 0, 1]) // Red = 1, Alpha = 1

        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        CGContextBeginPath(context)
        
        CGContextMoveToPoint(context, 0, 0)
        
        CGContextAddLineToPoint(context, rect.size.width, 0)
        
        CGContextStrokePath(context)
    }
}


