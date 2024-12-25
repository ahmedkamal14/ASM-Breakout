.MODEL small
.STACK 600H
.DATA
    ; PADDLE DATA
    PADDLE_X             DW  180
    PADDLE_Y             DW  140
    PADDLE_WIDTH         DW  40
    PADDLE_HEIGHT        DW  6
    PADDLE_COLOR         DB  3
    PADDLE_SPEED         DW  4

    ; SCREEN INFO
    SCREEN_WIDTH         DW  320
    SCREEN_HEIGHT        DW  200
    SCREEN_SIZE          DW  ?                                                         ; SCREEN_WIDTH * SCREEN_HEIGHT

    SCREEN_WIDTH_CONST   EQU 320
    SCREEN_HEIGHT_CONST  EQU 200

    ; BORDERS
    BORDER_LEFT          DW  0
    BORDER_RIGHT         DW  ?                                                         ; SCREEN_WIDTH - PADDLE_WIDTH
    BORDER_TOP           DW  0
    BORDER_BOTTOM        DW  SCREEN_HEIGHT - PADDLE_HEIGHT

    BORDER_MIDDLE        EQU 159

    ; NEEDED COLORS
    BLACK                DB  0
    WHITE                DB  15

    ; BALL DATA
    Ball_X               DW  160
    Ball_Y               DW  158
    Ball_X_Right         DW  165
    Ball_Y_Right         DW  78
    Ball_X_Left          DW  165
    Ball_Y_Left          DW  239
    Ball_Size            DW  2                                                         ;I=0;I<=2 , HENCE IT IS 3 PIXELS WIDE
    Ball_Velocity_X      DW  2
    Ball_Velocity_Y      DW  2
    Prev_Time            DB  0
    BALL_COLOR           DB  0

    ; TWO PLAYER VELOCITY
    Ball_Velocity_X1     DW  2
    Ball_Velocity_Y1     DW  2
    Ball_Velocity_X2     DW  2
    Ball_Velocity_Y2     DW  2

    ;BRICKS DATA
    Brick_Width          DW  35
    Brick_Height         DW  9
    Brick_Color          DB  9
    Rows_Number          DB  5
    Cols_Number          DB  10
    Gap_X                DW  5
    Gap_Y                DW  5
    Bricks_States        DB  40 DUP(1)
    Bricks_Positions     DW  80 DUP(?)
    Bricks_Rows          DW  5
    Bricks_Cols          DW  8

    ; SCORE DATA AND LIVES
    SCORE                DB  'SCORE: $'
    LIVES                DB  '              LIVES: $'
    ENDING               DB  '$'
    SCORE_COUNT          DW  0
    LIVES_COUNT          DB  3

    SCORE_COUNT_PLAYER_1 DW  0
    SCORE_COUNT_PLAYER_2 DW  0
    LIVES_COUNT_PLAYER_1 DB  3
    LIVES_COUNT_PLAYER_2 DB  3
    

    FRAME_DELAY          EQU 64

    ; MAIN VARS
    string1              db  'CHAT MODE => 1.', 13, 10, '$'
    string2              db  'ONE PLAYER MODE => 2.', 13, 10, '$'
    string3              db  'TWO PLAYERS MODE => 3.', 13, 10, '$'
    string4              db  'CO-OP PING PONG  => 4.', 13, 10, '$'
    string5              db  'Exit => Esc.', 13, 10, '$'

    ; CHAT VARS
    sendMessage          DB  'Serial communication: Send one byte', 0Ah, 0Dh, '$'
    INITIALMESSAGE       DB  'CHAT IS ON', 0Ah, 0Dh, '$'
    receiveMessage       DB  'Receiver on, press ESC to end session', 0Ah, 0Dh, '$'
    inputPrompt          DB  'MESSAGE: ', 0Ah, 0Dh, '$'
    goodbyeMessage       DB  ' Goodbye!', 0Ah, 0Dh, '$'
    receivedValue        DB  2 dup('$')                                                ; Buffer to store the received character and null-terminate
    inData               DB  30, ?, 30 dup('$')
    emptyStr             DB  10, 13, '$'
    ReceivedSTRING       DB  10, 13, 'Receiving:  ', '$'
    SendingString        DB  10, 13,'Sending: ', '$'
    sendFLAG             DB  0
    recFLAG              DB  0

    WINSTRING            DB  'YOU WIN', 0Ah, 0Dh, '$'
    LOSESTRING           DB  'YOU LOSE', 0Ah, 0Dh, '$'

    ; ESCAPE STATUS
    ESCSTATUS            DB  0


    ; SCORE STRING
    SCORE_STRING         DB  '-$'

    ; Two Player Mode
    PADDLE_X1            DW  180
    PADDLE_Y1            DW  60

    PADDLE_X2            DW  180
    PADDLE_Y2            DW  221

    PADDLE_COLOR1        DB  8
    PADDLE_COLOR2        DB  8

    PLAYER_INPUT         DB  ?


    START_PLAYING        DB  0

    GIFT_TIME            DB  5D
    GIFT_STATUS          DB  0
    GIFT_X               DW  75d
    GIFT_Y               DW  160d

    ; PING PONG DATA
    PLAYER_LEFT_X        DW  80
    PLAYER_LEFT_Y        DW  9

    PLAYER_RIGHT_X       DW  80
    PLAYER_RIGHT_Y       DW  305

    PLAYER_LEFT_COLOR    DB  8
    PLAYER_RIGHT_COLOR   DB  8

    PING_PADDLE_WIDTH    DW  6
    PING_PADDLE_HEIGHT   DW  40
    PING_PADDLE_HEIGHT2  DW  40

    PING_PADDLE_SPEED    DW  5

    PONG_INPUT           DB  0

    ; PONG BALL DATA
    PONG_BALL_X          DW  100
    PONG_BALL_Y          DW  158
    PONG_BALL_SIZE       DW  4
    PONG_BALL_COLOR      DB  10
    PONG_BALL_SPEED_X    DW  2
    PONG_BALL_SPEED_Y    DW  6

    PLAYER_LEFT_SCORE    DB  0
    PLAYER_RIGHT_SCORE   DB  0

    WHO_STARTED          DB  0
    START_PLAYING_PONG   DB  0
    AWL_MARA             DB  0

    LEVEL                DB  1

.CODE

MAIN proc FAR
    ; Initialize the data segment
                                     mov   ax, @data
                                     mov   ds, ax

                                     MOV   ESCSTATUS, 0
                                     MOV   LIVES_COUNT, 3
                                     MOV   LIVES_COUNT_PLAYER_1, 3
                                     MOV   LIVES_COUNT_PLAYER_2, 3
    ;INTIALIZE BALL  POSITION AND ITS VELOCITY
                                     MOV   Ball_X, 160
                                     MOV   Ball_Y, 158
                                     MOV   LEVEL,1
                                     NEG   Ball_Velocity_X
                                     NEG   Ball_Velocity_Y


    Options_page:                    
    ; Clear the screen
                                     mov   ah, 06h                                 ; Scroll up function
                                     mov   al, 0                                   ; Clear entire screen
                                     mov   bh, 07h                                 ; Page and attribute (white text on black background)
                                     mov   cx, 0                                   ; Upper-left corner (row=0, col=0)
                                     mov   dx, 184Fh                               ; Bottom-right corner (row=24, col=79)
                                     int   10h                                     ; BIOS video interrupt

    ; Center and display the first string
                                     mov   ah, 02h                                 ; Set cursor position
                                     mov   bh, 0                                   ; Video page
                                     mov   dh, 10                                  ; Row (approximately 10 for the first string)
                                     mov   dl, 32                                  ; Column (approximately 32 for horizontal centering)
                                     int   10h                                     ; BIOS video interrupt

                                     lea   dx, string1                             ; Load the first string address
                                     mov   ah, 09h                                 ; Print the string
                                     int   21h                                     ; DOS interrupt

    ; Center and display the second string
                                     mov   ah, 02h                                 ; Set cursor position
                                     mov   bh, 0                                   ; Video page
                                     mov   dh, 12                                  ; Row (approximately 12 for the second string)
                                     mov   dl, 30                                  ; Column (approximately 30 for horizontal centering)
                                     int   10h                                     ; BIOS video interrupt

                                     lea   dx, string2                             ; Load the second string address
                                     mov   ah, 09h                                 ; Print the string
                                     int   21h                                     ; DOS interrupt

    ; Center and display the third string
                                     mov   ah, 02h                                 ; Set cursor position
                                     mov   bh, 0                                   ; Video page
                                     mov   dh, 14                                  ; Row (approximately 14 for the third string)
                                     mov   dl, 29                                  ; Column (approximately 29 for horizontal centering)
                                     int   10h                                     ; BIOS video interrupt

                                     lea   dx, string3                             ; Load the third string address
                                     mov   ah, 09h                                 ; Print the string
                                     int   21h                                     ; DOS interrupt

    ; Center and display the 4th string
                                     mov   ah, 02h                                 ; Set cursor position
                                     mov   bh, 0                                   ; Video page
                                     mov   dh, 16                                  ; Row (approximately 14 for the third string)
                                     mov   dl, 29                                  ; Column (approximately 29 for horizontal centering)
                                     int   10h                                     ; BIOS video interrupt

                                     lea   dx, string4                             ; Load the third string address
                                     mov   ah, 09h                                 ; Print the string
                                     int   21h                                     ; DOS interrupt

    ; Center and display the 5th string
                                     mov   ah, 02h                                 ; Set cursor position
                                     mov   bh, 0                                   ; Video page
                                     mov   dh, 18                                  ; Row (approximately 14 for the third string)
                                     mov   dl, 29                                  ; Column (approximately 29 for horizontal centering)
                                     int   10h                                     ; BIOS video interrupt

                                     lea   dx, string5                             ; Load the third string address
                                     mov   ah, 09h                                 ; Print the string
                                     int   21h                                     ; DOS interrupt
    ;   JMP CONT
    ;DUMMY:
    ;JMP Options_page
    ;CONT:

    ; Wait for a key press
                                     mov   ah, 0h                                  ; Keyboard interrupt
                                     int   16h                                     ; DOS interrupt

    ; CHECK THE KEY ENTERED Esc
                                     cmp   al, 27D                                 ; ASCII value for escape key
                                     jz    exit_program

    ;CHECK IF NUMBER 2 IS PRESSED
                                     cmp   al, 32h                                 ; ASCII value for 'f2'
                                     JE    one_player_mode

    ; CHECK THE KEY ENTERED 1
                                     cmp   al, 31h                                 ; ASCII value for '1'
                                     JE    chat_mode


    ; CHECK THE KEY ENTERED 3
                                     cmp   al, 33h                                 ; ASCII value for 'f3'
                                     JE    two_player_mode
                                     

    ; CHECK THE KEY ENTERED 4
                                     cmp   al, 34h                                 ; ASCII value for 'f3'
                                     JE    ping_pong_mode
                                     JMP   Options_page

    
    ; Switch to one player mode
    one_player_mode:                 
                                     call  START_ONE_PLAYER
                                     JMP   Options_page

    ; Switch to chat mode
    chat_mode:                       
                                     call  Start_Chat
                                     JMP   Options_page

    ; Switch to two player mode
    two_player_mode:                 
                                     CALL  START_TWO_PLAYER
                                     JMP   Options_page

    ; Switch to ping pong mode
    ping_pong_mode:                  
                                     CALL  START_PING_PONG
                                     JMP   Options_page

    ; Exit the program
    exit_program:                    
                                     mov   ah, 4Ch
                                     int   21h
MAIN endp


    ; CHAT PROCs----------------------------------------------------------------------------------------------------

