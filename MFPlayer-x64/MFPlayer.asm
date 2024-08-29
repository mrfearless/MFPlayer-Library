;==============================================================================
;
; MFPlayer x86 Library
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

;DEBUG64 EQU 1
;
;IFDEF DEBUG64
;    PRESERVEXMMREGS equ 1
;    includelib \UASM\lib\x64\Debug64.lib
;    DBG64LIB equ 1
;    DEBUGEXE textequ <'\UASM\bin\DbgWin.exe'>
;    include \UASM\include\debug64.inc
;    .DATA
;    RDBG_DbgWin    DB DEBUGEXE,0
;    .CODE
;ENDIF

includelib user32.lib
includelib kernel32.lib
includelib ole32.lib
includelib shell32.lib

IFNDEF NULL
NULL EQU 0
ENDIF
IFNDEF TRUE
TRUE EQU 1
ENDIF
IFNDEF FALSE
FALSE EQU 0
ENDIF
IFNDEF GlobalAlloc
GlobalAlloc PROTO uFlags:DWORD, qwBytes:QWORD
ENDIF
IFNDEF GlobalFree
GlobalFree PROTO pMem:QWORD
ENDIF
IFNDEF GMEM_FIXED
GMEM_FIXED EQU 0000h
ENDIF
IFNDEF GMEM_ZEROINIT
GMEM_ZEROINIT EQU 0040h
ENDIF
IFNDEF RtlMoveMemory
RtlMoveMemory PROTO Destination:QWORD, Source:QWORD, qwLength:QWORD
ENDIF
IFNDEF lstrlenA
lstrlenA PROTO lpString:QWORD
ENDIF
IFNDEF lstrlenW
lstrlenW PROTO lpString:QWORD
ENDIF
IFNDEF lstrcpyA
lstrcpyA PROTO lpString1:QWORD, lpString2:QWORD
ENDIF
IFNDEF lstrcpyW
lstrcpyW PROTO lpString1:QWORD, lpString2:QWORD
ENDIF
IFNDEF WideCharToMultiByte 
WideCharToMultiByte PROTO CodePage:DWORD, dwFlags:DWORD, lpWideCharStr:QWORD, ccWideChar:DWORD, lpMultiByteStr:QWORD, cbMultiByte:DWORD, lpDefaultChar:QWORD, lpUsedDefaultChar:QWORD
ENDIF
IFNDEF MultiByteToWideChar 
MultiByteToWideChar PROTO CodePage:DWORD, dwFlags:DWORD, lpMultiByteStr:QWORD, cbMultiByte:DWORD, lpWideCharStr:QWORD, ccWideChar:DWORD
ENDIF
IFNDEF CoInitializeEx
CoInitializeEx PROTO pvReserved:QWORD, dwCoInit:DWORD
ENDIF
IFNDEF CoUninitialize
CoUninitialize PROTO
ENDIF
IFNDEF CoCreateInstance
CoCreateInstance PROTO rclsid:QWORD, pUnkOuter:QWORD, dwClsContext:DWORD, riid:QWORD, ppv:QWORD
ENDIF
IFNDEF CoTaskMemFree
CoTaskMemFree PROTO pv:QWORD
ENDIF
IFNDEF SHCreateItemFromParsingName
SHCreateItemFromParsingName PROTO pszPath:QWORD, pbc:QWORD, riid:QWORD, ppv:QWORD
ENDIF
IFNDEF MFPCreateMediaPlayer
MFPCreateMediaPlayer PROTO pwszURL:QWORD, fStartPlayback:QWORD, creationOptions:QWORD, pCallback:QWORD, hWnd:QWORD, ppMediaPlayer:QWORD
ENDIF
IFNDEF ShowWindow
ShowWindow PROTO hWnd:QWORD, nCmdShow:DWORD
ENDIF
IFNDEF SW_HIDE
SW_HIDE EQU 0
ENDIF
IFNDEF SW_NORMAL
SW_NORMAL EQU 1 
ENDIF
IFNDEF SW_SHOWNA
SW_SHOWNA EQU 8
ENDIF

includelib MFPlay.lib

include MFPlayer.inc

;------------------------------------------------------------------------------
; Prototypes for internal use
;------------------------------------------------------------------------------
IMFPMediaPlayerInit             PROTO pMediaPlayer:QWORD
IMFPMediaItemInit               PROTO pMediaItem:QWORD

;_MFP_utoa_ex                    PROTO uvar:QWORD, pbuffer:QWORD
_MFP_utoa_ex                    PROTO qwvalue:QWORD, pbuffer:QWORD ; Habrans http://masm32.com/board/index.php?topic=4174.msg60108#msg60108
_MFP_ConvertStringToAnsi        PROTO lpszWideString:QWORD
_MFP_ConvertStringToWide        PROTO lpszAnsiString:QWORD
_MFP_ConvertStringFree          PROTO lpString:QWORD
_MFP_Convert100NSValueToMSTime  PROTO pvValue:QWORD, pdwMilliseconds:QWORD
_MFP_ConvertMSTimeTo100NSValue  PROTO pvValue:QWORD, dwMilliseconds:DWORD

;------------------------------------------------------------------------------
; COM Prototypes
;------------------------------------------------------------------------------
; IUnknown:
IUnknown_QueryInterface_Proto                    TYPEDEF PROTO pThis:QWORD, riid:QWORD, ppvObject:QWORD
IUnknown_AddRef_Proto                            TYPEDEF PROTO pThis:QWORD
IUnknown_Release_Proto                           TYPEDEF PROTO pThis:QWORD

; IMFPMediaPlayerCallback:
IMFPMediaPlayerCallback_OnMediaPlayerEvent_Proto TYPEDEF PROTO pThis:QWORD, pEventHeader:QWORD

; IMFPMediaPlayer:
IMFPMediaPlayer_Play_Proto                       TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_Pause_Proto                      TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_Stop_Proto                       TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_FrameStep_Proto                  TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_SetPosition_Proto                TYPEDEF PROTO pThis:QWORD, guidPositionType:QWORD, pvPositionValue:QWORD
IMFPMediaPlayer_GetPosition_Proto                TYPEDEF PROTO pThis:QWORD, guidPositionType:QWORD, pvPositionValue:QWORD
IMFPMediaPlayer_GetDuration_Proto                TYPEDEF PROTO pThis:QWORD, guidPositionType:QWORD, pvDurationValue:QWORD
IMFPMediaPlayer_SetRate_Proto                    TYPEDEF PROTO pThis:QWORD, flRate:REAL4
IMFPMediaPlayer_GetRate_Proto                    TYPEDEF PROTO pThis:QWORD, pflRate:QWORD
IMFPMediaPlayer_GetSupportedRates_Proto          TYPEDEF PROTO pThis:QWORD, bForwardDirection:DWORD, pflSlowestRate:QWORD, pflFastestRate:QWORD
IMFPMediaPlayer_GetState_Proto                   TYPEDEF PROTO pThis:QWORD, peState:QWORD
IMFPMediaPlayer_CreateMediaItemFromURL_Proto     TYPEDEF PROTO pThis:QWORD, pwszURL:QWORD, fSync:DWORD, qwUserData:QWORD, ppMediaItem:QWORD
IMFPMediaPlayer_CreateMediaItemFromObject_Proto  TYPEDEF PROTO pThis:QWORD, pIUnknownObj:QWORD, fSync:DWORD, qwUserData:QWORD, ppMediaItem:QWORD
IMFPMediaPlayer_SetMediaItem_Proto               TYPEDEF PROTO pThis:QWORD, pIMFPMediaItem:QWORD
IMFPMediaPlayer_ClearMediaItem_Proto             TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_GetMediaItem_Proto               TYPEDEF PROTO pThis:QWORD, ppIMFPMediaItem:QWORD
IMFPMediaPlayer_GetVolume_Proto                  TYPEDEF PROTO pThis:QWORD, pflVolume:QWORD
IMFPMediaPlayer_SetVolume_Proto                  TYPEDEF PROTO pThis:QWORD, flVolume:REAL4
IMFPMediaPlayer_GetBalance_Proto                 TYPEDEF PROTO pThis:QWORD, pflBalance:QWORD
IMFPMediaPlayer_SetBalance_Proto                 TYPEDEF PROTO pThis:QWORD, flBalance:REAL4
IMFPMediaPlayer_GetMute_Proto                    TYPEDEF PROTO pThis:QWORD, pfMute:QWORD
IMFPMediaPlayer_SetMute_Proto                    TYPEDEF PROTO pThis:QWORD, fMute:DWORD
IMFPMediaPlayer_GetNativeVideoSize_Proto         TYPEDEF PROTO pThis:QWORD, pszVideo:QWORD, pszARVideo:QWORD
IMFPMediaPlayer_GetIdealVideoSize_Proto          TYPEDEF PROTO pThis:QWORD, pszMin:QWORD, pszMax:QWORD
IMFPMediaPlayer_SetVideoSourceRect_Proto         TYPEDEF PROTO pThis:QWORD, pnrcSource:QWORD
IMFPMediaPlayer_GetVideoSourceRect_Proto         TYPEDEF PROTO pThis:QWORD, pnrcSource:QWORD
IMFPMediaPlayer_SetAspectRatioMode_Proto         TYPEDEF PROTO pThis:QWORD, dwAspectRatioMode:DWORD
IMFPMediaPlayer_GetAspectRatioMode_Proto         TYPEDEF PROTO pThis:QWORD, pdwAspectRatioMode:QWORD
IMFPMediaPlayer_GetVideoWindow_Proto             TYPEDEF PROTO pThis:QWORD, phwndVideo:QWORD
IMFPMediaPlayer_UpdateVideo_Proto                TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_SetBorderColor_Proto             TYPEDEF PROTO pThis:QWORD, Color:DWORD
IMFPMediaPlayer_GetBorderColor_Proto             TYPEDEF PROTO pThis:QWORD, pColor:QWORD
IMFPMediaPlayer_InsertEffect_Proto               TYPEDEF PROTO pThis:QWORD, pEffect:QWORD, fOptional:DWORD
IMFPMediaPlayer_RemoveEffect_Proto               TYPEDEF PROTO pThis:QWORD, pEffect:QWORD
IMFPMediaPlayer_RemoveAllEffects_Proto           TYPEDEF PROTO pThis:QWORD
IMFPMediaPlayer_Shutdown_Proto                   TYPEDEF PROTO pThis:QWORD

; IMFPMediaItem:
IMFPMediaItem_GetMediaPlayer_Proto               TYPEDEF PROTO pThis:QWORD, ppMediaPlayer:QWORD
IMFPMediaItem_GetURL_Proto                       TYPEDEF PROTO pThis:QWORD, ppwszURL:QWORD
IMFPMediaItem_GetObject_Proto                    TYPEDEF PROTO pThis:QWORD, ppIUnknown:QWORD
IMFPMediaItem_GetUserData_Proto                  TYPEDEF PROTO pThis:QWORD, pqwUserData:QWORD
IMFPMediaItem_SetUserData_Proto                  TYPEDEF PROTO pThis:QWORD, qwUserData:QWORD
IMFPMediaItem_GetStartStopPosition_Proto         TYPEDEF PROTO pThis:QWORD, pguidStartPositionType:QWORD, pvStartValue:QWORD, pguidStopPositionType:QWORD, pvStopValue:QWORD
IMFPMediaItem_SetStartStopPosition_Proto         TYPEDEF PROTO pThis:QWORD, pguidStartPositionType:QWORD, pvStartValue:QWORD, pguidStopPositionType:QWORD, pvStopValue:QWORD
IMFPMediaItem_HasVideo_Proto                     TYPEDEF PROTO pThis:QWORD, pfHasVideo:QWORD, pfSelected:QWORD
IMFPMediaItem_HasAudio_Proto                     TYPEDEF PROTO pThis:QWORD, pfHasAudio:QWORD, pfSelected:QWORD
IMFPMediaItem_IsProtected_Proto                  TYPEDEF PROTO pThis:QWORD, pfProtected:QWORD
IMFPMediaItem_GetDuration_Proto                  TYPEDEF PROTO pThis:QWORD, guidPositionType:QWORD, pvDurationValue:QWORD
IMFPMediaItem_GetNumberOfStreams_Proto           TYPEDEF PROTO pThis:QWORD, pdwStreamCount:QWORD
IMFPMediaItem_GetStreamSelection_Proto           TYPEDEF PROTO pThis:QWORD, dwStreamIndex:DWORD, pfEnabled:QWORD
IMFPMediaItem_SetStreamSelection_Proto           TYPEDEF PROTO pThis:QWORD, dwStreamIndex:DWORD, fEnabled:DWORD
IMFPMediaItem_GetStreamAttribute_Proto           TYPEDEF PROTO pThis:QWORD, dwStreamIndex:DWORD, guidMFAttribute:QWORD, pvValue:QWORD
IMFPMediaItem_GetPresentationAttribute_Proto     TYPEDEF PROTO pThis:QWORD, guidMFAttribute:QWORD, pvValue:QWORD
IMFPMediaItem_GetCharacteristics_Proto           TYPEDEF PROTO pThis:QWORD, pCharacteristics:QWORD
IMFPMediaItem_SetStreamSink_Proto                TYPEDEF PROTO pThis:QWORD, dwStreamIndex:DWORD, pMediaSink:QWORD
IMFPMediaItem_GetMetadata_Proto                  TYPEDEF PROTO pThis:QWORD, ppMetadataStore:QWORD


;------------------------------------------------------------------------------
; Pointer To Prototypes
;------------------------------------------------------------------------------
; IUnknown
IUnknown_QueryInterface_Ptr                      TYPEDEF PTR IUnknown_QueryInterface_Proto
IUnknown_AddRef_Ptr                              TYPEDEF PTR IUnknown_AddRef_Proto
IUnknown_Release_Ptr                             TYPEDEF PTR IUnknown_Release_Proto

; IMFPMediaPlayerCallback:
IMFPMediaPlayerCallback_QueryInterface_Ptr       TYPEDEF PTR IUnknown_QueryInterface_Proto
IMFPMediaPlayerCallback_AddRef_Ptr               TYPEDEF PTR IUnknown_AddRef_Proto
IMFPMediaPlayerCallback_Release_Ptr              TYPEDEF PTR IUnknown_Release_Proto
IMFPMediaPlayerCallback_OnMediaPlayerEvent_Ptr   TYPEDEF PTR IMFPMediaPlayerCallback_OnMediaPlayerEvent_Proto

