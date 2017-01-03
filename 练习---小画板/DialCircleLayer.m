//
//  DialCircleLayer.m
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//
#import "DialCircleLayer.h"
#import <UIKit/UIKit.h>
@implementation DialCircleLayer
{
    CGPoint centerP;
}

+(instancetype)layer{
    
    return  [[DialCircleLayer alloc]init];
}

-(instancetype)init
{
    if (self = [super init]) {

        //self.anchorPoint = CGPointMake(0.5, 0.5);
        _radius = 8;
        _lineWith = 4;
        _fillColor = [UIColor greenColor].CGColor;
        _lineColor = [UIColor brownColor].CGColor;
        
        [self removeAllAnimations];
   
        
    }
    
    return  self;
}
-(instancetype)initWithLayer:(id)layer
{
    
    
    return [super initWithLayer:layer];
}



-(void)drawInContext:(CGContextRef)ctx
{

    
//       centerP.x= self.frame.size.width * 0.5;
//    
//        centerP.y = self.frame.size.height *0.5;
    
      //   CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    
     //    UIColor *aColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//       CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
 //      CGContextSetLineWidth(ctx, self.lineWith);
    
       CGContextAddArc(ctx,self.bounds.size.width * 0.5 ,self.bounds.size.width * 0.5, self.radius, 0, 2*M_PI, 1);;
    //        CGContextDrawPath(ctx, kCGPathStroke)
       CGContextClosePath(ctx);
       CGContextSetFillColorWithColor(ctx, self.fillColor);
       CGContextFillPath(ctx);
    
    
    
    
       CGContextSetStrokeColorWithColor(ctx,self.lineColor);
    
       CGContextSetLineWidth(ctx, self.lineWith);
       CGContextAddArc(ctx,self.bounds.size.width * 0.5 ,self.bounds.size.width * 0.5, self.radius, 0, 2*M_PI, 1);
       CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //   CGContextStrokePath(ctx);
    
}



@end