START_CHAT PROC
                                     mov   ax, @data
                                     mov   ds, ax

    ; CLEAR SCREEN
                                     mov   ah, 06h
                                     mov   al, 0
                                     mov   bh, 07h
                                     mov   cx, 0
                                     mov   dx, 184Fh
                                     int   10h

    ; MOVE CURSOR TO 0, 0
                                     mov   ah, 02h
                                     mov   bh, 0
                                     mov   dh, 0
                                     mov   dl, 0
                                     int   10h

    ; Display the initial message
                                     mov   ah, 09h
                                     lea   dx, INITIALMESSAGE
                                     int   21h

    ; DISPLAY ENTER YOUR STRING MESSAGE
                                     mov   ah, 09h
                                     lea   dx, inputPrompt
                                     int   21h

    ; Initialize COM port
    ; Set Divisor Latch Access Bit
                                     mov   dx, 3FBh                                ; Line Control Register
                                     mov   al, 10000000b                           ; Set Divisor Latch Access Bit
                                     out   dx, al

    ; Set LSB byte of the Baud Rate Divisor Latch register
                                     mov   dx, 3F8h
                                     mov   al, 0Ch
                                     out   dx, al

    ; Set MSB byte of the Baud Rate Divisor Latch register
                                     mov   dx, 3F9h
                                     mov   al, 00h
                                     out   dx, al

    ; Set port configuration
                                     mov   dx, 3FBh
                                     mov   al, 00011011b
                                     out   dx, al

    MAIN_LOOP:                       
    ; Check if key is pressed
                                     mov   ah, 01h
                                     int   16h
                                     jz    CHECK_UART                              ; If no key is pressed, check UART for incoming data

                                     CMP   sendFLAG, 0
                                     JNE   SEND

    ; get cursor pos and store it in bx
                                     mov   ah, 03h
                                     mov   bh, 0
                                     int   10h
                                     push  dx

    ; move cursor one row down
                                     mov   ah, 2
                                     add   dh, 1
                                     mov   dl, 0
                                     int   10h

    ; display a letter 8 times in green
                                     mov   ah, 9
                                     mov   bh, 0
                                     mov   al, 44h
                                     mov   cx, 8
                                     mov   bl, 00AH
                                     int   10h

                                     pop   dx
    ; move cursor to dx
                                     mov   ah, 02h
                                     int   10H


                                     mov   ah, 09h
                                     lea   dx, SendingString
                                     int   21h
                  
                                     MOV   sendFLAG, 1

    SEND:                            
    ; Key is pressed, read it
                                     mov   ah, 00h
                                     int   16h
                                     mov   ah, 02h
                                     mov   dl, al
                                     int   21h                                     ; Display the key
                                     MOV   AH, AL

                                     CMP   AH, 0Dh
                                     JNE   SENDUART

    ; IF ENTER IS PRESSED DISPLAY NEW LINE AND RESET FLAGS
                                     MOV   recFLAG, 0
                                     MOV   sendFLAG, 0

    ; DISPLAY NEW LINE
                                     mov   ah, 09h
                                     lea   dx, emptyStr
                                     int   21h

                                     jmp   MAIN_LOOP                               ; Go back to the main loop

    SENDUART:                        

    ; Check that Transmitter Holding Register is empty
                                     mov   dx, 3FDh                                ; Line Status Register
    WAIT_TRANSMIT:                   
                                     in    al, dx                                  ; Read Line Status
                                     and   al, 00100000b
                                     jz    WAIT_TRANSMIT

    ; Transmit the value
                                     mov   dx, 3F8h                                ; Transmit Data Register
                                     mov   al, AH
                                     out   dx, al

    ; Exit if ESC key is pressed
                                     cmp   al, 1Bh
                                     je    EXIT

    CHECK_UART:                      
    ; ; Check if data is ready to be received from UART
                                     mov   dx, 3FDh                                ; Line Status Register
                                     in    al, dx
                                     and   al, 01h
                                     jz    MAIN_LOOP                               ; If no data, go back to the main loop

    ; DISPLAY RECEIVED STRING
                                     CMP   recFLAG, 0
                                     JNE   CONT

                                     mov   ah, 03h
                                     mov   bh, 0
                                     int   10h
                                     push  dx

    ; move cursor one row down
                                     mov   ah, 2
                                     add   dh, 1
                                     mov   dl, 0
                                     int   10h

    ; display a letter 8 times in green
                                     mov   ah, 9
                                     mov   bh, 0
                                     mov   al, 44h
                                     mov   cx, 10
                                     mov   bl, 00CH
                                     int   10h

                                     pop   dx
    ; move cursor to dx
                                     mov   ah, 02h
                                     int   10H


                                     mov   ah, 09h
                                     lea   dx, ReceivedSTRING
                                     int   21h
                                     MOV   recFLAG, 1

    CONT:                            
    ; Data is ready, read it
                                     mov   dx, 3F8h                                ; Receive Data Register
                                     in    al, dx
                                     MOV   AH, AL
                                     mov   receivedValue, al
                                     mov   receivedValue+1, '$'                    ; Null-terminate the string for display

    ; IF ENTER IS PRESSED DISPLAY NEW LINE AND RESET FLAGS
                                     cmp   AH, 0Dh
                                     je    ENTERPRESSED

    ; Exit if received value is ESC
                                     cmp   al, 1Bh
                                     je    EXIT

    ; Display the received value
                                     mov   ah, 09h
                                     lea   dx, receivedValue
                                     int   21h

                                     jmp   MAIN_LOOP                               ; Go back to the main loop

    ENTERPRESSED:                    
                                     MOV   recFLAG, 0
                                     MOV   sendFLAG, 0

    ; DISPLAY NEW LINE
                                     mov   ah, 09h
                                     lea   dx, emptyStr
                                     int   21h

                                     jmp   MAIN_LOOP                               ; Go back to the main loop

    EXIT:                            
    ; clear the screen
                                     mov   ah, 06h
                                     mov   al, 0
                                     mov   bh, 07h
                                     mov   cx, 0
                                     mov   dx, 184Fh
                                     int   10h

    ; MOVE CURSOR TO CENTER
                                     mov   ah, 02h
                                     mov   bh, 0
                                     mov   dh, 12
                                     mov   dl, 20
                                     int   10h

    ; Display goodbye message
                                     mov   ah, 09h
                                     lea   dx, goodbyeMessage
                                     int   21h


                                     RET
START_CHAT ENDP

    ; ONE PLAYER PROC---------------------------------------------------------------------------------------------------
START_ONE_PLAYER PROC

    NEXT_LEVEL:                      

                                     MOV   Paddle_X, 180
                                     MOV   PADDLE_Y, 140

                                     MOV   Ball_X, 160
                                     MOV   Ball_Y, 158

    ; CALC SCREEN SIZE AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     MUL   SCREEN_HEIGHT
                                     MOV   SCREEN_SIZE, AX

    ; CALC BORDER RIGHT AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     SUB   AX, PADDLE_WIDTH
                                     MOV   BORDER_RIGHT, AX

     
    ; INITIALIZE VIDEO MODE
                                     MOV   AX, 0A000H
                                     MOV   ES, AX
                                     MOV   AH, 0
                                     MOV   AL, 13H
                                     INT   10H
    ;DRAW SCORE CONTAINER
                                     CALL  Draw_Score_Container

    ;DRAW LIVES
                                     CALL  DRAW_LIVES

    ;INTIALIZE PADDEL VALUES
                                     MOV   PADDLE_COLOR, 3
                                     MOV   PADDLE_WIDTH, 40

    ; DRAW PADDLE

                                     MOV   AX, PADDLE_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
    ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                                     MOV   AL, PADDLE_COLOR
                                     CALL  Draw_Single_Rect

    ;Test drawing destroyed bricks
    ; MOV  SI, 8
    ; MOV  byte ptr [Bricks_States + si], 0
    ; MOV  SI, 11
    ; MOV  byte ptr [Bricks_States + si], 0

    ;Store the positions of bricks into Bricks_Positions

                                     MOV   Bricks_Rows, 3
                                     MOV   Bricks_Cols, 8
                                     MOV   Brick_Height, 8
                                     MOV   Brick_Width, 35
                                     MOV   Gap_X, 5
                                     MOV   Gap_Y, 5
                                     MOV   Brick_Color, 12
                                     MOV   SCORE_COUNT, 0
    ; INTIALIZE GIFT  PARAMETERS
                                     MOV   GIFT_STATUS, 0
                                     MOV   GIFT_X, 75d
                                     MOV   GIFT_Y, 160d
                                     MOV   GIFT_TIME, 3D




    ; loop on the bricks states and set them to 1
                                     MOV   SI, 0
                                     MOV   CX, 24

    Set_Bricks_States:               
                                     MOV   AL, LEVEL
                                     MOV   byte ptr [Bricks_States + SI], AL
                                     INC   SI
                                     LOOP  Set_Bricks_States


                                     CALL  Initialize_Bricks_Positions

    ;Draw Bricks
                                     CALL  Draw_Bricks

    ;Draw ball
                                     CALL  Draw_Ball

    ; MAIN LOOP
    Check_Time_Label:                

    ; Get the current system time
                                     MOV   AH, 2CH
                                     INT   21H

    ; Check if the time has changed
                                     CMP   DL, Prev_Time
                                     JE    Check_Time_Label                        ; Skip the rest of the loop if time hasn't changed
                                     MOV   Prev_Time, DL

    ; Handle user input


                                     CMP   SCORE_COUNT, 10
                                     JNE   KMELYA3M
                                     JMP   EXIT_MODE
    KMELYA3M:                        
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     CALL  INPUT_MAIN_LOOP

                                     CMP   ESCSTATUS, 1
                                     JNE   DUMMY242
                                     JMP   EXIT_MODE
    DUMMY242:                        
                                     CMP   LIVES_COUNT, 0
                                     JNE   DUMMY243
                                     JMP   EXIT_MODE
    DUMMY243:                        
                                     CMP   SCORE_COUNT, 10
                                     JNE   DUMMY244
                                     JMP   EXIT_MODE
    DUMMY244:                        

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

    ; Handle ball movement and collision
                                     MOV   BALL_COLOR, 0
                                     CALL  Draw_Black_Ball
                                     MOV   BALL_COLOR, 14
                                     CALL  Move_Ball
                                     CALL  Draw_Ball

                                     CMP   GIFT_STATUS, 0
                                     JE    NO_GIFT

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  DI
                                     PUSH  SI

                                     MOV   AX, GIFT_X
                                     MOV   BX, 320d
                                     MUL   BX
                                     ADD   AX, GIFT_Y
                                     MOV   DI, AX
                                     MOV   SI, 10D
                                     MOV   DX, 10D
                                     MOV   AL, 0
                                     CALL  Draw_Single_Rect

                                     ADD   GIFT_X, 4D
                                     CMP   GIFT_X, SCREEN_HEIGHT_CONST-10
                                     JG    RESET_GIFT_STATUS
                                     MOV   AX, GIFT_X
                                     MOV   BX, 320d
                                     MUL   BX
                                     ADD   AX, GIFT_Y
                                     MOV   DI, AX
                                     MOV   SI, 10D
                                     MOV   DX, 10D
                                     MOV   AL, 10D
                                     CALL  Draw_Single_Rect
                                     POP   SI
                                     POP   DI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     JMP   NO_GIFT
    RESET_GIFT_STATUS:               
                                     POP   SI
                                     POP   DI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     MOV   GIFT_STATUS, 0
                                     MOV   GIFT_X, 75D
                                     MOV   GIFT_Y, 160D


    ; Update the paddle position
    NO_GIFT:                         
                                     PUSH  DX
                                     PUSH  AX
                                     MOV   DX, PADDLE_HEIGHT
                                     MOV   AL, PADDLE_COLOR
    ; CALL Draw_Single_Rect
                                     POP   AX
                                     POP   DX

                                     JMP   Check_Time_Label

    EXIT_MODE:                       
    ; RESTORE VIDEO MODE
                                     MOV   AH, 0
                                     MOV   AL, 3
                                     INT   10H

    ; MOVE CURSOR TO CENTER
                                     mov   ah, 02h
                                     mov   bh, 0
                                     mov   dh, 12
                                     mov   dl, 20
                                     int   10h

                                     CMP   SCORE_COUNT, 10
                                     JNE   LOSE

    ; Display the win message
                                     INC   LEVEL
                                     MOV   AH, 09H
                                     LEA   DX, WINSTRING
                                     INT   21H
                                     CMP   LEVEL, 4
                                     JE    NO

                                     JMP   NEXT_LEVEL

                                     JMP   NO
    LOSE:                            
                                     MOV   AH, 09H
                                     LEA   DX, LOSESTRING
                                     INT   21H

    NO:                              
    ; WAIT 2 SECONDS
                                     MOV   AH, 86H                                 ; Set function number for delay
                                     MOV   CX, 30                                  ; High-order word of the delay
                                     MOV   DX, 19456                               ; Low-order word of the delay
                                     INT   15H                                     ; Call BIOS to execute the delay
                                        
                                        

    ; RETURN CONTROL TO OPERATING SYSTEM
    ; MOV   AH, 4CH
    ; INT   21H
                                     CALL  MAIN
