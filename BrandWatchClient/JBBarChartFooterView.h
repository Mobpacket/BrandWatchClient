//
//  JBBarChartFooterView.h
//  BrandWatchClient
//
//  Created by Niaz Jalal on 10/25/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBBarChartFooterView : UIView

@property (nonatomic, assign) CGFloat padding; // label left & right padding (default = 4.0)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;

@end
