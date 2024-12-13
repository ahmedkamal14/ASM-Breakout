PUBLIC Move_Ball
PUBLIC Clear_Screen

EXTRN Ball_Velocity_X
EXTRN Ball_Velocity_Y
EXTRN Ball_X
EXTRN Ball_Y
EXTRN Ball_Size
EXTRN SCREEN_HEIGHT
EXTRN SCREEN_WIDTH
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
                   RET
    Neg_Velocity_X:
                   NEG  Ball_Velocity_X
                          
                   RET

    Neg_Velocity_Y:
                   NEG  Ball_Velocity_Y
                         
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