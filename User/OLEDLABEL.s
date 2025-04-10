        AREA    |.text|, CODE, READONLY
        EXPORT  display_oled_labels
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明外部函数 OLED_ShowString
        IMPORT  OLED_ShowString

display_oled_labels PROC
        PUSH    {r4, lr}          ; 保存寄存器和返回地址（至少 2 个寄存器，确保栈对齐）

        ; 调用 OLED_ShowString(1, 1, "Count:")
        MOV     r0, #1            ; 行号 = 1
        MOV     r1, #1            ; 列号 = 1
        LDR     r2, =str_count    ; r2 = "Count:" 的地址
        BL      OLED_ShowString   ; 调用 C 函数

        ; 调用 OLED_ShowString(2, 1, "Angle:")
        MOV     r0, #2            ; 行号 = 2
        MOV     r1, #1            ; 列号 = 1
        LDR     r2, =str_angle    ; r2 = "Angle:" 的地址
        BL      OLED_ShowString   ; 调用 C 函数

        ; 调用 OLED_ShowString(3, 1, "Time :")
        MOV     r0, #3            ; 行号 = 3
        MOV     r1, #1            ; 列号 = 1
        LDR     r2, =str_time     ; r2 = "Time :" 的地址
        BL      OLED_ShowString   ; 调用 C 函数

        POP     {r4, pc}          ; 恢复寄存器并返回

        ENDP

        ; 定义字符串常量
        AREA    |.rodata|, DATA, READONLY
str_count
        DCB     "Count:", 0       ; 以 null 结尾的字符串
        ALIGN   4                 ; 确保 4 字节对齐

str_angle
        DCB     "Angle:", 0       ; 以 null 结尾的字符串
        ALIGN   4                 ; 确保 4 字节对齐

str_time
        DCB     "Time :", 0       ; 以 null 结尾的字符串
        ALIGN   4                 ; 确保 4 字节对齐

        END