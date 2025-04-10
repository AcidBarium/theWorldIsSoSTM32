#include "stm32f10x.h" // Device header
#include "Delay.h"
#include "OLED.h"
#include "usart.h"
#include "JQ8X00.h"
#include "Key.h"
#include "CountSensor.h"
#include "Servo.h"

uint32_t Angle; // 定义角度变量
uint16_t sensor_cnt_last = 0;
uint16_t sensor_cnt = 0;
uint16_t Num = 0;
uint16_t is_ok = 0;
uint8_t isMentionWork = 1;

extern void display_oled(uint16_t sensor_cnt, uint32_t Angle, uint16_t Num, uint16_t is_ok);
extern void display_oled_labels(void);
extern void check_sensor_change(void);
extern void check_num_threshold(void);
extern void set_angle_by_num(void);
extern void init(void);

int main(void)
{
	init();
	display_oled_labels();
	while (1)
	{
		display_oled(sensor_cnt, (uint32_t)Angle, Num, is_ok);

		sensor_cnt = CountSensor_Get();
		if (isMentionWork)
			check_sensor_change();
		else
		{
			check_num_threshold();
			set_angle_by_num();
			Servo_SetAngle(Angle);
		}
	}
}

void TIM2_IRQHandler(void)
{
	if (TIM_GetITStatus(TIM2, TIM_IT_Update) == SET) // 判断是否是TIM2的更新事件触发的中断
	{
		Num++;										// Num变量自增，用于测试定时中断
		TIM_ClearITPendingBit(TIM2, TIM_IT_Update); // 清除TIM2更新事件的中断标志位
	}
}
