;==============================================================================
;
; MFPlayer x64 DLL
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
.x64

option casemap : none
option win64 : 11
option frame : auto

includelib user32.lib
includelib kernel32.lib
includelib MFPlay.lib

IFNDEF MFPCreateMediaPlayer
MFPCreateMediaPlayer PROTO pwszURL:QWORD, fStartPlayback:QWORD, creationOptions:QWORD, pCallback:QWORD, hWnd:QWORD, ppMediaPlayer:QWORD
ENDIF

DLL_PROCESS_ATTACH	EQU	1
DLL_THREAD_ATTACH	EQU	2
DLL_THREAD_DETACH	EQU	3
DLL_PROCESS_DETACH	EQU	0
DLL_PROCESS_VERIFIER	EQU	4

FALSE	EQU	0
TRUE	EQU	1

HINSTANCE  typedef ptr
LPVOID  typedef ptr

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

;=====================================================================================
; Main entry function for a DLL file  - required.
;-------------------------------------------------------------------------------------
DllMain PROC hinstDLL:HINSTANCE, fdwReason:DWORD, lpvReserved:LPVOID
    .IF fdwReason == DLL_PROCESS_ATTACH
        
    .ENDIF
    mov rax, TRUE
    ret
DllMain ENDP

END DllMain
