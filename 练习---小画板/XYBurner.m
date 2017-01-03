//
//  XYBurner.m
//  练习---小画板
//
//  Created by RainPoll on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XYBurner.h"

#import "HexCode.h"
#import "NSData+SubData.h"
#import "NSString+FindString.h"
#import "XYSerialManage.h"

@interface XYBurner ()
@property (nonatomic,copy) void (^callback)(CGFloat NSProgress);

@end

@implementation XYBurner



-(void)didChangleProgress:(void (^)(CGFloat progress))callback
{
    self.callback = callback;
}

/*
 string 返回 (char)类型hex
 */

-(unsigned char *)intergeHexCodeFromString:(NSString *)str
{
    unsigned char * temp;
    
    int i = str.length;
    
    if ((i % 2)) {
        NSLog(@"strlength 奇数");
        return 0;
    }
    
    temp = malloc( i / 2 * sizeof(unsigned char));
    
    NSLog(@"strlength %d",str.length);
    
    for (int index = 0; index < i; index += 2) {
        
        NSRange range = NSMakeRange(index, 2);
        
        NSString *sub = [str substringWithRange:range];
        
        unsigned char result = [self intergeHexCodeFromMinorString:sub];
        
        //   NSLog(@"result %d  hex:%02x\n",result,result);
        
        temp[index/2] = result;
        
    }
    //    free(temp);
    return temp;
}

/*
 读取文件
 返回 切割后文件的文字
 */
-(NSString *)Hexstring2fromFile:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableString *str_M = [@""mutableCopy];
    [data subDataWithLength:45 findCallBack:^(NSData *findData, int index, bool *stop) {
        
        NSString *source = [[NSString alloc]initWithData:findData encoding:NSUTF8StringEncoding];
        //  NSLog(@"分割fileData%@",source);
        
        if (findData.length < 45 ) {
            NSArray *arr = [source componentsSeparatedByString:@"\n"];
            NSMutableString * tailStr  = [@""mutableCopy];
            int tailIndex = 0;
            for (NSString *objS in arr) {
                if (objS.length >12) {
                
                    tailIndex += objS.length - 2 - 10;
                    
                    NSString *obj_N = [objS substringWithRange:NSMakeRange(9, objS.length - 2 - 10)];
                    
                    [tailStr appendString:obj_N];
                }
                
            }
            if (tailStr.length < 32) {
                
                for (int i = 0; i< 32 - tailIndex; i++) {
                    [tailStr appendString:@"F"];
                }
            }
            [str_M appendString:tailStr];
            
        }
        else
        {
            NSRange rang = NSMakeRange(9, 32);
            NSData *data_N = [findData subdataWithRange:rang];
            NSString *strMain = [[NSString alloc]initWithData:data_N encoding:NSUTF8StringEncoding];
            [str_M appendString:strMain];
        }
        
    }];
    return [str_M copy];
}


-(NSString *)HexstringfromFile:(NSString *)fileName
{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];

    NSString *arrS = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
  //  NSLog(@"arrs%@",arrS);
    
    
    NSMutableArray *arr = [[arrS componentsSeparatedByString:@"\n"]mutableCopy];
    
  //  NSLog(@"arr %@",arr);
    NSMutableString *str_M = [@""mutableCopy];

    NSString *last = arr.lastObject;
    
    if ([last isEqualToString:@""]) {
    
        [arr removeObject:last];
    }
        
    for (int i = 0; i< arr.count - 2 ; i++) {
        
        NSMutableString *newS  = [@""mutableCopy];
        
        NSString *orS = [arr objectAtIndex:i];
        
    //    NSLog(@"----->%@----<%u>",orS,orS.length);
        if (orS.length >= 11) {
            newS = [[orS substringWithRange:NSMakeRange(9, 32)]mutableCopy];
        }
        [str_M appendString:newS];
    }
    //last two line
    NSString *lastSec = [arr objectAtIndex:arr.count - 2];
    
    NSMutableString *lastS = [@"" mutableCopy];

    NSMutableString *newLastSec = [[lastSec substringWithRange:NSMakeRange(9, lastSec.length - 11)]mutableCopy];
   
    int tailIndex = newLastSec.length;
    
    if (newLastSec.length < 32) {
      for (int i = 0; i < 32 - tailIndex; i++) {
          [newLastSec appendString:@"F"];
      }
    }
    
  //  NSLog(@"倒数第二行 %@",newLastSec);
    
    [str_M appendString:newLastSec];
    
    for (int i = 0; i< 32; i++) {
        [lastS appendString:@"F"];
    }
   // NSLog(@"倒数第二行 %@",lastS);
    
    [str_M appendString:lastS];
  
   // NSLog(@"arr--->\n%@\n<--------\n",arr);
    return [str_M copy];
    
}

/*
 读取文件
 返回 文件切割后 数组
 */
-(NSArray *)HexArrayfromFile:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableArray *arr_M = [@[]mutableCopy];
    
    [data subDataWithLength:45 findCallBack:^(NSData *findData, int index, bool *stop) {
        
        NSString *source = [[NSString alloc]initWithData:findData encoding:NSUTF8StringEncoding];
        
        if (findData.length < 45 ) {
            
            NSArray *arr = [source componentsSeparatedByString:@"\n"];
            NSMutableString * tailStr  = [@""mutableCopy];
            int tailIndex = 0;
            for (NSString *objS in arr) {
                
                if (objS.length >12) {
                    
                    tailIndex += objS.length - 2 - 10;
                    
                    NSString *obj_N = [objS substringWithRange:NSMakeRange(9, objS.length - 2 - 10)];
                    
                    [tailStr appendString:obj_N];
                }
                
            }
            if (tailStr.length < 32) {
                
                for (int i = 0; i< 32 - tailIndex; i++) {
                    [tailStr appendString:@"F"];
                }
            }
            [arr_M addObject:tailStr];
            
        }
        else
        {
            
            NSRange rang = NSMakeRange(9, 32);
            NSData *data_N = [findData subdataWithRange:rang];
            NSString *strMain = [[NSString alloc]initWithData:data_N encoding:NSUTF8StringEncoding];
            [arr_M addObject:strMain];
            
        }
        
    }];
    
    
    //    NSLog(@"resul\n%@",arr_M);
    
    return arr_M;
}

