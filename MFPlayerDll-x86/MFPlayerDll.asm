;==============================================================================
;
; MFPlayer x86 DLL
;
; http://github.com/mrfearless
;
; This software is provided 'as-is', without any express or implied warranty. 
; In no event will the author be held liable for any damages arising from the 
; use of this software.
;
;==============================================================================
;
; MFPlayer Library consists of functions that wrap the MFPlay COM 
; implementation of the IMFPMediaPlayer and IMFPMediaItem objects. MFPlay is a 
; Microsoft Media Foundation API for creating media playback applications. Thus 
; the MFPlayer Library functions hide the complexities of interacting with the 
; COM objects.
;
;-------------------------------------------------------------------------------
.686
.MMX
.XMM
.model flat,stdcall
option casemap:none

include windows.inc

include user32.inc
includelib user32.lib

include kernel32.inc
includelib kernel32.lib

IFNDEF MFPCreateMediaPlayer
MFPCreateMediaPlayer PROTO pwszURL:DWORD, fStartPlayback:DWORD, creationOptions:DWORD, pCallback:DWORD, hWnd:DWORD, ppMediaPlayer:DWORD
ENDIF

includelib MFPlay.lib

;--------------------------------------
; Conditionals
;--------------------------------------
MFPLAYER_DLL EQU 1

;--------------------------------------
; Main Include File
;--------------------------------------
Include .\..\MFPlayer.inc

;--------------------------------------
; Main Library Files
;--------------------------------------
Include .\..\MFPlayer.asm


.CODE

;==============================================================================
; Main entry function for a DLL file  - required.
;------------------------------------------------------------------------------
DllEntry PROC hInst:HINSTANCE, reason:DWORD, reserved:DWORD
    .IF reason == DLL_PROCESS_ATTACH
        
    .ENDIF
    mov eax, TRUE
    ret
DllEntry ENDP

END DllEntry

