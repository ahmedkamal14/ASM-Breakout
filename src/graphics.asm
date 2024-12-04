PUBLIC Draw_Single_Rect
PUBLIC Draw_Ball
EXTRN PADDLE_X
EXTRN PADDLE_Y
EXTRN PADDLE_WIDTH
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_COLOR:BYTE
EXTRN Ball_X
EXTRN Ball_Y
EXTRN Ball_Size

.model small
.stack 100h
.code




Draw_Single_Rect proc
    ;summary:
    ;di=> pixle number
    ;dx=> hieght
    ;cx=> width
    ;al=> color
    ;  MOV AX, @DATA
    ;  MOV DS, AX
                     
        
    ;  mov ax,0A000h
    ;  mov es,ax
    ;  mov ah,0
    ;  mov al,13h
    ;  int 10h
    ; mov dx, 10d
    ; mov di, 650d
    ; STORE THE VALUE OF  PADDLE_X IN AX THEN MULTIPLY IT BY 320 AND THEN ADD PADDLE_Y THEN STORE IT IN DI
                        
    DRAW_IN_ROW:         

                         mov  bx, di
    ;mov al,0eh
    ;mov cx,18
                         mov  cx, si
                         rep  stosb
                         mov  di, bx
                         add  di, 320d
                         dec  dx
                         jnz  DRAW_IN_ROW
                         RET
Draw_Single_Rect endp
Draw_Ball PROC
    ;initialization
                         MOV  CX,Ball_Y
                         MOV  DX, Ball_X

    Draw_Ball_Horizontal:
    ;Update Columns
                         MOV  AH,0CH
                         MOV  AL,14
                         INT  10H
                         INC  CX
                         MOV  AX,CX
                         SUB  AX,Ball_Y
                         CMP  AX,Ball_Size
                         JNG  Draw_Ball_Horizontal

    ;Update Rows
                         MOV  CX,Ball_Y
                         INC  DX
                         MOV  AX,DX
                         SUB  AX,Ball_X
                         CMP  AX,Ball_Size
                         JNG  Draw_Ball_Horizontal

                         RET
                         ENDP Draw_Ball

end Draw_Single_Rect

