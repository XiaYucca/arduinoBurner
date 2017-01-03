//
//  setMaskView.h
//  XYCoreBlueToothDemo
//
//  Created by RainPoll on 16/1/16.
//  Copyright © 2016年 RainPoll. All rights reserved.
//

#import "TestViewController.h"
#import "SetMaskView.h"

#import "XYDirectionCalculate.h"
#import "DialLayer.h"

#import "DialView.h"

#import "XYSerialManage.h"
#import "SerialGATT.h"

#import "XYBurner.h"

#import "MegaBurner.h"


#import "NSData+SubData.h"

#import "netdb.h"






@interface TestViewController ()

@property (nonatomic ,strong)SetMaskView *mask;
@property (nonatomic ,strong)XYSerialManage *manage;

@property (nonatomic ,copy)NSArray *hexArr;
@property (nonatomic ,copy)NSString *fileName;

@property (nonatomic ,strong)XYBurner *burner;

@property (nonatomic ,strong)MegaBurner *megaBurner;

@property (nonatomic ,copy)NSMutableArray *arr;

@end

@implementation TestViewController
{
    
}


-(void)viewDidLoad
{
   getAngleWithPoint(CGPointMake(0, 0), CGPointMake(0, 1));
    
   getAngleWithPoint(CGPointMake(0, 0), CGPointMake(1, 1));
    
   getAngleWithPoint(CGPointMake(0, 0), CGPointMake(1, 0));

    
 
    getAngleWithPoint(CGPointMake(0, 0), CGPointMake(1, -1));
    
    getAngleWithPoint(CGPointMake(0, 0), CGPointMake(0, -1));
    
    getAngleWithPoint(CGPointMake(0, 0), CGPointMake(-1, -1));
    
    getAngleWithPoint(CGPointMake(0, 0), CGPointMake(-1, 0));
    
    getAngleWithPoint(CGPointMake(0, 0), CGPointMake(-1, 1));
    
    
    
    NSString *dts = [self getIPWithHostName:@"www.baidu.com"];
    NSLog(@"getIP");
    NSLog(dts);
    
    
    
    
//    DialLayer *layer = [DialLayer layer];
//    
//    layer.frame = CGRectMake(200, 0, 100, 100);
//    layer.backgroundColor = [[UIColor greenColor]CGColor];
////
//    [self.view.layer addSublayer:layer];
    
    
    DialView *dialV = [[DialView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.view addSubview: dialV];
    
    dialV.backgroundColor = [UIColor grayColor];
    
    
//    
//    [dialV.layer addSublayer:layer];
//    
//    [layer needsDisplay];

    XYSerialManage *manage = [[XYSerialManage alloc]init];
    
    self.manage = manage;
    
    __weak TestViewController * weakself = self;
    self.burner = [[XYBurner alloc]init];
    
    [self.burner didChangleProgress:^(CGFloat progress) {
        
        NSLog(@"++++++++++++++++++++%0.2f",progress);
        dialV.progress = progress;
        
    }];
    
    _burner.manage = manage;
    
  //  [self testLoop];
    
    NSString *str = @"123456789";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [data subDataWithLength:2 findCallBack:^(NSData *findData, int index, bool *stop) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:findData encoding:NSUTF8StringEncoding]);
        
    }];
    
    
    
  
}

-(void)testSendMes
{
    
    NSLog(@"*****************************sendMes Yes");
}

-(void)testMega
{
    self.megaBurner = [[MegaBurner alloc]init];
    
    _megaBurner.manage = self.manage;
    [_megaBurner test];
    
}

-(IBAction)buttonclick:(UIButton *)btn
{
    __weak TestViewController *weakSelf = self;
    if (btn.tag == 10) {
   
        [_manage blueToothAutoScaning:1.5 withTimeOut:10 autoConnectDistance:-70 didConnected:^(CBPeripheral *peripheral) {
            NSLog(@"连接完成");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              //  [self senddata];
                [weakSelf.burner sendDataWithContentOfFile:@"downFile_loop.hex"];
                
            });
        } timeOutCallback:^{
            NSLog(@"连接超时");
        }];
    }
    if (btn.tag == 20) {
        
        [_manage disConnectPeripheral:_manage.serial.activePeripheral];
        
    }
    if (btn.tag==30 ) {
     
        [weakSelf.burner sendDataWithContentOfFile:@"downFile_loop.hex"];

    }
    if (btn.tag == 40) {
        
     //   [self intergeHexCodeFromString:@"a1e1ff3"];
        
      //  [self HexstringfromFile];
        
//         self.fileName = @"downFile.hex";
//         [self senddata];
//        
        [weakSelf.burner sendDataWithContentOfFile:@"downFile.hex"];

        
        

    }
    if (btn.tag == 50) {
    
        if (self.megaBurner.manage)
        {
            [self testMega];
 
        }else
        {
        [_manage blueToothAutoScaning:1.5 withTimeOut:10 autoConnectDistance:-70 didConnected:^(CBPeripheral *peripheral) {
            NSLog(@"连接完成");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //  [self senddata];
               // [weakSelf.burner sendDataWithContentOfFile:@"downFile_loop.hex"];
                
                [self testMega];
                
            });
        } timeOutCallback:^{
            NSLog(@"连接超时");
        }];
        }
        
    }
    
    if(btn.tag == 60)
    {
        if (self.megaBurner.manage)
        {
           // [self testMega];
            
        }else
        {
            [_manage blueToothAutoScaning:1.5 withTimeOut:10 autoConnectDistance:-70 didConnected:^(CBPeripheral *peripheral) {
                NSLog(@"连接完成");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //  [self senddata];
                    // [weakSelf.burner sendDataWithContentOfFile:@"downFile_loop.hex"];
                    
                 //   [self testMega];
                    
                    self.megaBurner = [[MegaBurner alloc]init];
                    _megaBurner.manage = self.manage;
                    
                });
            } timeOutCallback:^{
                NSLog(@"连接超时");
            }];
        }
    }
    
    
}
-(void)test2
{
    static BOOL bloop = YES;
    NSDate* dat1 = [NSDate dateWithTimeIntervalSinceNow:0];
    
    while (true) {
          NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
          NSTimeInterval a=[dat timeIntervalSinceDate:dat1];
         
          NSString *timeString = [NSString stringWithFormat:@"%f", a];
         NSLog(timeString);
         
         if (a > 3) {
             break;
         }
         
//        if ((time(NULL) - uiTimestamp) > 0.5) {
//            break;
//        }else
//        {
//            NSLog(@"test 2");
//        }
    }
    
    
}



