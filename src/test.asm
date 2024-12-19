EXTRN INPUT_MAIN_LOOP: FAR
EXTRN Draw_Single_Rect: FAR
EXTRN Draw_Ball: FAR
EXTRN Draw_Bricks: FAR
EXTRN Initialize_Bricks_Positions: FAR
EXTRN DRAW_SCORES: FAR

; BALL INT
EXTRN Move_Ball: FAR
EXTRN Clear_Screen: FAR
EXTRN Draw_Black_Ball: FAR

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
PUBLIC Bricks_States
PUBLIC Bricks_Positions
PUBLIC Bricks_Rows
PUBLIC Bricks_Cols

 ; SCORE DATA AND LIVES
PUBLIC SCORE
PUBLIC LIVES
PUBLIC ENDING
PUBLIC SCORE_COUNT
PUBLIC LIVES_COUNT

; BALL DATA
PUBLIC Ball_Velocity_X
PUBLIC Ball_Velocity_Y
PUBLIC Prev_Time

PUBLIC START_ONE_PLAYER

.MODEL SMALL
.STACK 100H
.DATA
     ; PADDLE DATA
     PADDLE_X         DW  180
     PADDLE_Y         DW  140
     PADDLE_WIDTH     DW  40
     PADDLE_HEIGHT    DW  6
     PADDLE_COLOR     DB  8
     PADDLE_SPEED     DW  5

     ; SCREEN INFO
     SCREEN_WIDTH     DW  320
     SCREEN_HEIGHT    DW  200
     SCREEN_SIZE      DW  ?                                 ; SCREEN_WIDTH * SCREEN_HEIGHT

     ; BORDERS
     BORDER_LEFT      DW  0
     BORDER_RIGHT     DW  ?                                 ; SCREEN_WIDTH - PADDLE_WIDTH
     BORDER_TOP       DW  0
     BORDER_BOTTOM    DW  SCREEN_HEIGHT - PADDLE_HEIGHT

     ; NEEDED COLORS
     BLACK            DB  0
     WHITE            DB  15

     ; BALL DATA
     Ball_X           DW  160
     Ball_Y           DW  158
     Ball_Size        DW  4
     Ball_Velocity_X  DW  4
     Ball_Velocity_Y  DW  4
     Prev_Time        DB  0
     BALL_COLOR       DB  0

     ;BRICKS DATA
     Brick_Width      DW  35
     Brick_Height     DW  9
     Brick_Color      DB  9
     Rows_Number      DB  5
     Cols_Number      DB  10
     Gap_X            DW  5
     Gap_Y            DW  5
     Bricks_States    DB  40 DUP(1)
     Bricks_Positions DW  80 DUP(?)
     Bricks_Rows      DW  5
     Bricks_Cols      DW  8

     ; SCORE DATA AND LIVES
     SCORE            DB  'SCORE: $'
     LIVES            DB  '              LIVES: $'
     ENDING           DB  '$'
     SCORE_COUNT      DW  0
     LIVES_COUNT      DB  51

     FRAME_DELAY      EQU 64



.CODE

START_ONE_PLAYER PROC

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
                      CALL Draw_Single_Rect

     ;Test drawing destroyed bricks
     ; MOV  SI, 8
     ; MOV  byte ptr [Bricks_States + si], 0
     ; MOV  SI, 11
     ; MOV  byte ptr [Bricks_States + si], 0

     ;Store the positions of bricks into Bricks_Positions
                      CALL Initialize_Bricks_Positions

     ;Draw Bricks
                      CALL Draw_Bricks

     ;Draw ball
                      CALL Draw_Ball
     ; DRAW SCORES AT THE TOP OF THE SCREEN
                      CALL DRAW_SCORES                     ; Always redraw the scores with the updated values

     ; MAIN LOOP
     Check_Time_Label:

     ; Get the current system time
                      MOV  AH, 2CH
                      INT  21H

     ; Check if the time has changed
                      CMP  DL, Prev_Time
                      JE   Check_Time_Label                ; Skip the rest of the loop if time hasn't changed
                      MOV  Prev_Time, DL

     ; Handle user input
                      PUSH AX
                      PUSH BX
                      PUSH CX
                      PUSH DX
                      CALL INPUT_MAIN_LOOP
                      POP  DX
                      POP  CX
                      POP  BX
                      POP  AX

     ; Handle ball movement and collision
                      MOV  BALL_COLOR, 0
                      CALL Draw_Black_Ball
                      MOV  BALL_COLOR, 14
                      CALL Move_Ball
                      CALL Draw_Ball

     ; Update the paddle position
                      PUSH DX
                      PUSH AX
                      MOV  DX, PADDLE_HEIGHT
                      MOV  AL, PADDLE_COLOR
     ; CALL Draw_Single_Rect
                      POP  AX
                      POP  DX

                      JMP  Check_Time_Label

     ; RESTORE VIDEO MODE
                      MOV  AH, 0
                      MOV  AL, 3
                      INT  10H

                      RET
START_ONE_PLAYER ENDP
END START_ONE_PLAYER