.MODEL small
.STACK 600H
.DATA
    ; PADDLE DATA
    PADDLE_X             DW  180
    PADDLE_Y             DW  140
    PADDLE_WIDTH         DW  40
    PADDLE_HEIGHT        DW  6
    PADDLE_COLOR         DB  8
    PADDLE_SPEED         DW  6

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
    BORDER_MIDDLE        EQU 161

    ; NEEDED COLORS
    BLACK                DB  0
    WHITE                DB  15

    ; BALL DATA
    Ball_X               DW  160
    Ball_Y               DW  158
    Ball_X_Right         DW  120
    Ball_Y_Right         DW  140
    Ball_X_Left          DW  160
    Ball_Y_Left          DW  170
    Ball_Size            DW  3
    Ball_Velocity_X      DW  4
    Ball_Velocity_Y      DW  4
    Prev_Time            DB  0
    BALL_COLOR           DB  0

    ; TWO PLAYER VELOCITY
    Ball_Velocity_X1     DW  4
    Ball_Velocity_Y1     DW  4
    Ball_Velocity_X2     DW  4
    Ball_Velocity_Y2     DW  4

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

    FRAME_DELAY          EQU 64

    ; MAIN VARS
    string1              db  'CHAT MODE => 1.', 13, 10, '$'
    string2              db  'ONE PLAYER MODE => 2.', 13, 10, '$'
    string3              db  'TWO PLAYERS MODE => 3.', 13, 10, '$'
    string4              db  'Exit => Esc.', 13, 10, '$'

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

    ; ESCAPE STATUS
    ESCSTATUS            DB  0


    ; SCORE STRING
    SCORE_STRING         DB  '-$'

    ; Two Player Mode
    PADDLE_X1            DW  180
    PADDLE_Y1            DW  60

    PADDLE_X2            DW  180
    PADDLE_Y2            DW  225

    PADDLE_COLOR1        DB  8
    PADDLE_COLOR2        DB  8


.CODE

MAIN proc far
    ; Initialize the data segment
                                     mov   ax, @data
                                     mov   ds, ax

                                     MOV   ESCSTATUS, 0
    ;INTIALIZE BALL  POSITION AND ITS VELOCITY
                                     MOV   Ball_X, 160
                                     MOV   Ball_Y, 158
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
                                     mov   receivedValue, al
                                     mov   receivedValue+1, '$'                    ; Null-terminate the string for display

    ; Exit if received value is ESC
                                     cmp   al, 1Bh
                                     je    EXIT

    ; IF ENTER IS PRESSED DISPLAY NEW LINE AND RESET FLAGS
                                     cmp   AL, 0Dh
                                     je    ENTERPRESSED

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

    ; INITIALIZE DATA SEGMENT
    ; MOV   AX, @DATA
    ; MOV   DS, AX

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


    ; loop on the bricks states and set them to 1
                                     MOV   SI, 0
                                     MOV   CX, 40
    Set_Bricks_States:               
                                     MOV   byte ptr [Bricks_States + SI], 1
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
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     CALL  INPUT_MAIN_LOOP

                                     CMP   ESCSTATUS, 0
                                     JNE   EXIT_MODE

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

    ; Update the paddle position
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

    ; RETURN CONTROL TO OPERATING SYSTEM
    ; MOV   AH, 4CH
    ; INT   21H
                                     CALL  MAIN
START_ONE_PLAYER ENDP

