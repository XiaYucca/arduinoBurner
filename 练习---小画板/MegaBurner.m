//
//  MegaBurner.m
//  练习---小画板
//
//  Created by RainPoll on 16/8/24.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "MegaBurner.h"

#import "Burnerinterfaces.h"
#import "XYSerialManage.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "NSData+SubData.h"
#import "NSString+FindString.h"

#import "XYBurner.h"


@interface MegaBurner ()

@property(nonatomic ,strong)NSData *recData;
@property(nonatomic ,assign)BOOL isTimeOut;
@property(nonatomic ,strong)NSTimer *timer;

@property(nonatomic, strong) dispatch_semaphore_t sem;

//@property (nonatomic,weak) MegaBurner* mega;
@end

static MegaBurner *this;

@implementation MegaBurner
{
   bool already ;
}


-(instancetype)init
{
    if (self = [super init]) {
        
        this = self;
        self.sem = dispatch_semaphore_create(0);
        
    }
    return self;
}

#pragma mark - c interfaces

void sendData(Message m){
    
    NSData *send_data = [NSData dataWithBytes:m.data length:m.size];
//    NSLog(@" \r\n send_data ----:%lu",send_data.length);
    printMessage(m);
    
    int writeLength = 16;
    
    if (send_data.length > writeLength) {
        
        [send_data subDataWithLength:writeLength findCallBack:^(NSData *findData, int index, bool *stop) {
            
             [this.manage writeData:findData];
            
             [NSThread sleepForTimeInterval:0.01];

        }];
    }
    else{
        
        [this.manage writeData:send_data];
    }
    
    
    //
    //    for (int i = 0; i < m.size; i++) {
    //
    //        unsigned char temp = m.data[i];
    //
    //        NSData *data = [NSData dataWithBytes:&temp length:1];
    //
    //        [this.manage writeData:data];
    //
    //        [NSThread sleepForTimeInterval:0.001];
    //
    //        
    //    }
    //
    //4
   
}

Message recvData(void)
{
    //信号量 接收线程同步信号
    __block dispatch_semaphore_t semMain = dispatch_semaphore_create(0);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [this recvDataOCFunc];
    //    NSLog(@" getdata %lu",this.recData.length);
        dispatch_semaphore_signal(semMain);
    });
    
 //   NSLog(@"wait thread recvmain");
    
    dispatch_semaphore_wait(semMain, DISPATCH_TIME_FOREVER);
    
  //  NSLog(@"end thread recvmain");
    Message m =  [this messageFromNSData:this.recData];
    this.recData = nil;
    return m ;
}

#pragma mark - c->oc interface

-(NSData *)dataWithInt:(unsigned char)data
{
    NSData *sendDa1 = [NSData dataWithBytes:&data length:sizeof(data)];
    return sendDa1;
}

-(Message)messageFromNSData:(NSData *)data
{
 //   NSLog(@"data-length%lu",data.length);
    unsigned char *da = malloc(data.length *sizeof(unsigned char ));
    [data getBytes:da  length:data.length];
    Message me = {da, (unsigned int)data.length};
 //   printMessage(me);
    
    return me;
}



#pragma mark - oc transform

-(void)writeByte:(unsigned char)byte
{
    [_manage writeData:[self dataWithInt:byte]];
}

-(void)setRecData:(NSData *)recData
{
    if (_recData != recData) {
        _recData = recData;
 
     //   NSLog(@"收到%lu",recData.length);
        _isTimeOut = NO;

    }
}

#pragma mark - enter interface
-(void)test{
    
    __weak MegaBurner *weakSelf = self;
    [self.manage peripheralValueChangle:^(CBPeripheral *peripheral, NSData *data) {
        weakSelf.recData = data;
    //    NSLog(@"test 函数收到%lu",_recData.length);
        dispatch_semaphore_signal(weakSelf.sem);
        
    }];
    
    [self sendDataWithFile:@"Blink.ino.hex"];
}