/*
 字符转换成 十六进制
 */
-(unsigned char)intergeHexCodeFromMinorString:(NSString *)str
{
    char chars[3];
    
    chars[0] = [str characterAtIndex:0];
    chars[1] = [str characterAtIndex:1];
    chars[2] = '\0';
    
    unsigned char result = IntegerCode(chars,16,16);
    
    return result;
}
-(void)sendDataWithContentOfFile:(NSString *)fileName
{
    [self.manage.serial read: self.manage.serial.activePeripheral];
    // NSArray *arr = [self HexArrayfromFile:fileName];
    
    dispatch_queue_t t = dispatch_queue_create("XYBurner", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(t, ^{
        
         [self sendDataWithFile:fileName];
        
    }) ;
  
}

-(void)sendDataWithFile:(NSString *)fileName;
{

    unsigned char **tempList;
    unsigned char *temp[50];
//        unsigned char *temp[50];
    int tempListIndex = 0;  //二维数组中多少行
    int tempCount[50]= {0}; //每行有几个 便于垃圾回收记录
    unsigned char *strTemp ;
    
    
    NSString *string = [self HexstringfromFile:fileName];
    
    NSMutableArray *arrData= [@[]mutableCopy];
    
    [string subStringWithLength:256 findCallBack:^(NSString *findData, int index, bool *stop) {
        
        [arrData addObject:[findData copy]];
        
    }];

    for (int count = 0; count < arrData.count; count ++) {
        
        NSString *str = arrData[count];
        strTemp = [self intergeHexCodeFromString:str];
        
        temp[tempListIndex ++] = strTemp;
        
        tempCount[tempListIndex - 1] = (int)str.length / 2;
        
        //      tempCount[tempListIndex -1] = (int)_hexArr.count/2;
    }
    
    for (int i = 0; i<5; i++) {       //syncing");
        [self writeByte:0x30];
        [self writeByte:0x20];
        
        [NSThread sleepForTimeInterval:0.05];
    }
    
    [self writeByte:0x41];     //reading major version");
    [self writeByte:0x80];
    [self writeByte:0x20];
    [NSThread sleepForTimeInterval:0.05];
    
    [self writeByte:0x41];    //reading minor version");
    [self writeByte:0x81];
    [self writeByte:0x20];
    [NSThread sleepForTimeInterval:0.05];
    
    //    [self writeByte:0x41];
    //    [self writeByte:0x98];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //
    //    [self writeByte:0x41];
    //    [self writeByte:0x84];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x85];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x86];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x87];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x89];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //
    //    [self writeByte:0x41];
    //    [self writeByte:0x81];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x82];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    //    [self writeByte:0x41];
    //    [self writeByte:0x86];
    //    [self writeByte:0x20];
    //    [NSThread sleepForTimeInterval:0.05];
    
    [self writeByte:0x41];       //reading minor version");
    [self writeByte:0x82];
    [self writeByte:0x20];
    [NSThread sleepForTimeInterval:0.05];
    
    
    [self writeByte:0x50];  //entering programming mode");
    [self writeByte:0x20];
    // [self writeByte:0x20];
    [NSThread sleepForTimeInterval:0.05];
    
    [self writeByte:0x75]; //"getting device signature");  这里有问题
    [self writeByte:0x20];
    
    [NSThread sleepForTimeInterval:0.04];
    
    
    unsigned char size  = 64;    //默认值
    unsigned char pageSize = 128;
    unsigned int address = 0;
   
    for(int  i = 0 ; i < tempListIndex ; i++)
    {
        if(tempCount[i] > 0)
        {
            size = tempCount[i] / 2;
            pageSize = size * 2;
            
            unsigned int  laddress = address % 256;
            unsigned int  haddress = address / 256;
            
            address += size;
            
            [self writeByte:0x55];  //"loading page address");
            [self writeByte:laddress];
            [self writeByte: haddress];
            [self writeByte:0x20];
            [NSThread sleepForTimeInterval:0.05];
            
            
            
            [self writeByte:0x64];
            [self writeByte:0x00];
            [self writeByte:(Byte)(pageSize)];
            [self writeByte:0x46];
            
            
            for (int j = 0; j < tempCount[i]; j++) {
             //   printf("%02x ",temp[i][j]);
                
                [self writeByte:temp[i][j]];
                
                [NSThread sleepForTimeInterval:0.01];
                
            }
            printf("第%d段完成传输",i);
            [self writeByte:0x20];
        
            if (self.callback) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.callback(i/(tempListIndex-1.0));
                    
                });
            }
           [NSThread sleepForTimeInterval:0.04];
        }
        printf("\n\n");
    }
    [self writeByte:0x51];
    [self writeByte:0x20];
    
    for(int  i = 0 ; i < tempListIndex ; i++)  //释放
    {
        free(temp[i]);
        printf("\n\n");
    }
}

-(void)writeByte:(unsigned char)byte
{
    [_manage writeData:[self dataWithInt:byte]];
}

-(NSData *)dataWithInt:(unsigned char)data
{
    NSData *sendDa1 = [NSData dataWithBytes:&data length:sizeof(data)];
    return sendDa1;
}



@end
