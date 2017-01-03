//
//  DialView.m
//  练习---小画板
//
//  Created by RainPoll on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "DialView.h"
#import "DialLayer.h"
#import "DialCircleLayer.h"
#import "XYDirectionCalculate.h"
#include "math.h"


#define XYAngleToRadian(angle)  (angle)*M_PI/180.0

#define XYRadianToAngle(angle)  (angle)/M_PI*180.0

@interface DialView ()<UIGestureRecognizerDelegate>

//@property(nonatomic ,assign)CGFloat beginAngle;
//@property (nonatomic ,assign)CGFloat endAngle;
@property (nonatomic, assign)CGFloat currAngle;

@property (nonatomic ,strong) DialLayer* dialLayer;
@property (nonatomic ,strong) DialCircleLayer *dialCircleLayer;
@property (nonatomic ,strong) UIPanGestureRecognizer *gesture;
@property (nonatomic ,assign) BOOL enableGesture;

@property (nonatomic ,assign) CGFloat touchRangle;


@property (nonatomic ,copy)void(^didUpdateTouch)(CGFloat angle);


@end

@implementation DialView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        
    }
    return self;
}


-(void)setup
{
   
    self.dialCircleLayer = [DialCircleLayer layer];
      self.dialLayer = [DialLayer layer];
    
    _dialLayer.frame = self.layer.frame;
    
    _dialLayer.arcRadius = 80;
    _dialLayer.frontLineColor = [UIColor greenColor].CGColor;
    _dialLayer.lineWith = 8;
    _dialLayer.backgroundColor = [UIColor blackColor].CGColor;

    _dialCircleLayer.radius = 6;
    _dialCircleLayer.lineWith = 3;
    _dialCircleLayer.lineColor = [UIColor whiteColor].CGColor;
    _dialCircleLayer.fillColor = [UIColor greenColor].CGColor;
    

    _dialCircleLayer.bounds = CGRectMake(0, 0, (_dialCircleLayer.radius + _dialCircleLayer.lineWith)*2, (_dialCircleLayer.radius + _dialCircleLayer.lineWith)*2);
    
    CGFloat anchX = (_dialLayer.arcRadius - _dialCircleLayer.bounds.size.width * 0.5)/(_dialCircleLayer.bounds.size.width);
    [_dialCircleLayer setAnchorPoint:CGPointMake(-anchX, 0.5)];
    
    _dialCircleLayer.position = CGPointMake(self.center.x , self.center.y);
    
  
    self.beginAngle = 40;//XYAngleToRadian(120);
    self.endAngle = -40;//XYAngleToRadian(60);
    self.currAngle = _beginAngle;
    
    self.progress = 0.5;  //设置当前进度
    _touchRangle = 40;
    
    
    [self.layer addSublayer:_dialLayer];
    [self.layer addSublayer:_dialCircleLayer];
    
    self.backgroundColor = [UIColor blackColor];
    
    [self loadGesture];
    }

-(void)loadGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesttureClick:)];
    self.gesture = pan;
    pan.delegate = self;
    
    [self addGestureRecognizer:pan];
}

-(void)layoutSubviews
{
    DialLayer *layer = [DialLayer layer];
    [self.layer addSublayer:layer];
    [layer setNeedsDisplay];
}


-(void)gesttureClick:(UIPanGestureRecognizer *)pan
{
  
    CGPoint point = [pan locationInView:self];
  
    if (touchRingWithPoint(self.center, _dialLayer.arcRadius - _touchRangle, _dialLayer.arcRadius + _touchRangle, point)) {

        CGFloat result =  getAngleWithPoint(self.center,point);
         self.currAngle = getCoordinateTransform(result, M_PI_2);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.gesture addTarget:self action:@selector(gesttureClick:)];
}
-(void)didUpdateTouch:(void (^)(CGFloat))callback
{
    self.didUpdateTouch = callback;
}