; IMFPMediaPlayer:
IMFPMediaPlayer_QueryInterface_Ptr               TYPEDEF PTR IUnknown_QueryInterface_Proto
IMFPMediaPlayer_AddRef_Ptr                       TYPEDEF PTR IUnknown_AddRef_Proto
IMFPMediaPlayer_Release_Ptr                      TYPEDEF PTR IUnknown_Release_Proto
IMFPMediaPlayer_Play_Ptr                         TYPEDEF PTR IMFPMediaPlayer_Play_Proto
IMFPMediaPlayer_Pause_Ptr                        TYPEDEF PTR IMFPMediaPlayer_Pause_Proto
IMFPMediaPlayer_Stop_Ptr                         TYPEDEF PTR IMFPMediaPlayer_Stop_Proto
IMFPMediaPlayer_FrameStep_Ptr                    TYPEDEF PTR IMFPMediaPlayer_FrameStep_Proto
IMFPMediaPlayer_SetPosition_Ptr                  TYPEDEF PTR IMFPMediaPlayer_SetPosition_Proto
IMFPMediaPlayer_GetPosition_Ptr                  TYPEDEF PTR IMFPMediaPlayer_GetPosition_Proto
IMFPMediaPlayer_GetDuration_Ptr                  TYPEDEF PTR IMFPMediaPlayer_GetDuration_Proto
IMFPMediaPlayer_SetRate_Ptr                      TYPEDEF PTR IMFPMediaPlayer_SetRate_Proto
IMFPMediaPlayer_GetRate_Ptr                      TYPEDEF PTR IMFPMediaPlayer_GetRate_Proto
IMFPMediaPlayer_GetSupportedRates_Ptr            TYPEDEF PTR IMFPMediaPlayer_GetSupportedRates_Proto
IMFPMediaPlayer_GetState_Ptr                     TYPEDEF PTR IMFPMediaPlayer_GetState_Proto
IMFPMediaPlayer_CreateMediaItemFromURL_Ptr       TYPEDEF PTR IMFPMediaPlayer_CreateMediaItemFromURL_Proto
IMFPMediaPlayer_CreateMediaItemFromObject_Ptr    TYPEDEF PTR IMFPMediaPlayer_CreateMediaItemFromObject_Proto
IMFPMediaPlayer_SetMediaItem_Ptr                 TYPEDEF PTR IMFPMediaPlayer_SetMediaItem_Proto
IMFPMediaPlayer_ClearMediaItem_Ptr               TYPEDEF PTR IMFPMediaPlayer_ClearMediaItem_Proto
IMFPMediaPlayer_GetMediaItem_Ptr                 TYPEDEF PTR IMFPMediaPlayer_GetMediaItem_Proto
IMFPMediaPlayer_GetVolume_Ptr                    TYPEDEF PTR IMFPMediaPlayer_GetVolume_Proto
IMFPMediaPlayer_SetVolume_Ptr                    TYPEDEF PTR IMFPMediaPlayer_SetVolume_Proto
IMFPMediaPlayer_GetBalance_Ptr                   TYPEDEF PTR IMFPMediaPlayer_GetBalance_Proto
IMFPMediaPlayer_SetBalance_Ptr                   TYPEDEF PTR IMFPMediaPlayer_SetBalance_Proto
IMFPMediaPlayer_GetMute_Ptr                      TYPEDEF PTR IMFPMediaPlayer_GetMute_Proto
IMFPMediaPlayer_SetMute_Ptr                      TYPEDEF PTR IMFPMediaPlayer_SetMute_Proto
IMFPMediaPlayer_GetNativeVideoSize_Ptr           TYPEDEF PTR IMFPMediaPlayer_GetNativeVideoSize_Proto
IMFPMediaPlayer_GetIdealVideoSize_Ptr            TYPEDEF PTR IMFPMediaPlayer_GetIdealVideoSize_Proto
IMFPMediaPlayer_SetVideoSourceRect_Ptr           TYPEDEF PTR IMFPMediaPlayer_SetVideoSourceRect_Proto
IMFPMediaPlayer_GetVideoSourceRect_Ptr           TYPEDEF PTR IMFPMediaPlayer_GetVideoSourceRect_Proto
IMFPMediaPlayer_SetAspectRatioMode_Ptr           TYPEDEF PTR IMFPMediaPlayer_SetAspectRatioMode_Proto
IMFPMediaPlayer_GetAspectRatioMode_Ptr           TYPEDEF PTR IMFPMediaPlayer_GetAspectRatioMode_Proto
IMFPMediaPlayer_GetVideoWindow_Ptr               TYPEDEF PTR IMFPMediaPlayer_GetVideoWindow_Proto
IMFPMediaPlayer_UpdateVideo_Ptr                  TYPEDEF PTR IMFPMediaPlayer_UpdateVideo_Proto
IMFPMediaPlayer_SetBorderColor_Ptr               TYPEDEF PTR IMFPMediaPlayer_SetBorderColor_Proto
IMFPMediaPlayer_GetBorderColor_Ptr               TYPEDEF PTR IMFPMediaPlayer_GetBorderColor_Proto
IMFPMediaPlayer_InsertEffect_Ptr                 TYPEDEF PTR IMFPMediaPlayer_InsertEffect_Proto
IMFPMediaPlayer_RemoveEffect_Ptr                 TYPEDEF PTR IMFPMediaPlayer_RemoveEffect_Proto
IMFPMediaPlayer_RemoveAllEffects_Ptr             TYPEDEF PTR IMFPMediaPlayer_RemoveAllEffects_Proto
IMFPMediaPlayer_Shutdown_Ptr                     TYPEDEF PTR IMFPMediaPlayer_Shutdown_Proto

; IMFPMediaItem:
IMFPMediaItem_QueryInterface_Ptr                 TYPEDEF PTR IUnknown_QueryInterface_Proto
IMFPMediaItem_AddRef_Ptr                         TYPEDEF PTR IUnknown_AddRef_Proto
IMFPMediaItem_Release_Ptr                        TYPEDEF PTR IUnknown_Release_Proto
IMFPMediaItem_GetMediaPlayer_Ptr                 TYPEDEF PTR IMFPMediaItem_GetMediaPlayer_Proto
IMFPMediaItem_GetURL_Ptr                         TYPEDEF PTR IMFPMediaItem_GetURL_Proto
IMFPMediaItem_GetObject_Ptr                      TYPEDEF PTR IMFPMediaItem_GetObject_Proto
IMFPMediaItem_GetUserData_Ptr                    TYPEDEF PTR IMFPMediaItem_GetUserData_Proto
IMFPMediaItem_SetUserData_Ptr                    TYPEDEF PTR IMFPMediaItem_SetUserData_Proto
IMFPMediaItem_GetStartStopPosition_Ptr           TYPEDEF PTR IMFPMediaItem_GetStartStopPosition_Proto
IMFPMediaItem_SetStartStopPosition_Ptr           TYPEDEF PTR IMFPMediaItem_SetStartStopPosition_Proto
IMFPMediaItem_HasVideo_Ptr                       TYPEDEF PTR IMFPMediaItem_HasVideo_Proto
IMFPMediaItem_HasAudio_Ptr                       TYPEDEF PTR IMFPMediaItem_HasAudio_Proto
IMFPMediaItem_IsProtected_Ptr                    TYPEDEF PTR IMFPMediaItem_IsProtected_Proto
IMFPMediaItem_GetDuration_Ptr                    TYPEDEF PTR IMFPMediaItem_GetDuration_Proto
IMFPMediaItem_GetNumberOfStreams_Ptr             TYPEDEF PTR IMFPMediaItem_GetNumberOfStreams_Proto
IMFPMediaItem_GetStreamSelection_Ptr             TYPEDEF PTR IMFPMediaItem_GetStreamSelection_Proto
IMFPMediaItem_SetStreamSelection_Ptr             TYPEDEF PTR IMFPMediaItem_SetStreamSelection_Proto
IMFPMediaItem_GetStreamAttribute_Ptr             TYPEDEF PTR IMFPMediaItem_GetStreamAttribute_Proto
IMFPMediaItem_GetPresentationAttribute_Ptr       TYPEDEF PTR IMFPMediaItem_GetPresentationAttribute_Proto
IMFPMediaItem_GetCharacteristics_Ptr             TYPEDEF PTR IMFPMediaItem_GetCharacteristics_Proto
IMFPMediaItem_SetStreamSink_Ptr                  TYPEDEF PTR IMFPMediaItem_SetStreamSink_Proto
IMFPMediaItem_GetMetadata_Ptr                    TYPEDEF PTR IMFPMediaItem_GetMetadata_Proto


;------------------------------------------------------------------------------
; COM Structures
;------------------------------------------------------------------------------
IFNDEF IUnknownVtbl
IUnknownVtbl                  STRUCT 8
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
IUnknownVtbl                  ENDS
ENDIF

IFNDEF IMFPMediaPlayerCallbackVtbl
IMFPMediaPlayerCallbackVtbl   STRUCT 8
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
    OnMediaPlayerEvent        IMFPMediaPlayerCallback_OnMediaPlayerEvent_Ptr 0
IMFPMediaPlayerCallbackVtbl   ENDS
ENDIF

IFNDEF IMFPMPCallback
IMFPMPCallback              STRUCT 8
    QueryInterface          QWORD IMFPMPCallback_QueryInterfaceProc
    AddRef                  QWORD IMFPMPCallback_AddRefProc
    Release                 QWORD IMFPMPCallback_ReleaseProc
    OnMediaPlayerEvent      QWORD 0
IMFPMPCallback              ENDS
ENDIF

IFNDEF IMFPMediaPlayerVtbl
IMFPMediaPlayerVtbl           STRUCT 8
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
    Play                      IMFPMediaPlayer_Play_Ptr 0
    Pause_                    IMFPMediaPlayer_Pause_Ptr 0
    Stop                      IMFPMediaPlayer_Stop_Ptr 0
    FrameStep                 IMFPMediaPlayer_FrameStep_Ptr 0
    SetPosition               IMFPMediaPlayer_SetPosition_Ptr 0
    GetPosition               IMFPMediaPlayer_GetPosition_Ptr 0
    GetDuration               IMFPMediaPlayer_GetDuration_Ptr 0
    SetRate                   IMFPMediaPlayer_SetRate_Ptr 0
    GetRate                   IMFPMediaPlayer_GetRate_Ptr 0
    GetSupportedRates         IMFPMediaPlayer_GetSupportedRates_Ptr 0
    GetState                  IMFPMediaPlayer_GetState_Ptr 0
    CreateMediaItemFromURL    IMFPMediaPlayer_CreateMediaItemFromURL_Ptr 0
    CreateMediaItemFromObject IMFPMediaPlayer_CreateMediaItemFromObject_Ptr 0
    SetMediaItem              IMFPMediaPlayer_SetMediaItem_Ptr 0
    ClearMediaItem            IMFPMediaPlayer_ClearMediaItem_Ptr 0
    GetMediaItem              IMFPMediaPlayer_GetMediaItem_Ptr 0
    GetVolume                 IMFPMediaPlayer_GetVolume_Ptr 0
    SetVolume                 IMFPMediaPlayer_SetVolume_Ptr 0
    GetBalance                IMFPMediaPlayer_GetBalance_Ptr 0
    SetBalance                IMFPMediaPlayer_SetBalance_Ptr 0
    GetMute                   IMFPMediaPlayer_GetMute_Ptr 0
    SetMute                   IMFPMediaPlayer_SetMute_Ptr 0
    GetNativeVideoSize        IMFPMediaPlayer_GetNativeVideoSize_Ptr 0
    GetIdealVideoSize         IMFPMediaPlayer_GetIdealVideoSize_Ptr 0
    SetVideoSourceRect        IMFPMediaPlayer_SetVideoSourceRect_Ptr 0
    GetVideoSourceRect        IMFPMediaPlayer_GetVideoSourceRect_Ptr 0
    SetAspectRatioMode        IMFPMediaPlayer_SetAspectRatioMode_Ptr 0
    GetAspectRatioMode        IMFPMediaPlayer_GetAspectRatioMode_Ptr 0
    GetVideoWindow            IMFPMediaPlayer_GetVideoWindow_Ptr 0
    UpdateVideo               IMFPMediaPlayer_UpdateVideo_Ptr 0
    SetBorderColor            IMFPMediaPlayer_SetBorderColor_Ptr 0
    GetBorderColor            IMFPMediaPlayer_GetBorderColor_Ptr 0
    InsertEffect              IMFPMediaPlayer_InsertEffect_Ptr 0
    RemoveEffect              IMFPMediaPlayer_RemoveEffect_Ptr 0
    RemoveAllEffects          IMFPMediaPlayer_RemoveAllEffects_Ptr 0
    Shutdown                  IMFPMediaPlayer_Shutdown_Ptr 0
IMFPMediaPlayerVtbl           ENDS
ENDIF

IFNDEF IMFPMediaItemVtbl
IMFPMediaItemVtbl             STRUCT 8
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
    GetMediaPlayer            IMFPMediaItem_GetMediaPlayer_Ptr 0
    GetURL                    IMFPMediaItem_GetURL_Ptr 0
    GetObject                 IMFPMediaItem_GetObject_Ptr 0
    GetUserData               IMFPMediaItem_GetUserData_Ptr 0
    SetUserData               IMFPMediaItem_SetUserData_Ptr 0
    GetStartStopPosition      IMFPMediaItem_GetStartStopPosition_Ptr 0
    SetStartStopPosition      IMFPMediaItem_SetStartStopPosition_Ptr 0
    HasVideo                  IMFPMediaItem_HasVideo_Ptr 0
    HasAudio                  IMFPMediaItem_HasAudio_Ptr 0
    IsProtected               IMFPMediaItem_IsProtected_Ptr 0
    GetDuration               IMFPMediaItem_GetDuration_Ptr 0
    GetNumberOfStreams        IMFPMediaItem_GetNumberOfStreams_Ptr 0
    GetStreamSelection        IMFPMediaItem_GetStreamSelection_Ptr 0
    SetStreamSelection        IMFPMediaItem_SetStreamSelection_Ptr 0
    GetStreamAttribute        IMFPMediaItem_GetStreamAttribute_Ptr 0
    GetPresentationAttribute  IMFPMediaItem_GetPresentationAttribute_Ptr 0
    GetCharacteristics        IMFPMediaItem_GetCharacteristics_Ptr 0
    SetStreamSink             IMFPMediaItem_SetStreamSink_Ptr 0
    GetMetadata               IMFPMediaItem_GetMetadata_Ptr 0
IMFPMediaItemVtbl             ENDS
ENDIF

IFNDEF GUID
GUID        STRUCT 8
    Data1   DD ?
    Data2   DW ?
    Data3   DW ?
    Data4   DB 8 DUP (?)
GUID        ENDS
ENDIF

IFNDEF LARGE_INTEGER
LARGE_INTEGER UNION
    STRUCT
      LowPart  DWORD ?
      HighPart DWORD ?
    ENDS
  QuadPart QWORD ?
LARGE_INTEGER ENDS
ENDIF

IFNDEF ULARGE_INTEGER
ULARGE_INTEGER UNION
    STRUCT
      LowPart  DWORD ?
      HighPart DWORD ?
    ENDS
  QuadPart QWORD ?
ULARGE_INTEGER ENDS
ENDIF

IFNDEF PROPVARIANT
PROPVARIANT     STRUCT 8
    vt          DW ?
    wReserved1  DW ?
    wReserved2  DW ?
    wReserved3  DW ?
    UNION
        hVal LARGE_INTEGER <>
        uhVal ULARGE_INTEGER <>
        fltVal REAL4 ?
        ; etc
    ENDS
PROPVARIANT     ENDS
ENDIF


.CONST
CP_ACP	EQU	0
CP_UTF7	EQU	65000
CP_UTF8	EQU	65001

COINIT_APARTMENTTHREADED    EQU 02h
COINIT_MULTITHREADED        EQU 00h
COINIT_DISABLE_OLE1DDE      EQU 04h
COINIT_SPEED_OVER_MEMORY    EQU 08h

CLSCTX_INPROC_SERVER        EQU 1h
CLSCTX_INPROC_HANDLER       EQU 2h
CLSCTX_LOCAL_SERVER         EQU 4h
CLSCTX_INPROC_SERVER16      EQU 8h
CLSCTX_REMOTE_SERVER        EQU 10h
CLSCTX_INPROC_HANDLER16     EQU 20h
CLSCTX_INPROC_SERVERX86     EQU 40h
CLSCTX_INPROC_HANDLERX86    EQU 80h
CLSCTX_ESERVER_HANDLER      EQU 100h
CLSCTX_NO_CODE_DOWNLOAD     EQU 400h
CLSCTX_NO_CUSTOM_MARSHAL    EQU 1000h
CLSCTX_ENABLE_CODE_DOWNLOAD EQU 2000h
CLSCTX_NO_FAILURE_LOG       EQU 4000h
CLSCTX_DISABLE_AAA          EQU 8000h
CLSCTX_ENABLE_AAA           EQU 10000h
CLSCTX_FROM_DEFAULT_CONTEXT EQU 20000h

IFNDEF S_OK
S_OK EQU 0
ENDIF
IFNDEF S_FALSE
S_FALSE EQU 1
ENDIF
IFNDEF HRESULT
HRESULT TYPEDEF QWORD
ENDIF
IFNDEF MFP_CREATION_OPTIONS
MFP_CREATION_OPTIONS TYPEDEF QWORD
ENDIF
IFNDEF MFP_MEDIAPLAYER_STATE
MFP_MEDIAPLAYER_STATE TYPEDEF QWORD
ENDIF
IFNDEF MFP_MEDIAITEM_CHARACTERISTICS
MFP_MEDIAITEM_CHARACTERISTICS TYPEDEF QWORD
ENDIF
IFNDEF MFP_CREDENTIAL_FLAGS
MFP_CREDENTIAL_FLAGS TYPEDEF QWORD
ENDIF
IFNDEF MFP_EVENT_TYPE
MFP_EVENT_TYPE TYPEDEF QWORD
ENDIF
IFNDEF MediaEventType
MediaEventType TYPEDEF QWORD
ENDIF
IFNDEF HRESULT_ERROR_CANCELLED
HRESULT_ERROR_CANCELLED EQU 800704C7h
ENDIF
IFNDEF MF_E_ATTRIBUTENOTFOUND
MF_E_ATTRIBUTENOTFOUND EQU 0C00D36E6h
ENDIF
IFNDEF MF_E_INVALIDREQUEST
MF_E_INVALIDREQUEST EQU 0C00D36B2h
ENDIF
IFNDEF E_NOINTERFACE
E_NOINTERFACE EQU 80004002h
ENDIF

IFNDEF VT_I8
VT_I8 EQU 20
ENDIF


.DATA
ALIGN 8
;------------------------------------------------------------------------------
; Function Pointers
;------------------------------------------------------------------------------
utoa_hextbl  db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

; IUnknown
IUnknown_QueryInterface                    IUnknown_QueryInterface_Ptr 0
IUnknown_AddRef                            IUnknown_AddRef_Ptr 0
IUnknown_Release                           IUnknown_Release_Ptr 0

