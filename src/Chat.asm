PUBLIC START_CHAT


.MODEL small
.STACK 100h
.data
    sendMessage    DB 'Serial communication: Send one byte', 0Ah, 0Dh, '$'
    INITIALMESSAGE DB 'CHAT IS ON', 0Ah, 0Dh, '$'
    receiveMessage DB 'Receiver on, press ESC to end session', 0Ah, 0Dh, '$'
    inputPrompt    DB 'MESSAGE: ', 0Ah, 0Dh, '$'
    goodbyeMessage DB ' Goodbye!', 0Ah, 0Dh, '$'
    receivedValue  DB 2 dup('$')                                                ; Buffer to store the received character and null-terminate
    inData         DB 30, ?, 30 dup('$')
    emptyStr       DB 10, 13, '$'
    ReceivedSTRING DB 10, 13, 'Receiving:  ', '$'
    SendingString  DB 10, 13,'Sending: ', '$'
    sendFLAG       DB 0
    recFLAG        DB 0

.code
START_CHAT PROC
                  mov  ax, @data
                  mov  ds, ax

    ; CLEAR SCREEN
                  mov  ah, 06h
                  mov  al, 0
                  mov  bh, 07h
                  mov  cx, 0
                  mov  dx, 184Fh
                  int  10h

    ; MOVE CURSOR TO 0, 0
                  mov  ah, 02h
                  mov  bh, 0
                  mov  dh, 0
                  mov  dl, 0
                  int  10h

    ; Display the initial message
                  mov  ah, 09h
                  lea  dx, INITIALMESSAGE
                  int  21h

    ; DISPLAY ENTER YOUR STRING MESSAGE
                  mov  ah, 09h
                  lea  dx, inputPrompt
                  int  21h

    ; Initialize COM port
    ; Set Divisor Latch Access Bit
                  mov  dx, 3FBh                ; Line Control Register
                  mov  al, 10000000b           ; Set Divisor Latch Access Bit
                  out  dx, al

    ; Set LSB byte of the Baud Rate Divisor Latch register
                  mov  dx, 3F8h
                  mov  al, 0Ch
                  out  dx, al

    ; Set MSB byte of the Baud Rate Divisor Latch register
                  mov  dx, 3F9h
                  mov  al, 00h
                  out  dx, al

    ; Set port configuration
                  mov  dx, 3FBh
                  mov  al, 00011011b
                  out  dx, al

    MAIN_LOOP:    
    ; Check if key is pressed
                  mov  ah, 01h
                  int  16h
                  jz   CHECK_UART              ; If no key is pressed, check UART for incoming data

                  CMP  sendFLAG, 0
                  JNE  SEND

    ; get cursor pos and store it in bx
                  mov  ah, 03h
                  mov  bh, 0
                  int  10h
                  push dx

    ; move cursor one row down
                  mov  ah, 2
                  add  dh, 1
                  mov  dl, 0
                  int  10h

    ; display a letter 8 times in green
                  mov  ah, 9
                  mov  bh, 0
                  mov  al, 44h
                  mov  cx, 8
                  mov  bl, 00AH
                  int  10h

                  pop  dx
    ; move cursor to dx
                  mov  ah, 02h
                  int  10H


                  mov  ah, 09h
                  lea  dx, SendingString
                  int  21h
                  
                  MOV  sendFLAG, 1

    SEND:         
    ; Key is pressed, read it
                  mov  ah, 00h
                  int  16h
                  mov  ah, 02h
                  mov  dl, al
                  int  21h                     ; Display the key
                  MOV  AH, AL

                  CMP  AH, 0Dh
                  JNE  SENDUART

    ; IF ENTER IS PRESSED DISPLAY NEW LINE AND RESET FLAGS
                  MOV  recFLAG, 0
                  MOV  sendFLAG, 0

    ; DISPLAY NEW LINE
                  mov  ah, 09h
                  lea  dx, emptyStr
                  int  21h

                  jmp  MAIN_LOOP               ; Go back to the main loop

    SENDUART:     

    ; Check that Transmitter Holding Register is empty
                  mov  dx, 3FDh                ; Line Status Register
    WAIT_TRANSMIT:
                  in   al, dx                  ; Read Line Status
                  and  al, 00100000b
                  jz   WAIT_TRANSMIT

    ; Transmit the value
                  mov  dx, 3F8h                ; Transmit Data Register
                  mov  al, AH
                  out  dx, al

    ; Exit if ESC key is pressed
                  cmp  al, 1Bh
                  je   EXIT

    CHECK_UART:   
    ; ; Check if data is ready to be received from UART
                  mov  dx, 3FDh                ; Line Status Register
                  in   al, dx
                  and  al, 01h
                  jz   MAIN_LOOP               ; If no data, go back to the main loop

    ; DISPLAY RECEIVED STRING
                  CMP  recFLAG, 0
                  JNE  CONT

                  mov  ah, 03h
                  mov  bh, 0
                  int  10h
                  push dx

    ; move cursor one row down
                  mov  ah, 2
                  add  dh, 1
                  mov  dl, 0
                  int  10h

    ; display a letter 8 times in green
                  mov  ah, 9
                  mov  bh, 0
                  mov  al, 44h
                  mov  cx, 10
                  mov  bl, 00CH
                  int  10h

                  pop  dx
    ; move cursor to dx
                  mov  ah, 02h
                  int  10H


                  mov  ah, 09h
                  lea  dx, ReceivedSTRING
                  int  21h
                  MOV  recFLAG, 1

    CONT:         
    ; Data is ready, read it
                  mov  dx, 3F8h                ; Receive Data Register
                  in   al, dx
                  mov  receivedValue, al
                  mov  receivedValue+1, '$'    ; Null-terminate the string for display

    ; Exit if received value is ESC
                  cmp  al, 1Bh
                  je   EXIT

    ; IF ENTER IS PRESSED DISPLAY NEW LINE AND RESET FLAGS
                  cmp  AL, 0Dh
                  je   ENTERPRESSED

    ; Display the received value
                  mov  ah, 09h
                  lea  dx, receivedValue
                  int  21h

                  jmp  MAIN_LOOP               ; Go back to the main loop

    ENTERPRESSED: 
                  MOV  recFLAG, 0
                  MOV  sendFLAG, 0

    ; DISPLAY NEW LINE
                  mov  ah, 09h
                  lea  dx, emptyStr
                  int  21h

                  jmp  MAIN_LOOP               ; Go back to the main loop

    EXIT:         
    ; clear the screen
                  mov  ah, 06h
                  mov  al, 0
                  mov  bh, 07h
                  mov  cx, 0
                  mov  dx, 184Fh
                  int  10h

    ; MOVE CURSOR TO CENTER
                  mov  ah, 02h
                  mov  bh, 0
                  mov  dh, 12
                  mov  dl, 20
                  int  10h

    ; Display goodbye message
                  mov  ah, 09h
                  lea  dx, goodbyeMessage
                  int  21h


                  RET
START_CHAT ENDP
END START_CHAT