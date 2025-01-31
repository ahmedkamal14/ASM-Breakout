EXTRN START_CHAT: FAR
EXTRN START_ONE_PLAYER: FAR



.model small
.stack 100h

.data
    string1 db 'CHAT MODE => 1.', 13, 10, '$'
    string2 db 'ONE PLAYER MODE => 2.', 13, 10, '$'
    string3 db 'TWO PLAYERS MODE => 3.', 13, 10, '$'
    string4 db 'Exit => Esc.', 13, 10, '$'

.code
main proc
    ; Initialize the data segment
                    mov  ax, @data
                    mov  ds, ax


    Options_page:   
    ; Clear the screen
                    mov  ah, 06h             ; Scroll up function
                    mov  al, 0               ; Clear entire screen
                    mov  bh, 07h             ; Page and attribute (white text on black background)
                    mov  cx, 0               ; Upper-left corner (row=0, col=0)
                    mov  dx, 184Fh           ; Bottom-right corner (row=24, col=79)
                    int  10h                 ; BIOS video interrupt

    ; Center and display the first string
                    mov  ah, 02h             ; Set cursor position
                    mov  bh, 0               ; Video page
                    mov  dh, 10              ; Row (approximately 10 for the first string)
                    mov  dl, 32              ; Column (approximately 32 for horizontal centering)
                    int  10h                 ; BIOS video interrupt

                    lea  dx, string1         ; Load the first string address
                    mov  ah, 09h             ; Print the string
                    int  21h                 ; DOS interrupt

    ; Center and display the second string
                    mov  ah, 02h             ; Set cursor position
                    mov  bh, 0               ; Video page
                    mov  dh, 12              ; Row (approximately 12 for the second string)
                    mov  dl, 30              ; Column (approximately 30 for horizontal centering)
                    int  10h                 ; BIOS video interrupt

                    lea  dx, string2         ; Load the second string address
                    mov  ah, 09h             ; Print the string
                    int  21h                 ; DOS interrupt

    ; Center and display the third string
                    mov  ah, 02h             ; Set cursor position
                    mov  bh, 0               ; Video page
                    mov  dh, 14              ; Row (approximately 14 for the third string)
                    mov  dl, 29              ; Column (approximately 29 for horizontal centering)
                    int  10h                 ; BIOS video interrupt

                    lea  dx, string3         ; Load the third string address
                    mov  ah, 09h             ; Print the string
                    int  21h                 ; DOS interrupt

    ; Center and display the 4th string
                    mov  ah, 02h             ; Set cursor position
                    mov  bh, 0               ; Video page
                    mov  dh, 16              ; Row (approximately 14 for the third string)
                    mov  dl, 29              ; Column (approximately 29 for horizontal centering)
                    int  10h                 ; BIOS video interrupt

                    lea  dx, string4         ; Load the third string address
                    mov  ah, 09h             ; Print the string
                    int  21h                 ; DOS interrupt
    ;   JMP CONT
    ;DUMMY:
    ;JMP Options_page
    ;CONT:

    ; Wait for a key press
                    mov  ah, 0h              ; Keyboard interrupt
                    int  16h                 ; DOS interrupt

    ; CHECK THE KEY ENTERED Esc
                    cmp  al, 27D             ; ASCII value for escape key
                    jz   exit_program

    ;CHECK IF NUMBER 2 IS PRESSED
                    cmp  al, 32h             ; ASCII value for 'f2'
                    JE   one_player_mode

    ; CHECK THE KEY ENTERED 1
                    cmp  al, 31h             ; ASCII value for '1'
                    JE   chat_mode


    ; CHECK THE KEY ENTERED 3
                    cmp  al, 33h             ; ASCII value for 'f3'
                    JE   two_player_mode

                    JMP  Options_page



    
    ; Switch to one player mode
    one_player_mode:
                    call START_ONE_PLAYER
                    JMP  Options_page

    ; Switch to chat mode
    chat_mode:      
                    call Start_Chat
                    JMP  Options_page

    ; Switch to two player mode
    two_player_mode:
                    JMP  Options_page

    ; Exit the program
    exit_program:   
                    mov  ah, 4Ch
                    int  21h
main endp
end main
