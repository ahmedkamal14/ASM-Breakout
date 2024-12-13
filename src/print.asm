; This File contains functions related to Printing

PUBLIC DRAW_SCORES

EXTRN SCORE
EXTRN LIVES
EXTRN ENDING
EXTRN SCORE_COUNT
EXTRN LIVES_COUNT

.MODEL SMALL
.STACK 100H

.CODE

DRAW_SCORES PROC
                push dx
                push CX
                push bx
                push ax
                 
                mov  dh, 23           ;row
                mov  dl, 20            ;col
                mov  ah, 2
                int  10h
    
                lea  dx, SCORE
                mov  ah, 9
                int  21h
    
                CALL PRINT_SCORE
    
                lea  dx,LIVES
                mov  ah,9
                int  21h

                pop  ax
                pop  BX
                pop  CX
                pop  dx
                ret
DRAW_SCORES ENDP


PRINT_SCORE PROC
                push ax
                push bx
                push cx
                push dx
    
                mov  cx,0
    
                mov  ax,SCORE_COUNT
    ll:         
                mov  bx,10
                mov  dx,0
                div  bx
                push dx
                inc  cx
                cmp  ax,0
                jne  ll
    
    l2:         
                pop  dx
                mov  ah,2
                add  dl,'0'
                int  21h
                loop l2
    
                pop  dx
                pop  cx
                pop  bx
                pop  ax
    
                ret
PRINT_SCORE ENDP

END DRAW_SCORES