START_ONE_PLAYER ENDP

START_TWO_PLAYER PROC


                                     MOV   PADDLE_X1, 180
                                     MOV   PADDLE_Y1, 60
                                     MOV   PADDLE_X2, 180
                                     MOV   PADDLE_Y2, 221

                                     MOV   Ball_X_Left, 165
                                     MOV   Ball_Y_Left, 239
                                     MOV   Ball_X_Right, 165
                                     MOV   Ball_Y_Right, 78


                                     MOV   SCORE_COUNT, 0
                                     MOV   SCORE_COUNT_PLAYER_2, 0
    ; INITIALIZE DATA SEGMENT
                                     MOV   AX, @DATA
                                     MOV   DS, AX

    ; CALC SCREEN SIZE AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     MUL   SCREEN_HEIGHT
                                     MOV   SCREEN_SIZE, AX

    ; CALC BORDER RIGHT AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     SUB   AX, PADDLE_WIDTH
                                     MOV   BORDER_RIGHT, AX


    ; INITIALIZE VIDEO MODE
                                     MOV   AX, 0A000H
                                     MOV   ES, AX
                                     MOV   AH, 0
                                     MOV   AL, 13H
                                     INT   10H

    ; DRAW VERTICAL LINE AT THE CENTER OF THE SCREEN
                                     mov   di, 159                                 ; Starting position in video memory (DI = 159)
                                     mov   si, 2
                                     mov   dx, 200
                                     mov   al, 0FH
                                     call  Draw_Single_Rect


                                     call  Draw_Score_Container_left
                                     call  Draw_Score_Container_right
                                     CALL  DRAW_LIVES
                                     CALL  Draw_Lives_Right

                                     MOV   START_PLAYING, 0
    ; INITIALIZATIONS
                                    

                                     MOV   ESCSTATUS, 0
                                     MOV   SCORE_COUNT_PLAYER_2, 0

                                     MOV   Ball_X_Right , 165
                                     MOV   Ball_Y_Right , 78
                                     MOV   Ball_X_Left , 165
                                     MOV   Ball_Y_Left , 239                       ;border_middle + 77
                                    
    ; CHECK IF THE BALL VELOCITY IS NEG MAKE IT POSITIVE
                                     CMP   Ball_Velocity_X1, 0
                                     JL    DUMMY12
                                     NEG   Ball_Velocity_X1
    DUMMY12:                         
                                     CMP   Ball_Velocity_X2, 0
                                     JL    DUMMY13
                                     NEG   Ball_Velocity_X2
    DUMMY13:                         

                                    
    ; ----------------------------------------------------------------------------------------------

                                     MOV   Bricks_Rows, 3
                                     MOV   Bricks_Cols, 8
                                     MOV   Brick_Height, 8
                                     MOV   Brick_Width, 32
                                     MOV   Gap_X, 8
                                     MOV   Gap_Y, 4
                                     MOV   Brick_Color, 10
                                     MOV   SCORE_COUNT, 0

    ; loop on the bricks states and set them to 1
                                     MOV   SI, 0
                                     MOV   CX, 40
    SETST:                           
                                     MOV   byte ptr [Bricks_States + SI], 1
                                     INC   SI
                                     LOOP  SETST


                                     CALL  Initialize_Bricks_Positions

    ;Draw Bricks
                                     CALL  Draw_Bricks
                                     CALL  Draw_Ball_Right
                                     CALL  Draw_Ball_Left



    ; DRAW PADDLE 1
                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y1
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, PADDLE_COLOR1
                                     CALL  Draw_Single_Rect

    ; DRAW PADDLE 2
                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y2
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, PADDLE_COLOR2
                                     CALL  Draw_Single_Rect
    Check_Time_Label_Two_Player:     

    ; Get the current system time
                                     MOV   AH, 2CH
                                     INT   21H

    ; Check if the time has changed
                                     CMP   DL, Prev_Time
                                     JNE   DUMMY8
                                     JMP   Check_Time_Label_Two_Player
    DUMMY8:                                                                        ; Skip the rest of the loop if time hasn't changed
                                     MOV   Prev_Time, DL

    ; Handle user input
                                     CMP   SCORE_COUNT, 12
                                     JE    EXIT_MODE_TWO_PLAYER
                                     CMP   SCORE_COUNT_PLAYER_2, 12
                                     JE    EXIT_MODE_TWO_PLAYER

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     CALL  INPUT_TWO_PLAYER

                                     CMP   ESCSTATUS, 0
                                     JNE   EXIT_MODE_TWO_PLAYER
                                     CMP   LIVES_COUNT, 0
                                     JE    EXIT_MODE_TWO_PLAYER
                                     CMP   LIVES_COUNT_PLAYER_2, 0
                                     JE    EXIT_MODE_TWO_PLAYER

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

    ; Handle ball movement and collision
                                     CMP   START_PLAYING, 0
                                     JE    Check_Time_Label_Two_Player

                                     CALL  Draw_Black_Ball_Left
                                     CALL  Move_Ball_Two_Player_Right
                                     CALL  Draw_Ball_Left
                             
                                     CALL  Draw_Black_Ball_Right
                                     CALL  Move_Ball_Two_Player_Left
                                     CALL  Draw_Ball_Right


    ; Update the paddle position
                                     PUSH  DX
                                     PUSH  AX
                                     MOV   DX, PADDLE_HEIGHT
                                     MOV   AL, PADDLE_COLOR
    ; CALL Draw_Single_Rect
                                     POP   AX
                                     POP   DX

                                     JMP   Check_Time_Label_Two_Player


    EXIT_MODE_TWO_PLAYER:            
    ; RESTORE VIDEO MODE
                                     MOV   AH, 0
                                     MOV   AL, 3
                                     INT   10H

    ; MOVE CURSOR TO CENTER
                                     mov   ah, 02h
                                     mov   bh, 0
                                     mov   dh, 12
                                     mov   dl, 20
                                     int   10h

                                     CMP   SCORE_COUNT, 12
                                     JE    WIN_TWO
                                     CMP   SCORE_COUNT_PLAYER_2, 12
                                     JE    LOSE_TWO

                                     MOV   BL, LIVES_COUNT
                                     CMP   BL, LIVES_COUNT_PLAYER_2
                                     JG    WIN_TWO
                                     JL    LOSE_TWO

                                     MOV   BL, LIVES_COUNT
                                     CMP   BL, LIVES_COUNT_PLAYER_2
                                     JG    WIN_TWO
                                     JL    LOSE_TWO
                                     JE    NO2
                                     
    ; Display the win message
    WIN_TWO:                         
                                     MOV   AH, 09H
                                     LEA   DX, WINSTRING
                                     INT   21H
                                     INC   PLAYER_LEFT_COLOR
                                     ADD   PING_PADDLE_HEIGHT, 6D
                                     JMP   NO2

    LOSE_TWO:                        
                                     MOV   AH, 09H
                                     LEA   DX, LOSESTRING
                                     INT   21H
                                     INC   PLAYER_RIGHT_COLOR
                                     ADD   PING_PADDLE_HEIGHT2, 6D

                                     

    NO2:                             
    ; WAIT 2 SECONDS
                                     MOV   AH, 86H                                 ; Set function number for delay
                                     MOV   CX, 30                                  ; High-order word of the delay
                                     MOV   DX, 19456                               ; Low-order word of the delay
                                     INT   15H                                     ; Call BIOS to execute the delay
                                     CALL  START_PING_PONG
                                     
START_TWO_PLAYER ENDP

START_PING_PONG PROC

                                     MOV   SCORE_COUNT, 0
                                     MOV   SCORE_COUNT_PLAYER_2, 0


    ; CALC SCREEN SIZE AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     MUL   SCREEN_HEIGHT
                                     MOV   SCREEN_SIZE, AX

    ; CALC BORDER RIGHT AND STORE IT
                                     MOV   AX, SCREEN_WIDTH
                                     SUB   AX, PADDLE_WIDTH
                                     MOV   BORDER_RIGHT, AX

     
    ; INITIALIZE VIDEO MODE
                                     MOV   AX, 0A000H
                                     MOV   ES, AX
                                     MOV   AH, 0
                                     MOV   AL, 13H
                                     INT   10H

    ;DRAW SCORE CONTAINER
                                     call  Draw_Score_Container_left
                                     call  Draw_Score_Container_right

    ; DRAW LEFT PADDLE
                                     MOV   AX, PLAYER_LEFT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_LEFT_Y
                                     MOV   DI, AX

                                     MOV   DX, PING_PADDLE_HEIGHT
                                     MOV   SI, PING_PADDLE_WIDTH

                                     MOV   AL, PLAYER_LEFT_COLOR
                                     CALL  Draw_Single_Rect

    ; DRAW RIGHT PADDLE
                                     MOV   AX, PLAYER_RIGHT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_RIGHT_Y
                                     MOV   DI, AX

                                     MOV   DX, PING_PADDLE_HEIGHT2
                                     MOV   SI, PING_PADDLE_WIDTH

                                     MOV   AL, PLAYER_RIGHT_COLOR
                                     CALL  Draw_Single_Rect

                                     


    ; DRAW PONG BALL
                                     CALL  TEST_DRAW_BALL

    Check_Time_Label_PONG:           

    ; Get the current system time
                                     MOV   AH, 2CH
                                     INT   21H

    ; Check if the time has changed
                                     CMP   DL, Prev_Time
                                     JNE   DUMMY80
                                     JMP   Check_Time_Label_PONG
    DUMMY80:                                                                       ; Skip the rest of the loop if time hasn't changed
                                     MOV   Prev_Time, DL

    ; Handle user input
                                     CMP   SCORE_COUNT, 5
                                     JE    EXITYY
                                     CMP   SCORE_COUNT_PLAYER_2, 5
                                     JE    EXITYY

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     CALL  HANDLE_PONG_INPUT

                                     CMP   ESCSTATUS, 0
                                     JNE   EXITYY

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

                                     CMP   START_PLAYING_PONG, 0
                                     JE    Check_Time_Label_PONG

                                     CALL  TEST_DRAW_BLACK_BALL
                                     CALL  MOVE_BALL_PING
                                     CALL  TEST_DRAW_BALL

                                     JMP   Check_Time_Label_PONG

    EXITYY:                          
    ; RESTORE VIDEO MODE
                                     MOV   AH, 0
                                     MOV   AL, 3
                                     INT   10H

    ; MOVE CURSOR TO CENTER
                                     mov   ah, 02h
                                     mov   bh, 0
                                     mov   dh, 12
                                     mov   dl, 20
                                     int   10h

                                     CMP   SCORE_COUNT, 5
                                     JE    WIN_TWOP
                                     CMP   SCORE_COUNT_PLAYER_2, 5
                                     JE    LOSE_TWOP

                                     MOV   BX, SCORE_COUNT
                                     CMP   BX, SCORE_COUNT_PLAYER_2
                                     JG    WIN_TWOP
                                     JL    LOSE_TWOP
                                     
    ; Display the win message
    WIN_TWOP:                        
                                     MOV   AH, 09H
                                     LEA   DX, WINSTRING
                                     INT   21H
                                     JMP   NO2P
    LOSE_TWOP:                       
                                     MOV   AH, 09H
                                     LEA   DX, LOSESTRING
                                     INT   21H

    NO2P:                            
    ; WAIT 2 SECONDS
                                     MOV   AH, 86H                                 ; Set function number for delay
                                     MOV   CX, 30                                  ; High-order word of the delay
                                     MOV   DX, 19456                               ; Low-order word of the delay
                                     INT   15H                                     ; Call BIOS to execute the delay


                                     CALL  MAIN