-(void)setCurrAngle:(CGFloat)currAngle
{
    if (currAngle != _currAngle) {
        _currAngle = currAngle;
        if ([self isDraw:currAngle]) {
           
            self.dialLayer.currAngle = currAngle;
            //关闭隐式动画
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self.dialCircleLayer setAffineTransform:CGAffineTransformMakeRotation(self.currAngle)];
            
            
            [_dialCircleLayer setNeedsDisplay];
            [self.dialLayer setNeedsDisplay];
            [CATransaction commit];
            CGFloat progress =  [self progress:_currAngle];
            !_didUpdateTouch ?: _didUpdateTouch(progress);
            NSLog(@"PROGRESS ----->%f",progress);
         }
            if (fabsf(_currAngle - M_PI_2) < XYAngleToRadian(5)) {
            [self.gesture removeTarget:self action:@selector(gesttureClick:)];
            }
            NSLog(@"currang %f",XYRadianToAngle( _currAngle));
    }
}

-(BOOL)isDraw:(CGFloat)angle
{
    if ((angle >= _beginAngle && angle < M_PI * 2)||(angle < _endAngle && angle >=0)) {

        return  YES;
    }
    return NO;
}

-(void)setProgress:(CGFloat)progress
{
    CGFloat ANGLE = progress *(M_PI * 2 - _beginAngle + _endAngle) + _beginAngle;
    if (ANGLE > M_PI *2)
    {
        ANGLE = ANGLE - M_PI * 2;
    }
    if (progress >1.0) {
        ANGLE = _endAngle;
    }
    self.currAngle = ANGLE;
}

-(CGFloat)progress:(CGFloat) angle
{
//    static BOOL leftAngle;
//    static BOOL rightAngle;
//    static BOOL midAngle;

    CGFloat dAngle;

    if (angle >= _beginAngle && angle < M_PI * 2) {
   
        dAngle = angle - _beginAngle;
    }else if ((angle < _endAngle && angle >=0)) {

        dAngle = M_PI * 2 - _beginAngle + _currAngle;
    }
    if (angle >= _endAngle && angle < _beginAngle) {
    
        return  1;
    }
    
    dAngle = dAngle / (M_PI * 2 - _beginAngle + _endAngle);
    
    if (dAngle < 0.001) {
        dAngle = 0;
    }
    if (dAngle > 0.999) {
        dAngle = 1;
    }
    return dAngle;
    
}

-(void)setBeginAngle:(CGFloat)beginAngle
{
    _beginAngle =XYAngleToRadian(90 + beginAngle);
    _dialLayer.beginAngle = _beginAngle;
    [_dialCircleLayer setNeedsDisplay];
    [self.dialLayer setNeedsDisplay];
  
}
-(void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = XYAngleToRadian(90 + endAngle);
    _dialLayer.endAngle = _endAngle;
    [_dialCircleLayer setNeedsDisplay];
    [self.dialLayer setNeedsDisplay];
}

-(void)setArcWith:(CGFloat)arcWith
{
    if (_arcWith != arcWith) {
        _dialLayer.lineWith = arcWith;
        _arcWith = arcWith;
    }
}
-(void)setArcColor:(UIColor *)arcColor
{
    if (_arcColor != arcColor) {
        _dialLayer.frontLineColor = arcColor.CGColor;
        _arcColor = arcColor;
    }
}

-(void)setCircleRadius:(CGFloat)circleRadius
{
    if (_circleRadius != circleRadius) {
        _circleRadius = circleRadius;
        _dialCircleLayer.radius = circleRadius;
        
    }
    
}
-(void)setCircleLineWith:(CGFloat)circleLineWith
{
    if (_circleLineWith != circleLineWith) {
        _circleLineWith = circleLineWith;
        _dialCircleLayer.lineWith = circleLineWith;
    }
}
-(void)setCircleFillColor:(UIColor *)circleFillColor
{
    if (_circleFillColor != circleFillColor) {
        _circleFillColor = circleFillColor;
        
        _dialCircleLayer.fillColor = circleFillColor.CGColor;
    }
}
-(void)setCircleLineColor:(UIColor *)circleLineColor
{
    if (_circleLineColor != circleLineColor) {
        _circleLineColor = circleLineColor;
        _dialCircleLayer.lineColor = circleLineColor.CGColor;
    }
}








@end