-(void)sendDataWithFile:(NSString *)fileName;
{
    
    
    XYBurner *burnerManage = [[XYBurner alloc]init];
    
    unsigned char **tempList;
    unsigned int *tempCount;
    unsigned char *strTemp ;
    
    
    NSString *string = [burnerManage HexstringfromFile:fileName];
    
    
    NSMutableArray *arrData= [@[]mutableCopy];
    [string subStringWithLength:512 findCallBack:^(NSString *findData, int index, bool *stop) {
        [arrData addObject:[findData copy]];
    }];
    
    tempList = malloc(arrData.count * sizeof(unsigned char *));
    tempCount = malloc(arrData.count * sizeof(int));
    
    __block unsigned char ** tempListOr = tempList;
    __block unsigned int *tempCountOr = tempCount;
    
    
    for (int count = 0; count < arrData.count; count ++) {
        
        NSString *str = arrData[count];
        
        strTemp = [burnerManage intergeHexCodeFromString:str];
        
        *(tempList++) = strTemp;
        *(tempCount++) = (int)str.length / 2;
        
    }
    
  //  NSLog(@"修改的string%@",string);
    
//    int  len = string.length / 2;
//    
//    unsigned char *orData = [burnerManage intergeHexCodeFromString:string];
//    unsigned char *orData_temp = orData;
//    NSLog(@"测试%lu",len);
//    
//    
    tempList = tempListOr;
    tempCount = tempCountOr;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        regestFunc(sendData, recvData);
        
        signOn();
        [NSThread sleepForTimeInterval:0.02];
        
        signOn();
        [NSThread sleepForTimeInterval:0.02];
        
        
        
 //       signOn();
      //[NSThread sleepForTimeInterval:0.05];
        
 //       enterIsporgram();
      //[NSThread sleepForTimeInterval:0.05];
        
        enterIsporgram();
       [NSThread sleepForTimeInterval:0.02];
        
        signature_byte();
       [NSThread sleepForTimeInterval:0.02];
      //  enterIsporgram();
        
        unsigned int address = 0x80000000;
        
        load_program_address(address);
        
        write_program_flash(*(tempListOr),(tempCountOr[0]));
        
        [NSThread sleepForTimeInterval:0.7];
        

//        write_program_flash(orData_temp,(unsigned int)len);
        for (int i = 0; i < arrData.count; i++) {
            
            int size = tempCountOr[i];
       
            NSLog(@"addrsize +++++++++++++%u add =========%x",size,address);
            
           // enterIsporgram();
           // [NSThread sleepForTimeInterval:0.02];
            
            load_program_address(address);
            
            [NSThread sleepForTimeInterval:0.01];
            
             write_program_flash(*(tempListOr++),(unsigned int)size);
            
            [NSThread sleepForTimeInterval:0.8];
            
            //read_program_flash_byLen(size);
            
             address += size;
        }
        
        address = 0x80000000;
        
        tempListOr = tempList;
        tempCountOr = tempCount;
        
        for (int i = 0; i < arrData.count; i++) {
            
            int size = tempCountOr[i];
            
            NSLog(@"read data  addrsize +++++++++++++%u add =========%x",size,address);
            
            // enterIsporgram();
            // [NSThread sleepForTimeInterval:0.02];
            
            load_program_address(address);
            
            [NSThread sleepForTimeInterval:0.01];
            
              read_program_flash_byLen(size);
           // write_program_flash(*(tempListOr++),(unsigned int)size);
            
            [NSThread sleepForTimeInterval:0.8];
            
            //read_program_flash_byLen(size);
            
            address += size;
        }

        
        
        
       
        
//        load_program_address(0x80000600);
//        NSLog(@"开始读取问题");
//       // read_program_flash();
//        read_program_flash_byLen(0x0100);
//
//        [NSThread sleepForTimeInterval:0.3];
        
//        load_program_address(0x80000000);
//        NSLog(@"开始读取第二段++++++++++++++++++\r\n\r\n");
//        
//        read_program_flash_byLen(0x0100);
//
//        [NSThread sleepForTimeInterval:0.3];
        
        
        leave_program_flash();

        
        
       
        
//        write_program_flash(*tempListOr,128);
//        [NSThread sleepForTimeInterval:0.1];
//        
//        load_program_address(0x80000000 + 128);
//        [NSThread sleepForTimeInterval:0.1];
//        
//        write_program_flash(*(tempListOr+1),128);
//        [NSThread sleepForTimeInterval:0.1];
    });