START_PING_PONG ENDP

INIT_PORT PROC
    ; Initialize COM port
    ; Set Divisor Latch Access Bit
                                     mov   dx, 3FBh                                ; Line Control Register
                                     mov   al, 10000000b                           ; Set Divisor Latch Access Bit
                                     out   dx, al

    ; Set LSB byte of the Baud Rate Divisor Latch register
                                     mov   dx, 3F8h
                                     mov   al, 0Ch
                                     out   dx, al

    ; Set MSB byte of the Baud Rate Divisor Latch register
                                     mov   dx, 3F9h
                                     mov   al, 00h
                                     out   dx, al

    ; Set port configuration
                                     mov   dx, 3FBh
                                     mov   al, 00011011b
                                     out   dx, al

                                     RET
INIT_PORT ENDP

HANDLE_PONG_INPUT PROC
    ; SERIAL PART --------------------------########################################--------------------------------
                                     MOV   PONG_INPUT, 0

                                     CALL  INIT_PORT

    ; Check if key is pressed
                                     mov   ah, 01h
                                     int   16h
    
                                     JZ    CHECK_UART_PONG                         ; If no key is pressed, check UART for incoming data

    SEND_PONG:                       
    ; Key is pressed, read it
                                     mov   ah, 00h
                                     int   16h
                                     MOV   PONG_INPUT, AL

    ; Check that Transmitter Holding Register is empty
                                     mov   dx, 3FDh                                ; Line Status Register
    WAIT_TRANSMIT_PONG:              
                                     in    al, dx                                  ; Read Line Status
                                     and   al, 00100000b

    ; Transmit the value
                                     mov   dx, 3F8h                                ; Transmit Data Register
                                     mov   al, PONG_INPUT
                                     out   dx, al

    ; CHECK IF THE KEY PRESSED IS Q
                                     CMP   PONG_INPUT, 'Q'
                                     JNE   MA4Y
                                     INC   START_PLAYING_PONG
                                     MOV   WHO_STARTED, 1

    MA4Y:                            
    ; CHECK IF EXIT IS PRESSED
                                     CMP   PONG_INPUT, 1Bh
                                     JE    EXIT_PONG
                                     JMP   PONG_START_INPUT

    CHECK_UART_PONG:                 
    ; Check if UART has incoming data
                                     mov   dx, 3FDh                                ; Line Status Register
                                     in    al, dx
                                     and   al, 01h
                                     JNZ   CONT_PONG                               ; If no data, continue to input handling
                                     RET

    CONT_PONG:                       
    ; Data is ready, read it
                                     mov   dx, 3F8h                                ; Receive Data Register
                                     in    al, dx

    ; CHECK IF THE RECEIVED IS Q
                                     CMP   AL, 'Q'
                                     JNE   MA4Y2
                                     INC   START_PLAYING_PONG
                                     MOV   WHO_STARTED, 2
    MA4Y2:                           
    ; Exit if received value is ESC
                                     MOV   CL, AL
                                     cmp   al, 1Bh
                                     JE    EXIT_PONG

                                     JMP   PONG_START_INPUT

    EXIT_PONG:                       
                                     INC   ESCSTATUS
                                     RET
    ; SERIAL PART END --------------------------########################################--------------------------------

    PONG_START_INPUT:                
                                     CMP   PONG_INPUT, 0
                                     JNZ   DUMMY50
                                     JMP   CHECK_TWO_PONG
                            
    DUMMY50:                         
                                     MOV   AL, PONG_INPUT
    ;  MOV   CL, PONG_INPUT
                                     MOV   PONG_INPUT, 0

    ; ; FETCH THE KEY DETAILS
    ;                                  MOV   AH, 00H
    ;                                  INT   16H

    ; HANDLE LEFT ARROW KEY
                                     CMP   AL, 35H
                                     JE    PLAYER_1_MOVE_UP

    ; HANDLE RIGHT ARROW KEY
                                     CMP   AL, 32H
                                     JE    PLAYER_1_MOVE_DOWN

    CHECK_TWO_PONG:                  
    ; HANDLE UP ARROW KEY
                                     CMP   CL, 35H
                                     JE    PLAYER_2_MOVE_UP

    ; HANDLE DOWN ARROW KEY
                                     CMP   CL, 32H
                                     JNE   DUMMY60
                                     JMP   PLAYER_2_MOVE_DOWN
    DUMMY60:                         

    ; HANDLE ESC KEY
                                     CMP   AL, 1BH
                                     JE    DUMMY70
                                     JMP   PONG_EXIT
    DUMMY70:                         
                                     INC   ESCSTATUS
                                     RET


    PLAYER_1_MOVE_UP:                
    ; ; MOVE PADDLE UP
                                     MOV   AX, PLAYER_LEFT_X
                                     SUB   AX, PING_PADDLE_SPEED
                                     CMP   AX, 10
                                     JL    PLAYER_1_MOVE_UP_DONE
                                     MOV   [PLAYER_LEFT_X], AX
    PLAYER_1_MOVE_UP_DONE:           
                                     CALL  PLAYER_1_CLEAR_PADDLE_PONG

                                     MOV   AX, PLAYER_LEFT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_LEFT_Y
                                     MOV   DI, AX

                                     MOV   DX, PING_PADDLE_HEIGHT
                                     mov   si, PING_PADDLE_WIDTH

                                     MOV   AL, PLAYER_LEFT_COLOR

                                     CALL  Draw_Single_Rect
                                     RET

    PLAYER_1_MOVE_DOWN:              
    ; ; MOVE PADDLE DOWN
                                     MOV   AX, PLAYER_LEFT_X
                                     ADD   AX, PING_PADDLE_SPEED
                                     CMP   AX, 160
                                     JG    PLAYER_1_MOVE_DOWN_DONE
                                     MOV   [PLAYER_LEFT_X], AX
    PLAYER_1_MOVE_DOWN_DONE:         
                                     CALL  PLAYER_1_CLEAR_PADDLE_PONG

                                     MOV   AX, PLAYER_LEFT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_LEFT_Y
                                     MOV   DI, AX

                                     MOV   DX, PING_PADDLE_HEIGHT2
                                     mov   si, PING_PADDLE_WIDTH

                                     MOV   AL, PLAYER_LEFT_COLOR

                                     CALL  Draw_Single_Rect
                                     RET

    PLAYER_2_MOVE_UP:                
    ; ; MOVE PADDLE UP
                                     MOV   AX, PLAYER_RIGHT_X
                                     SUB   AX, PING_PADDLE_SPEED
                                     CMP   AX, 10
                                     JL    PLAYER_2_MOVE_UP_DONE
                                     MOV   [PLAYER_RIGHT_X], AX
    PLAYER_2_MOVE_UP_DONE:           
                                     CALL  PLAYER_2_CLEAR_PADDLE_PONG
    
                                     MOV   AX, PLAYER_RIGHT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_RIGHT_Y
                                     MOV   DI, AX
    
                                     MOV   DX, PING_PADDLE_HEIGHT2
                                     mov   si, PING_PADDLE_WIDTH
    
                                     MOV   AL, PLAYER_RIGHT_COLOR
    
                                     CALL  Draw_Single_Rect
                                     RET

    PLAYER_2_MOVE_DOWN:              
    ; ; MOVE PADDLE DOWN
                                     MOV   AX, PLAYER_RIGHT_X
                                     ADD   AX, PING_PADDLE_SPEED
                                     CMP   AX, 160
                                     JG    PLAYER_2_MOVE_DOWN_DONE
                                     MOV   [PLAYER_RIGHT_X], AX
    PLAYER_2_MOVE_DOWN_DONE:         
                                     CALL  PLAYER_2_CLEAR_PADDLE_PONG
    
                                     MOV   AX, PLAYER_RIGHT_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PLAYER_RIGHT_Y
                                     MOV   DI, AX
    
                                     MOV   DX, PING_PADDLE_HEIGHT2
                                     mov   si, PING_PADDLE_WIDTH
    
                                     MOV   AL, PLAYER_RIGHT_COLOR
    
                                     CALL  Draw_Single_Rect
                                     RET

    PONG_EXIT:                       
                                     RET

HANDLE_PONG_INPUT ENDP

PLAYER_1_CLEAR_PADDLE_PONG PROC
                                     MOV   AX, 10
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, 0
                                     MOV   DI, AX

                                     MOV   DX, SCREEN_HEIGHT
                                     mov   si, 15

                                     MOV   AL, 0
                          
                                     CALL  Draw_Single_Rect
                                     RET
PLAYER_1_CLEAR_PADDLE_PONG ENDP

PLAYER_2_CLEAR_PADDLE_PONG PROC
                                     MOV   AX, 10
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, SCREEN_WIDTH_CONST - 15
                                     MOV   DI, AX
    
                                     MOV   DX, SCREEN_HEIGHT
                                     mov   si, 15
    
                                     MOV   AL, 0
                                     CALL  Draw_Single_Rect
                                     RET
PLAYER_2_CLEAR_PADDLE_PONG ENDP

MOVE_BALL_PING PROC

                                     CMP   AWL_MARA, 0
                                     JNE   KMEL
                                     INC   AWL_MARA
                                     CMP   WHO_STARTED, 2
                                     JNE   KMEL
                                     NEG   PONG_BALL_SPEED_Y


    KMEL:                            
                                     MOV   AX, PONG_BALL_SPEED_X
                                     ADD   PONG_BALL_X, AX
                                     CMP   PONG_BALL_X, 10
    ;  JLE   PONG_BALL_X_NEG
                                     JG    NT
                                     JMP   PONG_BALL_X_NEG
    NT:                              

                                     MOV   AX, SCREEN_HEIGHT
                                     CMP   PONG_BALL_X, AX
                                     JGE   PONG_BALL_X_NEG

                                     MOV   AX, PONG_BALL_SPEED_Y
                                     ADD   PONG_BALL_Y, AX

    ; CHECK IF ANY ONE SCORED
                                     CMP   PONG_BALL_Y, 0
                                     JG    X2
                                     INC   SCORE_COUNT_PLAYER_2
                                     CALL  Draw_Score_right
                                     JMP   PONG_BALL_Y_NEG
    X2:                              
                                     MOV   AX, 314
                                     CMP   PONG_BALL_Y, AX
                                     JL    X3
                                     INC   SCORE_COUNT
                                     CALL  Draw_Score
                                     JMP   PONG_BALL_Y_NEG
    X3:                              

    ; CHECK IF BALL HIT THE PADDLE
                                     MOV   AX, PLAYER_LEFT_Y
                                     ADD   AX, PING_PADDLE_WIDTH
                                     CMP   AX, PONG_BALL_Y
                                     JNG   CHECK_RIGHT_PLAYER

                                     MOV   AX, PLAYER_LEFT_X
                                     CMP   AX, PONG_BALL_X
                                     JG    CHECK_RIGHT_PLAYER

                                     ADD   AX, PING_PADDLE_HEIGHT
                                     CMP   AX, PONG_BALL_X
                                     JL    CHECK_RIGHT_PLAYER

                                     NEG   PONG_BALL_SPEED_Y

    CHECK_RIGHT_PLAYER:              
                                     MOV   AX, PONG_BALL_Y
                                     ADD   AX, PONG_BALL_SIZE
                                     CMP   AX, PLAYER_RIGHT_Y
                                     JL    STOP_BALL

                                     MOV   AX, PONG_BALL_X
                                     ADD   AX, PONG_BALL_SIZE
                                     CMP   AX, PLAYER_RIGHT_X
                                     JL    STOP_BALL

                                     MOV   AX, PLAYER_RIGHT_X
                                     ADD   AX, PING_PADDLE_HEIGHT
                                     CMP   AX, PONG_BALL_X
                                     JL    STOP_BALL


                                     NEG   PONG_BALL_SPEED_Y
                                     RET

    PONG_BALL_X_NEG:                 
                                     NEG   PONG_BALL_SPEED_X
                                     RET
    PONG_BALL_Y_NEG:                 
                                     NEG   PONG_BALL_SPEED_Y
                                     RET

    STOP_BALL:                       
                                     RET
