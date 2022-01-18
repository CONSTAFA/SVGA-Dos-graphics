; Memory Mapped Graphics, Mode 13           (Mode13.asm)
.model small

.data
saveMode db ?

.code
main:
mov ax,@data
mov ds,ax

call    SetVideoMode
call    Draw_Some_Pixels
call    RestoreVideoMode

;-----------------------------------------------
SetVideoMode PROC
; Saves the current video mode, switches to a
; new mode, and points ES to the video segment.
;-----------------------------------------------
mov ah,0fh
int 10h
mov saveMode,al ; save it
mov ah,4fh ;SET_VIDEO_MODE (SVGA)
mov al,02h  ;MODE_13  ; to mode 13h
mov bx,10fh ;320X200
int 10h

push 0A000h  ; video segment address
pop es             ; ES points to video segment
ret
SetVideoMode ENDP

;---------------------------------------------
RestoreVideoMode PROC
; Waits for a key to be pressed and restores
; the video mode to its original value.
;----------------------------------------------
    mov ah,10h
    int 16h
    mov ah,0   ; reset video mode
    mov al,saveMode         ; to saved mode
    int 10h
    ret
RestoreVideoMode ENDP

;-----------------------------------------------
Draw_Some_Pixels PROC
;
; Sets individual palette colors and draws 
; several pixels.
;------------------------------------------------

; Change the color at index 1 to white (63,63,63).
    
mov dx,3c8h
mov al,1        ; set palette index 1
out dx,al

mov dx,3c9h
mov al,175  ; red
out dx,al
mov al,255  ; green
out dx,al
mov al,255   ; blue
out dx,al

mov cx,65535   ; draw 10 pixels
mov ax,0   ; AX contains buffer offset
mov di,ax
DP1:
mov word ptr es:[di],ax
inc ax
inc di
;add di,5     ; move 5 pixels to the right
loop DP1
ret
Draw_Some_Pixels ENDP
END main