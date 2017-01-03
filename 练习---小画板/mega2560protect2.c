//
//  mega2560protect2.c
//  练习---小画板
//
//  Created by RainPoll on 16/8/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#include "mega2560protect2.h"
//
//  mega1280Protect.c
//  AlsRobot_4WD
//
//  Created by RainPoll on 16/7/13.
//  Copyright © 2016年 RainPoll. All rights reserved.
//

/*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

#include "mega1280Protect.h"
#include <stdlib.h>

#define message_start 0x1B
#define message_mark 0x0E

unsigned char * messageFormat(unsigned char *data, unsigned short  dataSize)
{
    static unsigned char num = 0;
    unsigned char chack;
    unsigned char h_size;
    unsigned char l_size;
    unsigned char *result;
    
    num ++;  //
    
    h_size = (dataSize >> 8)&0xff;
    l_size = dataSize & 0x00ff;
    
    result = malloc((dataSize + 6)*sizeof(unsigned char));
    
    for (int i = 0; i < dataSize + 6; i ++) {
        
        if (i == 0) {
            result[i] = message_start;
        }else if (i == 1)
        {
            result[i]= num;
        }
        else if (i == 2)
        {
            result[i]= h_size;
        }else if(i == 3)
        {
            result[i] = l_size;
        }else if (i == 4)
        {
            result[i]= message_mark;
        }else if (i == dataSize + 5)
        {
            result[i] = chack;
            return result;
            
        }else
        {
            result[i] = data[i-5];
        }
        chack ^= result[i];
    }
    return result;
}


Message messageFormatByMessage(Message message)
{
    Message me ={  messageFormat(message.data, message.size), message.size + 6};
    return me;
}

Message messageFormatByList(unsigned char *data,unsigned short dataSize)
{
    Message me ={  messageFormat(data, dataSize), dataSize + 6};
    return me;
}


Message sign_on()
{
    unsigned char CMD_SIGN_ON = 0x01 ;
    return messageFormatByList(&CMD_SIGN_ON, 1);
}


Message load_address(unsigned int address)
{
    unsigned char CMD_LOAD_ADDRESS = 0x06;
    
    unsigned char data[4]={};
    
    data[0] = (address >> 24) & 0xff;
    data[1] = (address >> 16) & 0xff;
    data[2] = (address >> 8) & 0xff;
    data[3] = (address) & 0xff;
    
    unsigned char dataM[5] = {CMD_LOAD_ADDRESS,data[0],data[1],data[2],data[3]};
    Message me = {dataM , 5};
    return messageFormatByMessage(me);
}


Message send_chip_erase_isp()
{
    unsigned char CMD_CHIP_ERASE_ISP                  = 0x12;
    
    unsigned char data[7] = {CMD_CHIP_ERASE_ISP,0x37,0x00,0xac,0x80,0x00,0x00};
    
    return messageFormatByList(data, 7);
    
}

Message spi_multi(unsigned char numRx,Message data,unsigned char rxStartAddr)
{
    unsigned char CMD_SPI_MULTI                       = 0x1D;
    
    unsigned char *dataM;
    
    dataM = malloc((4 + data.size)* sizeof(unsigned char));
    
    dataM[0] = CMD_SPI_MULTI;
    dataM[1] = data.size;
    dataM[2] = numRx;
    dataM[3] = rxStartAddr;
    
    for (int i = 0; i<data.size; i++) {
        dataM[i+4] = (data.data)[i];
    }
    Message message = {dataM,data.size + 4};
    
    
    
    return messageFormatByMessage(message);
}

Message cmd_enter_progmode_isp(
                               unsigned char timeout,
                               unsigned char stabDelay,
                               unsigned char cmdexeDelay,
                               unsigned char synchLoops,
                               unsigned char byteDelay,
                               unsigned char pollValue,
                               unsigned char pollIndex,
                               unsigned char cmd1,
                               unsigned char cmd2,
                               unsigned char cmd3,
                               unsigned char cmd4)
{
    unsigned char CMD_FIRMWARE_UPGRADE = 0x10;
    //    unsigned char timeout;
    //    unsigned char stabDelay;
    //    unsigned char cmdexeDelay;
    //    unsigned char synchLoops;
    //    unsigned char byteDelay;
    //    unsigned char pollValue;
    //    unsigned char pollIndex;
    //    unsigned char cmd1;
    //    unsigned char cmd2;
    //    unsigned char cmd3;
    //    unsigned char cmd4;
    
    unsigned char cmd[12]={CMD_FIRMWARE_UPGRADE,timeout,stabDelay,cmdexeDelay,synchLoops,byteDelay,pollValue,pollIndex,cmd1,cmd2,cmd3,cmd4};
    
    Message message = { cmd, 12};
    
    return messageFormatByMessage(message);
}


Message cmd_leave_progmode_isp(unsigned char preDelay, unsigned char postDelay)
{
    unsigned char CMD_LEAVE_PROGRAM_MODE = 0x11;
    unsigned char cmd[3] = {CMD_LEAVE_PROGRAM_MODE,preDelay,postDelay};
    
    Message message = {cmd,3};
    
    return message;
}


Message cmd_chip_erase_isp(unsigned char eraseDelay, unsigned char pollMethod, unsigned char cmd1 ,unsigned char cmd2, unsigned char cmd3, unsigned char cmd4)
{
    unsigned char CMD_CHIP_ERASE_ISP  = 0x12;
    
    unsigned char data[7] = {CMD_CHIP_ERASE_ISP,eraseDelay,pollMethod,cmd1,cmd2,cmd3,cmd4};
    
    return messageFormatByList(data, 7);
}


Message cmd_program_flash_isp(unsigned char numBytes_h,
                              unsigned char numBytes_l,
                              unsigned char mode,
                              unsigned char cmd_delay,
                              unsigned char cmd1,
                              unsigned char cmd2,
                              unsigned char cmd3,
                              unsigned char poll1,
                              unsigned char poll2,
                              Message data )
{
    
    unsigned char CMD_PROGRAM_FLASH_ISP = 0x13;
    unsigned char *dataM = malloc((data.size + 9)*sizeof(unsigned char));
    dataM[0] = CMD_PROGRAM_FLASH_ISP;
    dataM[1] =numBytes_h;
    dataM[2] =numBytes_l;
    dataM[3] =mode;
    dataM[4] =cmd_delay;
    dataM[5] =cmd1;
    dataM[6] =cmd2;
    dataM[7] =cmd3;
    dataM[8] = poll1;
    dataM[9] = poll2;
    
    for (int i = 0; i<data.size; i++) {
        dataM[i+9] = data.data[i];
    }
    
    Message message = {dataM,data.size+10};
    return message;
}

Message write_hfuse(unsigned char byte)
{
    unsigned char bytes = 0xd8;
    if (byte) {
        bytes = byte;
    }
    unsigned char data[4]={0xac,0xa8,0x00,bytes};
    
    Message me = {data ,4};
    
    Message m2 = {{1,2,3,4},4};
    
    return  spi_multi(4, me, 0);
}

Message write_lfuse(unsigned char byte)
{
    unsigned char bytes = 0xef;
    if (byte) {
        bytes = byte;
    }
    unsigned char data[4]={0xac,0xa0,0x00,bytes};
    
    Message me = {data ,4};
    
    Message m2 = {{1,2,3,4},4};
    
    return  spi_multi(4, me, 0);
}

Message write_efuse(unsigned char byte)
{
    unsigned char bytes = 0xff;
    if (byte) {
        bytes = byte;
    }
    unsigned char data[4]={0xac, 0xA4, 0x00, bytes};
    
    Message me = {data ,4};
    
    Message m2 = {{1,2,3,4},4};
    
    return  spi_multi(4, me, 0);
}

void mega_enter_progmode_isp()
{
    printMessage(
                 cmd_enter_progmode_isp(0xc8, 0x64, 0x19, 0x20, 0x00, 0x53, 0x03, 0xac, 0x53, 0, 0)
                 );
}

void mega_chip_erase_isp()
{
    printMessage(
                 cmd_chip_erase_isp(0x37, 0x00, 0xac, 0x80, 0, 0)
                 );
}

void mega_load_page(Message data)
{
    unsigned char numByte_h = data.size >> 8 & 0xff;
    unsigned char numByte_l = data.size & 0x00ff;
    
    printMessage(
                 cmd_program_flash_isp(numByte_h, numByte_l, 0xc1, 0X06, 0X40, 0X4C, 0X20, 0, 0, data)
                 );
    
}

void mega_load_address(unsigned int addr)
{
    unsigned int address ;
    unsigned char WORDSIZE = 2;
    
    load_address(address / WORDSIZE);
}

float mega_load_data(Message data)
{
    unsigned int currentByteAddr = 0;
    unsigned int size = data.size;
    unsigned int blockSize = 0x0080;
    float progress = 0.0;
    
    while (currentByteAddr < size) {
        
        mega_load_address(currentByteAddr);
        
        Message temp = messageSub(data, currentByteAddr, blockSize);
        
        mega_load_page(temp);
        
        progress = (currentByteAddr)/size;
        
    }
    return  progress;
}


******
 测试用的
 *****
Message messageSub( Message message, unsigned int  index ,unsigned int length)
{
    unsigned int len = message.size;
    Message rem ;
    
    if (index > len) {
        printf("error out range of message");
        return rem;
    }
    
    if (index + length > len) {
        length = len - index;
    }
    unsigned char * data = malloc(length * sizeof(unsigned char));
    
    for (int i = 0 ; i< length ;i++) {
        data[i] = message.data[index + i];
    }
    rem.data = data;
    rem.size = length;
    
    return rem;
}

Message messageApendMessage(Message m1,Message m2)
{
    unsigned char *temp = malloc((m1.size + m2.size)*sizeof(unsigned char));
    
    for (int i = 0; i < m1.size + m2.size  ; i++) {
        if (i< m1.size) {
            temp[i] = m1.data[i];
        }else
        {
            temp[i] = m2.data[i- m1.size];
        }
    }
    
    Message message = {temp ,m1.size + m2.size};
    return message;
}

void printMessage(Message m)
{
    printf("\nmessageSize : %d = (\n",m.size);
    
    for (int i = 0; i < m.size ; i++) {
        printf("%.2x ",m.data[i]);
    }
    printf(")\n");
}

Bool messageContentMessage(Message m1,Message m2)
{
    if (m1.size < m2.size) {
        return No;
    }else
    {
        for (int i = 0; i < m1.size; i++) {
            
            if (m1.data[i] == m2.data[0]) {
                //  int m = i;
                for (int j = 0; j < m2.size; j++) {
                    if (m1.data[i+j] != m2.data[j]) {
                        break;
                    }
                    if (j == m2.size - 1) {
                        return Yes;
                    }
                    
                }
                
            }
            
        }
    }
    return No;
}

Message messageFromString(char *str)
{   char *org = str;
    int len = 0;
    while (*str) {
        len++;
        str++;
    }
    unsigned char *data = malloc(len * sizeof(unsigned char));
    len = 0;
    while (*org) {
        data[len++] = *org++;
        //        printf("%c",*org);
    }
    
    Message m = {data ,len};
    
    printMessage(m);
    
    return m;
}
*/


