//
//  main.c
//  进制计算
//
//  Created by RainPoll on 15/7/28.
//  Copyright (c) 2015年 RainPoll. All rights reserved.
//

#include <stdio.h>

//char end[10],Dat[10];
//int com,cmp;

int judgeSouceData(char * da,char com)
{   char flag=0;
    while(*da)
    {
        if(!((*da>='0'&&*da<='9')||((*da>='a'&&*da<='f')||(*da>='A'&&*da<='F'))))
        {flag=1; break;}
        da++;
    }
    if (flag) {
        printf("字符转换 有错误\n");
        return 0;
    }
    return 1;
    
}


//进制数据判断
int judgeSouceDataFormat(char * da,int com)
{
    char flag=0;char cmp1,cmp2,cmp3;
    if(com>10){                                        //设定范围的如果是16进制就另行判断
        cmp1='a'-10+com; cmp2='A'-10+com;cmp3='9';}
    if(com<=10)
    {cmp3='0'+com-1; cmp1='a'; cmp2='A';}
    
    while(*da)
    {
        if(!((*da>='0'&&*da<=cmp3)||((*da>='a'&&*da<cmp1)||(*da>='A'&&*da<cmp2))))  //如果符合条件就是存在的
        {flag=1; break;}
        da++;
    }
    if (flag) {
        printf("输入%d进制数%s格式有误,请重新输入\n\n",com,da);
        return 0;
    }
    return 1;
    
}
//
//进制数据转换函数

int IntegerCode(char* da, int  com,int  cmp)
{
    int x = 0; char get;
    char *dat=da;
    
    if( !judgeSouceData(da,com))
    {
        return 0;
    }
    if (! judgeSouceDataFormat(da, com)) {
    
        return 0;
    }
//
    /* if(com>10){      //如果是字母的话
     if(*dat>'a')x=*dat-'a'+10;
     if(*dat>'A')x=*dat-'A'+10;
     }
     else
     x=0;  //如果是数字的话
     
     if(cmp>10){      //如果是字母的话
     if(*dat>'a')x=*dat-'a'+10;
     if(*dat>'A')x=*dat-'A'+10;
     }*/
  
    //   printf("%d,%d\n",'a','f');
    
    while(*dat)
    {
        if(com>10)
        {
            if((*dat>='a'&&*dat<='f'))   //对超过16进制的数据单独运算
            {
                get=*dat;              //只能用个参数接收赋值不能直接对*dat赋值操作
                get=get-'a'+10;
                x=x*com+get;
                dat++;}
            else if((*dat>='A'&&*dat<='F'))
            {  get=*dat;
                get=get-'A'+10;
                x=x*com+get;
                dat++;
            }
            
            else   x=x*com+((*dat++)-'0');    //低于十进制数据直接计算成某进制数据  还是以十进制表示
        }
        else x=x*com+((*dat++)-'0');
    }
    return (int)x;
}




//char* InterCodeToString(char* da, int  com,int  cmp)
//{
//    long x ;char c,i,get;
//    char temp[20];char *tempc,*dat=da;
//    /* if(com>10){      //如果是字母的话
//     if(*dat>'a')x=*dat-'a'+10;
//     if(*dat>'A')x=*dat-'A'+10;
//     }
//     else
//     x=0;  //如果是数字的话
//     
//     if(cmp>10){      //如果是字母的话
//     if(*dat>'a')x=*dat-'a'+10;
//     if(*dat>'A')x=*dat-'A'+10;
//     }*/
//    x = InterCode(da,com,cmp);
//    
//    while(x>0)
//    {
//        c =x%cmp;             //之前转换成的十进制数据转换成某进制数据
//        x=x/cmp;
//        if(cmp>10&&c>=10)             //如果是大于十进制，并且数据大于十  字母字符表示；
//        {
//            temp[i++]=c+'A'-10;
//        }
//        else
//            temp[i++]=c+'0';    //得到字符数据顺序是反的
//    }
//    tempc=temp;
//    
//    while(i--)      //反序存储
//    {
//        end[i]=*tempc;
//        tempc++;
//    }
//    
//    return end;
//}


