; IMFPMediaPlayerCallback:
IMFPMediaPlayerCallback_QueryInterface     IMFPMediaPlayerCallback_QueryInterface_Ptr 0
IMFPMediaPlayerCallback_AddRef             IMFPMediaPlayerCallback_AddRef_Ptr 0
IMFPMediaPlayerCallback_Release            IMFPMediaPlayerCallback_Release_Ptr 0
IMFPMediaPlayerCallback_OnMediaPlayerEvent IMFPMediaPlayerCallback_OnMediaPlayerEvent_Ptr 0

; IMFPMediaPlayer:
IMFPMediaPlayer_QueryInterface             IMFPMediaPlayer_QueryInterface_Ptr 0
IMFPMediaPlayer_AddRef                     IMFPMediaPlayer_AddRef_Ptr 0
IMFPMediaPlayer_Release                    IMFPMediaPlayer_Release_Ptr 0
IMFPMediaPlayer_Play                       IMFPMediaPlayer_Play_Ptr 0
IMFPMediaPlayer_Pause                      IMFPMediaPlayer_Pause_Ptr 0
IMFPMediaPlayer_Stop                       IMFPMediaPlayer_Stop_Ptr 0
IMFPMediaPlayer_FrameStep                  IMFPMediaPlayer_FrameStep_Ptr 0
IMFPMediaPlayer_SetPosition                IMFPMediaPlayer_SetPosition_Ptr 0
IMFPMediaPlayer_GetPosition                IMFPMediaPlayer_GetPosition_Ptr 0
IMFPMediaPlayer_GetDuration                IMFPMediaPlayer_GetDuration_Ptr 0
IMFPMediaPlayer_SetRate                    IMFPMediaPlayer_SetRate_Ptr 0
IMFPMediaPlayer_GetRate                    IMFPMediaPlayer_GetRate_Ptr 0
IMFPMediaPlayer_GetSupportedRates          IMFPMediaPlayer_GetSupportedRates_Ptr 0
IMFPMediaPlayer_GetState                   IMFPMediaPlayer_GetState_Ptr 0
IMFPMediaPlayer_CreateMediaItemFromURL     IMFPMediaPlayer_CreateMediaItemFromURL_Ptr 0
IMFPMediaPlayer_CreateMediaItemFromObject  IMFPMediaPlayer_CreateMediaItemFromObject_Ptr 0
IMFPMediaPlayer_SetMediaItem               IMFPMediaPlayer_SetMediaItem_Ptr 0
IMFPMediaPlayer_ClearMediaItem             IMFPMediaPlayer_ClearMediaItem_Ptr 0
IMFPMediaPlayer_GetMediaItem               IMFPMediaPlayer_GetMediaItem_Ptr 0
IMFPMediaPlayer_GetVolume                  IMFPMediaPlayer_GetVolume_Ptr 0
IMFPMediaPlayer_SetVolume                  IMFPMediaPlayer_SetVolume_Ptr 0
IMFPMediaPlayer_GetBalance                 IMFPMediaPlayer_GetBalance_Ptr 0
IMFPMediaPlayer_SetBalance                 IMFPMediaPlayer_SetBalance_Ptr 0
IMFPMediaPlayer_GetMute                    IMFPMediaPlayer_GetMute_Ptr 0
IMFPMediaPlayer_SetMute                    IMFPMediaPlayer_SetMute_Ptr 0
IMFPMediaPlayer_GetNativeVideoSize         IMFPMediaPlayer_GetNativeVideoSize_Ptr 0
IMFPMediaPlayer_GetIdealVideoSize          IMFPMediaPlayer_GetIdealVideoSize_Ptr 0
IMFPMediaPlayer_SetVideoSourceRect         IMFPMediaPlayer_SetVideoSourceRect_Ptr 0
IMFPMediaPlayer_GetVideoSourceRect         IMFPMediaPlayer_GetVideoSourceRect_Ptr 0
IMFPMediaPlayer_SetAspectRatioMode         IMFPMediaPlayer_SetAspectRatioMode_Ptr 0
IMFPMediaPlayer_GetAspectRatioMode         IMFPMediaPlayer_GetAspectRatioMode_Ptr 0
IMFPMediaPlayer_GetVideoWindow             IMFPMediaPlayer_GetVideoWindow_Ptr 0
IMFPMediaPlayer_UpdateVideo                IMFPMediaPlayer_UpdateVideo_Ptr 0
IMFPMediaPlayer_SetBorderColor             IMFPMediaPlayer_SetBorderColor_Ptr 0
IMFPMediaPlayer_GetBorderColor             IMFPMediaPlayer_GetBorderColor_Ptr 0
IMFPMediaPlayer_InsertEffect               IMFPMediaPlayer_InsertEffect_Ptr 0
IMFPMediaPlayer_RemoveEffect               IMFPMediaPlayer_RemoveEffect_Ptr 0
IMFPMediaPlayer_RemoveAllEffects           IMFPMediaPlayer_RemoveAllEffects_Ptr 0
IMFPMediaPlayer_Shutdown                   IMFPMediaPlayer_Shutdown_Ptr 0

; IMFPMediaItem:
IMFPMediaItem_QueryInterface               IMFPMediaItem_QueryInterface_Ptr 0
IMFPMediaItem_AddRef                       IMFPMediaItem_AddRef_Ptr 0
IMFPMediaItem_Release                      IMFPMediaItem_Release_Ptr 0
IMFPMediaItem_GetMediaPlayer               IMFPMediaItem_GetMediaPlayer_Ptr 0
IMFPMediaItem_GetURL                       IMFPMediaItem_GetURL_Ptr 0
IMFPMediaItem_GetObject                    IMFPMediaItem_GetObject_Ptr 0
IMFPMediaItem_GetUserData                  IMFPMediaItem_GetUserData_Ptr 0
IMFPMediaItem_SetUserData                  IMFPMediaItem_SetUserData_Ptr 0
IMFPMediaItem_GetStartStopPosition         IMFPMediaItem_GetStartStopPosition_Ptr 0
IMFPMediaItem_SetStartStopPosition         IMFPMediaItem_SetStartStopPosition_Ptr 0
IMFPMediaItem_HasVideo                     IMFPMediaItem_HasVideo_Ptr 0
IMFPMediaItem_HasAudio                     IMFPMediaItem_HasAudio_Ptr 0
IMFPMediaItem_IsProtected                  IMFPMediaItem_IsProtected_Ptr 0
IMFPMediaItem_GetDuration                  IMFPMediaItem_GetDuration_Ptr 0
IMFPMediaItem_GetNumberOfStreams           IMFPMediaItem_GetNumberOfStreams_Ptr 0
IMFPMediaItem_GetStreamSelection           IMFPMediaItem_GetStreamSelection_Ptr 0
IMFPMediaItem_SetStreamSelection           IMFPMediaItem_SetStreamSelection_Ptr 0
IMFPMediaItem_GetStreamAttribute           IMFPMediaItem_GetStreamAttribute_Ptr 0
IMFPMediaItem_GetPresentationAttribute     IMFPMediaItem_GetPresentationAttribute_Ptr 0
IMFPMediaItem_GetCharacteristics           IMFPMediaItem_GetCharacteristics_Ptr 0
IMFPMediaItem_SetStreamSink                IMFPMediaItem_SetStreamSink_Ptr 0
IMFPMediaItem_GetMetadata                  IMFPMediaItem_GetMetadata_Ptr 0

sIMFPMediaPlayerCallback    IMFPMPCallback <>
pIMFPMediaPlayerCallback    QWORD sIMFPMediaPlayerCallback
                            QWORD 0 ; count?


MFP_POSITIONTYPE_100NS          GUID <00000000,0000,0000,<00,00,00,00,00,00,00,00>>




MFP_DIV100                  REAL4 0.01
MFP_DIV10000                REAL4 0.0001
MFP_MUL100                  REAL4 100.0

.CODE

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Init
;
; Create and initialize the MFPlay IMFPMediaPlayer COM object with the video 
; window handle and the callback function (if specified).
;
; Parameters:
;
; * hMFPWindow - handle to the window to use for the video output
;
; * pCallback - Address of the MFPlay event notification callback function.
;
; * ppMediaPlayer - pointer to a QWORD value to store the pMediaPlayer.
;
; Returns:
;
; Stores a pMediaPlayer object in the QWORD pointer to by the ppMediaPlayer
; parameter, or 0 if an error occurred. Returns in rax TRUE if successful or
; FALSE otherwise. 
;
; Notes:
;
; MFPMediaPlayer_Free should be called on program close to free up any resources.
;
; See Also:
;
; MFPMediaPlayer_Free
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Init PROC FRAME USES RBX hMFPWindow:QWORD, pCallback:QWORD, ppMediaPlayer:QWORD
    LOCAL pMediaPlayer:QWORD
    
    mov pMediaPlayer, 0
    
    Invoke CoInitializeEx, NULL, COINIT_APARTMENTTHREADED
    
    .IF pCallback != 0
        lea rbx, sIMFPMediaPlayerCallback
        mov rax, pCallback
        mov [rbx].IMFPMPCallback.OnMediaPlayerEvent, rax
        Invoke MFPCreateMediaPlayer, NULL, FALSE, MFP_OPTION_NONE, Addr pIMFPMediaPlayerCallback, hMFPWindow, Addr pMediaPlayer
    .ELSE
        Invoke MFPCreateMediaPlayer, NULL, FALSE, MFP_OPTION_NONE, NULL, hMFPWindow, Addr pMediaPlayer
    .ENDIF
    .IF rax != S_OK
        jmp MFPMediaPlayer_Init_Error
    .ENDIF
    
    Invoke IMFPMediaPlayerInit, pMediaPlayer
    .IF rax == FALSE
        jmp MFPMediaPlayer_Init_Error
    .ENDIF

    jmp MFPMediaPlayer_Init_Exit

MFPMediaPlayer_Init_Error:
    
    .IF ppMediaPlayer != 0
        mov rbx, ppMediaPlayer
        mov rax, 0
        mov [rbx], rax
    .ENDIF
    
    Invoke CoUninitialize
    mov rax, FALSE
    ret
    
MFPMediaPlayer_Init_Exit:
    
    .IF ppMediaPlayer != 0
        mov rbx, ppMediaPlayer
        mov rax, pMediaPlayer
        mov [rbx], rax
    .ENDIF
    mov rax, TRUE
    ret

MFPMediaPlayer_Init ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Free
;
; Shuts down the MFPlay IMFPMediaPlayer COM object and frees any resources 
; used by it. 
;
; Parameters:
;
; * ppMediaPlayer - pointer to a QWORD value that contains pMediaPlayer. The 
;   pMediaPlayer variable is returned from a the MFPMediaPlayer_Init function.
;
; Returns:
;
; None.
;
; Notes:
;
; The pMediaPlayer variable, pointed to by the ppMediaPlayer parameter is set 
; to 0 by this function.
;
; See Also:
;
; MFPMediaPlayer_Init
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Free PROC FRAME USES RBX ppMediaPlayer:QWORD
    LOCAL pMediaPlayer:QWORD
    
    .IF ppMediaPlayer != 0
        mov rbx, ppMediaPlayer
        mov rax, [rbx]
        .IF rax != 0
            mov pMediaPlayer, rax
            Invoke IMFPMediaPlayer_Shutdown, pMediaPlayer
            Invoke IMFPMediaPlayer_Release, pMediaPlayer
            mov rbx, ppMediaPlayer
            mov rax, 0
            mov [rbx], rax
            Invoke CoUninitialize
        .ENDIF
    .ENDIF
    ret
MFPMediaPlayer_Free ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Play
;
; Begins playback of a media item that is currently set in the media player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Media items have to be created and set before they can be played, paused, 
; stepped or stopped. A media item is created with the 
; MFPMediaPlayer_CreateMediaItemA/W function and is set in the queue to play 
; with the MFPMediaPlayer_SetMediaItem function.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_PLAY
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_Pause, MFPMediaPlayer_Stop, 
; MFPMediaPlayer_Toggle
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Play PROC FRAME pMediaPlayer:QWORD
    LOCAL dwState:DWORD
    LOCAL hWindow:QWORD
    LOCAL pMediaItem:QWORD
    LOCAL bVideo:DWORD
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    ; Added code to show video window, if state is stopped and play is invoked.
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF rax != S_OK
        mov rax, FALSE
        ret
    .ENDIF
    mov eax, dwState
    .IF eax == MFP_MEDIAPLAYER_STATE_STOPPED || eax == MFP_MEDIAPLAYER_STATE_PAUSED
        ; Added code to check for video or audio track, dont show window if audio
        Invoke MFPMediaPlayer_GetMediaItem, pMediaPlayer, Addr pMediaItem
        .IF rax == TRUE
            Invoke MFPMediaItem_HasVideo, pMediaItem, Addr bVideo, NULL
            Invoke MFPMediaItem_Release, pMediaItem
        .ELSE
            mov bVideo, FALSE
        .ENDIF
        mov hWindow, 0
        .IF bVideo == TRUE
            Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
            .IF rax == S_OK && hWindow != 0
                Invoke ShowWindow, hWindow, SW_SHOWNA
            .ENDIF
        .ELSE
            Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
            .IF rax == S_OK && hWindow != 0
                Invoke ShowWindow, hWindow, SW_HIDE
            .ENDIF
        .ENDIF
        
    .ENDIF
    
    Invoke IMFPMediaPlayer_Play, pMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Play ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Pause
;
; Pauses playback of a media item that is currently set in the media player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Media items have to be created and set before they can be played, paused, 
; stepped or stopped. A media item is created with the 
; MFPMediaPlayer_CreateMediaItemA/W function and is set in the queue to play 
; with the MFPMediaPlayer_SetMediaItem function.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_PAUSE
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_Play, MFPMediaPlayer_Stop, 
; MFPMediaPlayer_Toggle
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Pause PROC FRAME pMediaPlayer:QWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF rax != S_OK
        mov rax, FALSE
        ret
    .ENDIF
    mov eax, dwState
    .IF eax == MFP_MEDIAPLAYER_STATE_PLAYING
        Invoke IMFPMediaPlayer_Pause, pMediaPlayer
    .ENDIF
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Pause ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Stop
;
; Stops playback of a media item that is currently set in the media player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Media items have to be created and set before they can be played, paused, 
; stepped or stopped. A media item is created with the 
; MFPMediaPlayer_CreateMediaItemA/W function and is set in the queue to play 
; with the MFPMediaPlayer_SetMediaItem function.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_STOP
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_Play, MFPMediaPlayer_Pause, 
; MFPMediaPlayer_Toggle
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Stop PROC FRAME pMediaPlayer:QWORD
    LOCAL hWindow:QWORD
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_Stop, pMediaPlayer
    .IF rax == S_OK
        ; Added code to hide window once stopped
        mov hWindow, 0
        Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
        .IF rax == S_OK && hWindow != 0
            Invoke ShowWindow, hWindow, SW_HIDE
        .ENDIF
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Stop ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Step
;
; Steps a frame of a media item that is currently set in the media player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Media items have to be created and set before they can be played, paused, 
; stepped or stopped. A media item is created with the 
; MFPMediaPlayer_CreateMediaItemA/W function and is set in the queue to play 
; with the MFPMediaPlayer_SetMediaItem function.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_FRAME_STEP
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_Play, MFPMediaPlayer_Pause, 
; MFPMediaPlayer_Stop, MFPMediaPlayer_Toggle
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Step PROC FRAME pMediaPlayer:QWORD
    LOCAL dwState:DWORD
    LOCAL hWindow:QWORD
    LOCAL pMediaItem:QWORD
    LOCAL bVideo:DWORD

    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    ; Added code to show video window, if state is stopped and step is invoked.
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF rax != S_OK
        mov rax, FALSE
        ret
    .ENDIF

    Invoke IMFPMediaPlayer_FrameStep, pMediaPlayer
    .IF rax == S_OK
        mov eax, dwState ; if previously was stopped or paused, show window
        .IF eax == MFP_MEDIAPLAYER_STATE_STOPPED || eax == MFP_MEDIAPLAYER_STATE_PAUSED

            ; Added code to check for video or audio track, dont show window if audio
            Invoke MFPMediaPlayer_GetMediaItem, pMediaPlayer, Addr pMediaItem
            .IF rax == TRUE   
                Invoke MFPMediaItem_HasVideo, pMediaItem, Addr bVideo, NULL
                Invoke MFPMediaItem_Release, pMediaItem
            .ELSE
                mov bVideo, FALSE
            .ENDIF            
            mov hWindow, 0
            .IF bVideo == TRUE
                Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
                .IF rax == S_OK && hWindow != 0
                    Invoke ShowWindow, hWindow, SW_SHOWNA
                .ENDIF
            .ELSE
                Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
                .IF rax == S_OK && hWindow != 0
                    Invoke ShowWindow, hWindow, SW_HIDE
                .ENDIF
            .ENDIF
        .ENDIF
    
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Step ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Toggle
;
; Toggles between play and pause for a media item that is currently set in the 
; media player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Media items have to be created and set before they can be played, paused, 
; stepped or stopped. A media item is created with the 
; MFPMediaPlayer_CreateMediaItemA/W function and is set in the queue to play 
; with the MFPMediaPlayer_SetMediaItem function.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_PAUSE or MFP_EVENT_TYPE_PLAY
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_Play, MFPMediaPlayer_Pause, 
; MFPMediaPlayer_Stop, MFPMediaPlayer_Step
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Toggle PROC FRAME pMediaPlayer:QWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF rax != S_OK
        mov rax, FALSE
        ret
    .ENDIF
    mov eax, dwState
    .IF eax == MFP_MEDIAPLAYER_STATE_PAUSED || eax == MFP_MEDIAPLAYER_STATE_STOPPED
        Invoke MFPMediaPlayer_Play, pMediaPlayer
    .ELSEIF eax == MFP_MEDIAPLAYER_STATE_PLAYING
        Invoke MFPMediaPlayer_Pause, pMediaPlayer
    .ENDIF

    ret
