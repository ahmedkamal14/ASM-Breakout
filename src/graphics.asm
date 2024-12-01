PUBLIC Draw_Single_Rect
EXTRN PADDLE_X
EXTRN PADDLE_Y
EXTRN PADDLE_WIDTH
EXTRN PADDLE_HEIGHT
EXTRN PADDLE_COLOR:BYTE

.model small
.stack 100h
.code




Draw_Single_Rect proc
    ;summary:
    ;di=> pixle number
    ;dx=> hieght
    ;cx=> width
    ;al=> color
    ;  MOV AX, @DATA
    ;  MOV DS, AX
                     
        
    ;  mov ax,0A000h
    ;  mov es,ax
    ;  mov ah,0
    ;  mov al,13h
    ;  int 10h
    ; mov dx, 10d
    ; mov di, 650d
    ; STORE THE VALUE OF  PADDLE_X IN AX THEN MULTIPLY IT BY 320 AND THEN ADD PADDLE_Y THEN STORE IT IN DI
                     MOV AX, PADDLE_X
                     MOV DX, 320
                     MUL DX
                     ADD AX, PADDLE_Y
                     MOV DI, AX


                     MOV DX, PADDLE_HEIGHT
                     mov si, PADDLE_WIDTH
    ;  MOV DI, PADDLE_X * 320 + PADDLE_Y
                     MOV AL, PADDLE_COLOR
    DRAW_IN_ROW:     
                     mov bx, di
                     MOV AL, PADDLE_COLOR
    ;mov al,0eh
    ;mov cx,18
                     mov cx, si
                     rep stosb
                     mov di, bx
                     add di, 320d
                     dec dx
                     jnz DRAW_IN_ROW
Draw_Single_Rect endp
end Draw_Single_Rect