MOVE_BALL_PING ENDP

TEST_DRAW_BALL PROC
                                     MOV   CX, PONG_BALL_Y
                                     MOV   DX, PONG_BALL_X
    TEST_DRAW_HOR:                   
                                     MOV   AH, 0CH
                                     MOV   AL, PONG_BALL_COLOR
                                     INT   10H
                                     INC   CX
                                     MOV   AX, CX
                                     SUB   AX, PONG_BALL_Y
                                     CMP   AX, PONG_BALL_SIZE
                                     JNG   TEST_DRAW_HOR

                                     MOV   CX, PONG_BALL_Y
                                     INC   DX
                                     MOV   AX, DX
                                     SUB   AX, PONG_BALL_X
                                     CMP   AX, PONG_BALL_SIZE
                                     JNG   TEST_DRAW_HOR
                                     RET
TEST_DRAW_BALL ENDP

TEST_DRAW_BLACK_BALL PROC
                                     MOV   CX, PONG_BALL_Y
                                     MOV   DX, PONG_BALL_X
    TEST_DRAW_HOR1:                  
                                     MOV   AH, 0CH
                                     MOV   AL, 0
                                     INT   10H
                                     INC   CX
                                     MOV   AX, CX
                                     SUB   AX, PONG_BALL_Y
                                     CMP   AX, PONG_BALL_SIZE
                                     JNG   TEST_DRAW_HOR1

                                     MOV   CX, PONG_BALL_Y
                                     INC   DX
                                     MOV   AX, DX
                                     SUB   AX, PONG_BALL_X
                                     CMP   AX, PONG_BALL_SIZE
                                     JNG   TEST_DRAW_HOR1
                                     RET
TEST_DRAW_BLACK_BALL ENDP

INPUT_TWO_PLAYER PROC

    ; SERIAL PART --------------------------########################################--------------------------------
                                     MOV   PLAYER_INPUT, 0

                                     CALL  INIT_PORT
    ; Check if key is pressed
                                     mov   ah, 01h
                                     int   16h

                                     JZ    CHECK_UART_TWO_PLAYER                   ; If no key is pressed, check UART for incoming data


    SEND_TWO_PLAYER:                 
    ; Key is pressed, read it
                                     mov   ah, 00h
                                     int   16h
                                     MOV   PLAYER_INPUT, AL

    ; Check that Transmitter Holding Register is empty
                                     mov   dx, 3FDh                                ; Line Status Register
    WAIT_TRANSMIT_TWO_PLAYER:        
                                     in    al, dx                                  ; Read Line Status
                                     and   al, 00100000b
    ;  JZ    START_INPUT

    ; Transmit the value
                                     mov   dx, 3F8h                                ; Transmit Data Register
                                     mov   al, PLAYER_INPUT
                                     out   dx, al

    ; if F is pressed inc START_PLAYING
                                     CMP   AL, 46H
                                     JNE   GG

    ; DELAY ONE CLOCK CYCLE
                                     MOV   CX, 0
    DELAY:                           
                                     INC   CX
                                     CMP   CX, 1000
                                     JNE   DELAY

                                     JE    START_GAME


    GG:                              
    ; Exit if ESC key is pressed
                                     cmp   al, 1Bh
                                     JE    EXITX
                                     jmp   START_INPUT

    CHECK_UART_TWO_PLAYER:           
    ; ; Check if data is ready to be received from UART
                                     mov   dx, 3FDh                                ; Line Status Register
                                     in    al, dx
                                     and   al, 01h
                                     JNZ   CONT_TWO_PLAYER                         ; if no data, continue to input handling
                                     RET
    CONT_TWO_PLAYER:                 
    ; Data is ready, read it
                                     mov   dx, 3F8h                                ; Receive Data Register
                                     in    al, dx
                                     

    ; Exit if received value is ESC
                                     MOV   CL, AL
                                     cmp   al, 1Bh
                                     JE    EXITX
    ; CHECK IF F KEY IS PRESSED
                                     CMP   AL, 46H
                                     JE    START_GAME
                                     MOV   AL, 0
                                     JMP   START_INPUT
    START_GAME:                      
                                     inc   START_PLAYING
                                     RET

    EXITX:                           
                                     inc   ESCSTATUS
                                     RET
   
    ; SERIAL PART END --------------------------########################################--------------------------------
    START_INPUT:                     
    ; CHECK IF A KEY IS PRESSED
    ;  MOV   AH, 01H
    ;  INT   16H
                                     CMP   PLAYER_INPUT, 0
                                     JNZ   DUMMY5
                                     JMP   CHECK_TWO
                            
    DUMMY5:                          
                                     MOV   AL, PLAYER_INPUT
                                     MOV   PLAYER_INPUT, 0

    ; ; FETCH THE KEY DETAILS
    ;                                  MOV   AH, 00H
    ;                                  INT   16H

    ; HANDLE LEFT ARROW KEY
                                     CMP   AL, 31H
                                     JE    PLAYER_1_MOVE_LEFTT

    ; HANDLE RIGHT ARROW KEY
                                     CMP   AL, 33H
                                     JE    PLAYER_1_MOVE_RIGHTT

    CHECK_TWO:                       
    ; HANDLE UP ARROW KEY
                                     CMP   CL, 31H
                                     JE    PLAYER_2_MOVE_LEFTT

    ; HANDLE DOWN ARROW KEY
                                     CMP   CL, 33H
                                     JNE   DUMMY6
                                     JMP   PLAYER_2_MOVE_RIGHTT
    DUMMY6:                          

    ; HANDLE ESC KEY
                                     CMP   AL, 1BH
                                     JE    DUMMY7
                                     JMP   TWO_PLAYER_EXIT
    DUMMY7:                          
                                     INC   ESCSTATUS
    ;   JMP  INPUT_MAIN_LOOP
                                     RET

    ; MOVE PADDLE LEFT AND CHECK FOR BORDERS
    PLAYER_1_MOVE_LEFTT:             
                                     MOV   AX, PADDLE_Y1
                                     SUB   AX, PADDLE_SPEED
                                     CMP   AX, BORDER_LEFT
                                     JL    PLAYER_1_MOVE_LEFTT_DONE
                                     MOV   [PADDLE_Y1], AX
    PLAYER_1_MOVE_LEFTT_DONE:        
                                     CALL  PLAYER_1_CLEAR_PADDLE

                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y1
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR1

                                     CALL  Draw_Single_Rect
                                     RET
    ;   JMP  INPUT_MAIN_LOOP

    ; MOVE PADDLE RIGHT AND CHECK FOR BORDERS
    PLAYER_1_MOVE_RIGHTT:            
                                     MOV   AX, PADDLE_Y1
                                     ADD   AX, PADDLE_SPEED
                                     CMP   AX, BORDER_MIDDLE - 41
                                     JG    PLAYER_1_MOVE_RIGHTT_DONE
                                     MOV   [PADDLE_Y1], AX
    PLAYER_1_MOVE_RIGHTT_DONE:       
                                     CALL  PLAYER_1_CLEAR_PADDLE

                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y1
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR1
                          
                                     CALL  Draw_Single_Rect
                                     RET
    

    ; MOVE PADDLE LEFT AND CHECK FOR BORDERS
    PLAYER_2_MOVE_LEFTT:             
                                     MOV   AX, PADDLE_Y2
                                     SUB   AX, PADDLE_SPEED
    ;  CMP   AX, BORDER_MIDDLE - 1
                                     MOV   CX, BORDER_MIDDLE
                                     ADD   CX, 2
                                     CMP   AX, CX
                                     JL    PLAYER_2_MOVE_LEFTT_DONE
                                     MOV   [PADDLE_Y2], AX
    PLAYER_2_MOVE_LEFTT_DONE:        
                                     CALL  PLAYER_2_CLEAR_PADDLE

                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y2
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR2

                                     CALL  Draw_Single_Rect
                                     RET
    ;   JMP  INPUT_MAIN_LOOP

    ; MOVE PADDLE RIGHT AND CHECK FOR BORDERS
    PLAYER_2_MOVE_RIGHTT:            
                                     MOV   AX, PADDLE_Y2
                                     ADD   AX, PADDLE_SPEED
                                     CMP   AX, BORDER_RIGHT
                                     JG    PLAYER_2_MOVE_RIGHTT_DONE
                                     MOV   [PADDLE_Y2], AX
    PLAYER_2_MOVE_RIGHTT_DONE:       
                                     CALL  PLAYER_2_CLEAR_PADDLE

                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y2
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR2
                          
                                     CALL  Draw_Single_Rect

    TWO_PLAYER_EXIT:                 
                                     RET
INPUT_TWO_PLAYER ENDP

PLAYER_1_CLEAR_PADDLE PROC
                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, 159

                                     MOV   AL, 0
                          
                                     CALL  Draw_Single_Rect
                                     RET
PLAYER_1_CLEAR_PADDLE ENDP


PLAYER_2_CLEAR_PADDLE PROC
                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, 161
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, 159

                                     MOV   AL, 0
                          
                                     CALL  Draw_Single_Rect
                                     RET
PLAYER_2_CLEAR_PADDLE ENDP

    ; INPUT PROCs----------------------------------------------------------------------------------------------------
INPUT_MAIN_LOOP PROC

    ; CHECK IF A KEY IS PRESSED
                                     MOV   AH, 01H
                                     INT   16H
                                     JZ    INPUT_EXIT

    ; FETCH THE KEY DETAILS
                                     MOV   AH, 00H
                                     INT   16H

    ; HANDLE LEFT ARROW KEY
                                     CMP   AH, 4BH
                                     JE    INPUT_MOVE_LEFT

    ; HANDLE RIGHT ARROW KEY
                                     CMP   AH, 4DH
                                     JE    INPUT_MOVE_RIGHT

    ; HANDLE ESC KEY
                                     CMP   AL, 1BH
                                     JNE   INPUT_EXIT
                                     INC   ESCSTATUS
    ;   JMP  INPUT_MAIN_LOOP
                                     ret

    ; MOVE PADDLE LEFT AND CHECK FOR BORDERS
    INPUT_MOVE_LEFT:                 
                                     MOV   AX, PADDLE_Y
                                     SUB   AX, PADDLE_SPEED
                                     CMP   AX, BORDER_LEFT
                                     JL    INPUT_MOVE_LEFT_DONE
                                     MOV   [PADDLE_Y], AX
    INPUT_MOVE_LEFT_DONE:            
                                     CALL  INPUT_CLEAR_SCREEN

                                     MOV   AX, PADDLE_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR

                                     CALL  Draw_Single_Rect
                                     RET
    ;   JMP  INPUT_MAIN_LOOP

    ; MOVE PADDLE RIGHT AND CHECK FOR BORDERS
    INPUT_MOVE_RIGHT:                
                                     MOV   AX, PADDLE_Y
                                     ADD   AX, PADDLE_SPEED
                                     CMP   AX, BORDER_RIGHT
                                     JG    INPUT_MOVE_RIGHT_DONE
                                     MOV   [PADDLE_Y], AX
    INPUT_MOVE_RIGHT_DONE:           
                                     CALL  INPUT_CLEAR_SCREEN

                                     MOV   AX, PADDLE_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH

                                     MOV   AL, PADDLE_COLOR
                          
                                     CALL  Draw_Single_Rect
    ;   JMP  INPUT_MAIN_LOOP
    
    INPUT_EXIT:                      
                                     RET

INPUT_MAIN_LOOP ENDP

INPUT_CLEAR_SCREEN PROC
                                     MOV   AX, 0A000h
                                     MOV   ES, AX
                                     MOV   DI, (SCREEN_HEIGHT_CONST - 20) * 320
                                     MOV   CX, 2000
                                     MOV   AL, BLACK
                                     REP   STOSB
                                     RET
INPUT_CLEAR_SCREEN ENDP

    ;DRAW SCORE CONTAINER------------------------------------------------------------------------------------------------------

Draw_Score_Container PROC

                                     mov   al, 2
                                     mov   di, 325
                                     mov   cx, 26d
                                     rep   stosb

                                     mov   al, 2
                                     mov   di, 1925
                                     mov   cx, 26d
                                     rep   stosb

                                     mov   di, 325                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLine:                         
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLine                                 ; Repeat until CX = 0

                                     mov   di, 351                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLine2:                        
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLine2
                                     ret