MFPMediaPlayer_Toggle ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetState
;
; Obtains the current state of the MFPlay Media Player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwState - pointer to a DWORD value to store the state of the Media Player.
;
; Returns:
;
; TRUE if successful or FALSE otherwise. The QWORD pointer to by the pState
; parameter will contain one of following value:
;
; * ``MFP_MEDIAPLAYER_STATE_EMPTY``
; * ``MFP_MEDIAPLAYER_STATE_STOPPED``
; * ``MFP_MEDIAPLAYER_STATE_PLAYING``
; * ``MFP_MEDIAPLAYER_STATE_PAUSED``
; * ``MFP_MEDIAPLAYER_STATE_SHUTDOWN``
;
; See Also:
;
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetState PROC FRAME USES RBX pMediaPlayer:QWORD, pdwState:QWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0 || pdwState == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF rax == S_OK
        mov rbx, pdwState
        mov eax, dwState
        mov [rbx], eax
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetState ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_ClearMediaItem
;
; Clears the current media item.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This method is currently not implemented. It still sends a notification to
; the Media Event callback as MFP_EVENT_TYPE_MEDIAITEM_CLEARED, if the callback 
; function is specified when creating the Media Player (IMFPMediaPlayer) 
; object during the MFPMediaPlayer_Init function (MFPCreateMediaPlayer call)
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_MEDIAITEM_CLEARED
;
; See Also:
;
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_CreateMediaItemA, 
; MFPMediaPlayer_CreateMediaItemW
;
;------------------------------------------------------------------------------
MFPMediaPlayer_ClearMediaItem PROC FRAME pMediaPlayer:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_ClearMediaItem, pMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_ClearMediaItem ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetMediaItem
;
; Queues a media item for playback.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pMediaItem - A pointer to the media item (IMFPMediaItem) to queue for play.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_MEDIAITEM_SET
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW, 
; MFPMediaPlayer_GetMediaItem
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetMediaItem PROC FRAME pMediaPlayer:QWORD, pMediaItem:QWORD
    .IF pMediaPlayer == 0 || pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetMediaItem, pMediaPlayer, pMediaItem
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetMediaItem ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetMediaItem
;
; Gets a pointer to the current media item.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * ppMediaItem - A pointer to the media item's IMFPMediaItem interface.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The caller must release the interface.
;
; See Also:
;
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_CreateMediaItemA, 
; MFPMediaPlayer_CreateMediaItemW
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetMediaItem PROC FRAME pMediaPlayer:QWORD, ppMediaItem:QWORD
    .IF pMediaPlayer == 0 || ppMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetMediaItem, pMediaPlayer, ppMediaItem
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetMediaItem ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_CreateMediaItemA
;
; Creates a media item from a string.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * lpszMediaItem - A pointer to an ANSI string containing the media file to 
;   create the media item from.
;
; * qwUserData - A QWORD value used as custom data.
;
; * ppMediaItem - A pointer to the media item's IMFPMediaItem interface.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_MEDIAITEM_CREATED
;
; See Also:
;
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_GetMediaItem
;
;------------------------------------------------------------------------------
MFPMediaPlayer_CreateMediaItemA PROC FRAME USES RBX pMediaPlayer:QWORD, lpszMediaItem:QWORD, qwUserData:QWORD, ppMediaItem:QWORD
    LOCAL pMediaItem:QWORD
    LOCAL lpszWideMediaItem:QWORD    
    
    .IF pMediaPlayer == 0 || lpszMediaItem == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
        ret
    .ENDIF
    
    mov lpszWideMediaItem, 0
    
    Invoke _MFP_ConvertStringToWide, lpszMediaItem
    mov lpszWideMediaItem, rax

    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromURL, pMediaPlayer, lpszWideMediaItem, TRUE, qwUserData, Addr pMediaItem
    .IF rax == S_OK
        .IF lpszWideMediaItem != 0
            Invoke _MFP_ConvertStringFree, lpszWideMediaItem
        .ENDIF
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, pMediaItem
            mov [rbx], rax
        .ENDIF
        mov rax, TRUE
    .ELSE
        .IF lpszWideMediaItem != 0
            Invoke _MFP_ConvertStringFree, lpszWideMediaItem
        .ENDIF
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
    .ENDIF    
    ret
MFPMediaPlayer_CreateMediaItemA ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_CreateMediaItemW
;
; Creates a media item from a string.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * lpszMediaItem - A pointer to an Wide/Unicode string containing the media 
;   file to create the media item from.
;
; * qwUserData - A QWORD value used as custom data.
;
; * ppMediaItem - A pointer to the media item's IMFPMediaItem interface.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_MEDIAITEM_CREATED
;
; See Also:
;
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_GetMediaItem
;
;------------------------------------------------------------------------------
MFPMediaPlayer_CreateMediaItemW PROC FRAME USES RBX pMediaPlayer:QWORD, lpszMediaItem:QWORD, qwUserData:QWORD, ppMediaItem:QWORD
    LOCAL pMediaItem:QWORD

    .IF pMediaPlayer == 0 || lpszMediaItem == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
        ret
    .ENDIF

    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromURL, pMediaPlayer, lpszMediaItem, TRUE, qwUserData, Addr pMediaItem
    .IF rax == S_OK
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, pMediaItem
            mov [rbx], rax
        .ENDIF
        mov rax, TRUE
    .ELSE
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
    .ENDIF    
    ret
MFPMediaPlayer_CreateMediaItemW ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_CreateMediaItemFromObject
;
; Creates a media item from an object.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pIUnknownObj - A pointer to an IUnknown object.
;
; * qwUserData - A QWORD value used as custom data.
;
; * ppMediaItem - A pointer to the media item's IMFPMediaItem interface.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_MEDIAITEM_CREATED
;
; See Also:
;
; MFPMediaPlayer_SetMediaItem, MFPMediaPlayer_GetMediaItem, 
; MFPMediaPlayer_CreateMediaItemA, MFPMediaPlayer_CreateMediaItemW
;
;------------------------------------------------------------------------------
MFPMediaPlayer_CreateMediaItemFromObject PROC FRAME pMediaPlayer:QWORD, pIUnknownObj:QWORD, qwUserData:QWORD, ppMediaItem:QWORD
    LOCAL pMediaItem:QWORD

    .IF pMediaPlayer == 0 || pIUnknownObj == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
        ret
    .ENDIF
    
    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromObject, pMediaPlayer, pIUnknownObj, TRUE, qwUserData, Addr pMediaItem
    .IF rax == S_OK
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, pMediaItem
            mov [rbx], rax
        .ENDIF
        mov rax, TRUE
    .ELSE
        .IF ppMediaItem != 0
            mov rbx, ppMediaItem
            mov rax, 0
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
    .ENDIF  
    
    ret
