; This File contains functions related to user input
PUBLIC INPUT_MAIN_LOOP
EXTRN Draw_Single_Rect: FAR
EXTRN PADDLE_Y
EXTRN PADDLE_SPEED
EXTRN BORDER_LEFT
EXTRN BORDER_RIGHT
EXTRN BLACK:BYTE
EXTRN SCREEN_SIZE


.MODEL SMALL
.STACK 100H
.CODE

INPUT_MAIN_LOOP PROC

    ; WAIT FOR KEY PRESSED
                          MOV  AH, 00H
                          INT  16H                      ; -> AH = SCAN CODE, AL = ASCII
                       

    ; CHECK FOR KEY PRESSED
                          CMP  AH, 4BH                  ; LEFT ARROW CLICKED
                          JE   INPUT_MOVE_LEFT
                          CMP  AH, 4DH                  ; RIGHT ARROW CLICKED
                          JE   INPUT_MOVE_RIGHT

                          CMP  AH, 01H                  ; ESC KEY PRESSED
                          JE   INPUT_EXIT

                          JMP  INPUT_MAIN_LOOP


    ; MOVE PADDLE LEFT AND CHECK FOR BORDERS
    INPUT_MOVE_LEFT:      
                          MOV  AX, PADDLE_Y
                          SUB  AX, PADDLE_SPEED
                          CMP  AX, BORDER_LEFT
                          JL   INPUT_MOVE_LEFT_DONE
                          MOV  [PADDLE_Y], AX
    INPUT_MOVE_LEFT_DONE: 
                          CALL INPUT_CLEAR_SCREEN
                          CALL Draw_Single_Rect
                          JMP  INPUT_MAIN_LOOP

    ; MOVE PADDLE RIGHT AND CHECK FOR BORDERS
    INPUT_MOVE_RIGHT:     
                          MOV  AX, PADDLE_Y
                          ADD  AX, PADDLE_SPEED
                          CMP  AX, BORDER_RIGHT
                          JG   INPUT_MOVE_RIGHT_DONE
                          MOV  [PADDLE_Y], AX
    INPUT_MOVE_RIGHT_DONE:
                          CALL INPUT_CLEAR_SCREEN
                          CALL Draw_Single_Rect
                          JMP  INPUT_MAIN_LOOP
    

    ; FUNCTION TO CLEAR THE WHOLE SCREEN
    INPUT_CLEAR_SCREEN:   
                          MOV  AX, 0A000h
                          MOV  ES, AX
                          MOV  DI, 0
                          MOV  CX, SCREEN_SIZE
                          MOV  AL, BLACK
                          REP  STOSB
                          RET

    ; EXIT PROGRAM
    INPUT_EXIT:           
                          RET

INPUT_MAIN_LOOP ENDP
END INPUT_MAIN_LOOP
