
#include"mega1280Protect.h"
#include<stdlib.h>
#include "Burnerinterfaces.h"



//typedef uint8_t (*recvByteFunc_p)(int size);


static sendFunc_p _sendfun_p;
static recvFunc_p _recvfunc_p;
//static recvByteFunc_p _recvBytefunc_p;

void regestFunc(sendFunc_p sendfunc,recvFunc_p recvfunc /*,recvByteFunc_p recvBytefunc_p*/)
{
    _sendfun_p = sendfunc;
    _recvfunc_p = recvfunc;
 //   _recvBytefunc_p = recvBytefunc_p;
}

//Message processByte(  )
//{
//    Message result = {};
//    int size = 0;
//    if (message.size >= 6) {
//        if (message.data[0] == 0x1b && message.data[4] == 0x0e ) {
//            size = (message.data[2])&0xff +(message.data[3]<<8)&0xff;
//            unsigned char *c_data = malloc(size * sizeof(unsigned char));
//            
//            for (int i = 0; i < size; i++) {
//                c_data[i] = message.data[i+5];
//            }
//            result.data = c_data;
//            result.size = size;
//        }else
//        {
//            printf("data error -- no flags\r\n");
//        }
//    }
//    else{
//        printf("data error -- no data\r\n");
//    }
//    
//    free(message.data);
//    return result;
//}

Message processData(Message message)
{
    Message result = {};
    int size = 0;
    if (message.size >= 6) {
        if (message.data[0] == 0x1b && message.data[4] == 0x0e ) {
         //   printMessage(message);
            size = ((message.data[2]*256)&0xff) +((message.data[3])&0xff);
            unsigned char *c_data = malloc(size * sizeof(unsigned char));
            
            for (int i = 0; i < size; i++) {
                c_data[i] = message.data[i+5];
            }
            result.data = c_data;
            result.size = size;
        }else
        {
            printf("data error -- no flags\r\n");
        }
    }
    else{
        printf("data error -- no data!!!\r\n");
    }
    
//    free(message.data);
    return result;
}



Message sendAndRecv(Message message,sendFunc_p sendfunc,recvFunc_p recvfunc)
{
    Message result;
    
    if (*sendfunc != NULL)
    {
        (*sendfunc)(message);
    }else{
        printf("cannot send data ,please check interface \r\n");
    }
    if (*recvfunc != NULL)
    {
        result = (*recvfunc)();
     //   printMessage(result);
    }
    else
    {
        printf("cannot recieve data ,please check interface \r\n");
    }
    result = processData(result);
    return result;
}


Status startBurner()
{
    Message m = sign_on();
    Message result = sendAndRecv(m,_sendfun_p ,_recvfunc_p);
    
    if (result.size) {
        return STATUS_OK;
    }
    
    return STATUS_FAILED;
}

Status signOn()
{
    Message m = sign_on();
    
    Message result = sendAndRecv(m, _sendfun_p ,_recvfunc_p);
    if (result.size) {
        if (messageContentMessage(result, messageFromString("AVRISP_2") )) {
            printf("signOn ok \r\n ");
            return STATUS_OK;
        }
    }
    printf("signOn error!!! \r\n ");
    return STATUS_FAILED;
}

Status enterIsporgram()
{                                    //0xc8, 0x64, 0x19, 0x20, 0x00, 0x53, 0x03, 0xac, 0x53, 0x00, 0x00
    Message r = cmd_enter_progmode_isp(0xc8, 0x64, 0x19, 0x20, 0x00, 0x53, 0x03, 0xac, 0x53, 0x00, 0x00);
    
    Message result = sendAndRecv(r, _sendfun_p ,_recvfunc_p);
    
    if (result.size) {
        
        if (result.data[1] == 0) {
            printf("enterIsp OK\r\n ");
            return STATUS_OK;
        }
    }
    return STATUS_FAILED;
}




Status get_signature_byte(unsigned char *d)
{
    Message m = {d,4};
    
    m = spi_multi(0x04,m,0);
    
    Message result = sendAndRecv(m,_sendfun_p ,_recvfunc_p);
    
    if (result.size) {
        
        if (result.data[1] == 0) {
            return STATUS_OK;
        }
    }
    return STATUS_FAILED;
    
}

Status signature_byte()
{
    Status t;
    unsigned char d[4] = {0x30,0x0,0x0,0x0};
    for (int i = 0; i < 3 ; i++) {
        d[2] = i;
      Status x =  get_signature_byte(d);
    
        if (x!=STATUS_OK) {
            t = STATUS_FAILED;
            printf("get signature failed\r\n ");

            
        }else
        {
        printf("get signature ok\r\n ");
        }
    }
    
    return t;
}

Status load_program_address(unsigned int add)
{
    Message m = load_address(add);
    Message result = sendAndRecv(m,_sendfun_p,_recvfunc_p);
    
    if (result.size) {
        
        if (result.data[1] == 0) {
            printf("load address ok\r\n");
            return STATUS_OK;
        }
    }
    return STATUS_FAILED;
}

Status write_program_flash(unsigned char *d ,unsigned int size)
{
    Message m = {d, size};
    
    int bh = (size>>8)&0x00ff;
    int bl = (size)&0x00ff;
   // printf("---addr h %x \r\n ----addr l %x",bh,bl);
    
    m = cmd_program_flash_isp(bh,bl,0xc1,0x0a,0x40,0x4c,0x20,0,0,m);
    Message result = sendAndRecv(m,_sendfun_p,_recvfunc_p);
    
    if (result.size) {
        if (result.data[1] == 0) {
            printf("write programe ok\r\n");
            return STATUS_OK;
        }
    }
    return STATUS_FAILED;
}

Status leave_program_flash()
{
    Message m = cmd_leave_progmode_isp(0x01,0x01);
    Message result = sendAndRecv(m,_sendfun_p,_recvfunc_p);
    
    if (result.size) {
        if (result.data[1] == 0) {
            printf("leave programe flash ok");
            return STATUS_OK;
        }
    }
    return STATUS_FAILED;
}

Status read_program_flash_byLen(unsigned int size)
{
    int bh = (size>>8)&0x00ff;
    int bl = (size)&0x00ff;
    
    
    unsigned char d[4] = {0x14, bh, bl, 0x20};
    Message m = {d,4};
    
    Message result = messageFormatByMessage(m);
    
    result = sendAndRecv(result, _sendfun_p, _recvfunc_p);
    
    if (result.size) {
        if (result.data[1] == 0) {
            printf("read programe flash ok\r\n");
            return STATUS_OK;
        }
    }else
    {
        printf("read_flash_no_data\r\n");
    }
    printMessage(result);
    return STATUS_OK;
}

Status read_program_flash()
{
    unsigned char d[4] = {0x14, 0x10, 0x00, 0x20};
    Message m = {d,4};
    
    Message result = messageFormatByMessage(m);
    
    result = sendAndRecv(result, _sendfun_p, _recvfunc_p);
    
    if (result.size) {
        if (result.data[1] == 0) {
            printf("read programe flash ok\r\n");
            return STATUS_OK;
        }
    }else
    {
        printf("read_flash_no_data\r\n");
    }
    printMessage(result);
    return STATUS_OK;
}