MFPMediaPlayer_CreateMediaItemFromObject ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetPosition
;
; Sets the playback position.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * dwMilliseconds - The position to set in the media item, in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the milliseconds value to nano seconds.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_POSITION_SET
;
; See Also:
;
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetPosition PROC FRAME USES RBX pMediaPlayer:QWORD, dwMilliseconds:DWORD
    LOCAL PosValue:PROPVARIANT
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    mov rax, 0
    mov qword ptr [PosValue+00], rax
    mov qword ptr [PosValue+08], rax
    mov PosValue.vt, VT_I8
    
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr PosValue, dwMilliseconds
    
    Invoke IMFPMediaPlayer_SetPosition, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr PosValue
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetPosition ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetPosition
;
; Gets the current playback position.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwMilliseconds - A pointer to a DWORD variable to store the position of 
;   the media item, returned in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the nano second time value to milliseconds. If an 
; error occurs the value of the milliseconds is set to -1.
;
; See Also:
;
; MFPMediaPlayer_SetPosition, MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetPosition PROC FRAME USES RBX pMediaPlayer:QWORD, pdwMilliseconds:QWORD
    LOCAL PosValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD

    mov rax, 0
    mov qword ptr [PosValue+00], rax
    mov qword ptr [PosValue+08], rax
    mov PosValue.vt, VT_I8
    
    .IF pMediaPlayer == 0 || pdwMilliseconds == 0
        mov rax, FALSE
        ret
    .ENDIF

    Invoke IMFPMediaPlayer_GetPosition, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr PosValue
    .IF rax == S_OK
        Invoke _MFP_Convert100NSValueToMSTime, Addr PosValue, Addr dwMilliseconds
        mov rbx, pdwMilliseconds
        xor rax, rax
        mov eax, dwMilliseconds
        mov [rbx], eax
        mov rax, TRUE
    .ELSE
        mov rbx, pdwMilliseconds
        mov rax, -1
        mov [rbx], rax
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetPosition ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetDuration
;
; Gets the playback duration of the current media item.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwMilliseconds - A pointer to a DWORD variable to store the duration of 
;   the media item, returned in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the nano second time value to milliseconds. If an 
; error occurs the value of the milliseconds is set to -1.
;
; See Also:
;
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_SetPosition
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetDuration PROC FRAME USES RBX pMediaPlayer:QWORD, pdwMilliseconds:QWORD
    LOCAL DurValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD

    mov rax, 0
    mov qword ptr [DurValue+00], rax
    mov qword ptr [DurValue+08], rax
    mov DurValue.vt, VT_I8
    
    .IF pMediaPlayer == 0 || pdwMilliseconds == 0
        mov rax, FALSE
        ret
    .ENDIF

    Invoke IMFPMediaPlayer_GetDuration, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr DurValue
    .IF rax == S_OK
        Invoke _MFP_Convert100NSValueToMSTime, Addr DurValue, Addr dwMilliseconds
        mov rbx, pdwMilliseconds
        xor rax, rax
        mov eax, dwMilliseconds
        mov [rbx], eax
        mov rax, TRUE
    .ELSE
        mov rbx, pdwMilliseconds
        mov rax, -1
        mov [rbx], rax
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetDuration ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetRate
;
; Sets the playback rate.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * dwRate - A DWORD value of the rate to set.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 100 indicates normal playback speed, 50 indicates half speed, and 200 
; indicates twice speed, etc.
;
; Sends a notification to the Media Event callback function as 
; MFP_EVENT_TYPE_RATE_SET
;
; See Also:
;
; MFPMediaPlayer_GetRate, MFPMediaPlayer_GetSupportedRates
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetRate PROC FRAME pMediaPlayer:QWORD, dwRate:DWORD
    LOCAL fRate:REAL4
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    finit
    fwait
    fild dwRate
    fmul MFP_DIV100
    fstp fRate
    
    Invoke IMFPMediaPlayer_SetRate, pMediaPlayer, fRate
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetRate ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetRate
;
; Gets the current playback rate.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwRate - A pointer to a DWORD variable that store the rate value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 100 indicates normal playback speed, 50 indicates half speed, and 200 
; indicates twice speed, etc.
;
; See Also:
;
; MFPMediaPlayer_SetRate, MFPMediaPlayer_GetSupportedRates
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetRate PROC FRAME USES RBX pMediaPlayer:QWORD, pdwRate:QWORD
    LOCAL fRate:REAL4
    LOCAL dwRate:DWORD
    
    .IF pMediaPlayer == 0 || pdwRate == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetRate, pMediaPlayer, Addr fRate
    .IF rax == S_OK
        finit
        fwait
        fld fRate 
        fmul MFP_MUL100
        fistp dwRate

        mov rbx, pdwRate
        mov eax, dwRate
        mov [rbx], eax
        
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetRate ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetSupportedRates
;
; Gets the range of supported playback rates.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * bForwardDirection - TRUE for forward playback or FALSE for reverse playback
;
; * pdwSlowestRate - A pointer to a DWORD to store the slowest rate value.
;
; * pdwFastestRate - A pointer to a DWORD to store the fastest rate value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 100 indicates normal playback speed, 50 indicates half speed, and 200 
; indicates twice speed, etc.
;
; See Also:
;
; MFPMediaPlayer_GetRate, MFPMediaPlayer_SetRate
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetSupportedRates PROC FRAME USES RBX pMediaPlayer:QWORD, bForwardDirection:DWORD, pdwSlowestRate:QWORD, pdwFastestRate:QWORD
    LOCAL fSlowestRate:REAL4
    LOCAL fFastestRate:REAL4
    LOCAL dwSlowestRate:DWORD
    LOCAL dwFastestRate:DWORD

    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetSupportedRates, pMediaPlayer, bForwardDirection, Addr fSlowestRate, Addr fFastestRate
    .IF rax == S_OK
    
        .IF pdwSlowestRate != 0
            finit
            fwait
            fld fSlowestRate 
            fmul MFP_MUL100
            fistp dwSlowestRate
    
            mov rbx, pdwSlowestRate
            mov eax, dwSlowestRate
            mov [rbx], eax
        .ENDIF
        
        .IF pdwFastestRate != 0
            finit
            fwait
            fld fFastestRate 
            fmul MFP_MUL100
            fistp dwFastestRate
    
            mov rbx, pdwFastestRate
            mov eax, dwFastestRate
            mov [rbx], eax
        .ENDIF
        
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetSupportedRates ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetVolume
;
; Gets the current audio volume.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwVolume - A pointer to a DWORD variable to store the volume level.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 0 indicates silence and 100 indicates full volume.
;
; See Also:
;
; MFPMediaPlayer_SetVolume, MFPMediaPlayer_GetMute, MFPMediaPlayer_SetMute
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetVolume PROC FRAME USES RBX pMediaPlayer:QWORD, pdwVolume:QWORD
    LOCAL fVolume:REAL4
    LOCAL dwVolume:DWORD
    
    .IF pMediaPlayer == 0 || pdwVolume == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVolume, pMediaPlayer, Addr fVolume
    .IF rax == S_OK
        finit
        fwait
        fld fVolume
        fmul MFP_MUL100
        fistp dwVolume

        mov rbx, pdwVolume
        xor rax, rax
        mov eax, dwVolume
        mov [rbx], eax
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVolume ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetVolume
;
; Sets the audio volume.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * dwVolume - The volume level to set, 0 - 100.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 0 indicates silence and 100 indicates full volume.
;
; See Also:
;
; MFPMediaPlayer_GetVolume, MFPMediaPlayer_GetMute, MFPMediaPlayer_SetMute
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetVolume PROC FRAME pMediaPlayer:QWORD, dwVolume:DWORD
    LOCAL fVolume:REAL4
    
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF

    finit
    fwait
    .IF dwVolume == 0
        fldz
    .ELSEIF sdword ptr dwVolume >= 100
        fld1 
    .ELSE
        fild dwVolume
        fmul MFP_DIV100
        ;fild qw100
        ;fdiv
    .ENDIF
    fstp fVolume
    
    Invoke IMFPMediaPlayer_SetVolume, pMediaPlayer, fVolume
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetVolume ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetBalance
;
; Gets the current audio balance.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwBalance - A pointer to a DWORD variable to store the balance level.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 0 indicates balance, -100 indicates left, +100 indicates right.
;
; See Also:
;
; MFPMediaPlayer_GetBalance, MFPMediaPlayer_GetVolume, MFPMediaPlayer_GetMute, 
; MFPMediaPlayer_SetMute
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetBalance PROC FRAME pMediaPlayer:QWORD, pdwBalance:QWORD
    LOCAL fBalance:REAL4
    LOCAL dwBalance:DWORD
    
    .IF pMediaPlayer == 0 || pdwBalance == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetBalance, pMediaPlayer, Addr fBalance
    .IF rax == S_OK
        finit
        fwait
        fld fBalance
        fmul MFP_MUL100
        fistp dwBalance

        mov rbx, pdwBalance
        mov eax, dwBalance
        mov [rbx], eax
        
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetBalance ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetBalance
;
; Sets the current audio balance.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * dwBalance - The balance level to set, -100 to +100.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; 0 indicates balance, -100 indicates left, +100 indicates right.
;
; See Also:
;
; MFPMediaPlayer_GetBalance, MFPMediaPlayer_GetVolume, MFPMediaPlayer_GetMute, 
; MFPMediaPlayer_SetMute
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetBalance PROC FRAME pMediaPlayer:QWORD, dwBalance:SDWORD
    LOCAL fBalance:REAL4

    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    finit
    fwait
    .IF dwBalance == 0
        fldz
    .ELSEIF sdword ptr dwBalance >= 100
        fld1
    .ELSEIF sdword ptr dwBalance <= -100
        fld1
        fchs 
    .ELSE
        fild dwBalance
        fmul MFP_DIV100
    .ENDIF
    fstp fBalance
    
    Invoke IMFPMediaPlayer_SetBalance, pMediaPlayer, fBalance
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetBalance ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetMute
;
; Queries whether the audio is muted.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pbMute - A pointer to a DWORD variable containing TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The variable pointed to by the pbMute paramter will contain TRUE if the 
; audio is muted, or FALSE otherwise.
;
; See Also:
;
; MFPMediaPlayer_SetMute, MFPMediaPlayer_GetVolume, MFPMediaPlayer_SetVolume
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetMute PROC FRAME pMediaPlayer:QWORD, pbMute:QWORD
    .IF pMediaPlayer == 0 || pbMute == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetMute, pMediaPlayer, pbMute
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetMute ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetMute
;
; Mutes or unmutes the audio.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * bMute - TRUE to mute the audio, or FALSE to unmute the audio.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Get volume level before setting mute, then restore that level apon unmute.
;
; See Also:
;
; MFPMediaPlayer_GetMute, MFPMediaPlayer_GetVolume, MFPMediaPlayer_SetVolume
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetMute PROC FRAME pMediaPlayer:QWORD, bMute:DWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetMute, pMediaPlayer, bMute
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetMute ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetNativeVideoSize
;
; Gets the size and aspect ratio of the video. These values are computed before 
; any scaling is done to fit the video into the destination window.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pszVideo - Pointer to a SIZE variable to store the width and height of the 
;   video, in pixels. Can be NULL.
;
; * pszARVideo - Pointer to a SIZE variable to store the aspect ratio of the 
;   video. Can be NULL.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; At least one parameter must be non-NULL.
;
; See Also:
;
; MFPMediaPlayer_GetIdealVideoSize
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetNativeVideoSize PROC FRAME pMediaPlayer:QWORD, pszVideo:QWORD, pszARVideo:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetNativeVideoSize, pMediaPlayer, pszVideo, pszARVideo
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetNativeVideoSize ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetIdealVideoSize
;
; Gets the range of video sizes that can be displayed without significantly 
; degrading performance or image quality.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pszMin - Pointer to a SIZE variable to store the minimum size of video that 
;   is preferable. Can be NULL.
;
; * pszMax - Pointer to a SIZE variable to store the maximum size of video that 
;   is preferable. Can be NULL.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; At least one parameter must be non-NULL. Sizes are given in pixels.
;
; See Also:
;
; MFPMediaPlayer_GetNativeVideoSize
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetIdealVideoSize PROC FRAME pMediaPlayer:QWORD, pszMin:QWORD, pszMax:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetIdealVideoSize, pMediaPlayer, pszMin, pszMax
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetIdealVideoSize ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetVideoSourceRect
;
; Sets the video source rectangle.
;
; MFPlay clips the video to this rectangle and stretches the rectangle to fill 
; the video window.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pnrcSource - Pointer to an MFVideoNormalizedRect structure.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The upper-left corner of the video image is (0, 0).
; The lower-right corner of the video image is (1, 1)
;
; If the source rectangle is {0, 0, 1, 1}, the entire image is displayed. 
; This is the default value.
;
; See Also:
;
; MFPMediaPlayer_GetVideoSourceRect
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetVideoSourceRect PROC FRAME pMediaPlayer:QWORD, pnrcSource:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetVideoSourceRect, pMediaPlayer, pnrcSource
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetVideoSourceRect ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetVideoSourceRect
;
; Gets the video source rectangle.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pnrcSource- Pointer to an MFVideoNormalizedRect structure.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The upper-left corner of the video image is (0, 0).
; The lower-right corner of the video image is (1, 1)
;
; If the source rectangle is {0, 0, 1, 1}, the entire image is displayed. 
; This is the default value.
;
; See Also:
;
; MFPMediaPlayer_SetVideoSourceRect
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetVideoSourceRect PROC FRAME pMediaPlayer:QWORD, pnrcSource:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVideoSourceRect, pMediaPlayer, pnrcSource
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVideoSourceRect ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetVideoWindow
;
; Gets the window where the video is displayed.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * phwndVideo - A pointer to a variable to hold the window handle.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The video window is specified when you first call MFPMediaPlayer_Init to create the 
; MFPlay player object.
;
; See Also:
;
; MFPMediaPlayer_Init, MFPMediaPlayer_UpdateVideo
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetVideoWindow PROC FRAME pMediaPlayer:QWORD, phwndVideo:QWORD
    .IF pMediaPlayer == 0 || phwndVideo == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, phwndVideo
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVideoWindow ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_UpdateVideo
;
; Updates the video frame.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Is supposed to allow painting in WM_PAINT or WM_SIZE when video is not 
; rendering, but tests show that this isnt the case. At a best guess the window
; that is used to render is subclassed and doesnt pass back the chain of events
; for WM_PAINT once rendering starts. My workaround for this to allow a custom
; draw of the video window when not playing is to hide the window when stopped
; and show it when playing, this allows the background of the parent window to 
; show any custom painting, including a fake video screen with a logo.
;
; See Also:
;
; MFPMediaPlayer_GetVideoWindow
;
;------------------------------------------------------------------------------
MFPMediaPlayer_UpdateVideo PROC FRAME pMediaPlayer:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_UpdateVideo, pMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_UpdateVideo ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetBorderColor
;
; Sets the color for the video border. The border color is used to letterbox 
; the video.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * Color - Specifies the border color as a COLORREF value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Default color is black.
;
; See Also:
;
; MFPMediaPlayer_GetBorderColor
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetBorderColor PROC FRAME pMediaPlayer:QWORD, Color:DWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetBorderColor, pMediaPlayer, Color
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetBorderColor ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetBorderColor
;
; Gets the current color of the video border. The border color is used to 
; letterbox the video.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pColor - Pointer to a DWORD that stores the border color (COLORREF) value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Default color is black.
;
; See Also:
;
; MFPMediaPlayer_SetBorderColor
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetBorderColor PROC FRAME pMediaPlayer:QWORD, pColor:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetBorderColor, pMediaPlayer, pColor
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetBorderColor ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_InsertEffect
;
; Applies an audio or video effect to playback.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pEffect - Pointer to the IUnknown interface for one of the following:
;
;   * A Media Foundation transform (MFT) that implements the effect. MFTs 
;     expose the IMFTransform interface.
;
;   * An activation object that creates an MFT. Activation objects expose the 
;     IMFActivate interface.
;
; * bOptional - Specifies whether the effect is optional.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The object specified in the pEffect parameter can implement either a video 
; effect or an audio effect. The effect is applied to any media items set after 
; the method is called. It is not applied to the current media item.
;
; See Also:
;
; MFPMediaPlayer_RemoveEffect, MFPMediaPlayer_RemoveAllEffects
;
;------------------------------------------------------------------------------
MFPMediaPlayer_InsertEffect PROC FRAME pMediaPlayer:QWORD, pEffect:QWORD, bOptional:DWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_InsertEffect, pMediaPlayer, pEffect, bOptional
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_InsertEffect ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_RemoveEffect
;
; Removes an effect that was added with the MFPMediaPlayer_InsertEffect function.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pEffect - Pointer to the IUnknown interface of the effect object. Use the 
;   same pointer that you passed to the MFPMediaPlayer_InsertEffect function.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The change applies to the next media item that is set on the player. The 
; effect is not removed from the current media item.
;
; See Also:
;
; MFPMediaPlayer_InsertEffect, MFPMediaPlayer_RemoveAllEffects
;
;------------------------------------------------------------------------------
MFPMediaPlayer_RemoveEffect PROC FRAME pMediaPlayer:QWORD, pEffect:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_RemoveEffect, pMediaPlayer, pEffect
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_RemoveEffect ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_RemoveAllEffects
;
; Removes all effects that were added with the MFPMediaPlayer_InsertEffect 
; function.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The change applies to the next media item that is set on the player. The 
; effect is not removed from the current media item.
;
; See Also:
;
; MFPMediaPlayer_InsertEffect, MFPMediaPlayer_RemoveEffect
;
;------------------------------------------------------------------------------
MFPMediaPlayer_RemoveAllEffects PROC FRAME pMediaPlayer:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_RemoveAllEffects, pMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_RemoveAllEffects ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_Shutdown
;
; Shuts down the MFPlay player object and releases any resources the object is 
; using.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The player object automatically shuts itself down when its reference count 
; reaches zero. You can use the Shutdown method to shut down the player before 
; all of the references have been released.
;
; See Also:
;
; MFPMediaPlayer_Init, MFPMediaPlayer_Free
;
;------------------------------------------------------------------------------
MFPMediaPlayer_Shutdown PROC FRAME pMediaPlayer:QWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_Shutdown, pMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Shutdown ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_SetAspectRatioMode
;
; Specifies whether the aspect ratio of the video is preserved during playback.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * dwAspectRatioMode - Bitwise flags for aspect ratio.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; qwAspectRatioMode can contain a combination of the following:
;
; * ``MFVideoARMode_None``
; * ``MFVideoARMode_PreservePicture``
; * ``MFVideoARMode_PreservePixel``
; * ``MFVideoARMode_NonLinearStretch``
;
; In practice only MFVideoARMode_None and (MFVideoARMode_PreservePicture 
; or MFVideoARMode_PreservePixel) actually do anything. 
;
; See Also:
;
; MFPMediaPlayer_GetAspectRatioMode
;
;------------------------------------------------------------------------------
MFPMediaPlayer_SetAspectRatioMode PROC FRAME pMediaPlayer:QWORD, dwAspectRatioMode:DWORD
    .IF pMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetAspectRatioMode, pMediaPlayer, dwAspectRatioMode
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetAspectRatioMode ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetAspectRatioMode
;
; Gets the current aspect-ratio correction mode.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pdwAspectRatioMode - A pointer to a DWORD variable that contains aspect
;   ratio bitflags.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The variable pointed to by the pqwAspectRatioMode parameter can contain a 
; combination of the following:
;
; * ``MFVideoARMode_None``
; * ``MFVideoARMode_PreservePicture``
; * ``MFVideoARMode_PreservePixel``
; * ``MFVideoARMode_NonLinearStretch``
;
; See Also:
;
; MFPMediaPlayer_SetAspectRatioMode
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetAspectRatioMode PROC FRAME pMediaPlayer:QWORD, pdwAspectRatioMode:QWORD
    .IF pMediaPlayer == 0 || pdwAspectRatioMode == 0
        mov rax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetAspectRatioMode, pMediaPlayer, pdwAspectRatioMode
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetAspectRatioMode ENDP



