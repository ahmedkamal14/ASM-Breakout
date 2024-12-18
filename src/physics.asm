PUBLIC Move_Ball
PUBLIC Clear_Screen

EXTRN Ball_Velocity_X
EXTRN Ball_Velocity_Y
EXTRN Ball_X
EXTRN Ball_Y
EXTRN Ball_Size
EXTRN SCREEN_HEIGHT
EXTRN SCREEN_WIDTH

EXTRN PADDLE_Y  
EXTRN PADDLE_X
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_WIDTH

EXTRN Bricks_Positions
EXTRN Brick_Height
EXTRN Brick_Width
EXTRN Bricks_States

.MODEL SMALL
.STACK 100h

.CODE
MOTION PROC

Move_Ball PROC
       
                     MOV  AX,Ball_Velocity_X
                     ADD  Ball_X,AX
                     CMP  Ball_X,0
                     JLE  Neg_Velocity_X                        ;up and down

                     MOV  AX,SCREEN_HEIGHT
                     CMP  Ball_X,AX
                     JGE  Neg_Velocity_X                        ; up and down


                     MOV  AX,Ball_Velocity_Y
                     ADD  Ball_Y,AX



                     CMP  Ball_Y,0
                     JLE  Neg_Velocity_Y
                     MOV  AX,SCREEN_WIDTH
                     CMP  Ball_Y,AX
                     JGE  Neg_Velocity_Y

                     CALL Bricks_Collision

                     MOV  AX,Ball_X
                     ADD  AX,Ball_Size
                     CMP  AX ,PADDLE_X
                     JNG  STOP

                     MOV  AX,PADDLE_X
                     ADD  AX,PADDLE_HEIGHT
                     CMP  Ball_X,AX
                     JNL  STOP



                     MOV  AX,Ball_Y
                     ADD  AX,Ball_Size
                     CMP  AX ,PADDLE_Y
                     JNG  STOP

                     MOV  AX,PADDLE_Y
                     ADD  AX,PADDLE_WIDTH
                     CMP  Ball_Y,AX
                     JNL  STOP


                     NEG  Ball_Velocity_X
                     RET



                   
    Neg_Velocity_X:  
                     NEG  Ball_Velocity_X
                          
                     RET

    Neg_Velocity_Y:  
                     NEG  Ball_Velocity_Y
                         
                     RET


    STOP:            
                     RET
Move_Ball ENDP
Clear_Screen PROC
                     MOV  AH, 0
                     MOV  AL, 13H
                     INT  10H
                
    ;  MOV  AH,0BH
                        
    ;  MOV  BH,00
    ;  MOV  BL,00
    ;  INT  10H
                     RET
                     ENDP Clear_Screen

MOTION ENDP
Bricks_Collision PROC
                  
                     PUSH AX
                     PUSH BX
                     PUSH CX
                     PUSH DX
                     PUSH SI

                     XOR  SI, SI
                     XOR  CX, CX
                     MOV  BP, OFFSET Bricks_Positions

    Bricks_Loop:     
                     PUSH SI
                     MOV  SI, CX
                     MOV  AL,  byte ptr [Bricks_States + SI]
                     POP  SI
                     CMP  AL, 0
                     JE   No_Collision

                     PUSH SI
                     SHL  SI,1

    ;Load AX with Brick_X
                     MOV  AX, [BP + SI]
                     POP  SI
                     PUSH SI
                     INC  SI
                     SHL  SI,1
    ;Load Bx with Brick_Y
                     MOV  BX, [BP + SI]
                     POP  SI

                     MOV  DX,Ball_X
                     ADD  DX,Ball_Size
                     CMP  DX ,Ax
                     JNG  No_Collision

                     MOV  DX, AX
                     ADD  DX, Brick_Height
                     CMP  Ball_X, DX
                     JNL  No_Collision


                     MOV  DX,Ball_Y
                     ADD  DX,Ball_Size
                     CMP  DX ,BX
                     JNG  No_Collision

                     MOV  DX, BX
                     ADD  DX, Brick_Width
                     CMP  Ball_Y,DX
                     JNL  No_Collision


                     NEG  Ball_Velocity_X

                     PUSH SI
                     MOV  SI,CX
                     MOV  byte ptr [Bricks_States + SI], 0
                     POP  SI

    No_Collision:    
                     INC  CX
                     ADD  SI, 2

                     CMP  SI, 64
                     JL   Bricks_Loop

                     POP  SI
                     POP  DX
                     POP  CX
                     POP  BX
                     POP  AX

                     RET
                     ENDP Bricks_Collision

 END MOTION