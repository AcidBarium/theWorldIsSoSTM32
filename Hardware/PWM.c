#include "stm32f10x.h" // Device header

/**
 * 函    数：PWM初始化
 * 参    数：无
 * 返 回 值：无
 */
void PWM_Init(void)
{
	/*开启时钟*/
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2, ENABLE);  // 开启TIM2的时钟
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE); // 开启GPIOA的时钟

	/*GPIO初始化*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure); // 将PA1引脚初始化为复用推挽输出
										   // 受外设控制的引脚，均需要配置为复用模式

	/*配置时钟源*/
	TIM_InternalClockConfig(TIM2); // 选择TIM2为内部时钟，若不调用此函数，TIM默认也为内部时钟

	/*时基单元初始化*/
	TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;				// 定义结构体变量
	TIM_TimeBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;		// 时钟分频，选择不分频，此参数用于配置滤波器时钟，不影响时基单元功能
	TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up; // 计数器模式，选择向上计数
	TIM_TimeBaseInitStructure.TIM_Period = 20000 - 1;				// 计数周期，即ARR的值
	TIM_TimeBaseInitStructure.TIM_Prescaler = 36 - 1;				// 预分频器，即PSC的值
	TIM_TimeBaseInitStructure.TIM_RepetitionCounter = 0;			// 重复计数器，高级定时器才会用到
	TIM_TimeBaseInit(TIM2, &TIM_TimeBaseInitStructure);				// 将结构体变量交给TIM_TimeBaseInit，配置TIM2的时基单元

	/*输出比较初始化*/
	TIM_OCInitTypeDef TIM_OCInitStructure;						  // 定义结构体变量
	TIM_OCStructInit(&TIM_OCInitStructure);						  // 结构体初始化，若结构体没有完整赋值
																  // 则最好执行此函数，给结构体所有成员都赋一个默认值
																  // 避免结构体初值不确定的问题
	TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;			  // 输出比较模式，选择PWM模式1
	TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;	  // 输出极性，选择为高，若选择极性为低，则输出高低电平取反
	TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable; // 输出使能
	TIM_OCInitStructure.TIM_Pulse = 0;							  // 初始的CCR值
	TIM_OC2Init(TIM2, &TIM_OCInitStructure);					  // 将结构体变量交给TIM_OC2Init，配置TIM2的输出比较通道2

	/*中断输出配置*/
	TIM_ClearFlag(TIM2, TIM_FLAG_Update); // 清除定时器更新标志位
										  // TIM_TimeBaseInit函数末尾，手动产生了更新事件
										  // 若不清除此标志位，则开启中断后，会立刻进入一次中断
										  // 如果不介意此问题，则不清除此标志位也可

	TIM_ITConfig(TIM2, TIM_IT_Update, ENABLE); // 开启TIM2的更新中断

	/*NVIC中断分组*/
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); // 配置NVIC为分组2
													// 即抢占优先级范围：0~3，响应优先级范围：0~3
													// 此分组配置在整个工程中仅需调用一次
													// 若有多个中断，可以把此代码放在main函数内，while循环之前
													// 若调用多次配置分组的代码，则后执行的配置会覆盖先执行的配置

	/*NVIC配置*/
	NVIC_InitTypeDef NVIC_InitStructure;					  // 定义结构体变量
	NVIC_InitStructure.NVIC_IRQChannel = TIM2_IRQn;			  // 选择配置NVIC的TIM2线
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;			  // 指定NVIC线路使能
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 2; // 指定NVIC线路的抢占优先级为2
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;		  // 指定NVIC线路的响应优先级为1
	NVIC_Init(&NVIC_InitStructure);							  // 将结构体变量交给NVIC_Init，配置NVIC外设

	/*TIM使能*/
	TIM_Cmd(TIM2, ENABLE); // 使能TIM2，定时器开始运行
}

/**
 * 函    数：PWM设置CCR
 * 参    数：Compare 要写入的CCR的值，范围：0~100
 * 返 回 值：无
 * 注意事项：CCR和ARR共同决定占空比，此函数仅设置CCR的值，并不直接是占空比
 *           占空比Duty = CCR / (ARR + 1)
 */
void PWM_SetCompare2(uint16_t Compare)
{
	TIM_SetCompare2(TIM2, Compare); // 设置CCR2的值
}