;==============================================================================
; MFPMediaItem Functions
;==============================================================================

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_QueryInterface
; 
; Queries a COM object for a pointer to one of its interface; identifying the 
; interface by a reference to its interface identifier (IID). If the COM object 
; implements the interface, then it returns a pointer to that interface after 
; calling IUnknown::AddRef on it.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * riid - A reference to the interface identifier (IID) of the interface being 
;   queried for.
;
; * ppvObject - The address of a pointer to an interface with the IID specified 
;   in the riid parameter. Because you pass the address of an interface pointer
;   the method can overwrite that address with the pointer to the interface 
;   being queried for. Upon successful return, *ppvObject (the dereferenced 
;   address) contains a pointer to the requested interface. If the object 
;   doesn't support the interface, the method sets *ppvObject (the dereferenced 
;   address) to nullptr.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; For any given COM object (also known as a COM component), a specific query 
; for the IUnknown interface on any of the object's interfaces must always 
; return the same pointer value. This enables a client to determine whether two 
; pointers point to the same component by calling QueryInterface with 
; IID_IUnknown and comparing the results. It is specifically not the case that 
; queries for interfaces other than IUnknown (even the same interface through 
; the same pointer) must return the same pointer value.
;
; See Also:
;
; MFPMediaItem_AddRef, MFPMediaItem_Release
;
;------------------------------------------------------------------------------
MFPMediaItem_QueryInterface PROC FRAME USES RBX pMediaItem:QWORD, riid:QWORD, ppvObject:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.QueryInterface, pMediaItem, riid, ppvObject
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_QueryInterface ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_AddRef
; 
; Increments the reference count for an interface pointer to a COM object. 
; You should call this method whenever you make a copy of an interface pointer.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; A COM object uses a per-interface reference-counting mechanism to ensure 
; that the object doesn't outlive references to it. You use AddRef to stabilize 
; a copy of an interface pointer. It can also be called when the life of a 
; cloned pointer must extend beyond the lifetime of the original pointer. The 
; cloned pointer must be released by calling IUnknown::Release on it.
;
; The internal reference counter that AddRef maintains should be a 32-bit 
; unsigned integer.
;
; See Also:
;
; MFPMediaItem_Release, MFPMediaItem_QueryInterface
;
;------------------------------------------------------------------------------
MFPMediaItem_AddRef PROC FRAME USES RBX pMediaItem:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.AddRef, pMediaItem
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_AddRef ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_Release
;
; Decrements the reference count for an interface on a COM object.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; When the reference count on an object reaches zero, Release must cause the 
; interface pointer to free itself. When the released pointer is the only 
; (formerly) outstanding reference to an object (whether the object supports 
; single or multiple interfaces), the implementation must free the object.
;
; See Also:
;
; MFPMediaItem_AddRef, MFPMediaItem_QueryInterface
;
;------------------------------------------------------------------------------
MFPMediaItem_Release PROC FRAME USES RBX pMediaItem:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.Release, pMediaItem
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_Release ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetMediaPlayer
; 
; Gets a pointer to the MFPlay player object (IMFPMediaPlayer) that created the 
; media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppMediaPlayer - pointer to a QWORD variable to store the pMediaPlayer 
;   object (IMFPMediaPlayer).
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; N/A
;
; See Also:
;
; MFPMediaPlayer_Init
;
;------------------------------------------------------------------------------
MFPMediaItem_GetMediaPlayer PROC FRAME USES RBX pMediaItem:QWORD, ppMediaPlayer:QWORD
    .IF pMediaItem == 0 || ppMediaPlayer == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetMediaPlayer, pMediaItem, ppMediaPlayer
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetMediaPlayer ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetURLA
; 
; Gets the URL that was used to create the media item. This is the Ansi version 
; of MFPMediaItem_GetURL. For the Wide/Unicode version see MFPMediaItem_GetURLW
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppszURL - pointed to a QWORD that holds a pointer to the URL string.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Use GlobalFree on the ppszURL once no longer required.
;
; See Also:
;
; MFPMediaItem_GetURLW
;
;------------------------------------------------------------------------------
MFPMediaItem_GetURLA PROC FRAME USES RBX pMediaItem:QWORD, ppszURL:QWORD
    LOCAL ppwszURL:QWORD
    
    .IF pMediaItem == 0 || ppszURL == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetURL, pMediaItem, Addr ppwszURL
    .IF rax == S_OK
        ; convert to Ansi
        Invoke _MFP_ConvertStringToAnsi, ppwszURL
        mov rbx, ppszURL
        mov [rbx], rax
        Invoke CoTaskMemFree, ppwszURL
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetURLA ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetURLW
; 
; Gets the URL that was used to create the media item. This is the Wide/Unicode
; version of MFPMediaItem_GetURL. For the Ansi version see MFPMediaItem_GetURLA
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppszURL - pointed to a QWORD that holds a pointer to the URL string.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Use GlobalFree on the ppszURL once no longer required.
;
; See Also:
;
; MFPMediaItem_GetURLA
;
;------------------------------------------------------------------------------
MFPMediaItem_GetURLW PROC FRAME USES RBX pMediaItem:QWORD, ppszURL:QWORD
    LOCAL ppwszURL:QWORD
    LOCAL gawszURL:QWORD
    LOCAL nlength:QWORD
    
    .IF pMediaItem == 0 || ppszURL == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetURL, pMediaItem, Addr ppwszURL
    .IF rax == S_OK
        Invoke lstrlenW, ppwszURL
        shl rax, 1 ; x2 for bytes
        mov nlength, rax
        add rax, 4 ; for null
        Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, rax
        mov gawszURL, rax
        Invoke RtlMoveMemory, gawszURL, ppwszURL, nlength
        mov rbx, ppszURL
        mov rax, gawszURL
        mov [rbx], rax
        Invoke CoTaskMemFree, ppwszURL
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetURLW ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetObject
; 
; Gets the object that was used to create the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppIUnknown - A pointer to a QWORD value used to store the object's IUnknown 
;   interface.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The caller must release the interface. 
;
; The object pointer is set if the application uses CreateMediaItemFromObject 
; to create the media item.
;
; See Also:
;
; MFPMediaPlayer_CreateMediaItemFromObject
;
;------------------------------------------------------------------------------
MFPMediaItem_GetObject PROC FRAME USES RBX pMediaItem:QWORD, ppIUnknown:QWORD
    .IF pMediaItem == 0 || ppIUnknown == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetObject, pMediaItem, ppIUnknown
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetObject ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_SetUserData
; 
; Stores an application-defined value in the media item.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * qwUserData - The application-defined value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; You can assign this value when you first create the media item, by specifying 
; it in the qwUserData parameter of the MFPMediaPlayer_CreateMediaItemFromURL or 
; MFPMediaPlayer_CreateMediaItemFromObject method. 
;
; See Also:
;
; MFPMediaItem_GetUserData
;
;------------------------------------------------------------------------------
MFPMediaItem_SetUserData PROC FRAME USES RBX pMediaItem:QWORD, qwUserData:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.SetUserData, pMediaItem, qwUserData
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetUserData ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetUserData
; 
; Gets the application-defined value stored in the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pqwUserData - A pointer to a QWORD used to store user data.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; You can assign this value when you first create the media item, by specifying 
; it in the qwUserData parameter of the MFPMediaPlayer_CreateMediaItemFromURL or 
; MFPMediaPlayer_CreateMediaItemFromObject method. To update the value, call 
; MFPMediaItem_SetUserData.
;
; See Also:
;
; MFPMediaItem_SetUserData
;
;------------------------------------------------------------------------------
MFPMediaItem_GetUserData PROC FRAME USES RBX pMediaItem:QWORD, pqwUserData:QWORD
    .IF pMediaItem == 0 || pqwUserData == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetUserData, pMediaItem, pqwUserData
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetUserData ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_SetStartStopPosition
; 
; Sets the start and stop times for the media item.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwStartValue - The start position to set in the media item, in milliseconds
;
; * dwStopValue - The stop position to set in the media item, in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the milliseconds values to nano seconds.
;
; See Also:
;
; MFPMediaItem_GetStartStopPosition, MFPMediaItem_GetDuration, 
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_SetPosition, 
; MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaItem_SetStartStopPosition PROC FRAME USES RBX pMediaItem:QWORD, dwStartValue:DWORD, dwStopValue:DWORD
    LOCAL StartValue:PROPVARIANT
    LOCAL StopValue:PROPVARIANT
    
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    
    mov rax, 0
    mov qword ptr [StartValue+00], rax
    mov qword ptr [StartValue+08], rax
    mov StartValue.vt, VT_I8
    mov qword ptr [StopValue+00], rax
    mov qword ptr [StopValue+08], rax
    mov StopValue.vt, VT_I8
    
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr StartValue, dwStartValue
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr StopValue, dwStopValue
    
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.SetStartStopPosition, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr StartValue, Addr MFP_POSITIONTYPE_100NS, Addr StopValue
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStartStopPosition ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetStartStopPosition
; 
; Gets the start and stop times for the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pdwStartValue - A pointer to a DWORD variable to store the start position 
;   of the media item, returned in milliseconds.
;
; * pdwStopValue - A pointer to a DWORD variable to store the stop position 
;   of the media item, returned in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the nano second time values to milliseconds. If an 
; error occurs the value of the milliseconds is set to -1.
;
; See Also:
;
; MFPMediaItem_SetStartStopPosition, MFPMediaItem_GetDuration, 
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_SetPosition, 
; MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaItem_GetStartStopPosition PROC FRAME USES RBX pMediaItem:QWORD, pdwStartValue:QWORD, pdwStopValue:QWORD
    LOCAL StartValue:PROPVARIANT
    LOCAL StopValue:PROPVARIANT
    LOCAL dwStartValue:DWORD
    LOCAL dwStopValue:DWORD

    mov rax, 0
    mov qword ptr [StartValue+00], rax
    mov qword ptr [StartValue+08], rax
    mov StartValue.vt, VT_I8
    mov qword ptr [StopValue+00], rax
    mov qword ptr [StopValue+08], rax
    mov StopValue.vt, VT_I8

    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetStartStopPosition, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr StartValue, Addr MFP_POSITIONTYPE_100NS, Addr StopValue
    .IF rax == S_OK
        .IF pdwStartValue != 0
            Invoke _MFP_Convert100NSValueToMSTime, Addr StartValue, Addr dwStartValue
            mov rbx, pdwStartValue
            xor rax, rax
            mov eax, dwStartValue
            mov [rbx], eax
        .ENDIF
        .IF pdwStopValue != 0
            Invoke _MFP_Convert100NSValueToMSTime, Addr StopValue, Addr dwStopValue
            mov rbx, pdwStopValue
            xor rax, rax
            mov eax, dwStopValue
            mov [rbx], eax
        .ENDIF
        mov rax, TRUE
    .ELSE
        .IF pdwStartValue != 0
            mov rbx, pdwStartValue
            mov rax, -1
            mov [rbx], rax
        .ENDIF
        .IF pdwStopValue != 0
            mov rbx, pdwStopValue
            mov rax, -1
            mov [rbx], rax
        .ENDIF
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStartStopPosition ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_HasVideo
; 
; Queries whether the media item contains a video stream.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbHasVideo - A pointer to a QWORD that contains TRUE or FALSE.
;
; * pbSelected - A pointer to a QWORD that contains TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; To select or deselect streams before playback starts, call 
; MFPMediaItem_SetStreamSelection.
;
; See Also:
;
; MFPMediaItem_HasAudio, MFPMediaItem_IsProtected
;
;------------------------------------------------------------------------------
MFPMediaItem_HasVideo PROC FRAME USES RBX pMediaItem:QWORD, pbHasVideo:QWORD, pbSelected:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.HasVideo, pMediaItem, pbHasVideo, pbSelected
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_HasVideo ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_HasAudio
; 
; Queries whether the media item contains an audio stream.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbHasAudio - A pointer to a QWORD that contains TRUE or FALSE.
;
; * pbSelected - A pointer to a QWORD that contains TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; To select or deselect streams before playback starts, call 
; MFPMediaItem_SetStreamSelection.
;
; See Also:
;
; MFPMediaItem_HasVideo, MFPMediaItem_IsProtected
;
;------------------------------------------------------------------------------
MFPMediaItem_HasAudio PROC FRAME USES RBX pMediaItem:QWORD, pbHasAudio:QWORD, pbSelected:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.HasAudio, pMediaItem, pbHasAudio, pbSelected
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_HasAudio ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_IsProtected
; 
; Queries whether the media item contains protected content.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbProtected - A pointer to a QWORD that contains TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; If media item contains protected content any attempt to play it will cause a 
; playback error.
;
; See Also:
;
; MFPMediaItem_HasAudio, MFPMediaItem_HasVideo
;
;------------------------------------------------------------------------------
MFPMediaItem_IsProtected PROC FRAME USES RBX pMediaItem:QWORD, pbProtected:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.IsProtected, pMediaItem, pbProtected
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_IsProtected ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetDuration
; 
; Gets the duration of the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pdwMilliseconds - A pointer to a QWORD variable to store the duration of 
;   the media item, returned in milliseconds.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; This function converts the nano second time value to milliseconds. If an 
; error occurs the value of the milliseconds is set to -1.
;
; See Also:
;
; MFPMediaItem_GetStartStopPosition, MFPMediaItem_SetStartStopPosition, 
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_SetPosition, 
; MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaItem_GetDuration PROC FRAME USES RBX pMediaItem:QWORD, pdwMilliseconds:QWORD
    LOCAL DurValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD

    mov rax, 0
    mov qword ptr [DurValue+00], rax
    mov qword ptr [DurValue+08], rax
    mov DurValue.vt, VT_I8

    .IF pMediaItem == 0 || pdwMilliseconds == 0
        mov rax, FALSE
        ret
    .ENDIF

    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetDuration, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr DurValue
    .IF rax == S_OK
        Invoke _MFP_Convert100NSValueToMSTime, Addr DurValue, Addr dwMilliseconds
        mov rbx, pdwMilliseconds
        xor rax, rax
        mov eax, dwMilliseconds
        mov [rbx], eax
        mov rax, TRUE
    .ELSE
        mov rbx, pdwMilliseconds
        mov rax, -1
        mov [rbx], rax
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetDuration ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetNumberOfStreams
; 
; Gets the number of streams (audio, video, and other) in the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pdwStreamCount - A pointer to a DWORD variable used to store the steam 
;   count of the media item.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; N/A
;
; See Also:
;
; MFPMediaItem_GetStreamSelection, MFPMediaItem_SetStreamSelection
;
;------------------------------------------------------------------------------
MFPMediaItem_GetNumberOfStreams PROC FRAME USES RBX pMediaItem:QWORD, pdwStreamCount:QWORD
    .IF pMediaItem == 0 || pdwStreamCount == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetNumberOfStreams, pMediaItem, pdwStreamCount
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetNumberOfStreams ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_SetStreamSelection
; 
; Selects or deselects a stream.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwStreamIndex - A zero based index of the stream.
;
; * bEnabled - TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; You can use this method to change which streams are selected. The change goes 
; into effect the next time that IMFPMediaPlayer::SetMediaItem is called with 
; this media item. If the media item is already set on the player, the change 
; does not happen unless you call SetMediaItem again with this media item.
;
; See Also:
;
; MFPMediaItem_GetStreamSelection, MFPMediaItem_GetNumberOfStreams
;
;------------------------------------------------------------------------------
MFPMediaItem_SetStreamSelection PROC FRAME USES RBX pMediaItem:QWORD, dwStreamIndex:DWORD, bEnabled:DWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.SetStreamSelection, pMediaItem, dwStreamIndex, bEnabled
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStreamSelection ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetStreamSelection
; 
; Queries whether a stream is selected to play.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwStreamIndex - A zero based index of the stream.
;
; * pbEnabled - A pointer to a DWORD that contains TRUE or FALSE.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; To select or deselect a stream, call MFPMediaItem_SetStreamSelection.
;
; See Also:
;
; MFPMediaItem_SetStreamSelection, MFPMediaItem_GetNumberOfStreams
;
;------------------------------------------------------------------------------
MFPMediaItem_GetStreamSelection PROC FRAME USES RBX pMediaItem:QWORD, dwStreamIndex:DWORD, pbEnabled:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetStreamSelection, pMediaItem, dwStreamIndex, pbEnabled
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStreamSelection ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetStreamAttribute
; 
; Queries the media item for a stream attribute.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwStreamIndex - Zero-based index of the stream.
;
; * guidMFAttribute - GUID that identifies the attribute value to query.
;
; * pvValue - Pointer to a PROPVARIANT that receives the value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Call PropVariantClear to free the memory allocated and stored in variable 
; pointed to by the pvValue parameter.
; 
; Includelib mfuuid.lib to reference the already defined and exported property 
; GUIDs in that library. 
;
; See Also:
;
; MFPMediaItem_GetPresentationAttribute, MFPMediaItem_GetCharacteristics
;
;------------------------------------------------------------------------------
MFPMediaItem_GetStreamAttribute PROC FRAME USES RBX pMediaItem:QWORD, dwStreamIndex:DWORD, guidMFAttribute:QWORD, pvValue:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetStreamAttribute, pMediaItem, dwStreamIndex, guidMFAttribute, pvValue
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStreamAttribute ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetPresentationAttribute
; 
; Queries the media item for a presentation attribute.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * guidMFAttribute - GUID that identifies the attribute value to query.
;
; * pvValue - Pointer to a PROPVARIANT that receives the value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Call PropVariantClear to free the memory allocated and stored in variable 
; pointed to by the pvValue parameter.
; 
; Includelib mfuuid.lib to reference the already defined and exported property 
; GUIDs in that library. 
;
; See Also:
;
; MFPMediaItem_GetStreamAttribute, MFPMediaItem_GetCharacteristics
;
;------------------------------------------------------------------------------
MFPMediaItem_GetPresentationAttribute PROC FRAME USES RBX pMediaItem:QWORD, guidMFAttribute:QWORD, pvValue:QWORD
    .IF pMediaItem == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetPresentationAttribute, pMediaItem, guidMFAttribute, pvValue
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetPresentationAttribute ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetCharacteristics
; 
; Gets various flags that describe the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pCharacteristics - a pointer to a QWORD variable to recieve the bitflags of
; the characteristics of the media item.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; The variable pointed to by the pCharacteristics parameter can contain a 
; combination of the following values: 
;
; * ``MFP_MEDIAITEM_IS_LIVE``
; * ``MFP_MEDIAITEM_CAN_SEEK``
; * ``MFP_MEDIAITEM_CAN_PAUSE``
; * ``MFP_MEDIAITEM_HAS_SLOW_SEEK``
;
; See Also:
;
; MFPMediaItem_GetPresentationAttribute, MFPMediaItem_GetStreamAttribute
;
;------------------------------------------------------------------------------
MFPMediaItem_GetCharacteristics PROC FRAME USES RBX pMediaItem:QWORD, pCharacteristics:QWORD
    .IF pMediaItem == 0 || pCharacteristics == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetCharacteristics, pMediaItem, pCharacteristics
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetCharacteristics ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_SetStreamSink
; 
; Sets a media sink for the media item. A media sink is an object that consumes 
; the data from one or more streams.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwStreamIndex - Zero-based index of a stream on the media source. The media 
;   sink will receive the data from this stream.
;
; * pMediaSink - IUnknown pointer that specifies the media sink. Pass in one of 
;   the following:
;
;   * A pointer to a stream sink. Every media sink contains one or more stream 
;     sinks. Each stream sink receives the data from one stream. The stream 
;     sink must expose the IMFStreamSink interface.
;
;   * A pointer to an activation object that creates the media sink. The 
;     activation object must expose the IMFActivate interface. The media item 
;     uses the first stream sink on the media sink (that is, the stream sink at 
;     index 0).
;
;   * NULL. If you set pMediaSink to NULL, the default media sink for the 
;     stream type is used.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; By default, the MFPlay player object renders audio streams to the Streaming 
; Audio Renderer (SAR) and video streams to the Enhanced Video Renderer (EVR).
;
; Call this method before calling MFPMediaItem_SetMediaItem. Calling this 
; method after SetMediaItem has no effect, unless you stop playback and call 
; SetMediaItem again.
;
; To reset the media item to use the default media sink, set pMediaSink to NULL
;
; See Also:
;
; MFPMediaItem_SetMediaItem
;
;------------------------------------------------------------------------------
MFPMediaItem_SetStreamSink PROC FRAME USES RBX pMediaItem:QWORD, dwStreamIndex:DWORD, pMediaSink:QWORD
    .IF pMediaItem == 0 || pMediaSink == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.SetStreamSink, pMediaItem, dwStreamIndex, pMediaSink
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStreamSink ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPMediaItem_GetMetadata
; 
; Gets a property store that contains metadata for the source, such as author 
; or title.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppMetadataStore - A pointer to a QWORD variable to store the pMetadataStore
;   object (IPropertyStore)
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; TRUE if successful or FALSE otherwise.
;
; The caller must release the interface.
;
; See Also:
;
; MFPMediaItem_GetCharacteristics, MFPMediaItem_GetPresentationAttribute, 
; MFPMediaItem_GetStreamAttribute
;
;------------------------------------------------------------------------------
MFPMediaItem_GetMetadata PROC FRAME USES RBX pMediaItem:QWORD, ppMetadataStore:QWORD
    .IF pMediaItem == 0 || ppMetadataStore == 0
        mov rax, FALSE
        ret
    .ENDIF
    mov rax, pMediaItem
    mov rbx, [rax]
    Invoke [rbx].IMFPMediaItemVtbl.GetMetadata, pMediaItem, ppMetadataStore
    .IF rax == S_OK
        mov rax, TRUE
    .ELSE
        mov rax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetMetadata ENDP


;==============================================================================
; Initialize Functions
;==============================================================================