START_TWO_PLAYER PROC

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
                                     mov   di, 161                                 ; Starting position in video memory (DI = 159)
                                     mov   dx, di                                  ; Save the initial position in DX
                                     mov   cx, 200                                 ; Length of the vertical line
                                     mov   al, 0FH                                 ; Pixel color (e.g., 2)
    
    vert:                            
                                     stosb                                         ; Write AL (color) to memory at DI
                                     mov   di, dx                                  ; Restore DI to the starting position
                                     add   di, 320                                 ; Move to the next row (320 bytes down)
                                     mov   dx, di                                  ; Save new starting position for the next iteration
                                     dec   cx                                      ; Decrement the line counter
                                     jnz   vert                                    ; Repeat until CX = 0

                                     call  Draw_Score_Container
                                     call  Draw_Score_Container_right


    ; INITIALIZATIONS
                                    

                                     MOV   ESCSTATUS, 0
                                     MOV   SCORE_COUNT_PLAYER_2, 0

                                     MOV   Ball_X_Right , 120
                                     MOV   Ball_Y_Right , 140
                                     MOV   Ball_X_Left , 160
                                     MOV   Ball_Y_Left , 170
                                    
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
                                     MOV   Brick_Width, 30
                                     MOV   Gap_X, 11
                                     MOV   Gap_Y, 5
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
                                     PUSH  AX
                                     PUSH  BX
                                     PUSH  CX
                                     PUSH  DX
                                     CALL  INPUT_TWO_PLAYER

                                     CMP   ESCSTATUS, 0
                                     JNE   EXIT_MODE_TWO_PLAYER

                                     POP   DX
                                     POP   CX
                                     POP   BX
                                     POP   AX

    ; Handle ball movement and collision
                                     CALL  Draw_Black_Ball_Right
                                     CALL  Move_Ball_Two_Player_Left
                                     CALL  Draw_Ball_Right

                                     CALL  Draw_Black_Ball_Left
                                     CALL  Move_Ball_Two_Player_Right
                                     CALL  Draw_Ball_Left

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

                                     CALL  MAIN

                                     RET
START_TWO_PLAYER ENDP

INPUT_TWO_PLAYER PROC
    ; CHECK IF A KEY IS PRESSED
                                     MOV   AH, 01H
                                     INT   16H
                                     JNZ   DUMMY5
                                     JMP   TWO_PLAYER_EXIT
    DUMMY5:                          

    ; FETCH THE KEY DETAILS
                                     MOV   AH, 00H
                                     INT   16H

    ; HANDLE LEFT ARROW KEY
                                     CMP   AH, 4BH
                                     JE    PLAYER_1_MOVE_LEFTT

    ; HANDLE RIGHT ARROW KEY
                                     CMP   AH, 4DH
                                     JE    PLAYER_1_MOVE_RIGHTT

    ; HANDLE UP ARROW KEY
                                     CMP   AL, 31H
                                     JE    PLAYER_2_MOVE_LEFTT

    ; HANDLE DOWN ARROW KEY
                                     CMP   AL, 33H
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
                                     CMP   AX, BORDER_MIDDLE - 1
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
                                     ADD   AX, 0
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, 160

                                     MOV   AL, 0
                          
                                     CALL  Draw_Single_Rect
                                     RET
PLAYER_1_CLEAR_PADDLE ENDP


PLAYER_2_CLEAR_PADDLE PROC
                                     MOV   AX, PADDLE_X2
                                     MOV   DX, 320
                                     MUL   DX
                                     ADD   AX, 163
                                     MOV   DI, AX

                                     MOV   DX, PADDLE_HEIGHT
                                     mov   si, 156

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
                                     mov   di, 610
                                     mov   cx, 26d
                                     rep   stosb

                                     mov   al, 2
                                     mov   di, 2210
                                     mov   cx, 26d
                                     rep   stosb

                                     mov   di, 610                                 ; Starting position in video memory (DI = 325)
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

                                     mov   di, 636                                 ; Starting position in video memory (DI = 325)
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
                                     mov   di, 930
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

    ;GRAPHICS FUNCTIONS-----------------------------------------------------------------------------------------------------