Draw_Score_Container ENDP

    ;---------------------------------------------------------------------------------------------------------------------------

Draw_Score_Container_right PROC

                                     mov   al, 2
                                     mov   di, 620
                                     mov   cx, 13d
                                     rep   stosb

                                     mov   al, 2
                                     mov   di, 2220
                                     mov   cx, 13d
                                     rep   stosb

                                     mov   di, 620                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLineR:                        
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLineR                                ; Repeat until CX = 0

                                     mov   di, 633                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLineR2:                       
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLineR2
                                     ret
Draw_Score_Container_right ENDP

    ;---------------------------------------------------------------------------------------------------------------------------

Draw_Score_Container_left PROC

                                     mov   al, 2
                                     mov   di, 325
                                     mov   cx, 13d
                                     rep   stosb

                                     mov   al, 2
                                     mov   di, 1925
                                     mov   cx, 13d
                                     rep   stosb

                                     mov   di, 325                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLineL:                        
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLineL                                ; Repeat until CX = 0

                                     mov   di, 338                                 ; Starting position in video memory (DI = 325)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 5                                   ; Length of the vertical line
                                     mov   al, 2                                   ; Pixel color (e.g., 2)

    verLineL2:                       
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLineL2
                                     ret
Draw_Score_Container_left ENDP


    ;DRAWSCORE PROGRESS-----------------------------------------------------------------------------------------------------
Draw_Score PROC
                                     mov   al, 0Dh
                                     mov   di, 645
                                     add   di, SCORE_COUNT
                                     mov   cx, 4
                                     mov   dx, di
    verLine3:                        
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLine3
                                     ret

Draw_Score ENDP

    ;-----------------------------------------------------------------------------------------------------------------------------
Draw_Score_right PROC
                                     mov   al, 0Dh
                                     mov   di, 940
                                     add   di, SCORE_COUNT_PLAYER_2
                                     mov   cx, 4
                                     mov   dx, di
    verLineR3:                       
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   verLineR3
                                     ret

Draw_Score_right ENDP

Draw_Lives PROC


                                     MOV   AL, 0
                                     MOV   DI, 700
                                     XOR   CX,CX
                                     MOV   CL, 3
    ERASE_LIVES_LOOP:                
                                     PUSH  CX
                                     PUSH  DI
                                     MOV   DX, 4
                                     MOV   SI, 8
                                     CALL  Draw_Single_Rect
                                     POP   DI
                                     ADD   DI,10
                                     POP   CX
                                     LOOP  ERASE_LIVES_LOOP
                                     

                                     MOV   AL, 4
                                     MOV   DI, 700
                                     XOR   CX,CX
                                     MOV   CL, LIVES_COUNT
                                     CMP   CL, 0
                                     JE    END_DRAW_LIVES

    DRAW_LIVES_LOOP:                 
                                     PUSH  CX
                                     PUSH  DI
                                     MOV   DX, 4
                                     MOV   SI, 8
                                     CALL  Draw_Single_Rect
                                     POP   DI
                                     ADD   DI,10
                                     POP   CX
                                     LOOP  DRAW_LIVES_LOOP
    END_DRAW_LIVES:                  
                                     RET

Draw_Lives ENDP

Draw_Lives_Right PROC


                                     MOV   AL, 0
                                     MOV   DI, 876
                                     XOR   CX,CX
                                     MOV   CL, 3
    ERASE_LIVES_LOOP_RIGHT:          
                                     PUSH  CX
                                     PUSH  DI
                                     MOV   DX, 4
                                     MOV   SI, 8
                                     CALL  Draw_Single_Rect
                                     POP   DI
                                     ADD   DI,10
                                     POP   CX
                                     LOOP  ERASE_LIVES_LOOP_RIGHT
                                     

                                     MOV   AL, 4
                                     MOV   DI, 876
                                     XOR   CX,CX
                                     MOV   CL, LIVES_COUNT_PLAYER_2
                                     CMP   CL, 0
                                     JE    END_DRAW_LIVES_RIGHT

    DRAW_LIVES_LOOP_RIGHT:           
                                     PUSH  CX
                                     PUSH  DI
                                     MOV   DX, 4
                                     MOV   SI, 8
                                     CALL  Draw_Single_Rect
                                     POP   DI
                                     ADD   DI,10
                                     POP   CX
                                     LOOP  DRAW_LIVES_LOOP_RIGHT
    END_DRAW_LIVES_RIGHT:            
                                     RET

Draw_Lives_Right ENDP

    ;GRAPHICS FUNCTIONS-----------------------------------------------------------------------------------------------------
Draw_Single_Rect proc
    ;summary:
    ;di=> pixle number
    ;dx=> hieght
    ;si=> width
    ;al=> color
    ;  MOV AX, @DATA
    ;  MOV DS, AX
    ; STORE THE VALUE OF  PADDLE_X IN AX THEN MULTIPLY IT BY 320 AND THEN ADD PADDLE_Y THEN STORE IT IN DI
                        
    DRAW_IN_ROW:                     

                                     mov   bx, di
                                     mov   cx, si
                                     rep   stosb
                                     mov   di, bx
                                     add   di, 320d
                                     dec   dx
                                     jnz   DRAW_IN_ROW
                                     RET
Draw_Single_Rect endp
Draw_Ball PROC
    ;initialization
                                     MOV   CX,Ball_Y
                                     MOV   DX, Ball_X

    Draw_Ball_Horizontal:            
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,14
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal

    ;Update Rows
                                     MOV   CX,Ball_Y
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal

                                     RET
                                     ENDP  Draw_Ball
Draw_Ball_Right PROC
    ;initialization
                                     MOV   CX,Ball_Y_Right
                                     MOV   DX, Ball_X_Right

    Draw_Ball_Horizontal_Right:      
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,05                                   ;purple color
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y_Right
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal_Right

    ;Update Rows
                                     MOV   CX,Ball_Y_Right
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X_Right
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal_Right

                                     RET
                                     ENDP  Draw_Ball_Right
Draw_Ball_Left PROC
    ;initialization
                                     MOV   CX,Ball_Y_Left
                                     MOV   DX, Ball_X_Left

    Draw_Ball_Horizontal_Left:       
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,09                                   ;color
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y_Left
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal_Left

    ;Update Rows
                                     MOV   CX,Ball_Y_Left
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X_Left
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Ball_Horizontal_Left

                                     RET
                                     ENDP  Draw_Ball_Left

Initialize_Bricks_Positions PROC
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  SI

                                     XOR   CX, CX
                                     XOR   DX,DX

    Initialize_Row_Loop:             
    
    ;Set AX with the number of pixel row
                                     MOV   AX, CX
                                     MOV   BX, Brick_Height
                                     ADD   BX, Gap_Y
                                     PUSH  DX
                                     MUL   BX
                                     ADD   AX,14
                                     POP   DX


    ;Set BX to the beginning of the row
                                     XOR   DX, DX

    Initialize_Col_Loop:             

    ;  PUSH AX
    

    ;Set BX with the number of pixel col
                                     PUSH  AX
                                     MOV   AX, DX
                                     MOV   BX, Brick_Width
                                     ADD   BX, Gap_X
                                     PUSH  DX
                                     MUL   BX
                                     POP   DX
                                     MOV   BX, AX
                                     ADD   BX, 4
                                     POP   AX

    
    ;Calculate index
                                     PUSH  AX
                                     PUSH  DX
                                     MOV   AX, CX
                                     MOV   DX, Bricks_Cols
                                     MUL   DX
                                     POP   DX
                                     ADD   AX, DX
                                     PUSH  DX
                                     MOV   DX,2
                                     MUL   DX
                                     POP   DX
                                     MOV   SI, AX
                                     POP   AX

    ;store AX in Bricks_Positions
                                     PUSH  SI
                                     MOV   BP, OFFSET Bricks_Positions
                                     SHL   SI,1
                                     MOV   [BP + SI], AX
    ;store BX in Bricks_Positions
                                     POP   SI
                                     INC   SI
                                     SHL   SI,1
                                     MOV   [BP + SI], BX

                                

                                     INC   DX

                                     CMP   DX, Bricks_Cols
                                     JNE   Initialize_Col_Loop
    ; POP  AX

                                     INC   CX

                                     CMP   CX, Bricks_Rows
                                     JNE   Initialize_Row_Loop

                                     POP   SI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     RET
                                     ENDP  Initialize_Bricks_Positions
    ;Draw_Bricks---------------------------------------------------------------------------------------------------------

Draw_Bricks PROC

    ;Store all used registers
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  SI

                                     XOR   AX,AX
                                     XOR   BX,BX
                                     XOR   SI,SI

    ;Set brick's width and height
                                     MOV   DX, Brick_Height
    Draw_Row_Loop:                   
                                     XOR   BX, BX

    Draw_Col_Loop:                   
    
    ;Check the state of the brick
                                     PUSH  AX
                                     PUSH  DX
                                     PUSH  SI
                                     MOV   AX, SI
                                     MOV   DL, 2
                                     DIV   DL
                                     MOV   SI, AX
                                     MOV   AL, [Bricks_States + SI]
                                     CMP   AL, 0
                                     POP   SI
                                     POP   DX
                                     POP   AX
                                     JE    Skip_Brick

    ;Load AX, BX with the coordinates from Bricks_Positions
                                     PUSH  AX
                                     PUSH  BX

                                     PUSH  SI
                                     MOV   BP, OFFSET Bricks_Positions
                                     SHL   SI,1
                                     MOV   AX, [BP + SI]
                                     POP   SI
                                     PUSH  SI
                                     INC   SI
                                     SHL   SI,1
                                     MOV   BX, [BP + SI]
                                     POP   SI
                                     INC   SI


    ;Multiply AX (y) * 320 + BX (x)
                                     PUSH  BX
                                     MOV   BX, 320
                                     PUSH  DX
                                     MUL   BX
                                     POP   DX
                                     POP   BX
                                     ADD   AX, BX
                                     MOV   DI, AX
                                     MOV   AL, Brick_Color


    ;Draw brick
                                     PUSH  SI
                                     PUSH  DX
                                     PUSH  CX
                                     MOV   SI, Brick_Width
                                     CALL  Draw_Single_Rect
                                     POP   CX
                                     POP   DX
                                     POP   SI

                                     POP   BX
                                     POP   AX
   
    Skip_Brick:                      

                                     INC   BX
                                     INC   SI

                                     CMP   BX, Bricks_Cols
                                     JNE   Draw_Col_Loop

                                     INC   AX

                                     CMP   AX, Bricks_Rows
                                     JNE   Draw_Row_Loop

                                     POP   SI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

                                     RET
                                     ENDP  Draw_Bricks
        
    ;---------------------------------------------------------------------------------------------------------------

Draw_Black_Ball PROC
    ;initialization
                                     MOV   CX,Ball_Y
                                     MOV   DX, Ball_X

    Draw_Black_Ball_Horizontal:      
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,0
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal

    ;Update Rows
                                     MOV   CX,Ball_Y
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal

                                     RET
                                     ENDP  Draw_Black_Ball
Draw_Black_Ball_Right PROC
    ;initialization
                                     MOV   CX, Ball_Y_Right
                                     MOV   DX, Ball_X_Right

    Draw_Black_Ball_Horizontal_Right:
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,0
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y_Right
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal_Right

    ;Update Rows
                                     MOV   CX,Ball_Y_Right
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X_Right
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal_Right

                                     RET
                                     ENDP  Draw_Black_Ball_Right

Draw_Black_Ball_Left PROC
    ;initialization
                                     MOV   CX,Ball_Y_Left
                                     MOV   DX, Ball_X_Left

    Draw_Black_Ball_Horizontal_Left: 
    ;Update Columns
                                     MOV   AH,0CH
                                     MOV   AL,0
                                     INT   10H
                                     INC   CX
                                     MOV   AX,CX
                                     SUB   AX,Ball_Y_Left
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal_Left

    ;Update Rows
                                     MOV   CX,Ball_Y_Left
                                     INC   DX
                                     MOV   AX,DX
                                     SUB   AX,Ball_X_Left
                                     CMP   AX,Ball_Size
                                     JNG   Draw_Black_Ball_Horizontal_Left

                                     RET
                                     ENDP  Draw_Black_Ball_Left
    ;Move_Ball-------------------------------------------------------------------------------------------------------------