-(void)testLoop
{
    
    NSString *str = [NSMutableString stringWithFormat:@"test"];
    
    NSLog(@"%@",str);
    
    
    
    
//    [self test2];
//    UIViewController * co = [[TestViewController alloc]init];
//    
//    TestViewController * co1 = [[UIViewController alloc]init];
    
    __block int i = 0;
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue = dispatch_queue_create("zenny_chen_firstQueue", nil);
    dispatch_async(queue, ^(void) {
        while(true)
        {
            sleep(2-i/50);
            NSLog(@"The sum is: %d", i);
            
        }
    
     //    signal the semaphore
        dispatch_semaphore_signal(sem);
    });

    // wait for the semaphore
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    

//    dispatch_queue_t t = dispatch_queue_create("test",DISPATCH_QUEUE_SERIAL);
//    dispatch_async(t, ^{
//
//        while (true) {
//            i++;
//            NSLog(@"dispath async");
//        }
//    });
//    while (true) {
//        NSLog(@"main thread %d",i);
//    }
   
/*
    __block bool shouldLoop_p  = YES;
    NSData *data;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"value before%d",shouldLoop_p);

        if (shouldLoop_p == NO) {
            //没有超时;
        }else
        {
          shouldLoop_p = NO;
            NSLog(@"读取数据超时");
        }
//      pthread_mutex_unlock(&mutex);
        shouldLoop_p = NO;
        NSLog(@"value%d",shouldLoop_p);
    });
    
//    while (true) {
//    
// //           pthread_mutex_lock(&mutex);
//    
//            if (! shouldLoop_p) {
//                break;
//            }
//    
//            if (self.readData.length) {
//                data = [self.readData copy];
//                self.readData = nil;
//                shouldLoop_p = NO;
//            }
//            else
//            {
//                NSLog(@"一直在读取");
//            }
// //            pthread_mutex_unlock(&mutex);
//       //     sleep(1);
//        }
 //   return data;*/
}


//-(NSData *)dataWithHexString:(NSString *)
//{
//    
//}


//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.mask = [SetMaskView setMaskView];
//    [self.mask maskViewShowWithComplement:nil];
//}

-(NSString *) getIPWithHostName:(const NSString *)hostName
{
    struct addrinfo * result;
    struct addrinfo * res;
    char ipv4[128];
    char ipv6[128];
    int error;
    BOOL IS_IPV6 = FALSE;
    bzero(&ipv4, sizeof(ipv4));
    bzero(&ipv4, sizeof(ipv6));
    
    error = getaddrinfo([hostName UTF8String], NULL, NULL, &result);
    if(error != 0) {
        NSLog(@"error in getaddrinfo:%d", error);
        return nil;
    }
    for(res = result; res!=NULL; res = res->ai_next) {
        char hostname[1025] = "";
        error = getnameinfo(res->ai_addr, res->ai_addrlen, hostname, 1025, NULL, 0, 0);
        if(error != 0) {
            NSLog(@"error in getnameifno: %s", gai_strerror(error));
            continue;
        }
        else {
            switch (res->ai_addr->sa_family) {
                case AF_INET:
                    memcpy(ipv4, hostname, 128);
                    break;
                case AF_INET6:
                    memcpy(ipv6, hostname, 128);
                    IS_IPV6 = TRUE;
                default:
                    break;
            }
            NSLog(@"hostname: %s ", hostname);
        }
    }
    freeaddrinfo(result);
    if(IS_IPV6 == TRUE) return [NSString stringWithUTF8String:ipv6];
    return [NSString stringWithUTF8String:ipv4];
}




// 2001:2:0:1baa::c0a8:101

@end
