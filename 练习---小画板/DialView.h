//
//  DialView.h
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialView : UIView


@property (nonatomic,assign)CGFloat progress;

-(void)didUpdateTouch:(void (^)(CGFloat progress))callback;


@property(nonatomic ,assign)CGFloat beginAngle;
@property (nonatomic ,assign)CGFloat endAngle;

//设置圆弧
@property(nonatomic ,assign)CGFloat arcWith;
@property(nonatomic ,strong)UIColor *arcColor;

//设置圆圈
@property(nonatomic ,assign)CGFloat circleLineWith;
@property(nonatomic ,strong)UIColor *circleLineColor;
@property(nonatomic ,assign)CGFloat circleRadius;
@property(nonatomic ,strong)UIColor *circleFillColor;



@end
