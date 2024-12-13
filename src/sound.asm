; This File contains functions related to sound effects

PUBLIC START_COLLISION_SOUND

.MODEL SMALL
.STACK 100H

.CODE

START_COLLISION_SOUND PROC
                          PUSH AX
                          PUSH BX
                          PUSH CX
                          PUSH DX

                          MOV  AL, 182
                          OUT  43H, AL
                          MOV  AX, 400

                          OUT  42H, AL
                          MOV  AL, AH
                          OUT  42H, AL
                          IN   AL, 61H

                          OR   AL, 3
                          OUT  61H, AL
                          MOV  BX, 2

    PAUSE1:               
                          MOV  CX, 65535
    PAUSE2:               
                          DEC  CX
                          JNZ  PAUSE2
                          DEC  BX
                          JNZ  PAUSE1
                          IN   AL, 61H
                          AND  AL, 11111100b
                          OUT  61H, AL

                          POP  DX
                          POP  CX
                          POP  BX
                          POP  AX
                          RET
START_COLLISION_SOUND ENDP
    
END START_COLLISION_SOUND