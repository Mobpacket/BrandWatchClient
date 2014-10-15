//
//  SettingsLineView.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/15/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class SettingsLineView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextBeginPath(context)
        
        CGContextMoveToPoint(context, 0, 0)
        
        CGContextAddLineToPoint(context, rect.size.width, 0)
        
        CGContextStrokePath(context)
    }
}