ALIGN 8
;------------------------------------------------------------------------------
; IMFPMediaPlayerInit
;
; Initializes the IMFPMediaPlayer object and its methods.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Used to assign pointers to the various IMFPMediaPlayer methods to variables
; which are prototyped to the match the method parameters. This allows us to 
; use Invoke to call the methods directly. This function is called by the 
; MFPMediaPlayer_Init function.
;
; See Also:
;
; MFPMediaPlayer_Init, IMFPMediaItemInit
;
;------------------------------------------------------------------------------
IMFPMediaPlayerInit PROC FRAME USES RBX pMediaPlayer:QWORD
    
    .IF pMediaPlayer == 0
        jmp IMFPMediaPlayerInit_Error
    .ENDIF
    
    ; Get functions:
    mov rax, pMediaPlayer
    mov rbx, [rax]
    .IF rbx == 0
        IFDEF DEBUG64
        PrintText 'IMFPMediaPlayerInit pMediaPlayer::rbx == 0'
        ENDIF
        jmp IMFPMediaPlayerInit_Error
    .ENDIF
    
    mov rax, [rbx].IMFPMediaPlayerVtbl.QueryInterface
    mov IMFPMediaPlayer_QueryInterface, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.AddRef
    mov IMFPMediaPlayer_AddRef, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.Release
    mov IMFPMediaPlayer_Release, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.Play
    mov IMFPMediaPlayer_Play, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.Pause_
    mov IMFPMediaPlayer_Pause, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.Stop
    mov IMFPMediaPlayer_Stop, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.FrameStep
    mov IMFPMediaPlayer_FrameStep, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetPosition
    mov IMFPMediaPlayer_SetPosition, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetPosition
    mov IMFPMediaPlayer_GetPosition, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetDuration
    mov IMFPMediaPlayer_GetDuration, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetRate
    mov IMFPMediaPlayer_SetRate, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetRate
    mov IMFPMediaPlayer_GetRate, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetSupportedRates
    mov IMFPMediaPlayer_GetSupportedRates, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetState
    mov IMFPMediaPlayer_GetState, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.CreateMediaItemFromURL
    mov IMFPMediaPlayer_CreateMediaItemFromURL, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.CreateMediaItemFromObject
    mov IMFPMediaPlayer_CreateMediaItemFromObject, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetMediaItem
    mov IMFPMediaPlayer_SetMediaItem, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.ClearMediaItem
    mov IMFPMediaPlayer_ClearMediaItem, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetMediaItem
    mov IMFPMediaPlayer_GetMediaItem, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetVolume
    mov IMFPMediaPlayer_GetVolume, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetVolume
    mov IMFPMediaPlayer_SetVolume, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetBalance
    mov IMFPMediaPlayer_GetBalance, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetBalance
    mov IMFPMediaPlayer_SetBalance, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetMute
    mov IMFPMediaPlayer_GetMute, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetMute
    mov IMFPMediaPlayer_SetMute, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetNativeVideoSize
    mov IMFPMediaPlayer_GetNativeVideoSize, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetIdealVideoSize
    mov IMFPMediaPlayer_GetIdealVideoSize, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetVideoSourceRect
    mov IMFPMediaPlayer_SetVideoSourceRect, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetVideoSourceRect
    mov IMFPMediaPlayer_GetVideoSourceRect, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetAspectRatioMode
    mov IMFPMediaPlayer_SetAspectRatioMode, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetAspectRatioMode
    mov IMFPMediaPlayer_GetAspectRatioMode, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetVideoWindow
    mov IMFPMediaPlayer_GetVideoWindow, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.UpdateVideo
    mov IMFPMediaPlayer_UpdateVideo, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.SetBorderColor
    mov IMFPMediaPlayer_SetBorderColor, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.GetBorderColor
    mov IMFPMediaPlayer_GetBorderColor, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.InsertEffect
    mov IMFPMediaPlayer_InsertEffect, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.RemoveEffect
    mov IMFPMediaPlayer_RemoveEffect, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.RemoveAllEffects
    mov IMFPMediaPlayer_RemoveAllEffects, rax
    mov rax, [rbx].IMFPMediaPlayerVtbl.Shutdown
    mov IMFPMediaPlayer_Shutdown, rax

    jmp IMFPMediaPlayerInit_Exit

IMFPMediaPlayerInit_Error:
    
    mov rax, FALSE
    ret
    
IMFPMediaPlayerInit_Exit:
    
    mov rax, TRUE
    ret

IMFPMediaPlayerInit ENDP

ALIGN 8
;------------------------------------------------------------------------------
; IMFPMediaItemInit
;
; Initializes the IMFPMediaItem object and its methods.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Used to assign pointers to the various IMFPMediaItem methods to variables
; which are prototyped to the match the method parameters. This allows us to 
; use Invoke to call the methods directly.
;
; Probably easier to call the IMFPMedia_ functions directly instead of using 
; this function.
;
; See Also:
;
; IMFPMediaPlayerInit
;
;------------------------------------------------------------------------------
IMFPMediaItemInit PROC FRAME USES RBX pMediaItem:QWORD
    
    .IF pMediaItem == 0
        jmp IMFPMediaItemInit_Error
    .ENDIF
    
    ; Get functions:
    mov rax, pMediaItem
    mov rbx, [rax]
    .IF rbx == 0
        IFDEF DEBUG64
        PrintText 'IMFPMediaItemInit pMediaItem::rbx == 0'
        ENDIF
        jmp IMFPMediaItemInit_Error
    .ENDIF
    
    mov rax, [rbx].IMFPMediaItemVtbl.QueryInterface
    mov IMFPMediaItem_QueryInterface, rax
    mov rax, [rbx].IMFPMediaItemVtbl.AddRef
    mov IMFPMediaItem_AddRef, rax
    mov rax, [rbx].IMFPMediaItemVtbl.Release
    mov IMFPMediaItem_Release, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetMediaPlayer
    mov IMFPMediaItem_GetMediaPlayer, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetURL
    mov IMFPMediaItem_GetURL, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetObject
    mov IMFPMediaItem_GetObject, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetUserData
    mov IMFPMediaItem_GetUserData, rax
    mov rax, [rbx].IMFPMediaItemVtbl.SetUserData
    mov IMFPMediaItem_SetUserData, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetStartStopPosition
    mov IMFPMediaItem_GetStartStopPosition, rax
    mov rax, [rbx].IMFPMediaItemVtbl.SetStartStopPosition
    mov IMFPMediaItem_SetStartStopPosition, rax
    mov rax, [rbx].IMFPMediaItemVtbl.HasVideo
    mov IMFPMediaItem_HasVideo, rax
    mov rax, [rbx].IMFPMediaItemVtbl.HasAudio
    mov IMFPMediaItem_HasAudio, rax
    mov rax, [rbx].IMFPMediaItemVtbl.IsProtected
    mov IMFPMediaItem_IsProtected, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetDuration
    mov IMFPMediaItem_GetDuration, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetNumberOfStreams
    mov IMFPMediaItem_GetNumberOfStreams, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetStreamSelection
    mov IMFPMediaItem_GetStreamSelection, rax
    mov rax, [rbx].IMFPMediaItemVtbl.SetStreamSelection
    mov IMFPMediaItem_SetStreamSelection, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetStreamAttribute
    mov IMFPMediaItem_GetStreamAttribute, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetPresentationAttribute
    mov IMFPMediaItem_GetPresentationAttribute, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetCharacteristics
    mov IMFPMediaItem_GetCharacteristics, rax
    mov rax, [rbx].IMFPMediaItemVtbl.SetStreamSink
    mov IMFPMediaItem_SetStreamSink, rax
    mov rax, [rbx].IMFPMediaItemVtbl.GetMetadata
    mov IMFPMediaItem_GetMetadata, rax

    jmp IMFPMediaItemInit_Exit

IMFPMediaItemInit_Error:
    
    mov rax, FALSE
    ret
    
IMFPMediaItemInit_Exit:
    
    mov rax, TRUE
    ret

IMFPMediaItemInit ENDP


;==============================================================================
; Internal Functions
;==============================================================================

ALIGN 8
;------------------------------------------------------------------------------
; _MFP_Convert100NSValueToMSTime
;
; Converts PROPVARIANT nanoseconds value to milliseconds.
;
; Parameters:
;
; * pvValue - pointer to PROPVARIANT that holds the nanosecond value.
;
; * pdwMilliseconds - pointer to a DWORD to store the converted milliseconds.
;
; Returns:
;
; -1 if there is an error, otherwise returns the milliseconds value in rax.
;
; See Also:
;
; _MFP_ConvertMSTimeTo100NSValue, ConvertMSTimeToTimeString
;
;------------------------------------------------------------------------------
_MFP_Convert100NSValueToMSTime PROC FRAME USES RBX pvValue:QWORD, pdwMilliseconds:QWORD
    LOCAL qwTime:QWORD
    LOCAL dwTimeMS:DWORD

    .IF pvValue == 0 || pdwMilliseconds == 0
        mov rax, -1
        ret
    .ENDIF
    
    ; If high word of pvValue is >= 10000 then
    ; div wont be accurate, so most we return
    ; is -2 (4294967294 | FFFFFFFEh): 49d 17:02:47.29
    ;  (-1 is used for errors)
    mov rbx, pvValue
    xor rax, rax
    mov eax, dword ptr [rbx].PROPVARIANT.hVal.HighPart
    .IF sqword ptr rax >= 10000d
        IFDEF DEBUG64
        PrintText 'rax >= 10000d'
        ENDIF
        mov rax, -2 ; (FFFFFFFEh): 49d 17:02:47.29
        ret
    .ENDIF
    
    ; Convert 100ns units to milliseconds
    mov rbx, pvValue
    xor rax, rax
    mov eax, dword ptr [rbx].PROPVARIANT.hVal.LowPart
    mov dword ptr [qwTime+0], eax
    xor rax, rax
    mov eax, dword ptr [rbx].PROPVARIANT.hVal.HighPart
    mov dword ptr [qwTime+4], eax
    
    finit
    fwait
    fild qwTime
    fmul MFP_DIV10000
    fistp dwTimeMS
    IFDEF DEBUG64
    PrintDec dwTimeMS
    ENDIF
    
    mov rbx, pdwMilliseconds
    xor rax, rax
    mov eax, dwTimeMS
    mov [rbx], eax
    
    ret
_MFP_Convert100NSValueToMSTime ENDP

ALIGN 8
;------------------------------------------------------------------------------
; _MFP_ConvertMSTimeTo100NSValue
;
; Converts milliseconds to PROPVARIANT nanoseconds value.
;
; Parameters:
;
; * pvValue - pointer to PROPVARIANT that will hold the converted value.
;
; * pdwMilliseconds - milliseconds value to convert.
;
; Returns:
;
; -1 if there is an error, otherwise returns the milliseconds value in rax.
;
; See Also:
;
; _MFP_Convert100NSValueToMSTime, ConvertMSTimeToTimeString
;
;------------------------------------------------------------------------------
_MFP_ConvertMSTimeTo100NSValue PROC FRAME USES RBX pvValue:QWORD, dwMilliseconds:DWORD
    LOCAL qwTime:QWORD
    LOCAL dwTimeMS:DWORD
    LOCAL dwMSTo100NS:DWORD
    
    .IF pvValue == 0
        mov rax, -1
        ret
    .ENDIF
    
    ; Convert 100ns units to milliseconds
    mov eax, 10000d
    mov dwMSTo100NS, eax
    
    .IF dwMilliseconds != 0
        finit
        fwait
        fild dwMilliseconds
        fild dwMSTo100NS
        fmul
        fistp qwTime
        
        mov rbx, pvValue
        mov rax, 0
        mov qword ptr [rbx+00], rax
        mov qword ptr [rbx+08], rax
        
        xor rax, rax
        mov eax, dword ptr [qwTime+0]
        mov dword ptr [rbx].PROPVARIANT.hVal.LowPart, eax
        xor rax, rax
        mov eax, dword ptr [qwTime+4]
        mov dword ptr [rbx].PROPVARIANT.hVal.HighPart, eax
        mov word ptr [rbx].PROPVARIANT.vt, VT_I8
        
    .ELSE
        mov rbx, pvValue
        mov rax, 0
        mov qword ptr [rbx+00], rax
        mov qword ptr [rbx+08], rax
    .ENDIF
    
    mov eax, dwMilliseconds
    ret
_MFP_ConvertMSTimeTo100NSValue ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPConvertMSTimeToTimeStringA
;
; Converts a milliseconds value to a time string, which shows hours, minutes, 
; seconds and milliseconds. 
;
; Parameters:
;
; * dwMilliseconds - milliseconds value to convert.
;
; * lpszTime - pointer to string buffer to store the converted time.
;
; * dwTimeFormat - 0 to include milliseconds, 1 to exclude them.
;
; Returns:
;
; TRUE if succcesful or FALSE otherwise
;
; Notes:
;
; Ensure the string buffer pointed to by the lpszTime parameter is at least 16
; bytes long.
;
; See Also:
;
; _MFP_Convert100NSValueToMSTime, _MFP_ConvertMSTimeTo100NSValue
;
;------------------------------------------------------------------------------
MFPConvertMSTimeToTimeStringA PROC FRAME USES RBX RCX RDX RDI RSI dwMilliseconds:DWORD, lpszTime:QWORD, dwTimeFormat:DWORD
    LOCAL szDays[4]:BYTE
    LOCAL szHours[4]:BYTE
    LOCAL szMinutes[4]:BYTE
    LOCAL szSeconds[4]:BYTE
    LOCAL szMilliseconds[4]:BYTE
    LOCAL days:DWORD
    LOCAL hours:DWORD
    LOCAL minutes:DWORD
    LOCAL seconds:DWORD
    LOCAL milliseconds:DWORD
    LOCAL dwDays:DWORD
    LOCAL dwHours:DWORD
    LOCAL dwMinutes:DWORD
    LOCAL dwSeconds:DWORD
    
    .IF lpszTime == 0
        mov rax, FALSE
        ret
    .ENDIF
    
;    ;Invoke Div1000, dwTimeMS
;    mov rdi, dwMilliseconds
;    mov rdx, 2361183241434822607d
;    shr rdi, 3
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 4
;    mov dwSeconds, rax
    
    mov eax, dwMilliseconds
    mov edx, 274877907
    mul edx
    mov eax, edx
    shr eax, 6
    mov dwSeconds, eax
    
;    ;Invoke Div60, dwSeconds
;    mov rdi, dwSeconds
;    mov rdx, -8608480567731124087d
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 5
;    mov dwMinutes, rax
    
    mov eax, dwSeconds
    mov edx, -2004318071
    mul edx
    mov eax, edx
    shr eax, 5
    mov dwMinutes, eax
    
;    ;Invoke Div60, dwMinutes
;    mov rdi, dwMinutes
;    mov rdx, -8608480567731124087d
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 5
;    mov dwHours, rax
    
    mov eax, dwMinutes
    mov edx, -2004318071
    mul edx
    mov eax, edx
    shr eax, 5
    mov dwHours, eax
    
;    ;Invoke Div24, dwHours
;    mov rdi, dwHours
;    mov rdx, -6148914691236517205d ;movabs
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 4
;    mov days, rax
;    mov dwDays, rax
    
    mov eax, dwHours
    mov edx, -1431655765
    mul edx
    mov eax, edx
    shr eax, 4
    mov days, eax
    mov dwDays, eax
    
;    ;Invoke Rem1000, dwTimeMS
;    mov rdi, dwMilliseconds
;    mov rdx, 2361183241434822607d
;    mov rax, rdi
;    shr rax, 3
;    mul rdx
;    mov rax, rdx
;    shr rax, 4
;    imul rax, rax, 1000
;    sub rdi, rax
;    mov rax, rdi
;    mov milliseconds, rax
    
    mov eax, dwMilliseconds
    mov edx, 274877907
    mov  ecx, eax
    mul edx
    mov eax, edx
    shr eax, 6
    imul eax, eax, 1000
    sub ecx, eax
    mov eax, ecx
    mov milliseconds, eax
    
;    ;Invoke Rem60, dwSeconds
;    mov rdi, dwSeconds
;    mov rdx, -8608480567731124087d
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 5
;    mov rdx, rax
;    sal rdx, 4
;    sub rdx, rax
;    mov rax, rdi
;    sal rdx, 2
;    sub rax, rdx
;    mov seconds, rax
    
    mov eax, dwSeconds
    mov edx, -2004318071
    mov ecx, eax
    mul edx
    mov eax, edx
    shr eax, 5
    imul eax, eax, 60
    sub ecx, eax
    mov eax, ecx
    mov seconds, eax
    
;    ;Invoke Rem60, dwMinutes
;    mov rdi, dwMinutes
;    mov rdx, -8608480567731124087d
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 5
;    mov rdx, rax
;    sal rdx, 4
;    sub rdx, rax
;    mov rax, rdi
;    sal rdx, 2
;    sub rax, rdx
;    mov minutes, rax
    
    mov eax, dwMinutes
    mov edx, -2004318071
    mov ecx, eax
    mul edx
    mov eax, edx
    shr eax, 5
    imul eax, eax, 60
    sub ecx, eax
    mov eax, ecx
    mov minutes, eax
    
