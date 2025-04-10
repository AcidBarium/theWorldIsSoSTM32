        AREA    |.text|, CODE, READONLY
        EXPORT  set_angle_by_num
        PRESERVE8                 ; 显式声明保持 8 字节对齐

        ; 声明全局变量
        IMPORT  Num
        IMPORT  Angle

set_angle_by_num PROC
        PUSH    {r4, lr}          ; 保存寄存器和返回地址（8字节，满足对齐）

        ; uint16_t zjk = Num / 35;
        LDR     r4, =Num          ; r4 = &Num
        LDRH    r0, [r4]          ; r0 = Num (uint16_t)
        MOV     r1, #35           ; r1 = 35
        UDIV    r2, r0, r1        ; r2 = Num / 35 (zjk)

        ; if (zjk & 1) - 检查奇偶性
        TST     r2, #1            ; 测试 zjk 的最低位
        BEQ     angle_30          ; 如果最低位为 0（偶数），跳转到 30

        ; Angle = 150;  - 奇数情况
        LDR     r4, =Angle        ; r4 = &Angle
        MOV     r0, #150          ; r0 = 150
        STR     r0, [r4]          ; Angle = 150 (存储为整数)
        B       end_if

angle_30
        ; Angle = 30;   - 偶数情况
        LDR     r4, =Angle        ; r4 = &Angle
        MOV     r0, #30           ; r0 = 30
        STR     r0, [r4]          ; Angle = 30 (存储为整数)

end_if
        POP     {r4, pc}          ; 恢复寄存器并返回

        ENDP
        END