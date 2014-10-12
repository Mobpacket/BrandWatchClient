//
//  SectionLineView.swift
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/12/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

import UIKit

class SectionLineView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColor(context, [0, 0, 0, 1]) // Black = 1, Alpha = 1
        
        CGContextBeginPath(context)
        
        CGContextMoveToPoint(context, 0, 0)
        
        CGContextAddLineToPoint(context, rect.size.width, 0)
        
        CGContextStrokePath(context)
    }

}