Move_Ball PROC
                                     MOV   AX, SCREEN_HEIGHT_CONST - 10
                                     CMP   Ball_X, AX
                                     JL    SKIP
    ;  INC   ESCSTATUS
                                     DEC   LIVES_COUNT

                                     CALL  DRAW_LIVES

    ;Erase paddle
    ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                                     MOV   AX, PADDLE_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, 0
                                     CALL  Draw_Single_Rect

    ;Reset paddle and ball positions
                                     MOV   Ball_X, 160
                                     MOV   Ball_Y, 158
                                     MOV   PADDLE_X, 180
                                     MOV   PADDLE_Y, 140
                                     MOV   Ball_Velocity_X, 2
                                     MOV   Ball_Velocity_Y, 2
                                     NEG   Ball_Velocity_X
                                     NEG   Ball_Velocity_Y

    ;Draw New paddle
                                     MOV   AX, PADDLE_X
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, PADDLE_COLOR
                                     CALL  Draw_Single_Rect
                                     JMP   STOP
    SKIP:                            
       
                                     MOV   AX,Ball_Velocity_X
                                     ADD   Ball_X,AX
                                     CMP   Ball_X,10
                                     JG    CONTINUE
                                     JMP   FAR PTR  Neg_Velocity_X                 ;up and down
    CONTINUE:                        
                                     MOV   AX,SCREEN_HEIGHT
                                     CMP   Ball_X,AX
                                     JGE   Neg_Velocity_X                          ; up and down

                                     MOV   AX,Ball_Velocity_Y
                                     ADD   Ball_Y,AX

                                     CMP   Ball_Y,0
                                     JLE   Neg_Velocity_Y
                                     MOV   AX,SCREEN_WIDTH
                                     CMP   Ball_Y,AX
                                     JGE   Neg_Velocity_Y

                                     CALL  Bricks_Collision

                                     MOV   AX,Ball_X
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_X
                                     JNG   STOP

                                     MOV   AX,PADDLE_X
                                     ADD   AX,PADDLE_HEIGHT
                                     ADD   AX,4
                                     CMP   Ball_X,AX
                                     JNL   STOP

                                     MOV   AX,Ball_Y
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_Y
                                     JNG   STOP

                                     MOV   AX,PADDLE_Y
                                     ADD   AX,PADDLE_WIDTH
                                     ADD   AX,2
                                     CMP   Ball_Y,AX
                                     JNL   STOP

                                     MOV   AX,Ball_Y
                                     ADD   AX,Ball_Size
                                     SUB   AX,2
                                     CMP   AX ,PADDLE_Y
                                     JLE   Neg_Velocity_Y

                                     MOV   AX,PADDLE_Y
                                     ADD   AX,PADDLE_WIDTH
                                     SUB   AX,2
                                     CMP   Ball_Y,AX
                                     JGE   Neg_Velocity_Y
                   
    Neg_Velocity_X:                  
                                     NEG   Ball_Velocity_X
                          
                                     RET

    Neg_Velocity_Y:                  
                                     NEG   Ball_Velocity_Y
                         
                                     RET


    STOP:                            
                                     RET
Move_Ball ENDP


Move_Ball_Two_Player_Left PROC
                                     MOV   AX, SCREEN_HEIGHT_CONST - 10            ;Compare wirh paddle to see if the ball is below it
                                     CMP   Ball_X_Right, AX
                                     JL    SKIP_Two_Player
    ;  INC   ESCSTATUS
                                     DEC   LIVES_COUNT

                                     CALL  DRAW_LIVES

    ;Erase paddle
    ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y1
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, 0
                                     CALL  Draw_Single_Rect

    ;Reset paddle and ball positions
                                     MOV   Ball_X_Right, 165
                                     MOV   Ball_Y_Right, 78
                                     MOV   PADDLE_X1, 180
                                     MOV   PADDLE_Y1, 60
                                     MOV   Ball_Velocity_X1, 2
                                     MOV   Ball_Velocity_Y1, 2

                                     NEG   Ball_Velocity_X1
                                     NEG   Ball_Velocity_Y1

    ;Draw New paddle
                                     MOV   AX, PADDLE_X1
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y1
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, PADDLE_COLOR
                                     CALL  Draw_Single_Rect
                                     JMP   STOP_Two_Player
    SKIP_Two_Player:                 
       
                                     MOV   AX,Ball_Velocity_X1
                                     ADD   Ball_X_Right,AX
                                     CMP   Ball_X_Right,10                         ; Instead of zero to maintain score visual appearance
                                     JG    CONTINUE_FAR_LEFT
                                     JMP   Neg_Velocity_X_Two_Player               ;up and down
    CONTINUE_FAR_LEFT:               
                                     MOV   AX,SCREEN_HEIGHT                        ;End of screen,,not necessary???
                                     CMP   Ball_X_Right,AX
                                     JGE   Neg_Velocity_X_Two_Player               ; up and down


                                     MOV   AX,Ball_Velocity_Y1
                                     ADD   Ball_Y_Right,AX



                                     CMP   Ball_Y_Right,0                          ;Right edge of our screen
                                     JLE   Neg_Velocity_Y_Two_Player
                                     MOV   AX,  BORDER_MIDDLE - 3                  ;Middle of sreen: BORDER_MIDDLE - 3
                                     CMP   Ball_Y_Right,AX
                                     JGE   Neg_Velocity_Y_Two_Player

                                     CALL  Bricks_Collision_Left
    ;  RET

                                     MOV   AX,Ball_X_Right
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_X1
                                     JNG   STOP_Two_Player

                                     MOV   AX,PADDLE_X1
                                     ADD   AX,PADDLE_HEIGHT
                                     ADD   AX,2
                                     CMP   Ball_X_Right,AX
                                     JNL   STOP_Two_Player



                                     MOV   AX,Ball_Y_Right
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_Y1
                                     JNG   STOP_Two_Player

                                     MOV   AX,PADDLE_Y1
                                     ADD   AX,PADDLE_WIDTH
                                     ADD   AX,2
                                     CMP   Ball_Y_Right,AX
                                     JNL   STOP_Two_Player

                                     MOV   AX,Ball_Y_RIGHT
                                     ADD   AX,Ball_Size
                                     SUB   AX,2
                                     CMP   AX ,PADDLE_Y1
                                     JLE   Neg_Velocity_Y_Two_Player

                                     MOV   AX,PADDLE_Y1
                                     ADD   AX,PADDLE_WIDTH
                                     SUB   AX,2
                                     CMP   Ball_Y_RIGHT,AX
                                     JGE   Neg_Velocity_Y_Two_Player


                                   
    Neg_Velocity_X_Two_Player:       
                                     NEG   Ball_Velocity_X1
                                     RET

    Neg_Velocity_Y_Two_Player:       
                                     NEG   Ball_Velocity_Y1
                                     RET


    STOP_Two_Player:                 
                                     RET
Move_Ball_Two_Player_Left ENDP

Move_Ball_Two_Player_Right PROC
                                     MOV   AX, SCREEN_HEIGHT_CONST - 10            ;Compare wirh paddle to see if the ball is below it
                                     CMP   Ball_X_Left, AX
                                     JL    SKIP_Two_Player2
    ;  INC   ESCSTATUS

                                     DEC   LIVES_COUNT_PLAYER_2

                                     CALL  Draw_Lives_Right

    ;Erase paddle
    ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y2
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, 0
                                     CALL  Draw_Single_Rect

    ;Reset paddle and ball positions
                                     MOV   Ball_X_Left, 165
                                     MOV   Ball_Y_Left, 239
                                     MOV   PADDLE_X2, 180
                                     MOV   PADDLE_Y2, 225
                                     MOV   Ball_Velocity_X2,2
                                     MOV   Ball_Velocity_Y2,2


                                     NEG   Ball_Velocity_X2
                                     NEG   Ball_Velocity_Y2

    ;Draw New paddle
                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, PADDLE_Y2
                                     MOV   DI, AX


                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, PADDLE_WIDTH
                                     MOV   AL, PADDLE_COLOR
                                     CALL  Draw_Single_Rect
                                     JMP   STOP_Two_Player2

    SKIP_Two_Player2:                
       
                                     MOV   AX,Ball_Velocity_X2
                                     ADD   Ball_X_Left,AX
                                     CMP   Ball_X_Left,10                          ; Instead of zero to maintain score visual appearance
                                     JG    CONTINUE_FAR_RIGHT
                                     JMP   Neg_Velocity_X_Two_Player2              ;up and down
    CONTINUE_FAR_RIGHT:              
                                     MOV   AX,SCREEN_HEIGHT                        ;End of screen,,not necessary???
                                     CMP   Ball_X_Left,AX
                                     JGE   Neg_Velocity_X_Two_Player2              ; up and down


                                     MOV   AX,Ball_Velocity_Y2
                                     ADD   Ball_Y_Left,AX



                                     CMP   Ball_Y_Left,BORDER_MIDDLE+2             ;COMPARE WITH MIDDLE OF THE SCREEN
                                     JLE   Neg_Velocity_Y_Two_Player2
                                     MOV   AX, 316                                 ;COMPARE WITH THE RIGHT OF THE SCREEN
                                     CMP   Ball_Y_Left,AX
                                     JGE   Neg_Velocity_Y_Two_Player2

                                     CALL  Bricks_Collision_Right
    ;  RET

                                     MOV   AX,Ball_X_Left
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_X2
                                     JNG   STOP_Two_Player2

                                     MOV   AX,PADDLE_X2
                                     ADD   AX,PADDLE_HEIGHT
                                     ADD   AX,2
                                     CMP   Ball_X_Left,AX
                                     JNL   STOP_Two_Player2



                                     MOV   AX,Ball_Y_Left
                                     ADD   AX,Ball_Size
                                     ADD   AX,2
                                     CMP   AX ,PADDLE_Y2
                                     JNG   STOP_Two_Player2

                                     MOV   AX,PADDLE_Y2
                                     ADD   AX,PADDLE_WIDTH
                                     ADD   AX,2
                                     CMP   Ball_Y_Left,AX
                                     JNL   STOP_Two_Player2

                                     MOV   AX,Ball_Y_LEFT
                                     ADD   AX,Ball_Size
                                     SUB   AX,2
                                     CMP   AX ,PADDLE_Y2
                                     JLE   Neg_Velocity_Y_Two_Player2

                                     MOV   AX,PADDLE_Y2
                                     ADD   AX,PADDLE_WIDTH
                                     SUB   AX,2
                                     CMP   Ball_Y_LEFT,AX
                                     JGE   Neg_Velocity_Y_Two_Player2

    Neg_Velocity_X_Two_Player2:      
                                     NEG   Ball_Velocity_X2
                                     RET

    Neg_Velocity_Y_Two_Player2:      
                                     NEG   Ball_Velocity_Y2
                                     RET

    STOP_Two_Player2:                
                                     RET
Move_Ball_Two_Player_Right ENDP

