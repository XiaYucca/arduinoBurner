//
//  MegaBurner.h
//  练习---小画板
//
//  Created by RainPoll on 16/8/24.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYSerialManage;
@interface MegaBurner : NSObject

@property (nonatomic,strong)XYSerialManage *manage;

-(void)writeByte:(unsigned char)byte;

-(void)test;

@end
