//
//  XYBurner.h
//  练习---小画板
//
//  Created by RainPoll on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class XYSerialManage;

@protocol  XYBurner <NSObject>

//@required

//-(void)writeByte:(unsigned char)byte;

@end

@interface XYBurner : NSObject

@property (nonatomic ,strong)XYSerialManage *manage;

@property (nonatomic, assign)CGFloat progress;

-(void)sendDataWithContentOfFile:(NSString *)fileName;

-(void)didChangleProgress:(void (^)(CGFloat progress))callback;

-(NSString *)HexstringfromFile:(NSString *)fileName;

-(unsigned char *)intergeHexCodeFromString:(NSString *)str;




@end
