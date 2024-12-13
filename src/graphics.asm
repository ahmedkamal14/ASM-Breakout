PUBLIC Draw_Single_Rect
PUBLIC Draw_Ball
PUBLIC Draw_Bricks
PUBLIC  Draw_Black_Ball
EXTRN PADDLE_X
EXTRN PADDLE_Y
EXTRN PADDLE_WIDTH
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_COLOR:BYTE
EXTRN Ball_X
EXTRN Ball_Y
EXTRN Ball_Size
EXTRN BALL_COLOR :BYTE
EXTRN Brick_Width 
EXTRN Brick_Height
EXTRN Brick_Color: BYTE
EXTRN Rows_Number 
EXTRN Cols_Number 
EXTRN Gap_X
EXTRN Gap_Y

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
Draw_Black_Ball PROC
    ;initialization
                               MOV  CX,Ball_Y
                               MOV  DX, Ball_X

    Draw_Black_Ball_Horizontal:
    ;Update Columns
                               MOV  AH,0CH
                               MOV  AL,0
                               INT  10H
                               INC  CX
                               MOV  AX,CX
                               SUB  AX,Ball_Y
                               CMP  AX,Ball_Size
                               JNG  Draw_Black_Ball_Horizontal

    ;Update Rows
                               MOV  CX,Ball_Y
                               INC  DX
                               MOV  AX,DX
                               SUB  AX,Ball_X
                               CMP  AX,Ball_Size
                               JNG  Draw_Black_Ball_Horizontal

                               RET
                               ENDP Draw_Black_Ball

Draw_Bricks PROC

    ;Store all used registers
                               PUSH AX
                               PUSH BX
                               PUSH CX
                               PUSH DX

                               XOR  AX,AX
                               XOR  BX,BX

    ;Set brick's width and height
                               MOV  SI, Brick_Width
                               MOV  DX, Brick_Height

    ;Outer loop for each row
    Draw_Row_Loop:             
                               PUSH AX
    
    ;Set AX with the number of pixel row
                               MOV  BX, Brick_Height
                               ADD  BX, Gap_Y
                               PUSH DX
                               MUL  BX
                               POP  DX

    ;Set BX to the beginning of the row
                               XOR  BX, BX

    ;Inner loop for each column
    Draw_Col_Loop:             

    ;Store AX, bx
                               PUSH AX
                               PUSH BX

    ;Set BX with the number of pixel col
                               PUSH AX
                               MOV  AX, BX
                               MOV  BX, Brick_Width
                               ADD  BX, Gap_X
                               PUSH DX
                               MUL  BX
                               POP  DX
                               MOV  BX, AX
                               ADD  BX, 3
                               POP  AX


    ;Multiply AX (y) * 320 + BX (x)
                               PUSH BX
                               MOV  BX, 320
                               PUSH DX
                               MUL  BX
                               POP  DX
                               POP  BX
                               ADD  AX, BX
                               MOV  DI, AX
                               MOV  AL, Brick_Color

    ;  PUSH BX
    ;  PUSH AX
                               PUSH SI
                               PUSH DX
                               CALL Draw_Single_Rect
                               POP  DX
                               POP  SI
    ;  POP  AX
    ;  POP  BX

                               POP  BX
                               POP  AX

                               INC  BX

                               CMP  BX, 8
                               JNE  Draw_Col_Loop
                               POP  AX

                               INC  AX

                               CMP  AX, 5
                               JNE  Draw_Row_Loop

    
    Continue:                  

                               POP  DX
                               POP  CX
                               POP  BX
                               POP  AX
                               RET
                               ENDP Draw_Bricks

end Draw_Single_Rect

