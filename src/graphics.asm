PUBLIC Draw_Single_Rect
PUBLIC Draw_Ball
PUBLIC Draw_Bricks
PUBLIC Initialize_Bricks_Positions

EXTRN PADDLE_X
EXTRN PADDLE_Y
EXTRN PADDLE_WIDTH
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_COLOR:BYTE
EXTRN Ball_X
EXTRN Ball_Y
EXTRN Ball_Size
EXTRN Brick_Width 
EXTRN Brick_Height
EXTRN Brick_Color: BYTE
EXTRN Rows_Number 
EXTRN Cols_Number 
EXTRN Gap_X
EXTRN Gap_Y 
EXTRN Bricks_States: BYTE
EXTRN Bricks_Positions

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

Initialize_Bricks_Positions PROC
                                PUSH AX
                                PUSH BX
                                PUSH CX
                                PUSH DX
                                PUSH SI

                                XOR  CX, CX
                                XOR  DX,DX

    Initialize_Row_Loop:        
    
    ;Set AX with the number of pixel row
                                MOV  AX, CX
                                MOV  BX, Brick_Height
                                ADD  BX, Gap_Y
                                PUSH DX
                                MUL  BX
                                ADD  AX,14
                                POP  DX


    ;Set BX to the beginning of the row
                                XOR  DX, DX

    Initialize_Col_Loop:        

    ;  PUSH AX
    
    

    ;Set BX with the number of pixel col
                                PUSH AX
                                MOV  AX, DX
                                MOV  BX, Brick_Width
                                ADD  BX, Gap_X
                                PUSH DX
                                MUL  BX
                                POP  DX
                                MOV  BX, AX
                                ADD  BX, 3
                                POP  AX

    
    ;Calculate index
                                PUSH AX
                                PUSH DX
                                MOV  AX, CX
                                MOV  DX,8
                                MUL  DX
                                POP  DX
                                ADD  AX, DX
                                PUSH DX
                                MOV  DX,2
                                MUL  DX
                                POP  DX
                                MOV  SI, AX
                                POP  AX

    ;store AX in Bricks_Positions
                                PUSH SI
                                MOV  BP, OFFSET Bricks_Positions
                                SHL  SI,1
                                MOV  [BP + SI], AX
    ;store BX in Bricks_Positions
                                POP  SI
                                INC  SI
                                SHL  SI,1
                                MOV  [BP + SI], BX

                                

                                INC  DX

                                CMP  DX, 8
                                JNE  Initialize_Col_Loop
    ; POP  AX

                                INC  CX

                                CMP  CX, 4
                                JNE  Initialize_Row_Loop

                                POP  SI
                                POP  DX
                                POP  CX
                                POP  BX
                                POP  AX
                                RET
                                ENDP Initialize_Bricks_Positions

Draw_Bricks PROC

    ;Store all used registers
                                PUSH AX
                                PUSH BX
                                PUSH CX
                                PUSH DX
                                PUSH SI

                                XOR  AX,AX
                                XOR  BX,BX
                                XOR  SI,SI

    ;Set brick's width and height
                                MOV  DX, Brick_Height
    Draw_Row_Loop:              
                                XOR  BX, BX

    Draw_Col_Loop:              
    
    ;Check the state of the brick
                                PUSH AX
                                PUSH DX
                                PUSH SI
                                MOV  AX, SI
                                MOV  DL, 2
                                DIV  DL
                                MOV  SI, AX
                                MOV  AL, [Bricks_States + SI]
                                CMP  AL, 1
                                POP  SI
                                POP  DX
                                POP  AX
                                JNE  Skip_Brick

    ;Load AX, BX with the coordinates from Bricks_Positions
                                PUSH AX
                                PUSH BX

                                PUSH SI
                                MOV  BP, OFFSET Bricks_Positions
                                SHL  SI,1
                                MOV  AX, [BP + SI]
                                POP  SI
                                PUSH SI
                                INC  SI
                                SHL  SI,1
                                MOV  BX, [BP + SI]
                                POP  SI
                                INC  SI


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


    ;Draw brick
                                PUSH SI
                                PUSH DX
                                PUSH CX
                                MOV  SI, Brick_Width
                                CALL Draw_Single_Rect
                                POP  CX
                                POP  DX
                                POP  SI

                                POP  BX
                                POP  AX
   
    Skip_Brick:                 

                                INC  BX
                                INC  SI

                                CMP  BX, 8
                                JNE  Draw_Col_Loop

                                INC  AX

                                CMP  AX, 4
                                JNE  Draw_Row_Loop

                                POP  SI
                                POP  DX
                                POP  CX
                                POP  BX
                                POP  AX

                                RET
                                ENDP Draw_Bricks

end Draw_Single_Rect

