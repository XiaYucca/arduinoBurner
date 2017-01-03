
#ifndef Burnerinterfaces_h
#define Burnerinterfaces_h

#include <stdio.h>
#include "mega1280Protect.h"

typedef enum{
    STATUS_OK,
    STATUS_FAILED,
    STATUS_TIMEOUT
} Status;

typedef  void (*sendFunc_p) (Message message);
typedef Message (*recvFunc_p) ();

typedef unsigned char (*recvByLengthFunc_p)(unsigned char length);


void regestFunc(sendFunc_p sendfunc,recvFunc_p recvfunc /*,recvByteFunc_p recvBytefunc_p*/);
Message processData(Message message);

Message sendAndRecv(Message message,sendFunc_p sendfunc,recvFunc_p recvfunc);
Status startBurner();
Status signOn();
Status enterIsporgram();
Status get_signature_byte(unsigned char *d);
Status signature_byte();

Status load_program_address(unsigned int add);
Status write_program_flash(unsigned char*d ,unsigned int size);
Status read_program_flash();
Status read_program_flash_byLen(unsigned int size);

Status leave_program_flash();


#endif
