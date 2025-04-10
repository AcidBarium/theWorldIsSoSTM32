        AREA    |.text|, CODE, READONLY
        EXPORT  init
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明外部函数
        IMPORT  Servo_Init
        IMPORT  OLED_Init
        IMPORT  JQ8x00_Init
        IMPORT  Key_Init
        IMPORT  CountSensor_Init
        IMPORT  NVIC_PriorityGroupConfig
        IMPORT  uart_init
        IMPORT  Delay_ms
        IMPORT  JQ8x00_Command_Data

init PROC
        PUSH    {r4, lr}          ; 保存寄存器和返回地址（8字节，满足对齐）

        ; Servo_Init();
        BL      Servo_Init

        ; OLED_Init();
        BL      OLED_Init

        ; JQ8x00_Init();
        BL      JQ8x00_Init

        ; Key_Init();
        BL      Key_Init

        ; CountSensor_Init();
        BL      CountSensor_Init

        ; NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
        MOV     r0, #2            ; NVIC_PriorityGroup_2 通常为 2（根据 STM32F10x 库定义）
        BL      NVIC_PriorityGroupConfig

        ; uart_init(9600);
        MOVW    r0, #9600         ; r0 = 9600（使用 MOVW 处理大立即数）
        BL      uart_init

        ; Delay_ms(500);
        MOVW    r0, #500          ; r0 = 500
        BL      Delay_ms

        ; JQ8x00_Command_Data(SetVolume, 0);
        MOV     r0, #19           ; SetVolume = 19 (0x13)
        MOV     r1, #0            ; 数据 = 0
        BL      JQ8x00_Command_Data

        ; Delay_ms(10);
        MOV     r0, #10           ; r0 = 10
        BL      Delay_ms

        POP     {r4, pc}          ; 恢复寄存器并返回

        ENDP
        END