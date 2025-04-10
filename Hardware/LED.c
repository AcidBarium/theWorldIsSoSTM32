#include "stm32f10x.h"                  // Device header

void LED_Init(void)
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);//开启时钟
	
	GPIO_InitTypeDef GPIO_InitStructure;//结构体变量
	GPIO_InitStructure.GPIO_Mode= GPIO_Mode_Out_PP;//推挽输出
	GPIO_InitStructure.GPIO_Pin= GPIO_Pin_1 | GPIO_Pin_2;//设置端口
	GPIO_InitStructure.GPIO_Speed= GPIO_Speed_50MHz;//输出速度
	GPIO_Init(GPIOA,&GPIO_InitStructure);//初始化
	
	GPIO_SetBits(GPIOA,GPIO_Pin_1 | GPIO_Pin_2);//LED关闭状态
}

void LED1_ON(void)//低电平亮
{
	GPIO_ResetBits(GPIOA,GPIO_Pin_1);
}

void LED1_OFF(void)//高电平灭
{
	GPIO_SetBits(GPIOA,GPIO_Pin_1);
}

void LED1_Turn(void)//取返
{
	if(GPIO_ReadOutputDataBit(GPIOA,GPIO_Pin_1)==0)
	{
		GPIO_SetBits(GPIOA,GPIO_Pin_1);//高电平灭
	}
	else
	{
		GPIO_ResetBits(GPIOA,GPIO_Pin_1);//低电平亮
	}
}

void LED2_ON(void)//低电平亮
{
	GPIO_ResetBits(GPIOA,GPIO_Pin_2);
}

void LED2_OFF(void)//高电平灭
{
	GPIO_SetBits(GPIOA,GPIO_Pin_2);
}

void LED2_Turn(void)//取返
{
	if(GPIO_ReadOutputDataBit(GPIOA,GPIO_Pin_2)==0)
	{
		GPIO_SetBits(GPIOA,GPIO_Pin_2);//高电平灭
	}
	else
	{
		GPIO_ResetBits(GPIOA,GPIO_Pin_2);//低电平亮
	}
}

