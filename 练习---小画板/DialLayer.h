//
//  DialLayer.h
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DialLayer : CALayer

@property (nonatomic ,assign) CGColorRef frontLineColor;
@property (nonatomic ,assign) CGColorRef backLineColor;
@property (nonatomic ,assign)CGFloat lineWith;
@property (nonatomic ,assign)CGFloat arcRadius;

@property(nonatomic ,assign)CGFloat beginAngle;
@property (nonatomic ,assign)CGFloat endAngle;
@property (nonatomic, assign)CGFloat currAngle;

@end
