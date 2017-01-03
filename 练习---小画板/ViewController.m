//
//  ViewController.m
//  练习---小画板
//
//  Created by 远洋 on 15/11/17.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "HMView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet HMView *hmView;

@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlide;


- (IBAction)didChangeColor:(UIButton *)sender;

- (IBAction)save:(UIBarButtonItem *)sender;


- (IBAction)clear:(id)sender;


- (IBAction)back:(UIBarButtonItem *)sender;


- (IBAction)erase:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

- (IBAction)lineWidthChange:(UISlider *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self didChangeColor:_firstButton];
    
    //block来传值
    self.hmView.lineWidthBlock = ^CGFloat(){
        
       return  self.lineWidthSlide.value;
    };
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - /********改变颜色*******/
- (IBAction)didChangeColor:(UIButton *)sender {
    
    self.hmView.lineColor = sender.backgroundColor;
    
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    UIGraphicsBeginImageContext(self.hmView.bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.hmView.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    
    [self.hmView save];
    
}

- (IBAction)clear:(id)sender {
    [self.hmView clear];
    
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self.hmView back];
    
}

- (IBAction)erase:(id)sender {
    
    [self.hmView erase];
    if(((UIBarButtonItem *)sender).tag == 2)
    {
        [self.hmView reStart];
    }
}

#pragma mark - /********监听线宽的值的改变事件*******/

- (IBAction)lineWidthChange:(UISlider *)sender {
    
    if (sender.tag == 1) {
        self.hmView.lineWidth = sender.value;
    }
    if (sender.tag == 2) {
        self.hmView.speed = sender.value;
    }
}
@end
