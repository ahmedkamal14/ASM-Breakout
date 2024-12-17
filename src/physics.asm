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
.MODEL SMALL
.STACK 100h

.CODE
MOTION PROC

Move_Ball PROC
       
                   MOV  AX,Ball_Velocity_X
                   ADD  Ball_X,AX
                   CMP  Ball_X,0
                   JLE  Neg_Velocity_X        ;up and down

                   MOV  AX,SCREEN_HEIGHT
                   CMP  Ball_X,AX
                   JGE  Neg_Velocity_X        ; up and down


                   MOV  AX,Ball_Velocity_Y
                   ADD  Ball_Y,AX



                   CMP  Ball_Y,0
                   JLE  Neg_Velocity_Y
                   MOV  AX,SCREEN_WIDTH
                   CMP  Ball_Y,AX
                   JGE  Neg_Velocity_Y

                   MOV  AX,Ball_X
                   ADD  AX,Ball_Size
                   CMP  AX ,PADDLE_X
                   JNG  STOP

                   MOV  AX,PADDLE_X
                   ADD  AX,PADDLE_WIDTH
                   CMP  Ball_X,AX
                   JNL  STOP



                   MOV  AX,Ball_Y
                   ADD  AX,Ball_Size
                   CMP  AX ,PADDLE_Y
                   JNG  STOP

                   MOV  AX,PADDLE_Y
                   ADD  AX,PADDLE_HEIGHT
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

 END MOTION