Draw_Single_Rect proc
    ;summary:
    ;di=> pixle number
    ;dx=> hieght
    ;cx=> width
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
                                     ADD   BX, 3
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
                                     CMP   AL, 1
                                     POP   SI
                                     POP   DX
                                     POP   AX
                                     JNE   Skip_Brick

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
                                     MOV   CX,Ball_Y_Right
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
                                     INC   ESCSTATUS
    SKIP:                            
       
                                     MOV   AX,Ball_Velocity_X
                                     ADD   Ball_X,AX
                                     CMP   Ball_X,10
                                     JLE   Neg_Velocity_X                          ;up and down

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
                                     CMP   AX ,PADDLE_X
                                     JNG   STOP

                                     MOV   AX,PADDLE_X
                                     ADD   AX,PADDLE_HEIGHT
                                     CMP   Ball_X,AX
                                     JNL   STOP



                                     MOV   AX,Ball_Y
                                     ADD   AX,Ball_Size
                                     CMP   AX ,PADDLE_Y
                                     JNG   STOP

                                     MOV   AX,PADDLE_Y
                                     ADD   AX,PADDLE_WIDTH
                                     CMP   Ball_Y,AX
                                     JNL   STOP


                                     NEG   Ball_Velocity_X
                                     RET



                   
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
                                     INC   ESCSTATUS
    SKIP_Two_Player:                 
       
                                     MOV   AX,Ball_Velocity_X1
                                     ADD   Ball_X_Right,AX
                                     CMP   Ball_X_Right,10                         ; Instead of zero to maintain score visual appearance
                                     JLE   Neg_Velocity_X_Two_Player               ;up and down

                                     MOV   AX,SCREEN_HEIGHT                        ;End of screen,,not necessary???
                                     CMP   Ball_X_Right,AX
                                     JGE   Neg_Velocity_X_Two_Player               ; up and down


                                     MOV   AX,Ball_Velocity_Y1
                                     ADD   Ball_Y_Right,AX



                                     CMP   Ball_Y_Right,0                          ;Right edge of our screen
                                     JLE   Neg_Velocity_Y_Two_Player
                                     MOV   AX,BORDER_MIDDLE - 5                    ;Middle of sreen
                                     CMP   Ball_Y_Right,AX
                                     JGE   Neg_Velocity_Y_Two_Player

                                     CALL  Bricks_Collision_Left
    ;  RET

                                     MOV   AX,Ball_X_Right
                                     ADD   AX,Ball_Size
                                     CMP   AX ,PADDLE_X1
                                     JNG   STOP_Two_Player

                                     MOV   AX,PADDLE_X1
                                     ADD   AX,PADDLE_HEIGHT
                                     CMP   Ball_X_Right,AX
                                     JNL   STOP_Two_Player



                                     MOV   AX,Ball_Y_Right
                                     ADD   AX,Ball_Size
                                     CMP   AX ,PADDLE_Y1
                                     JNG   STOP_Two_Player

                                     MOV   AX,PADDLE_Y1
                                     ADD   AX,PADDLE_WIDTH
                                     CMP   Ball_Y_Right,AX
                                     JNL   STOP_Two_Player


                                     NEG   Ball_Velocity_X1
                                     RET
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
                                     INC   ESCSTATUS
    SKIP_Two_Player2:                
       
                                     MOV   AX,Ball_Velocity_X2
                                     ADD   Ball_X_Left,AX
                                     CMP   Ball_X_Left,10                          ; Instead of zero to maintain score visual appearance
                                     JLE   Neg_Velocity_X_Two_Player2              ;up and down

                                     MOV   AX,SCREEN_HEIGHT                        ;End of screen,,not necessary???
                                     CMP   Ball_X_Left,AX
                                     JGE   Neg_Velocity_X_Two_Player2              ; up and down


                                     MOV   AX,Ball_Velocity_Y2
                                     ADD   Ball_Y_Left,AX



                                     CMP   Ball_Y_Left,BORDER_MIDDLE + 2           ;COMPARE WITH MIDDLE OF THE SCREEN
                                     JLE   Neg_Velocity_Y_Two_Player2
                                     MOV   AX, 318                                 ;COMPARE WITH THE RIGHT OF THE SCREEN
                                     CMP   Ball_Y_Left,AX
                                     JGE   Neg_Velocity_Y_Two_Player2

                                     CALL  Bricks_Collision_Right
    ;  RET

                                     MOV   AX,Ball_X_Left
                                     ADD   AX,Ball_Size
                                     CMP   AX ,PADDLE_X2
                                     JNG   STOP_Two_Player2

                                     MOV   AX,PADDLE_X2
                                     ADD   AX,PADDLE_HEIGHT
                                     CMP   Ball_X_Left,AX
                                     JNL   STOP_Two_Player2



                                     MOV   AX,Ball_Y_Left
                                     ADD   AX,Ball_Size
                                     CMP   AX ,PADDLE_Y2
                                     JNG   STOP_Two_Player2

                                     MOV   AX,PADDLE_Y2
                                     ADD   AX,PADDLE_WIDTH
                                     CMP   Ball_Y_Left,AX
                                     JNL   STOP_Two_Player2


                                     NEG   Ball_Velocity_X2
                                     RET
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
                                     JNL   No_Collision


                                     MOV   DX,Ball_Y
                                     ADD   DX,Ball_Size
                                     CMP   DX ,BX
                                     JNG   No_Collision

                                     MOV   DX, BX
                                     ADD   DX, Brick_Width
                                     CMP   Ball_Y,DX
                                     JNL   No_Collision
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

                                     NEG   Ball_Velocity_X
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