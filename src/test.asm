EXTRN INPUT_MAIN_LOOP: FAR
EXTRN Draw_Single_Rect: FAR
EXTRN Draw_Ball: FAR
EXTRN Draw_Bricks: FAR
EXTRN Move_Ball: FAR
EXTRN Clear_Screen: FAR
PUBLIC PADDLE_X
PUBLIC PADDLE_Y
PUBLIC PADDLE_WIDTH
PUBLIC PADDLE_HEIGHT
PUBLIC PADDLE_COLOR
PUBLIC PADDLE_SPEED
PUBLIC SCREEN_WIDTH
PUBLIC SCREEN_HEIGHT
PUBLIC SCREEN_SIZE
PUBLIC BORDER_LEFT
PUBLIC BORDER_RIGHT
PUBLIC BORDER_TOP
PUBLIC BORDER_BOTTOM
PUBLIC BLACK
PUBLIC WHITE
PUBLIC Ball_X
PUBLIC Ball_Y
PUBLIC Ball_Size

PUBLIC Brick_Width 
PUBLIC Brick_Height
PUBLIC Brick_Color 
PUBLIC Rows_Number 
PUBLIC Cols_Number 
PUBLIC Gap_X
PUBLIC Gap_Y

PUBLIC Ball_Velocity_X
PUBLIC Ball_Velocity_Y
PUBLIC Prev_Time
.MODEL SMALL
.STACK 100H
.DATA
     ; PADDLE DATA
     PADDLE_X        DW  180
     PADDLE_Y        DW  140
     PADDLE_WIDTH    DW  40
     PADDLE_HEIGHT   DW  6
     PADDLE_COLOR    DB  8
     PADDLE_SPEED    DW  5

     ; SCREEN INFO
     SCREEN_WIDTH    DW  320
     SCREEN_HEIGHT   DW  200
     SCREEN_SIZE     DW  ?                                 ; SCREEN_WIDTH * SCREEN_HEIGHT

     ; BORDERS
     BORDER_LEFT     DW  0
     BORDER_RIGHT    DW  ?                                 ; SCREEN_WIDTH - PADDLE_WIDTH
     BORDER_TOP      DW  0
     BORDER_BOTTOM   DW  SCREEN_HEIGHT - PADDLE_HEIGHT

     ; NEEDED COLORS
     BLACK           DB  0
     WHITE           DB  15

     ; BALL DATA
     Ball_X          DW  160
     Ball_Y          DW  158
     Ball_Size       DW  4
     Ball_Velocity_X DW  4
     Ball_Velocity_Y DW  4
     Prev_Time       DB  0

     ;BRICKS DATA
     Brick_Width     DW  35
     Brick_Height    DW  9
     Brick_Color     DB  9
     Rows_Number     DB  5
     Cols_Number     DB  10
     Gap_X           DW  5
     Gap_Y           DW  5

     FRAME_DELAY     EQU 64

.CODE

MAIN PROC

     ; INITIALIZE DATA SEGMENT
                      MOV  AX, @DATA
                      MOV  DS, AX

     ; CALC SCREEN SIZE AND STORE IT
                      MOV  AX, SCREEN_WIDTH
                      MUL  SCREEN_HEIGHT
                      MOV  SCREEN_SIZE, AX

     ; CALC BORDER RIGHT AND STORE IT
                      MOV  AX, SCREEN_WIDTH
                      SUB  AX, PADDLE_WIDTH
                      MOV  BORDER_RIGHT, AX

     
     ; INITIALIZE VIDEO MODE
                      MOV  AX, 0A000H
                      MOV  ES, AX
                      MOV  AH, 0
                      MOV  AL, 13H
                      INT  10H

     ; DRAW PADDLE
                      MOV  AX, PADDLE_X
                      MOV  DX, 320
                      MUL  DX
                      ADD  AX, PADDLE_Y
                      MOV  DI, AX


                      MOV  DX, PADDLE_HEIGHT
                      mov  si, PADDLE_WIDTH
     ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                      MOV  AL, PADDLE_COLOR


     ;CALL Draw_Bricks

     ;Draw ball
                      CALL Clear_Screen
                      


     Check_Time_Label:
                      MOV  AH,2CH

                      INT  21H
                      CMP  DL,Prev_Time
                      JE   Check_Time_label
                      MOV  Prev_Time,DL

                       
     ;CALL Draw_Bricks
     ;CALL Draw_Single_Rect
                      CALL Clear_Screen
                      CALL Draw_Ball
                      CALL Move_Ball

                      JMP  Check_Time_label

     ; MAIN LOOP
     ;CALL INPUT_MAIN_LOOP

     ; RESTORE VIDEO MODE
     ;   MOV  AH, 0
     ;   MOV  AL, 3
     ;   INT  10H

     ; RETURN CONTROL TO OPERATING SYSTEM
                      MOV  AH, 4CH
                      INT  21H

                      RET
MAIN ENDP
END MAIN