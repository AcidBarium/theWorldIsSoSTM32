        AREA    |.text|, CODE, READONLY
        EXPORT  display_oled
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明外部函数 OLED_ShowNum
        IMPORT  OLED_ShowNum

display_oled PROC
        PUSH    {r4-r7, lr}       ; 保存寄存器和返回地址
        SUB     SP, SP, #4        ; 调整栈指针，确保 8 字节对齐（PUSH 压入 5 个寄存器 = 20 字节）

        ; 保存传入的参数
        MOV     r4, r0            ; r4 = sensor_cnt
        MOV     r5, r1            ; r5 = Angle (假设为整数传递)
        MOV     r6, r2            ; r6 = Num
        MOV     r7, r3            ; r7 = is_ok

        ; 调用 OLED_ShowNum(1, 7, sensor_cnt, 5)
        MOV     r0, #1            ; 行号 = 1
        MOV     r1, #7            ; 列号 = 7
        MOV     r2, r4            ; 值 = sensor_cnt
        MOV     r3, #5            ; 位数 = 5
        BL      OLED_ShowNum      ; 调用 C 函数

        ; 调用 OLED_ShowNum(2, 7, Angle, 5)
        MOV     r0, #2            ; 行号 = 2
        MOV     r1, #7            ; 列号 = 7
        MOV     r2, r5            ; 值 = Angle
        MOV     r3, #5            ; 位数 = 5
        BL      OLED_ShowNum      ; 调用 C 函数

        ; 调用 OLED_ShowNum(3, 7, Num, 5)
        MOV     r0, #3            ; 行号 = 3
        MOV     r1, #7            ; 列号 = 7
        MOV     r2, r6            ; 值 = Num
        MOV     r3, #5            ; 位数 = 5
        BL      OLED_ShowNum      ; 调用 C 函数

        ; 调用 OLED_ShowNum(4, 1, is_ok, 5)
        MOV     r0, #4            ; 行号 = 4
        MOV     r1, #1            ; 列号 = 1
        MOV     r2, r7            ; 值 = is_ok
        MOV     r3, #5            ; 位数 = 5
        BL      OLED_ShowNum      ; 调用 C 函数

        ADD     SP, SP, #4        ; 恢复栈指针
        POP     {r4-r7, pc}       ; 恢复寄存器并返回

        ENDP
        END