        AREA    |.text|, CODE, READONLY
        EXPORT  check_sensor_change
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明外部函数
        IMPORT  CountSensor_Get
        IMPORT  JQ8x00_Command_Data

        ; 声明全局变量
        IMPORT  sensor_cnt
        IMPORT  sensor_cnt_last
        IMPORT  isMentionWork
        IMPORT  Num

check_sensor_change PROC
        PUSH    {r4-r6, lr}       ; 保存寄存器和返回地址
        SUB     SP, SP, #4        ; 调整栈指针，确保 8 字节对齐（12+4=16字节）

        ; sensor_cnt = CountSensor_Get();
        BL      CountSensor_Get   ; 调用函数，返回值在 r0
        LDR     r4, =sensor_cnt   ; r4 = &sensor_cnt
        STRH    r0, [r4]          ; sensor_cnt = r0 (半字存储)

        ; if (sensor_cnt != sensor_cnt_last)
        LDR     r5, =sensor_cnt_last ; r5 = &sensor_cnt_last
        LDRH    r1, [r5]          ; r1 = sensor_cnt_last
        CMP     r0, r1            ; 比较 sensor_cnt 和 sensor_cnt_last
        BEQ     end_if            ; 如果相等，跳出 if 分支

        ; isMentionWork = 0;
        LDR     r6, =isMentionWork ; r6 = &isMentionWork
        MOV     r2, #0
        STRB    r2, [r6]          ; isMentionWork = 0 (字节存储)

        ; Num = 0;
        LDR     r6, =Num          ; r6 = &Num
        STRH    r2, [r6]          ; Num = 0 (半字存储)

        ; JQ8x00_Command_Data(SetVolume, 10);
        MOV     r0, #19           ; SetVolume = 19 (0x13)
        MOV     r1, #10           ; 数据 = 10
        BL      JQ8x00_Command_Data

        ; JQ8x00_Command_Data(AppointTrack, 2);
        MOV     r0, #7            ; AppointTrack = 7 (0x07)
        MOV     r1, #2            ; 数据 = 2
        BL      JQ8x00_Command_Data

        ; sensor_cnt_last = sensor_cnt;
        LDRH    r0, [r4]          ; r0 = sensor_cnt
        STRH    r0, [r5]          ; sensor_cnt_last = sensor_cnt

end_if
        ADD     SP, SP, #4        ; 恢复栈指针
        POP     {r4-r6, pc}       ; 恢复寄存器并返回

        ENDP
        END