//    
//    [NSThread sleepForTimeInterval:0.04];
//    
//    
//    unsigned char size  = 64;    //默认值
//    unsigned char pageSize = 128;
//    unsigned int address = 0;
//    
//    
//    for(int  i = 0 ; i < tempListIndex ; i++)
//    {
//        if(tempCount[i] > 0)
//        {
//            size = tempCount[i] / 2;
//            pageSize = size * 2;
//            
//            unsigned int  laddress = address % 256;
//            unsigned int  haddress = address / 256;
//            
//            address += size;
//            
//            [self writeByte:0x55];  //"loading page address");
//            [self writeByte:laddress];
//            [self writeByte: haddress];
//            [self writeByte:0x20];
//            [NSThread sleepForTimeInterval:0.05];
//            
//            
//            
//            [self writeByte:0x64];
//            [self writeByte:0x00];
//            [self writeByte:(Byte)(pageSize)];
//            [self writeByte:0x46];
//            
//            
//            for (int j = 0; j < tempCount[i]; j++) {
//                //   printf("%02x ",temp[i][j]);
//                
//                [self writeByte:temp[i][j] ];
//                
//                [NSThread sleepForTimeInterval:0.01];
//                
//            }
//            printf("第%d段完成传输",i);
//            [self writeByte:0x20];
//            
//            if (self.callback) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    self.callback(i/(tempListIndex-1.0));
//                    
//                });
//            }
//            [NSThread sleepForTimeInterval:0.04];
//        }
//        printf("\n\n");
//    }
   /*
    for(int  i = 0 ; i < tempListIndex ; i++)  //释放
    {
        free(temp[i]);
        printf("\n\n");
    }
     */
 }



-(void)recvDataOCFunc{

//timer 单独放到一个线程  要不等待信号量的时候会阻塞线程;
//   dispatch_queue_t t =  dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //不放到主线程时候 ,block 访问timer有点问题
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeOut:) userInfo:nil repeats:NO];
//        NSRunLoop *loop = [NSRunLoop currentRunLoop];
//        [loop addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [loop run];
    });
    
   // wait for the semaphore
 //   NSLog(@" wait recv data");
    dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
    
//    NSLog(@" end recv data");
//    NSLog(@"remove timer %@",self.timer);
    [_timer invalidate];
    _timer = nil;
    
}

-(void)timeOut:(NSTimer *)timer
{
        NSLog(@"进入超时%@",_timer);
        [_timer invalidate];
        _timer = nil;
        dispatch_semaphore_signal(_sem);
        _isTimeOut = YES;
}

/*

-(void)testw{
    
    //   dispatch_suspend(<#dispatch_object_t object#>)
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //  dispatch_release(group);
    //   dispatch_release(semaphore);
}
-(void)testd{
    
    //    __block BOOL isok = NO;
    //
    //    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //    Engine *engine = [[Engine alloc] init];
    //
    //    [engine queryCompletion:^(BOOL isOpen) {
    //        isok = isOpen;
    //        dispatch_semaphore_signal(sema);
    //    } onError:^(int errorCode, NSString *errorMessage) {
    //        isok = NO;
    //        dispatch_semaphore_signal(sema);
    //    }];
    //
    //    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //    dispatch_release(sema);
}

-(NSData *)dataByTimeOut:(float)timeout
{
    static BOOL bloop = YES;
    NSDate* dat1 = [NSDate dateWithTimeIntervalSinceNow:0];
    
    while (true) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSinceDate:dat1];
        if (a > timeout) {
            return self.recData;
            break;
        }else
        {
            if (self.recData.length) {
                return  self.recData;
            }
        }
        
    }
}
*/




@end
