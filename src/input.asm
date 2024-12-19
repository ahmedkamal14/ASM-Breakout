; This File contains functions related to user input
PUBLIC INPUT_MAIN_LOOP
EXTRN Draw_Single_Rect: FAR
EXTRN PADDLE_Y  
EXTRN PADDLE_X
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_WIDTH
EXTRN PADDLE_COLOR:BYTE
EXTRN PADDLE_SPEED
EXTRN BORDER_LEFT
EXTRN BORDER_RIGHT
EXTRN BLACK:BYTE
EXTRN WHITE:BYTE
EXTRN SCREEN_SIZE



.MODEL SMALL
.STACK 100H
.DATA
    ; Variables related to user input
    SCREEN_HEIGHT EQU 200
    SCREEN_WIDTH  EQU 320
.CODE

INPUT_MAIN_LOOP PROC

            
    ; CHECK IF A KEY IS PRESSED
                          MOV  AH, 01H
                          INT  16H
                          JNZ  D5
                          JMP  INPUT_EXIT

    D5:                   

    ; FETCH THE KEY DETAILS
                          MOV  AH, 00H
                          INT  16H

    ; HANDLE LEFT ARROW KEY
                          CMP  AH, 4BH
                          JE   INPUT_MOVE_LEFT

    ; HANDLE RIGHT ARROW KEY
                          CMP  AH, 4DH
                          JE   INPUT_MOVE_RIGHT

    ; HANDLE ESC KEY
                          CMP  AL, 1BH
                          JE   INPUT_EXIT
    ;   JMP  INPUT_MAIN_LOOP
                          RET

    ; MOVE PADDLE LEFT AND CHECK FOR BORDERS
    INPUT_MOVE_LEFT:      
                          MOV  AX, PADDLE_Y
                          SUB  AX, PADDLE_SPEED
                          CMP  AX, BORDER_LEFT
                          JL   INPUT_MOVE_LEFT_DONE
                          MOV  [PADDLE_Y], AX
    INPUT_MOVE_LEFT_DONE: 
                          CALL INPUT_CLEAR_SCREEN

                          PUSH AX
                          PUSH BX
                          PUSH CX
                          PUSH DX
                          PUSH SI
                          PUSH DI

                          MOV  AX, PADDLE_X
                          MOV  DX, 320
                          MUL  DX
                          ADD  AX, PADDLE_Y
                          MOV  DI, AX

                          MOV  DX, PADDLE_HEIGHT
                          mov  si, PADDLE_WIDTH

                          MOV  AL, PADDLE_COLOR

    ;   CALL Draw_Single_Rect


                          POP  DI
                          POP  SI
                          POP  DX
                          POP  CX
                          POP  BX
                          POP  AX

                          RET
    ;   JMP  INPUT_MAIN_LOOP

    ; MOVE PADDLE RIGHT AND CHECK FOR BORDERS
    INPUT_MOVE_RIGHT:     
                          MOV  AX, PADDLE_Y
                          ADD  AX, PADDLE_SPEED
                          CMP  AX, BORDER_RIGHT
                          JG   INPUT_MOVE_RIGHT_DONE
                          MOV  [PADDLE_Y], AX
    INPUT_MOVE_RIGHT_DONE:
                          CALL INPUT_CLEAR_SCREEN

                          PUSH AX
                          PUSH BX
                          PUSH CX
                          PUSH DX
                          PUSH SI
                          PUSH DI

                          MOV  AX, PADDLE_X
                          MOV  DX, 320
                          MUL  DX
                          ADD  AX, PADDLE_Y
                          MOV  DI, AX

                          MOV  DX, PADDLE_HEIGHT
                          mov  si, PADDLE_WIDTH

                          MOV  AL, PADDLE_COLOR
                          
    ;   CALL Draw_Single_Rect

                          POP  DI
                          POP  SI
                          POP  DX
                          POP  CX
                          POP  BX
                          POP  AX
                            
    ;   JMP  INPUT_MAIN_LOOP
    
    INPUT_EXIT:           
                          RET

INPUT_MAIN_LOOP ENDP

INPUT_CLEAR_SCREEN PROC
                          MOV  AX, 0A000h
                          MOV  ES, AX
                          MOV  DI, (SCREEN_HEIGHT - 20) * 320
                          MOV  CX, 2000
                          MOV  AL, BLACK
                          REP  STOSB
                          RET
INPUT_CLEAR_SCREEN ENDP


END INPUT_MAIN_LOOP