.model small
.stack 100h

.code




Draw_Single_Rect proc
    ;summary:
    ;di=> pixle number
    ;dx=> hieght
    ;cx=> width
    ;al=> color
                     
        
    ;mov ax,0A000h
    ;mov es,ax
    ;mov ah,0
    ;mov al,13h
    ;int 10h
    ;mov dx, 10d
    ;mov di, 650d
                     
                     
                     mov si,cx
    DRAW_IN_ROW:     
                     mov bx, di
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
