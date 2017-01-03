//
//  DialLayer.m
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "DialLayer.h"
#import "DialCircleLayer.h"
#import"XYDirectionCalculate.h"

#import <UIKit/UIKit.h>



@implementation DialLayer
{
    CGFloat currAngleTemp;
}

-(instancetype)init
{
    if (self = [super init]) {
 
        _lineWith = 10;
        _arcRadius = 50;
        _frontLineColor = [UIColor brownColor].CGColor;
        _backLineColor = [UIColor grayColor].CGColor;

        [self removeAllAnimations];
        
    }
    return self;
}

+(instancetype)layer
{
    return [[DialLayer alloc]init];
}

#pragma mark - 坐标系转换
//-(void)changleCoordinateTransform:(CGFloat)
//{
//    
//}




-(void)setCurrAngle:(CGFloat)currAngle
{
    
    _currAngle  = currAngle; // getCoordinateTransform(currAngle);
    
//    NSLog(@"currangle  ++++++> %lf",_currAngle);
}

-(void)setBeginAngle:(CGFloat)beginAngle
{
    _beginAngle = getCoordinateTransform(0, -beginAngle);
}


-(void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = getCoordinateTransform(0, -endAngle);

}

+(BOOL)needsDisplayForKey:(NSString *)key
{
    return [super needsDisplayForKey:key];
}




-(void)drawInContext:(CGContextRef)ctx
{
   

//      CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    
        CGContextSetStrokeColorWithColor(ctx, self.frontLineColor);
    
        CGContextSetLineWidth(ctx, self.lineWith);
        
        CGContextAddArc(ctx, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, _arcRadius, _beginAngle, _currAngle, 0);
        
//      CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextDrawPath(ctx, kCGPathStroke);
    
    
        CGContextSetStrokeColorWithColor(ctx, _backLineColor);
    
        CGContextSetLineWidth(ctx, self.lineWith);
    
        CGContextAddArc(ctx, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, _arcRadius, _currAngle, _endAngle, 0);
    
//      CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextDrawPath(ctx, kCGPathStroke);
    
    
    
//    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
//    
//    CGContextSetLineWidth(ctx, 10);
//    
//    CGContextAddArc(ctx, 100, 100, 50, 0, 2*M_PI, 1);
//    
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    
}




@end