;    ;Invoke Rem24, dwHours
;    mov rdi, dwHours
;    mov rdx, -6148914691236517205d
;    mov rax, rdi
;    mul rdx
;    mov rax, rdx
;    shr rax, 4
;    lea rax, [rax+rax*2]
;    sal rax, 3
;    sub rdi, rax
;    mov rax, rdi
;    mov hours, rax
    
    mov eax, dwHours
    mov edx, -1431655765
    mov ecx, eax
    mul edx
    mov eax, edx
    shr eax, 4
    lea eax, [eax+eax*2]
    sal eax, 3
    sub ecx, eax
    mov eax, ecx
    mov hours, eax
    
    mov eax, 0
    lea rbx, szDays
    mov dword ptr [rbx], eax
    lea rbx, szHours
    mov dword ptr [rbx], eax
    lea rbx, szMinutes
    mov dword ptr [rbx], eax
    lea rbx, szSeconds
    mov dword ptr [rbx], eax
    lea rbx, szMilliseconds
    mov dword ptr [rbx], eax
    
    .IF days != 0 ; output: days, hours, minutes, seconds, milliseconds
        .IF sdword ptr days < 10
            lea rbx, szDays
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, days, rbx
        .ELSE
            Invoke _MFP_utoa_ex, days, Addr szDays
        .ENDIF
        
        .IF sdword ptr hours < 10
            lea rbx, szHours
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, hours, rbx
        .ELSE
            Invoke _MFP_utoa_ex, hours, Addr szHours
        .ENDIF
        
        .IF sdword ptr minutes < 10
            lea rbx, szMinutes
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, minutes, rbx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea rbx, szSeconds
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, seconds, rbx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea rbx, szMilliseconds
            mov byte ptr [rbx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [rbx+1], '0'
                inc rbx
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ELSE ; 100s
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
        
        ; 10 22:33:44:123
        mov rdi, lpszTime
        
        lea rsi, szDays
        movzx eax, word ptr [rsi]
        ; Days
        mov word ptr [rdi+0], ax
        ; Space
        mov byte ptr [rdi+2], ' '
        
        lea rsi, szHours
        movzx eax, word ptr [rsi]
        ; Hours
        mov word ptr [rdi+3], ax
        ; Colon
        mov byte ptr [rdi+5], ':'
        
        lea rsi, szMinutes
        movzx eax, word ptr [rsi]
        ; Minutes
        mov word ptr [rdi+6], ax
        ; Colon
        mov byte ptr [rdi+8], ':'
        
        lea rsi, szSeconds
        movzx eax, word ptr [rsi]
        ; Seconds
        mov word ptr [rdi+9], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [rdi+11], ':'
        
            lea rsi, szMilliseconds
            mov eax, dword ptr [rsi]
            ; Milliseconds
            mov dword ptr [rdi+12], eax
            ; null
            mov byte ptr [rdi+15], 0
        .ELSE
            mov byte ptr [rdi+11], 0
        .ENDIF
        
    .ELSEIF hours != 0 ; output: hours, minutes, seconds, milliseconds
        
        .IF sdword ptr hours < 10
            lea rbx, szHours
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, hours, rbx
        .ELSE
            Invoke _MFP_utoa_ex, hours, Addr szHours
        .ENDIF
        
        .IF sdword ptr minutes < 10
            lea rbx, szMinutes
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, minutes, rbx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea rbx, szSeconds
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, seconds, rbx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea rbx, szMilliseconds
            mov byte ptr [rbx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [rbx+1], '0'
                inc rbx
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ELSE ; 100s
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
    
        ; 22:33:44:123
        mov rdi, lpszTime

        lea rsi, szHours
        movzx eax, word ptr [rsi]
        ; Hours
        mov word ptr [rdi+0], ax
        ; Colon
        mov byte ptr [rdi+2], ':'
        
        lea rsi, szMinutes
        movzx eax, word ptr [rsi]
        ; Minutes
        mov word ptr [rdi+3], ax
        ; Colon
        mov byte ptr [rdi+5], ':'
        
        lea rsi, szSeconds
        movzx eax, word ptr [rsi]
        ; Seconds
        mov word ptr [rdi+6], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [rdi+8], ':'
        
            lea rsi, szMilliseconds
            mov eax, dword ptr [rsi]
            ; Milliseconds
            mov dword ptr [rdi+9], eax
            ; null
            mov byte ptr [rdi+12], 0
        .ELSE
            mov byte ptr [rdi+8], 0
        .ENDIF
        
    .ELSE ;IF minutes != 0 ; output: minutes, seconds, milliseconds

        .IF sdword ptr minutes < 10
            lea rbx, szMinutes
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, minutes, rbx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea rbx, szSeconds
            mov byte ptr [rbx], '0'
            inc rbx
            Invoke _MFP_utoa_ex, seconds, rbx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea rbx, szMilliseconds
            mov byte ptr [rbx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [rbx+1], '0'
                inc rbx
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ELSE ; 100s
                inc rbx
                Invoke _MFP_utoa_ex, milliseconds, rbx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
    
        ; 33:44:123
        mov rdi, lpszTime

        lea rsi, szMinutes
        movzx eax, word ptr [rsi]
        ; Minutes
        mov word ptr [rdi+0], ax
        ; Colon
        mov byte ptr [rdi+2], ':'
        
        lea rsi, szSeconds
        movzx eax, word ptr [rsi]
        ; Seconds
        mov word ptr [rdi+3], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [rdi+5], ':'
            
            lea rsi, szMilliseconds
            mov eax, dword ptr [rsi]
            ; Milliseconds
            mov dword ptr [rdi+6], eax
            ; null
            mov byte ptr [rdi+9], 0
        .ELSE
            mov byte ptr [rdi+5], 0
        .ENDIF
    .ENDIF
    
    mov eax, TRUE  
    ret
MFPConvertMSTimeToTimeStringA ENDP

ALIGN 8
;------------------------------------------------------------------------------
; MFPConvertMSTimeToTimeStringW
;
; Converts a milliseconds value to a time string, which shows hours, minutes, 
; seconds and milliseconds. 
;
; Parameters:
;
; * dwMilliseconds - milliseconds value to convert.
;
; * lpszTime - pointer to string buffer to store the converted time.
;
; * dwTimeFormat - 0 to include milliseconds, 1 to exclude them.
;
; Returns:
;
; TRUE if succcesful or FALSE otherwise
;
; Notes:
;
; Ensure the string buffer pointed to by the lpszTime parameter is at least 32
; bytes long.
;
; See Also:
;
; _MFP_Convert100NSValueToMSTime, _MFP_ConvertMSTimeTo100NSValue
;
;------------------------------------------------------------------------------
MFPConvertMSTimeToTimeStringW PROC FRAME USES RBX dwMilliseconds:DWORD, lpszTime:QWORD, dwTimeFormat:DWORD
    LOCAL szAnsiTime[24]:BYTE
    LOCAL pWideTime:QWORD
    
    .IF lpszTime == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    Invoke MFPConvertMSTimeToTimeStringA, dwMilliseconds, Addr szAnsiTime, dwTimeFormat
    .IF rax == TRUE
        Invoke _MFP_ConvertStringToWide, Addr szAnsiTime
        .IF eax != NULL
            mov pWideTime, rax
            Invoke lstrcpyW, lpszTime, pWideTime
            Invoke _MFP_ConvertStringFree, pWideTime
            mov rax, TRUE
        .ELSE
            mov rax, FALSE
        .ENDIF
    .ENDIF
    
    ret
MFPConvertMSTimeToTimeStringW ENDP

ALIGN 8
;------------------------------------------------------------------------------
; _MFP_ConvertStringToAnsi 
;
; Converts a Wide/Unicode string to an ANSI/UTF8 string.
;
; Parameters:
; 
; * lpszWideString - pointer to a wide string to convert to an Ansi string.
; 
; Returns:
; 
; A pointer to the Ansi string if successful, or NULL otherwise.
; 
; Notes:
;
; The string that is converted should be freed when it is no longer needed with 
; a call to the _MFP_ConvertStringFree function.
;
; See Also:
;
; _MFP_ConvertStringToWide, _MFP_ConvertStringFree
; 
;------------------------------------------------------------------------------
_MFP_ConvertStringToAnsi PROC FRAME lpszWideString:QWORD
    LOCAL dwAnsiStringSize:DWORD
    LOCAL lpszAnsiString:QWORD

    .IF lpszWideString == NULL
        mov rax, NULL
        ret
    .ENDIF
    Invoke WideCharToMultiByte, CP_UTF8, 0, lpszWideString, -1, NULL, 0, NULL, NULL
    .IF rax == 0
        ret
    .ENDIF
    mov dwAnsiStringSize, eax
    ;shl rax, 1 ; x2 to get non wide char count
    add rax, 4 ; add 4 for good luck and nulls
    Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, rax
    .IF rax == NULL
        ret
    .ENDIF
    mov lpszAnsiString, rax    
    Invoke WideCharToMultiByte, CP_UTF8, 0, lpszWideString, -1, lpszAnsiString, dwAnsiStringSize, NULL, NULL
    .IF rax == 0
        ret
    .ENDIF
    mov rax, lpszAnsiString
    ret
_MFP_ConvertStringToAnsi ENDP

ALIGN 8
;------------------------------------------------------------------------------
; _MFP_ConvertStringToWide
;
; Converts a Ansi string to an Wide/Unicode string.
;
; Parameters:
; 
; * lpszAnsiString - pointer to an Ansi string to convert to a Wide string.
; 
; Returns:
; 
; A pointer to the Wide string if successful, or NULL otherwise.
; 
; Notes:
;
; The string that is converted should be freed when it is no longer needed with 
; a call to the _MFP_ConvertStringFree function.
;
; See Also:
;
; _MFP_ConvertStringToAnsi, _MFP_ConvertStringFree
; 
;------------------------------------------------------------------------------
_MFP_ConvertStringToWide PROC FRAME lpszAnsiString:QWORD
    LOCAL dwWideStringSize:DWORD
    LOCAL lpszWideString:QWORD
    
    .IF lpszAnsiString == NULL
        mov rax, NULL
        ret
    .ENDIF
    Invoke MultiByteToWideChar, CP_UTF8, 0, lpszAnsiString, -1, NULL, 0
    .IF rax == 0
        ret
    .ENDIF
    mov dwWideStringSize, eax
    shl rax, 1 ; x2 to get non wide char count
    add rax, 4 ; add 4 for good luck and nulls
    Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, rax
    .IF rax == NULL
        ret
    .ENDIF
    mov lpszWideString, rax
    Invoke MultiByteToWideChar, CP_UTF8, 0, lpszAnsiString, -1, lpszWideString, dwWideStringSize
    .IF rax == 0
        ret
    .ENDIF
    mov rax, lpszWideString
    ret
_MFP_ConvertStringToWide ENDP

ALIGN 8
;------------------------------------------------------------------------------
; _MFP_ConvertStringFree
;
; Frees a string created by _MFP_ConvertStringToWide or
; _MFP_ConvertStringToAnsi
;
; Parameters:
; 
; * lpString - pointer to a converted string to free.
; 
; Returns:
; 
; None.
; 
; See Also:
;
; _MFP_ConvertStringToWide, _MFP_ConvertStringToAnsi
; 
;------------------------------------------------------------------------------
_MFP_ConvertStringFree PROC FRAME lpString:QWORD
    mov rax, lpString
    .IF rax == NULL
        mov rax, FALSE
        ret
    .ENDIF
    Invoke GlobalFree, rax
    mov rax, TRUE
    ret
_MFP_ConvertStringFree ENDP


ALIGN 8
;------------------------------------------------------------------------------
; _MFP_utoa_ex
;
; Convert unsigned value to ascii
;
; Parameters:
;
; * qwvalue - The variable that holds the unsigned value to convert to ascii.
;
; * pbuffer - Pointer to a buffer to hold the ascii string.
;
; Returns:
;
; None.
;
; Notes:
;
; This algorithm was written by Habrans 
; http://masm32.com/board/index.php?topic=4174.msg60108#msg60108. 
; Ensure the buffer is large enough.
;
; See Also:
;
; N/A
;
;------------------------------------------------------------------------------
_MFP_utoa_ex PROC FRAME USES RCX RDX R8 R9 R10 R11 qwvalue:QWORD, pbuffer:QWORD
    LOCAL tmpbuf[34]:BYTE

    mov rcx, qwvalue
    .if (!rcx)
        mov rax, pbuffer
        mov byte ptr[rax],'0'
        jmp _MFP_utoa_ex_done
    .endif 
    lea r9, tmpbuf[33]                     
    mov byte ptr tmpbuf[33],0
    lea r11, utoa_hextbl
    .repeat
        xor edx,edx                      ;clear rdx               
        mov rax, rcx                     ;value into rax
        dec r9                           ;make space for next char
        mov rcx, 10
        div rcx                          ;div value with radix (2, 8, 10, 16)
        mov rcx,rax                      ;mod is in rdx, save result back in rcx
        movzx eax,byte ptr [rdx+r11]     ;put char from hextbl pointed by rdx
        mov byte ptr [r9], al            ;store char from al to tmpbuf pointed by r9
    .until (!rcx)                        ;repeat if rcx not clear
    lea r8, tmpbuf[34]                   ;start of the buffer in r8
    sub r8, r9                           ;that will give a count of chars to be copied
    invoke RtlMoveMemory, pbuffer, r9, r8;call routine to copy
    mov rax, pbuffer                     ;return the address of the buffer in rax
    
_MFP_utoa_ex_done: 
    ret
_MFP_utoa_ex ENDP


;------------------------------------------------------------------------------
; IMFPMPCallback functions
;------------------------------------------------------------------------------
IMFPMPCallback_QueryInterfaceProc   PROTO pThis:QWORD, riid:QWORD, ppvObject:QWORD
IMFPMPCallback_AddRefProc           PROTO pThis:QWORD
IMFPMPCallback_ReleaseProc          PROTO pThis:QWORD

ALIGN 8
;------------------------------------------------------------------------------
; IMFPMPCallback_QueryInterfaceProc
;
; QueryInterface method of IMFPMPCallback
;
; Parameters:
;
; * pThis - pointer to this IMFPMPCallback object.
;
; * riid - A reference to the interface identifier (IID) of the interface being 
;   queried for.
;
; * ppvObject - The address of a pointer to an interface with the IID specified 
;   in the riid parameter. Because you pass the address of an interface pointer
;   the method can overwrite that address with the pointer to the interface 
;   being queried for. Upon successful return, *ppvObject (the dereferenced 
;   address) contains a pointer to the requested interface. If the object 
;   doesn't support the interface, the method sets *ppvObject (the dereferenced 
;   address) to nullptr.
;
; Returns:
;
; E_NOINTERFACE
;
; Notes:
;
; Used in MFPMediaPlayer_Init for the callback function address.
;
; See Also:
;
; IMFPMPCallback_AddRefProc, IMFPMPCallback_ReleaseProc
;
;------------------------------------------------------------------------------
IMFPMPCallback_QueryInterfaceProc PROC FRAME pThis:QWORD, riid:QWORD, ppvObject:QWORD
    mov rax, E_NOINTERFACE
    ret
IMFPMPCallback_QueryInterfaceProc ENDP

ALIGN 8
;------------------------------------------------------------------------------
; IMFPMPCallback_AddRefProc
;
; AddRef method of IMFPMPCallback
;
; Parameters:
;
; * pThis - pointer to this IMFPMPCallback object.
;
; Returns:
;
; 0
;
; Notes:
;
; Used in MFPMediaPlayer_Init for the callback function address.
;
; See Also:
;
; IMFPMPCallback_QueryInterfaceProc, IMFPMPCallback_ReleaseProc
;
;------------------------------------------------------------------------------
IMFPMPCallback_AddRefProc PROC FRAME pThis:QWORD
    xor rax, rax
    ret
IMFPMPCallback_AddRefProc ENDP

ALIGN 8
;------------------------------------------------------------------------------
; IMFPMPCallback_ReleaseProc
;
; Release method of IMFPMPCallback
;
; Parameters:
;
; * pThis - pointer to this IMFPMPCallback object.
;
; Returns:
;
; 0
;
; Notes:
;
; Used in MFPMediaPlayer_Init for the callback function address.
;
; See Also:
;
; IMFPMPCallback_QueryInterfaceProc, IMFPMPCallback_AddRefProc
;
;------------------------------------------------------------------------------
IMFPMPCallback_ReleaseProc PROC FRAME pThis:QWORD
    xor rax, rax
    ret
IMFPMPCallback_ReleaseProc ENDP



END






