Bricks_Collision_Right PROC
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  SI

                                     XOR   SI, SI
                                     XOR   CX, CX
                                     MOV   BP, OFFSET Bricks_Positions

    Bricks_Loop_Right:               
                                     PUSH  SI
                                     MOV   SI, CX
                                     MOV   AL,  byte ptr [Bricks_States + SI]
                                     POP   SI
                                     CMP   AL, 0
                                     JNE   D1_Right
                                     JMP   No_Collision_Right
    D1_Right:                        

                                     PUSH  SI
                                     SHL   SI,1

    ;Load AX with Brick_X
                                     MOV   AX, [BP + SI]
                                     POP   SI
                                     PUSH  SI
                                     INC   SI
                                     SHL   SI,1
    ;Load Bx with Brick_Y
                                     MOV   BX, [BP + SI]
                                     POP   SI


                                     MOV   DX,Ball_X_Left
                                     ADD   DX,Ball_Size
                                     CMP   DX ,Ax
                                     JGE   D2_Right
                                     JMP   No_Collision_Right

    D2_Right:                        

                                    
                                     MOV   DX, AX
                                     ADD   DX, Brick_Height
                                     CMP   Ball_X_Left, DX
                                     JNL   No_Collision_Right

                                     MOV   DX,Ball_Y_Left
                                     ADD   DX,Ball_Size
                                     CMP   DX ,BX
                                     JNG   No_Collision_Right

                                     MOV   DX, BX
                                     ADD   DX, Brick_Width
                                     CMP   Ball_Y_Left,DX
                                     JNL   No_Collision_Right

    ;Multiply AX (y) * 320 + BX (x)
                                     PUSH  BX
                                     MOV   BX, 320
                                     PUSH  DX
                                     MUL   BX
                                     POP   DX
                                     POP   BX
                                     ADD   AX, BX
                                     MOV   DI, AX
                                     MOV   AL, 0


                                     PUSH  SI                                      ;Draw Rect
                                     PUSH  DX
                                     MOV   SI,Brick_Width
                                     MOV   DX,Brick_Height
                                     PUSH  CX
                                     CALL  Draw_Single_Rect
                                     POP   CX
                                     POP   DX
                                     POP   SI                                      ;After Draw single rect

                                     NEG   Ball_Velocity_X2
                                     INC   SCORE_COUNT_PLAYER_2

                                     PUSHF
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX

    ; MAKE COLLISION SOUND
                                     CALL  START_COLLISION_SOUND
                    
    ; MOV   Di, 0
    ; mov   si, 320
    ; MOV   AL, 000
    ; MOV   DX,10

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                        
    
    ; CALL  Draw_Single_Rect

                                     CALL  Draw_Score_right

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                        

    ;  CALL  DRAW_SCORE

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     POPF

                                     PUSH  SI
                                     MOV   SI,CX
                                     MOV   byte ptr [Bricks_States + SI], 0
                                     POP   SI

    No_Collision_Right:              
                                     INC   CX
                                     ADD   SI, 2

                                     CMP   SI, 64
                                     JGE   DUMMY11
                                     JMP   Bricks_Loop_Right

    DUMMY11:                         

                                     POP   SI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

                                     RET
                                     ENDP  Bricks_Collision_Right


Bricks_Collision_Left PROC
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  SI

                                     XOR   SI, SI
                                     XOR   CX, CX
                                     MOV   BP, OFFSET Bricks_Positions

    Bricks_Loop_left:                
                                     PUSH  SI
                                     MOV   SI, CX
                                     MOV   AL,  byte ptr [Bricks_States + SI]
                                     POP   SI
                                     CMP   AL, 0
                                     JNE   D1_Left
                                     JMP   No_Collision_Left
    D1_Left:                         

                                     PUSH  SI
                                     SHL   SI,1

    ;Load AX with Brick_X
                                     MOV   AX, [BP + SI]
                                     POP   SI
                                     PUSH  SI
                                     INC   SI
                                     SHL   SI,1
    ;Load Bx with Brick_Y
                                     MOV   BX, [BP + SI]
                                     POP   SI


                                     MOV   DX,Ball_X_Right
                                     ADD   DX,Ball_Size
                                     CMP   DX ,Ax
                                     JGE   D2_Left
                                     JMP   No_Collision_Left

    D2_Left:                         

                                    
                                     MOV   DX, AX
                                     ADD   DX, Brick_Height
                                     CMP   Ball_X_Right, DX
                                     JNL   No_Collision_Left

                                     MOV   DX,Ball_Y_Right
                                     ADD   DX,Ball_Size
                                     CMP   DX ,BX
                                     JNG   No_Collision_Left

                                     MOV   DX, BX
                                     ADD   DX, Brick_Width
                                     CMP   Ball_Y_Right,DX
                                     JNL   No_Collision_Left

    ;Multiply AX (y) * 320 + BX (x)
                                     PUSH  BX
                                     MOV   BX, 320
                                     PUSH  DX
                                     MUL   BX
                                     POP   DX
                                     POP   BX
                                     ADD   AX, BX
                                     MOV   DI, AX
                                     MOV   AL, 0


                                     PUSH  SI                                      ;Draw Rect
                                     PUSH  DX
                                     MOV   SI,Brick_Width
                                     MOV   DX,Brick_Height
                                     PUSH  CX
                                     CALL  Draw_Single_Rect
                                     POP   CX
                                     POP   DX
                                     POP   SI                                      ;After Draw single rect

                                     NEG   Ball_Velocity_X1
                                     INC   SCORE_COUNT

                                     PUSHF
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX

    ; MAKE COLLISION SOUND
                                     CALL  START_COLLISION_SOUND
                    
    ; MOV   Di, 0
    ; mov   si, 320
    ; MOV   AL, 000
    ; MOV   DX,10

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                        
    
    ; CALL  Draw_Single_Rect

                                     CALL  Draw_Score

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                        

    ;  CALL  DRAW_SCORE

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     POPF

                                     PUSH  SI
                                     MOV   SI,CX
                                     MOV   byte ptr [Bricks_States + SI], 0
                                     POP   SI

    No_Collision_Left:               
                                     INC   CX
                                     ADD   SI, 2

                                     CMP   SI, 64
                                     JGE   DUMMY10
                                     JMP   Bricks_Loop_left

    DUMMY10:                         

                                     POP   SI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

                                     RET
                                     ENDP  Bricks_Collision_Left



    ;-----------------------------------------------------------------------------------------------------------------------
Clear_Screen PROC
                                     MOV   AH, 0
                                     MOV   AL, 13H
                                     INT   10H
                
    ;  MOV  AH,0BH
                        
    ;  MOV  BH,00
    ;  MOV  BL,00
    ;  INT  10H
                                     RET
                                     ENDP  Clear_Screen

    ;--------------------------------------------------------------------------------------------------------
Bricks_Collision PROC
                  
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     PUSH  SI

                                     XOR   SI, SI
                                     XOR   CX, CX
                                     MOV   BP, OFFSET Bricks_Positions

    Bricks_Loop:                     
                                     PUSH  SI
                                     MOV   SI, CX
                                     MOV   AL,  byte ptr [Bricks_States + SI]
                                     POP   SI
                                     CMP   AL, 0
                                     JNE   D1
                                     JMP   No_Collision
    D1:                              

                                     PUSH  SI
                                     SHL   SI,1

    ;Load AX with Brick_X
                                     MOV   AX, [BP + SI]
                                     POP   SI
                                     PUSH  SI
                                     INC   SI
                                     SHL   SI,1
    ;Load Bx with Brick_Y
                                     MOV   BX, [BP + SI]
                                     POP   SI
                      


                                     MOV   DX,Ball_X
                                     ADD   DX,Ball_Size
                                     CMP   DX ,Ax
                                     JGE   D2
                                     JMP   No_Collision

    D2:                              

                                    
                                     MOV   DX, AX
                                     ADD   DX, Brick_Height
                                     CMP   Ball_X, DX
                                     JL    KK
                                     JMP   No_Collision
    KK:                              


                                     MOV   DX,Ball_Y
                                     ADD   DX,Ball_Size
                                     CMP   DX ,BX
                                     JG    DUMMY229
                                     JMP   No_Collision
    DUMMY229:                        
                                     MOV   DX, BX
                                     ADD   DX, Brick_Width
                                     CMP   Ball_Y,DX
                                     JL    DUMMY999
                                     JMP   No_Collision

    DUMMY999:                        
    ;This  causes a problem
                                     PUSH  SI
                                     MOV   SI, CX
                                     PUSH  DX
                                     MOV   DL,  byte ptr [Bricks_States + SI]
                                     CMP   DL, 1
                                     POP   DX
                                     POP   SI
                                     JNE   SKIP_DRAW_BLACK_BRICK
                                    
    ;Multiply AX (y) * 320 + BX (x)
                                     PUSH  BX
                                     MOV   BX, 320
                                     PUSH  DX
                                     MUL   BX
                                     POP   DX
                                     POP   BX
                                     ADD   AX, BX
                                     MOV   DI, AX
                                     MOV   AL, 0


                                     PUSH  SI                                      ;Draw Rect
                                     PUSH  DX
                                     MOV   SI,Brick_Width
                                     MOV   DX,Brick_Height
                                     PUSH  CX
                                     CALL  Draw_Single_Rect
                                     POP   CX
                                     POP   DX
                                     POP   SI                                      ;After Draw single rect
    SKIP_DRAW_BLACK_BRICK:           
                                     NEG   Ball_Velocity_X
                                     INC   SCORE_COUNT

                                     PUSHF
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     
                                     CMP   GIFT_TIME, 0
                                     JNE   NEVER_MIND
                                     MOV   GIFT_STATUS, 1D
                                     MOV   GIFT_TIME, 3D
                                     INC   PADDLE_COLOR
                                     ADD   PADDLE_SPEED, 1D
                                     INC   Ball_Velocity_X


    NEVER_MIND:                      
                                     DEC   GIFT_TIME

    ; MAKE COLLISION SOUND
                                     CALL  START_COLLISION_SOUND
                    
    ; MOV   Di, 0
    ; mov   si, 320
    ; MOV   AL, 000
    ; MOV   DX,10

                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                        
    
    ; CALL  Draw_Single_Rect

                                     CALL  Draw_Score

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                        

    ;  CALL  DRAW_SCORE

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     POPF

                                     PUSH  SI
                                     PUSH  AX
                                     MOV   SI,CX
                                     MOV   AL, byte ptr [Bricks_States + SI]
                                     DEC   AL
                                     MOV   byte ptr [Bricks_States + SI], AL
                                     POP   AX
                                     POP   SI

    No_Collision:                    
                                     INC   CX
                                     ADD   SI, 2

                                     CMP   SI, 64
                                     JGE   DUMMY
                                     JMP   Bricks_Loop

    DUMMY:                           

                                     POP   SI
                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

                                     RET
                                     ENDP  Bricks_Collision


    ;---------------------------------------------------------------------------------------------------------------

DRAW_SCORES proc
                                     push  dx
                                     push  ax
                 
    ; mov   dh, 23                                  ;row
    ; mov   dl, 5                                   ;col
    ; mov   ah, 2
    ; int   10h
    
    ; lea   dx, SCORE
    ; mov   ah, 9
    ; int   21h
                                     LEA   DX, SCORE_STRING
                                     MOV   AH, 9
                                     INT   21H
    
    ; lea   dx,LIVES
    ; mov   ah,9
    ; int   21h

                                     pop   ax
                                     pop   dx
                                     ret
DRAW_SCORES endp

    ;---------------------------------------------------------------------------------------------------------------
printScore proc
                                     push  ax
                                     push  bx
                                     push  cx
                                     push  dx
    
                                     mov   cx,0
    
                                     mov   ax,SCORE_COUNT
    ll:                              
                                     mov   bx,10
                                     mov   dx,0
                                     div   bx
                                     push  dx
                                     inc   cx
                                     cmp   ax,0
                                     jne   ll
    
    l2:                              
                                     pop   dx
                                     mov   ah,2
                                     MOV   DL, '-'
                                     int   21h
                                     loop  l2
    
                                     pop   dx
                                     pop   cx
                                     pop   bx
                                     pop   ax
    
                                     ret
printScore endp

START_COLLISION_SOUND PROC
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX

                                     MOV   AL, 182
                                     OUT   43H, AL
                                     MOV   AX, 400

                                     OUT   42H, AL
                                     MOV   AL, AH
                                     OUT   42H, AL
                                     IN    AL, 61H

                                     OR    AL, 3
                                     OUT   61H, AL
                                     MOV   BX, 2

    PAUSE1:                          
                                     MOV   CX, 65535
    PAUSE2:                          
                                     DEC   CX
                                     JNZ   PAUSE2
                                     DEC   BX
                                     JNZ   PAUSE1
                                     IN    AL, 61H
                                     AND   AL, 11111100b
                                     OUT   61H, AL

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX
                                     RET
START_COLLISION_SOUND ENDP

    ;---------------------------------------------------------------------------------------------------------------
END MAIN