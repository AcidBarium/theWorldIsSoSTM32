        AREA    |.text|, CODE, READONLY
        EXPORT  check_num_threshold
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明外部函数
        IMPORT  JQ8x00_Command_Data

        ; 声明全局变量
        IMPORT  Num
        IMPORT  isMentionWork
        IMPORT  sensor_cnt
        IMPORT  sensor_cnt_last

check_num_threshold PROC
        PUSH    {r4-r6, lr}       ; 保存寄存器和返回地址（16字节）
        SUB     SP, SP, #4        ; 调整栈指针，确保 8 字节对齐（20字节）

        ; if (Num >= 1500)
        LDR     r4, =Num          ; r4 = &Num
        LDRH    r0, [r4]          ; r0 = Num (uint16_t)
        MOVW    r1, #1500         ; r1 = 1500（使用 MOVW 加载大立即数）
        CMP     r0, r1            ; 比较 Num 和 1500
        BLO     end_if            ; 如果 Num < 1500，跳到结束

        ; isMentionWork = 1;
        LDR     r5, =isMentionWork ; r5 = &isMentionWork
        MOV     r2, #1
        STRB    r2, [r5]          ; isMentionWork = 1 (字节存储)

        ; JQ8x00_Command_Data(SetVolume, 0);
        MOV     r0, #19           ; SetVolume = 19 (0x13)
        MOV     r1, #0            ; 数据 = 0
        BL      JQ8x00_Command_Data

        ; JQ8x00_Command_Data(AppointTrack, 2);
        MOV     r0, #7            ; AppointTrack = 7 (0x07)
        MOV     r1, #2            ; 数据 = 2
        BL      JQ8x00_Command_Data

        ; sensor_cnt_last = sensor_cnt;
        LDR     r5, =sensor_cnt   ; r5 = &sensor_cnt
        LDRH    r2, [r5]          ; r2 = sensor_cnt
        LDR     r6, =sensor_cnt_last ; r6 = &sensor_cnt_last
        STRH    r2, [r6]          ; sensor_cnt_last = sensor_cnt

end_if
        ADD     SP, SP, #4        ; 恢复栈指针
        POP     {r4-r6, pc}       ; 恢复寄存器并返回

        ENDP
        END