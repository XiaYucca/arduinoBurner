//
//  DialCircleLayer.h
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DialCircleLayer : CALayer

@property (nonatomic ,assign) CGColorRef lineColor;
@property (nonatomic ,assign) CGColorRef fillColor;
@property (nonatomic ,assign) CGFloat radius;
@property (nonatomic ,assign) CGFloat lineWith;

@end
