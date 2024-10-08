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
.model flat,stdcall
option casemap:none

;DEBUG32 EQU 1
;IFDEF DEBUG32
;    PRESERVEXMMREGS equ 1
;    includelib M:\Masm32\lib\Debug32.lib
;    DBG32LIB equ 1
;    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
;    include M:\Masm32\include\debug32.inc
;    include msvcrt.inc
;    includelib ucrt.lib
;    includelib vcruntime.lib
;ENDIF

include windows.inc

include user32.inc
includelib user32.lib

include kernel32.inc
includelib kernel32.lib

includelib ole32.lib
includelib shell32.lib

IFNDEF CoInitializeEx
CoInitializeEx PROTO pvReserved:DWORD, dwCoInit:DWORD
ENDIF
IFNDEF CoUninitialize
CoUninitialize PROTO
ENDIF
IFNDEF CoCreateInstance
CoCreateInstance PROTO rclsid:DWORD, pUnkOuter:DWORD, dwClsContext:DWORD, riid:DWORD, ppv:DWORD
ENDIF
IFNDEF CoTaskMemFree
CoTaskMemFree PROTO pv:DWORD
ENDIF
IFNDEF SHCreateItemFromParsingName
SHCreateItemFromParsingName PROTO pszPath:DWORD, pbc:DWORD, riid:DWORD, ppv:DWORD
ENDIF
IFNDEF MFPCreateMediaPlayer
MFPCreateMediaPlayer PROTO pwszURL:DWORD, fStartPlayback:DWORD, creationOptions:DWORD, pCallback:DWORD, hWnd:DWORD, ppMediaPlayer:DWORD
ENDIF
IFNDEF RtlCompareMemory
RtlCompareMemory PROTO Source1:DWORD, Source2:DWORD, dwLength:DWORD
ENDIF
IFNDEF PropVariantClear
PropVariantClear PROTO pvValue:DWORD
ENDIF

;includelib ntdll.lib

includelib MFPlay.lib

include MFPlayer.inc

;------------------------------------------------------------------------------
; Prototypes for internal use
;------------------------------------------------------------------------------
IMFPMediaPlayerInit             PROTO pMediaPlayer:DWORD
IMFPMediaItemInit               PROTO pMediaItem:DWORD

_MFP_GetMajorType               PROTO pGUID:DWORD
_MFP_GetAudioSubType            PROTO pGUID:DWORD
_MFP_GetVideoSubType            PROTO pGUID:DWORD

_MFP_MemoryCompare              PROTO pMemoryAddress1:DWORD, pMemoryAddress2:DWORD, dwMemoryLength:DWORD
_MFP_utoa_ex                    PROTO uvar:DWORD, pbuffer:DWORD
_MFP_Convert100NSValueToMSTime  PROTO pvValue:DWORD, pdwMilliseconds:DWORD
_MFP_ConvertMSTimeTo100NSValue  PROTO pvValue:DWORD, dwMilliseconds:DWORD

;------------------------------------------------------------------------------
; COM Prototypes
;------------------------------------------------------------------------------
; IUnknown:
IUnknown_QueryInterface_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, riid:DWORD, ppvObject:DWORD
IUnknown_AddRef_Proto                            TYPEDEF PROTO STDCALL pThis:DWORD
IUnknown_Release_Proto                           TYPEDEF PROTO STDCALL pThis:DWORD

; IMFPMediaPlayerCallback:
IMFPMediaPlayerCallback_OnMediaPlayerEvent_Proto TYPEDEF PROTO STDCALL pThis:DWORD, pEventHeader:DWORD

; IMFPMediaPlayer:
IMFPMediaPlayer_Play_Proto                       TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_Pause_Proto                      TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_Stop_Proto                       TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_FrameStep_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_SetPosition_Proto                TYPEDEF PROTO STDCALL pThis:DWORD, guidPositionType:DWORD, pvPositionValue:DWORD
IMFPMediaPlayer_GetPosition_Proto                TYPEDEF PROTO STDCALL pThis:DWORD, guidPositionType:DWORD, pvPositionValue:DWORD
IMFPMediaPlayer_GetDuration_Proto                TYPEDEF PROTO STDCALL pThis:DWORD, guidPositionType:DWORD, pvDurationValue:DWORD
IMFPMediaPlayer_SetRate_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, flRate:REAL4
IMFPMediaPlayer_GetRate_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, pflRate:DWORD
IMFPMediaPlayer_GetSupportedRates_Proto          TYPEDEF PROTO STDCALL pThis:DWORD, bForwardDirection:DWORD, pflSlowestRate:DWORD, pflFastestRate:DWORD
IMFPMediaPlayer_GetState_Proto                   TYPEDEF PROTO STDCALL pThis:DWORD, peState:DWORD
IMFPMediaPlayer_CreateMediaItemFromURL_Proto     TYPEDEF PROTO STDCALL pThis:DWORD, pwszURL:DWORD, fSync:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
IMFPMediaPlayer_CreateMediaItemFromObject_Proto  TYPEDEF PROTO STDCALL pThis:DWORD, pIUnknownObj:DWORD, fSync:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
IMFPMediaPlayer_SetMediaItem_Proto               TYPEDEF PROTO STDCALL pThis:DWORD, pIMFPMediaItem:DWORD
IMFPMediaPlayer_ClearMediaItem_Proto             TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_GetMediaItem_Proto               TYPEDEF PROTO STDCALL pThis:DWORD, ppIMFPMediaItem:DWORD
IMFPMediaPlayer_GetVolume_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, pflVolume:DWORD
IMFPMediaPlayer_SetVolume_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, flVolume:REAL4
IMFPMediaPlayer_GetBalance_Proto                 TYPEDEF PROTO STDCALL pThis:DWORD, pflBalance:DWORD
IMFPMediaPlayer_SetBalance_Proto                 TYPEDEF PROTO STDCALL pThis:DWORD, flBalance:REAL4
IMFPMediaPlayer_GetMute_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, pfMute:DWORD
IMFPMediaPlayer_SetMute_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, fMute:DWORD
IMFPMediaPlayer_GetNativeVideoSize_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pszVideo:DWORD, pszARVideo:DWORD
IMFPMediaPlayer_GetIdealVideoSize_Proto          TYPEDEF PROTO STDCALL pThis:DWORD, pszMin:DWORD, pszMax:DWORD
IMFPMediaPlayer_SetVideoSourceRect_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pnrcSource:DWORD
IMFPMediaPlayer_GetVideoSourceRect_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pnrcSource:DWORD
IMFPMediaPlayer_SetAspectRatioMode_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, dwAspectRatioMode:DWORD
IMFPMediaPlayer_GetAspectRatioMode_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pdwAspectRatioMode:DWORD
IMFPMediaPlayer_GetVideoWindow_Proto             TYPEDEF PROTO STDCALL pThis:DWORD, phwndVideo:DWORD
IMFPMediaPlayer_UpdateVideo_Proto                TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_SetBorderColor_Proto             TYPEDEF PROTO STDCALL pThis:DWORD, Color:DWORD
IMFPMediaPlayer_GetBorderColor_Proto             TYPEDEF PROTO STDCALL pThis:DWORD, pColor:DWORD
IMFPMediaPlayer_InsertEffect_Proto               TYPEDEF PROTO STDCALL pThis:DWORD, pEffect:DWORD, fOptional:DWORD
IMFPMediaPlayer_RemoveEffect_Proto               TYPEDEF PROTO STDCALL pThis:DWORD, pEffect:DWORD
IMFPMediaPlayer_RemoveAllEffects_Proto           TYPEDEF PROTO STDCALL pThis:DWORD
IMFPMediaPlayer_Shutdown_Proto                   TYPEDEF PROTO STDCALL pThis:DWORD

; IMFPMediaItem:
IMFPMediaItem_GetMediaPlayer_Proto               TYPEDEF PROTO STDCALL pThis:DWORD, ppMediaPlayer:DWORD
IMFPMediaItem_GetURL_Proto                       TYPEDEF PROTO STDCALL pThis:DWORD, ppwszURL:DWORD
IMFPMediaItem_GetObject_Proto                    TYPEDEF PROTO STDCALL pThis:DWORD, ppIUnknown:DWORD
IMFPMediaItem_GetUserData_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, pdwUserData:DWORD
IMFPMediaItem_SetUserData_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, dwUserData:DWORD
IMFPMediaItem_GetStartStopPosition_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pguidStartPositionType:DWORD, pvStartValue:DWORD, pguidStopPositionType:DWORD, pvStopValue:DWORD
IMFPMediaItem_SetStartStopPosition_Proto         TYPEDEF PROTO STDCALL pThis:DWORD, pguidStartPositionType:DWORD, pvStartValue:DWORD, pguidStopPositionType:DWORD, pvStopValue:DWORD
IMFPMediaItem_HasVideo_Proto                     TYPEDEF PROTO STDCALL pThis:DWORD, pfHasVideo:DWORD, pfSelected:DWORD
IMFPMediaItem_HasAudio_Proto                     TYPEDEF PROTO STDCALL pThis:DWORD, pfHasAudio:DWORD, pfSelected:DWORD
IMFPMediaItem_IsProtected_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, pfProtected:DWORD
IMFPMediaItem_GetDuration_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, guidPositionType:DWORD, pvDurationValue:DWORD
IMFPMediaItem_GetNumberOfStreams_Proto           TYPEDEF PROTO STDCALL pThis:DWORD, pdwStreamCount:DWORD
IMFPMediaItem_GetStreamSelection_Proto           TYPEDEF PROTO STDCALL pThis:DWORD, dwStreamIndex:DWORD, pfEnabled:DWORD
IMFPMediaItem_SetStreamSelection_Proto           TYPEDEF PROTO STDCALL pThis:DWORD, dwStreamIndex:DWORD, fEnabled:DWORD
IMFPMediaItem_GetStreamAttribute_Proto           TYPEDEF PROTO STDCALL pThis:DWORD, dwStreamIndex:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
IMFPMediaItem_GetPresentationAttribute_Proto     TYPEDEF PROTO STDCALL pThis:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
IMFPMediaItem_GetCharacteristics_Proto           TYPEDEF PROTO STDCALL pThis:DWORD, pCharacteristics:DWORD
IMFPMediaItem_SetStreamSink_Proto                TYPEDEF PROTO STDCALL pThis:DWORD, dwStreamIndex:DWORD, pMediaSink:DWORD
IMFPMediaItem_GetMetadata_Proto                  TYPEDEF PROTO STDCALL pThis:DWORD, ppMetadataStore:DWORD

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
IUnknownVtbl                  STRUCT
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
IUnknownVtbl                  ENDS
ENDIF

IFNDEF IMFPMediaPlayerCallbackVtbl
IMFPMediaPlayerCallbackVtbl   STRUCT
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
    OnMediaPlayerEvent        IMFPMediaPlayerCallback_OnMediaPlayerEvent_Ptr 0
IMFPMediaPlayerCallbackVtbl   ENDS
ENDIF

IFNDEF IMFPMPCallback
IMFPMPCallback              STRUCT
    QueryInterface          DWORD IMFPMPCallback_QueryInterfaceProc
    AddRef                  DWORD IMFPMPCallback_AddRefProc
    Release                 DWORD IMFPMPCallback_ReleaseProc
    OnMediaPlayerEvent      DWORD 0
IMFPMPCallback              ENDS
ENDIF

IFNDEF IMFPMediaPlayerVtbl
IMFPMediaPlayerVtbl           STRUCT
    QueryInterface            IUnknown_QueryInterface_Ptr 0
    AddRef                    IUnknown_AddRef_Ptr 0
    Release                   IUnknown_Release_Ptr 0
    Play                      IMFPMediaPlayer_Play_Ptr 0
    Pause                     IMFPMediaPlayer_Pause_Ptr 0
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
IMFPMediaItemVtbl             STRUCT
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
GUID        STRUCT
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
PROPVARIANT     STRUCT
    vt          DW ?
    wReserved1  DW ?
    wReserved2  DW ?
    wReserved3  DW ?
    UNION
        hVal LARGE_INTEGER <>
        uhVal ULARGE_INTEGER <>
        uint64Val QWORD ?
        fltVal FLOAT ?
        uintVal DWORD ?
        pwszVal DWORD ?
        pszVal DWORD ?
        boolVal DWORD ?
        puuid DWORD ?
        ; etc
    ENDS
PROPVARIANT     ENDS
ENDIF

.CONST

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
HRESULT TYPEDEF DWORD
ENDIF
IFNDEF MFP_CREATION_OPTIONS
MFP_CREATION_OPTIONS TYPEDEF DWORD
ENDIF
IFNDEF MFP_MEDIAPLAYER_STATE
MFP_MEDIAPLAYER_STATE TYPEDEF DWORD
ENDIF
IFNDEF MFP_MEDIAITEM_CHARACTERISTICS
MFP_MEDIAITEM_CHARACTERISTICS TYPEDEF DWORD
ENDIF
IFNDEF MFP_CREDENTIAL_FLAGS
MFP_CREDENTIAL_FLAGS TYPEDEF DWORD
ENDIF
IFNDEF MFP_EVENT_TYPE
MFP_EVENT_TYPE TYPEDEF DWORD
ENDIF
IFNDEF MediaEventType
MediaEventType TYPEDEF DWORD
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
;------------------------------------------------------------------------------
; Function Pointers
;------------------------------------------------------------------------------
szStream                DB "S",0,"t",0,"r",0,"e",0,"a",0,"m",0," ",0,0,0,0,0


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
pIMFPMediaPlayerCallback    DWORD sIMFPMediaPlayerCallback
                            DWORD 0 ; count?


MFP_POSITIONTYPE_100NS             GUID <00000000,0000,0000,<00,00,00,00,00,00,00,00>>

MF_SD_LANGUAGE                     GUID <000AF2180h,0BDC2h,0423Ch,<0ABh,0CAh,0F5h,003h,059h,03Bh,0C1h,021h>>
MF_MT_MAJOR_TYPE                   GUID <048EBA18Eh,0F8C9h,04687h,<0BFh,011h,00Ah,074h,0C9h,0F9h,06Ah,08Fh>>
MF_MT_SUBTYPE                      GUID <0F7E34C9Ah,042E8h,04714h,<0B7h,04Bh,0CBh,029h,0D7h,02Ch,035h,0E5h>>
MF_MT_AUDIO_AVG_BYTES_PER_SECOND   GUID <01AAB75C8h,0CFEFh,0451Ch,<0ABh,095h,0ACh,003h,04Bh,08Eh,017h,031h>>
MF_MT_AUDIO_NUM_CHANNELS           GUID <037E48BF5h,0645Eh,04C5Bh,<089h,0DEh,0ADh,0A9h,0E2h,09Bh,069h,06Ah>>
MF_MT_AUDIO_CHANNEL_MASK           GUID <055FB5765h,0644Ah,04CAFh,<084h,079h,093h,089h,083h,0BBh,015h,088h>>
MF_MT_AUDIO_BITS_PER_SAMPLE        GUID <0F2DEB57Fh,040FAh,04764h,<0AAh,033h,0EDh,04Fh,02Dh,01Fh,0F6h,069h>>
MF_MT_AUDIO_SAMPLES_PER_SECOND     GUID <05FAEEAE7h,00290h,04C31h,<09Eh,08Ah,0C5h,034h,0F6h,08Dh,09Dh,0BAh>>
MF_MT_AVG_BITRATE                  GUID <020332624h,0FB0Dh,04D9Eh,<0BDh,00Dh,0CBh,0F6h,078h,06Ch,010h,02Eh>>
MF_MT_FRAME_SIZE                   GUID <01652C33Dh,0D6B2h,04012h,<0B8h,034h,072h,003h,008h,049h,0A3h,07Dh>>
MF_MT_FRAME_RATE                   GUID <0C459A2E8h,03D2Ch,04E44h,<0B1h,032h,0FEh,0E5h,015h,06Ch,07Bh,0B0h>>
MF_MT_INTERLACE_MODE               GUID <0E2724BB8h,0E676h,04806h,<0B4h,0B2h,0A8h,0D6h,0EFh,0B4h,04Ch,0CDh>>

; Media Major Types: https://www.magnumdb.com/search?q=filename%3A%22mfapi.h%22+MFMediaType_*
MFMediaType_Default                GUID <081A412E6h,08103h,04B06h,<085h,07Fh,018h,062h,078h,010h,024h,0ACh>>
MFMediaType_Audio                  GUID <073647561h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFMediaType_Video                  GUID <073646976h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFMediaType_Protected              GUID <07B4B6FE6h,09D04h,04494h,<0BEh,014h,07Eh,00Bh,0D0h,076h,0C8h,0E4h>>
MFMediaType_SAMI                   GUID <0E69669A0h,03DCDh,040CBh,<09Eh,02Eh,037h,008h,038h,07Ch,006h,016h>>
MFMediaType_Script                 GUID <072178C22h,0E45Bh,011D5h,<0BCh,02Ah,000h,0B0h,0D0h,0F3h,0F4h,0ABh>>
MFMediaType_Image                  GUID <072178C23h,0E45Bh,011D5h,<0BCh,02Ah,000h,0B0h,0D0h,0F3h,0F4h,0ABh>>
MFMediaType_HTML                   GUID <072178C24h,0E45Bh,011D5h,<0BCh,02Ah,000h,0B0h,0D0h,0F3h,0F4h,0ABh>>
MFMediaType_Binary                 GUID <072178C25h,0E45Bh,011D5h,<0BCh,02Ah,000h,0B0h,0D0h,0F3h,0F4h,0ABh>>
MFMediaType_FileTransfer           GUID <072178C26h,0E45Bh,011D5h,<0BCh,02Ah,000h,0B0h,0D0h,0F3h,0F4h,0ABh>>
MFMediaType_Stream                 GUID <0E436EB83h,0524Fh,011CEh,<09Fh,053h,000h,020h,0AFh,00Bh,0A7h,070h>>
MFMediaType_MultiplexedFrames      GUID <06EA542B0h,0281Fh,04231h,<0A4h,064h,0FEh,02Fh,050h,022h,050h,01Ch>>
MFMediaType_Subtitle               GUID <0A6D13581h,0ED50h,04E65h,<0AEh,008h,026h,006h,055h,076h,0AAh,0CCh>>
MFMediaType_Perception             GUID <0597FF6F9h,06EA2h,04670h,<085h,0B4h,0EAh,084h,007h,03Fh,0E9h,040h>>
MFMediaType_Metadata               GUID <02C8FA20Ch,082BBh,04782h,<090h,0A0h,098h,0A2h,0A5h,0BDh,08Eh,0F8h>>

; Audio Subtypes: https://www.magnumdb.com/search?q=filename%3A%22mfapi.h%22+MFAudioFormat_*
MFAudioFormat_Base                 GUID <000000000h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_PCM                  GUID <000000001h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_Float                GUID <000000003h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_DTS                  GUID <000000008h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_Dolby_AC3_SPDIF      GUID <000000092h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_DRM                  GUID <000000009h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_WMAudioV8            GUID <000000161h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_WMAudioV9            GUID <000000162h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_WMAudio_Lossless     GUID <000000163h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_WMASPDIF             GUID <000000164h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_MSP1                 GUID <00000000Ah,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_MP3                  GUID <000000055h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_MPEG                 GUID <000000050h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_AAC                  GUID <000001610h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_ADTS                 GUID <000001600h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_AMR_NB               GUID <000007361h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_AMR_WB               GUID <000007362h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_AMR_WP               GUID <000007363h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_FLAC                 GUID <00000F1ACh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_ALAC                 GUID <000006C61h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_Opus                 GUID <00000704Fh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_Dolby_AC4            GUID <00000AC40h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFAudioFormat_Dolby_AC3            GUID <0E06D802Ch,0DB46h,011CFh,<0B4h,0D1h,000h,080h,05Fh,06Ch,0BBh,0EAh>>
MFAudioFormat_Dolby_DDPlus         GUID <0A7FB87AFh,02D02h,042FBh,<0A4h,0D4h,005h,0CDh,093h,084h,03Bh,0DDh>>
MFAudioFormat_Dolby_AC4_V1         GUID <036B7927Ch,03D87h,04A2Ah,<091h,096h,0A2h,01Ah,0D9h,0E9h,035h,0E6h>>
MFAudioFormat_Dolby_AC4_V2         GUID <07998B2A0h,017DDh,049B6h,<08Dh,0FAh,09Bh,027h,085h,052h,0A2h,0ACh>>
MFAudioFormat_Dolby_AC4_V1_ES      GUID <09D8DCCC6h,0D156h,04FB8h,<097h,09Ch,0A8h,05Bh,0E7h,0D2h,01Dh,0FAh>>
MFAudioFormat_Dolby_AC4_V2_ES      GUID <07E58C9F9h,0B070h,045F4h,<08Ch,0CDh,0A9h,09Ah,004h,017h,0C1h,0ACh>>
MFAudioFormat_MPEGH                GUID <07C13C441h,0EBF8h,04931h,<0B6h,078h,080h,00Bh,019h,024h,022h,036h>>
MFAudioFormat_MPEGH_ES             GUID <019EE97FEh,01BE0h,04255h,<0A8h,076h,0E9h,09Fh,053h,0A4h,02Ah,0E3h>>
MFAudioFormat_Vorbis               GUID <08D2FD10Bh,05841h,04A6Bh,<089h,005h,058h,08Fh,0ECh,01Ah,0DEh,0D9h>>
MFAudioFormat_DTS_RAW              GUID <0E06D8033h,0DB46h,011CFh,<0B4h,0D1h,000h,080h,05Fh,06Ch,0BBh,0EAh>>
MFAudioFormat_DTS_HD               GUID <0A2E58EB7h,00FA9h,048BBh,<0A4h,00Ch,0FAh,00Eh,015h,06Dh,006h,045h>>
MFAudioFormat_DTS_XLL              GUID <045B37C1Bh,08C70h,04E59h,<0A7h,0BEh,0A1h,0E4h,02Ch,081h,0C8h,00Dh>>
MFAudioFormat_DTS_LBR              GUID <0C2FE6F0Ah,04E3Ch,04DF1h,<09Bh,060h,050h,086h,030h,091h,0E4h,0B9h>>
MFAudioFormat_DTS_UHD              GUID <087020117h,0ACE3h,042DEh,<0B7h,03Eh,0C6h,056h,070h,062h,063h,0F8h>>
MFAudioFormat_DTS_UHDY             GUID <09B9CCA00h,091B9h,04CCCh,<088h,03Ah,08Fh,078h,07Ah,0C3h,0CCh,086h>>
MFAudioFormat_Float_SpatialObjects GUID <0FA39CD94h,0BC64h,04AB1h,<09Bh,071h,0DCh,0D0h,09Dh,05Ah,07Eh,07Ah>>
MFAudioFormat_LPCM                 GUID <0E06D8032h,0DB46h,011CFh,<0B4h,0D1h,000h,080h,05Fh,06Ch,0BBh,0EAh>>
MFAudioFormat_PCM_HDCP             GUID <0A5E7FF01h,08411h,04ACCh,<0A8h,065h,05Fh,049h,041h,028h,08Dh,080h>>
MFAudioFormat_Dolby_AC3_HDCP       GUID <097663A80h,08FFBh,04445h,<0A6h,0BAh,079h,02Dh,090h,08Fh,049h,07Fh>>
MFAudioFormat_AAC_HDCP             GUID <0419BCE76h,08B72h,0400Fh,<0ADh,0EBh,084h,0B5h,07Dh,063h,048h,04Dh>>
MFAudioFormat_ADTS_HDCP            GUID <0DA4963A3h,014D8h,04DCFh,<092h,0B7h,019h,03Eh,0B8h,043h,063h,0DBh>>
MFAudioFormat_Base_HDCP            GUID <03884B5BCh,0E277h,043FDh,<098h,03Dh,003h,08Ah,0A8h,0D9h,0B6h,005h>>

; Video Subtypes: https://www.magnumdb.com/search?q=filename%3A%22mfapi.h%22+MFVideoFormat_*
MFVideoFormat_Base                 GUID <000000000h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>

MFVideoFormat_MP43                 GUID <03334504Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MP4S                 GUID <05334504Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_M4S2                 GUID <03253344Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MP4V                 GUID <05634504Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_WMV1                 GUID <031564D57h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_WMV2                 GUID <032564D57h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_WMV3                 GUID <033564D57h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_WVC1                 GUID <031435657h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MSS1                 GUID <03153534Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MSS2                 GUID <03253534Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MPG1                 GUID <03147504Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DVSL                 GUID <06C737664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DVSD                 GUID <064737664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DVHD                 GUID <064687664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DV25                 GUID <035327664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DV50                 GUID <030357664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DVH1                 GUID <031687664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_DVC                  GUID <020637664h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_H264                 GUID <034363248h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_H265                 GUID <035363248h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_MJPG                 GUID <047504A4Dh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_420O                 GUID <04F303234h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_HEVC                 GUID <043564548h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_HEVC_ES              GUID <053564548h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_VP80                 GUID <030385056h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_VP90                 GUID <030395056h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_ORAW                 GUID <05741524Fh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_H263                 GUID <033363248h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_VP10                 GUID <030315056h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_AV1                  GUID <031305641h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Theora               GUID <06F656874h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_H264_ES              GUID <03F40F4F0h,05622h,04FF8h,<0B6h,0D8h,0A1h,07Ah,058h,04Bh,0EEh,05Eh>>
MFVideoFormat_MPEG2                GUID <0E06D8026h,0DB46h,011CFh,<0B4h,0D1h,000h,080h,05Fh,06Ch,0BBh,0EAh>>
MFVideoFormat_H264_HDCP            GUID <05D0CE9DDh,09817h,049DAh,<0BDh,0FDh,0F5h,0F5h,0B9h,08Fh,018h,0A6h>>
MFVideoFormat_HEVC_HDCP            GUID <03CFE0FE6h,005C4h,047DCh,<09Dh,070h,04Bh,0DBh,029h,059h,072h,00Fh>>
MFVideoFormat_Base_HDCP            GUID <0EAC3B9D5h,0BD14h,04237h,<08Fh,01Fh,0BAh,0B4h,028h,0E4h,093h,012h>>
MFVideoFormat_MPG2                 GUID <0E06D8026h,0DB46h,011CFh,<0B4h,0D1h,000h,080h,05Fh,06Ch,0BBh,0EAh>>

; Pixel Formats:
MFVideoFormat_RGB32                GUID <000000016h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_ARGB32               GUID <000000015h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_RGB24                GUID <000000014h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_RGB555               GUID <000000018h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_RGB565               GUID <000000017h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_RGB8                 GUID <000000029h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_A2R10G10B10          GUID <00000001Fh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_A16B16G16R16F        GUID <000000071h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_L8                   GUID <000000032h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_L16                  GUID <000000051h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_D16                  GUID <000000050h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_AI44                 GUID <034344941h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_AYUV                 GUID <056555941h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_YUY2                 GUID <032595559h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_YVYU                 GUID <055595659h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_YVU9                 GUID <039555659h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_UYVY                 GUID <059565955h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_NV11                 GUID <03131564Eh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_NV12                 GUID <03231564Eh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_NV21                 GUID <03132564Eh,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_YV12                 GUID <032315659h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_I420                 GUID <030323449h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_IYUV                 GUID <056555949h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y210                 GUID <030313259h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y216                 GUID <036313259h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y410                 GUID <030313459h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y416                 GUID <036313459h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y41P                 GUID <050313459h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y41T                 GUID <054313459h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_Y42T                 GUID <054323459h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_P210                 GUID <030313250h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_P216                 GUID <036313250h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_P010                 GUID <030313050h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_P016                 GUID <036313050h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_v210                 GUID <030313276h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_v216                 GUID <036313276h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>
MFVideoFormat_v410                 GUID <030313476h,00000h,00010h,<080h,000h,000h,0AAh,000h,038h,09Bh,071h>>


; https://gix.github.io/media-types/

MFP_DIV100                  REAL4 0.01
MFP_DIV125                  REAL4 0.008
MFP_DIV1000                 REAL4 0.001
MFP_DIV10000                REAL4 0.0001
MFP_MUL100                  REAL4 100.0
MFP_MUL1000                 REAL4 1000.0
R1                          REAL4 1.0

.CODE

ALIGN 4
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
; * ppMediaPlayer - pointer to a DWORD value to store the pMediaPlayer.
;
; Returns:
;
; Stores a pMediaPlayer object in the DWORD pointer to by the ppMediaPlayer
; parameter, or 0 if an error occurred. Returns in eax TRUE if successful or
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
MFPMediaPlayer_Init PROC USES EBX hMFPWindow:DWORD, pCallback:DWORD, ppMediaPlayer:DWORD
    LOCAL pMediaPlayer:DWORD
    
    mov pMediaPlayer, 0
    
    Invoke CoInitializeEx, NULL, COINIT_APARTMENTTHREADED
    
    .IF pCallback != 0
        lea ebx, sIMFPMediaPlayerCallback
        mov eax, pCallback
        mov [ebx].IMFPMPCallback.OnMediaPlayerEvent, eax
        
        IFDEF DEBUG32
        PrintText 'MFPMediaPlayer_Init MFPCreateMediaPlayer'
        ENDIF        
        
        Invoke MFPCreateMediaPlayer, NULL, FALSE, MFP_OPTION_NONE, Addr pIMFPMediaPlayerCallback, hMFPWindow, Addr pMediaPlayer
    .ELSE
        IFDEF DEBUG32
        PrintText 'MFPMediaPlayer_Init MFPCreateMediaPlayer'
        ENDIF      
        Invoke MFPCreateMediaPlayer, NULL, FALSE, MFP_OPTION_NONE, NULL, hMFPWindow, Addr pMediaPlayer
    .ENDIF
    .IF eax != S_OK
        IFDEF DEBUG32
        PrintText 'MFPMediaPlayer_Init MFPCreateMediaPlayer Failed'
        ENDIF
        jmp MFPMediaPlayer_Init_Error
    .ENDIF
    
    Invoke IMFPMediaPlayerInit, pMediaPlayer
    .IF eax == FALSE
        IFDEF DEBUG32
        PrintText 'MFPMediaPlayer_Init IMFPMediaPlayerInit Failed'
        ENDIF
        jmp MFPMediaPlayer_Init_Error
    .ENDIF

    IFDEF DEBUG32
    PrintText 'MFPMediaPlayer_Init Success'
    PrintDec pMediaPlayer
    ENDIF

    jmp MFPMediaPlayer_Init_Exit

MFPMediaPlayer_Init_Error:
    
    .IF ppMediaPlayer != 0
        mov ebx, ppMediaPlayer
        mov eax, 0
        mov [ebx], eax
    .ENDIF
    
    Invoke CoUninitialize
    mov eax, FALSE
    ret
    
MFPMediaPlayer_Init_Exit:
    
    .IF ppMediaPlayer != 0
        mov ebx, ppMediaPlayer
        mov eax, pMediaPlayer
        mov [ebx], eax
    .ENDIF
    mov eax, TRUE
    ret

MFPMediaPlayer_Init ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaPlayer_Free
;
; Shuts down the MFPlay IMFPMediaPlayer COM object and frees any resources 
; used by it. 
;
; Parameters:
;
; * ppMediaPlayer - pointer to a DWORD value that contains pMediaPlayer. The 
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
MFPMediaPlayer_Free PROC USES EBX ppMediaPlayer:DWORD
    LOCAL pMediaPlayer:DWORD
    
    .IF ppMediaPlayer != 0
        mov ebx, ppMediaPlayer
        mov eax, [ebx]
        .IF eax != 0
            mov pMediaPlayer, eax
            Invoke IMFPMediaPlayer_Shutdown, pMediaPlayer
            Invoke IMFPMediaPlayer_Release, pMediaPlayer
            mov ebx, ppMediaPlayer
            mov eax, 0
            mov [ebx], eax
            Invoke CoUninitialize
        .ENDIF
    .ENDIF
    ret
MFPMediaPlayer_Free ENDP

ALIGN 4
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
MFPMediaPlayer_Play PROC pMediaPlayer:DWORD
    LOCAL dwState:DWORD
    LOCAL hWindow:DWORD
    LOCAL pMediaItem:DWORD
    LOCAL bVideo:DWORD
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    ; Added code to show video window, if state is stopped and play is invoked.
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF eax != S_OK
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, dwState
    .IF eax == MFP_MEDIAPLAYER_STATE_STOPPED || eax == MFP_MEDIAPLAYER_STATE_PAUSED
        
        ; Added code to check for video or audio track, dont show window if audio
        Invoke MFPMediaPlayer_GetMediaItem, pMediaPlayer, Addr pMediaItem
        .IF eax == TRUE   
            Invoke MFPMediaItem_HasVideo, pMediaItem, Addr bVideo, NULL
            Invoke MFPMediaItem_Release, pMediaItem
        .ELSE
            mov bVideo, FALSE
        .ENDIF
        mov hWindow, 0
        .IF bVideo == TRUE
            Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
            .IF eax == S_OK && hWindow != 0
                Invoke ShowWindow, hWindow, SW_SHOWNA
            .ENDIF
        .ELSE
            Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
            .IF eax == S_OK && hWindow != 0
                Invoke ShowWindow, hWindow, SW_HIDE
            .ENDIF
        .ENDIF
        
    .ENDIF
    
    Invoke IMFPMediaPlayer_Play, pMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Play ENDP

ALIGN 4
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
MFPMediaPlayer_Pause PROC pMediaPlayer:DWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF eax != S_OK
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, dwState
    .IF eax == MFP_MEDIAPLAYER_STATE_PLAYING
        Invoke IMFPMediaPlayer_Pause, pMediaPlayer
    .ENDIF
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Pause ENDP

ALIGN 4
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
MFPMediaPlayer_Stop PROC pMediaPlayer:DWORD
    LOCAL hWindow:DWORD
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_Stop, pMediaPlayer
    .IF eax == S_OK
        ; Added code to hide window once stopped
        mov hWindow, 0
        Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
        .IF eax == S_OK && hWindow != 0
            Invoke ShowWindow, hWindow, SW_HIDE
        .ENDIF
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Stop ENDP

ALIGN 4
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
MFPMediaPlayer_Step PROC pMediaPlayer:DWORD
    LOCAL dwState:DWORD
    LOCAL hWindow:DWORD
    LOCAL pMediaItem:DWORD
    LOCAL bVideo:DWORD

    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    ; Added code to show video window, if state is stopped and step is invoked.
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF eax != S_OK
        mov eax, FALSE
        ret
    .ENDIF

    Invoke IMFPMediaPlayer_FrameStep, pMediaPlayer
    .IF eax == S_OK
        mov eax, dwState ; if previously was stopped or paused, show window
        .IF eax == MFP_MEDIAPLAYER_STATE_STOPPED || eax == MFP_MEDIAPLAYER_STATE_PAUSED

            ; Added code to check for video or audio track, dont show window if audio
            Invoke MFPMediaPlayer_GetMediaItem, pMediaPlayer, Addr pMediaItem
            .IF eax == TRUE   
                Invoke MFPMediaItem_HasVideo, pMediaItem, Addr bVideo, NULL
                Invoke MFPMediaItem_Release, pMediaItem
            .ELSE
                mov bVideo, FALSE
            .ENDIF            
            mov hWindow, 0
            .IF bVideo == TRUE
                Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
                .IF eax == S_OK && hWindow != 0
                    Invoke ShowWindow, hWindow, SW_SHOWNA
                .ENDIF
            .ELSE
                Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, Addr hWindow
                .IF eax == S_OK && hWindow != 0
                    Invoke ShowWindow, hWindow, SW_HIDE
                .ENDIF
            .ENDIF
        .ENDIF
    
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Step ENDP

ALIGN 4
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
MFPMediaPlayer_Toggle PROC pMediaPlayer:DWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov dwState, MFP_MEDIAPLAYER_STATE_EMPTY
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF eax != S_OK
        mov eax, FALSE
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

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaPlayer_GetState
;
; Obtains the current state of the MFPlay Media Player.
;
; Parameters:
;
; * pMediaPlayer - A pointer to the Media Player (IMFPMediaPlayer) object.
;
; * pState - pointer to a DWORD value to store the state of the Media Player.
;
; Returns:
;
; TRUE if successful or FALSE otherwise. The DWORD pointer to by the pState
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
MFPMediaPlayer_GetState PROC USES EBX pMediaPlayer:DWORD, pState:DWORD
    LOCAL dwState:DWORD
    
    .IF pMediaPlayer == 0 || pState == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetState, pMediaPlayer, Addr dwState
    .IF eax == S_OK
        mov ebx, pState
        mov eax, dwState
        mov [ebx], eax
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetState ENDP

ALIGN 4
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
MFPMediaPlayer_ClearMediaItem PROC pMediaPlayer:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_ClearMediaItem, pMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_ClearMediaItem ENDP

ALIGN 4
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
MFPMediaPlayer_SetMediaItem PROC pMediaPlayer:DWORD, pMediaItem:DWORD
    .IF pMediaPlayer == 0 || pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetMediaItem, pMediaPlayer, pMediaItem
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetMediaItem ENDP

ALIGN 4
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
MFPMediaPlayer_GetMediaItem PROC pMediaPlayer:DWORD, ppMediaItem:DWORD
    .IF pMediaPlayer == 0 || ppMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetMediaItem, pMediaPlayer, ppMediaItem
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetMediaItem ENDP

ALIGN 4
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
; * dwUserData - A dword value used as custom data.
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
MFPMediaPlayer_CreateMediaItemA PROC USES EBX pMediaPlayer:DWORD, lpszMediaItem:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
    LOCAL pMediaItem:DWORD
    LOCAL lpszWideMediaItem:DWORD    
    
    .IF pMediaPlayer == 0 || lpszMediaItem == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
        ret
    .ENDIF
    
    mov lpszWideMediaItem, 0
    
    Invoke MFPConvertStringToWide, lpszMediaItem
    mov lpszWideMediaItem, eax

    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromURL, pMediaPlayer, lpszWideMediaItem, TRUE, dwUserData, Addr pMediaItem
    .IF eax == S_OK
        .IF lpszWideMediaItem != 0
            Invoke MFPConvertStringFree, lpszWideMediaItem
        .ENDIF
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, pMediaItem
            mov [ebx], eax
        .ENDIF
        mov eax, TRUE
    .ELSE
        .IF lpszWideMediaItem != 0
            Invoke MFPConvertStringFree, lpszWideMediaItem
        .ENDIF
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
    .ENDIF    
    ret
MFPMediaPlayer_CreateMediaItemA ENDP

ALIGN 4
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
; * dwUserData - A dword value used as custom data.
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
MFPMediaPlayer_CreateMediaItemW PROC USES EBX pMediaPlayer:DWORD, lpszMediaItem:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
    LOCAL pMediaItem:DWORD

    .IF pMediaPlayer == 0 || lpszMediaItem == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
        ret
    .ENDIF

    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromURL, pMediaPlayer, lpszMediaItem, TRUE, dwUserData, Addr pMediaItem
    .IF eax == S_OK
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, pMediaItem
            mov [ebx], eax
        .ENDIF
        mov eax, TRUE
    .ELSE
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
    .ENDIF    
    ret
MFPMediaPlayer_CreateMediaItemW ENDP

ALIGN 4
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
; * dwUserData - A dword value used as custom data.
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
MFPMediaPlayer_CreateMediaItemFromObject PROC pMediaPlayer:DWORD, pIUnknownObj:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
    LOCAL pMediaItem:DWORD

    .IF pMediaPlayer == 0 || pIUnknownObj == 0 || ppMediaItem == 0
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
        ret
    .ENDIF
    
    mov pMediaItem, 0
    Invoke IMFPMediaPlayer_CreateMediaItemFromObject, pMediaPlayer, pIUnknownObj, TRUE, dwUserData, Addr pMediaItem
    .IF eax == S_OK
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, pMediaItem
            mov [ebx], eax
        .ENDIF
        mov eax, TRUE
    .ELSE
        .IF ppMediaItem != 0
            mov ebx, ppMediaItem
            mov eax, 0
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
    .ENDIF  
    
    ret
MFPMediaPlayer_CreateMediaItemFromObject ENDP

ALIGN 4
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
MFPMediaPlayer_SetPosition PROC USES EBX pMediaPlayer:DWORD, dwMilliseconds:DWORD
    LOCAL PosValue:PROPVARIANT
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov eax, 0
    mov dword ptr [PosValue+00], eax
    mov dword ptr [PosValue+04], eax
    mov dword ptr [PosValue+08], eax
    mov dword ptr [PosValue+12], eax
    mov PosValue.vt, VT_I8
    
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr PosValue, dwMilliseconds
    
    Invoke IMFPMediaPlayer_SetPosition, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr PosValue
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetPosition ENDP

ALIGN 4
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
MFPMediaPlayer_GetPosition PROC USES EBX pMediaPlayer:DWORD, pdwMilliseconds:DWORD
    LOCAL PosValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD

    mov eax, 0
    mov dword ptr [PosValue+00], eax
    mov dword ptr [PosValue+04], eax
    mov dword ptr [PosValue+08], eax
    mov dword ptr [PosValue+12], eax
    mov PosValue.vt, VT_I8
    
    .IF pMediaPlayer == 0 || pdwMilliseconds == 0
        mov eax, FALSE
        ret
    .ENDIF

    Invoke IMFPMediaPlayer_GetPosition, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr PosValue
    .IF eax == S_OK
        Invoke _MFP_Convert100NSValueToMSTime, Addr PosValue, Addr dwMilliseconds
        mov ebx, pdwMilliseconds
        mov eax, dwMilliseconds
        mov [ebx], eax
        mov eax, TRUE
    .ELSE
        mov ebx, pdwMilliseconds
        mov eax, -1
        mov [ebx], eax
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetPosition ENDP

ALIGN 4
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
MFPMediaPlayer_GetDuration PROC USES EBX pMediaPlayer:DWORD, pdwMilliseconds:DWORD
    LOCAL DurValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD
    
    IFDEF DEBUG32
    PrintText 'MFPMediaPlayer_GetDuration'
    ENDIF
    
    mov eax, 0
    mov dword ptr [DurValue+00], eax
    mov dword ptr [DurValue+04], eax
    mov dword ptr [DurValue+08], eax
    mov dword ptr [DurValue+12], eax
    mov DurValue.vt, VT_I8
    
    .IF pMediaPlayer == 0 || pdwMilliseconds == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    Invoke IMFPMediaPlayer_GetDuration, pMediaPlayer, Addr MFP_POSITIONTYPE_100NS, Addr DurValue
    .IF eax == S_OK
        IFDEF DEBUG32
        lea eax, DurValue
        DbgDump eax, SIZEOF PROPVARIANT
        ENDIF
        Invoke _MFP_Convert100NSValueToMSTime, Addr DurValue, Addr dwMilliseconds
        mov ebx, pdwMilliseconds
        mov eax, dwMilliseconds
        mov [ebx], eax
        mov eax, TRUE
    .ELSE
        mov ebx, pdwMilliseconds
        mov eax, -1
        mov [ebx], eax
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetDuration ENDP

ALIGN 4
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
; 1000 indicates normal playback speed, 500 indicates half speed, and 2000 
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
MFPMediaPlayer_SetRate PROC pMediaPlayer:DWORD, dwRate:DWORD
    LOCAL fRate:REAL4
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    finit
    fwait
    fild dwRate
    fmul MFP_DIV1000 ;MFP_DIV100
    ;fild dw100
    ;fdiv
    fstp fRate
    
    Invoke IMFPMediaPlayer_SetRate, pMediaPlayer, fRate
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetRate ENDP

ALIGN 4
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
; 1000 indicates normal playback speed, 500 indicates half speed, and 2000 
; indicates twice speed, etc.
;
; See Also:
;
; MFPMediaPlayer_SetRate, MFPMediaPlayer_GetSupportedRates
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetRate PROC USES EBX pMediaPlayer:DWORD, pdwRate:DWORD
    LOCAL fRate:REAL4
    LOCAL dwRate:DWORD
    
    .IF pMediaPlayer == 0 || pdwRate == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetRate, pMediaPlayer, Addr fRate
    .IF eax == S_OK
        finit
        fwait
        fld fRate 
        fmul MFP_MUL1000 ;MFP_MUL100
        fistp dword ptr dwRate

        mov ebx, pdwRate
        mov eax, dwRate
        mov [ebx], eax
        
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetRate ENDP

ALIGN 4
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
; 1000 indicates normal playback speed, 500 indicates half speed, and 2000
; indicates twice speed, etc.
;
; See Also:
;
; MFPMediaPlayer_GetRate, MFPMediaPlayer_SetRate
;
;------------------------------------------------------------------------------
MFPMediaPlayer_GetSupportedRates PROC USES EBX pMediaPlayer:DWORD, bForwardDirection:DWORD, pdwSlowestRate:DWORD, pdwFastestRate:DWORD
    LOCAL fSlowestRate:REAL4
    LOCAL fFastestRate:REAL4
    LOCAL dwSlowestRate:DWORD
    LOCAL dwFastestRate:DWORD

    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov dwSlowestRate, 1000
    mov dwFastestRate, 1000
    
    Invoke IMFPMediaPlayer_GetSupportedRates, pMediaPlayer, bForwardDirection, Addr fSlowestRate, Addr fFastestRate
    .IF eax == S_OK
    
        .IF pdwSlowestRate != 0
            finit
            fwait
            fld fSlowestRate 
            fmul MFP_MUL1000 ;MFP_MUL100
            fistp dword ptr dwSlowestRate
    
            mov ebx, pdwSlowestRate
            mov eax, dwSlowestRate
            mov [ebx], eax
        .ENDIF
        
        .IF pdwFastestRate != 0
            finit
            fwait
            fld fFastestRate 
            fmul MFP_MUL1000 ;MFP_MUL100
            fistp dword ptr dwFastestRate
    
            mov ebx, pdwFastestRate
            mov eax, dwFastestRate
            mov [ebx], eax
        .ENDIF
        
        mov eax, TRUE
    .ELSE
        .IF pdwSlowestRate != 0
            mov ebx, pdwSlowestRate
            mov eax, dwSlowestRate
            mov [ebx], eax
        .ENDIF
        .IF pdwFastestRate != 0
            mov ebx, pdwFastestRate
            mov eax, dwFastestRate
            mov [ebx], eax
        .ENDIF
        
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetSupportedRates ENDP

ALIGN 4
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
MFPMediaPlayer_GetVolume PROC USES EBX pMediaPlayer:DWORD, pdwVolume:DWORD
    LOCAL fVolume:REAL4
    LOCAL dwVolume:DWORD
    
    .IF pMediaPlayer == 0 || pdwVolume == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVolume, pMediaPlayer, Addr fVolume
    .IF eax == S_OK
        finit
        fwait
        fld fVolume
        fmul MFP_MUL100
        fistp dword ptr dwVolume

        mov ebx, pdwVolume
        mov eax, dwVolume
        mov [ebx], eax
        
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVolume ENDP

ALIGN 4
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
MFPMediaPlayer_SetVolume PROC pMediaPlayer:DWORD, dwVolume:DWORD
    LOCAL fVolume:REAL4
    
    .IF pMediaPlayer == 0
        mov eax, FALSE
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
        ;fild dw100
        ;fdiv
    .ENDIF
    fstp fVolume
    
    Invoke IMFPMediaPlayer_SetVolume, pMediaPlayer, fVolume
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetVolume ENDP

ALIGN 4
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
MFPMediaPlayer_GetBalance PROC pMediaPlayer:DWORD, pdwBalance:DWORD
    LOCAL fBalance:REAL4
    LOCAL dwBalance:DWORD
    
    .IF pMediaPlayer == 0 || pdwBalance == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetBalance, pMediaPlayer, Addr fBalance
    .IF eax == S_OK
        finit
        fwait
        fld fBalance
        fmul MFP_MUL100
        fistp dword ptr dwBalance

        mov ebx, pdwBalance
        mov eax, dwBalance
        mov [ebx], eax
        
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetBalance ENDP

ALIGN 4
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
MFPMediaPlayer_SetBalance PROC pMediaPlayer:DWORD, dwBalance:SDWORD
    LOCAL fBalance:REAL4

    .IF pMediaPlayer == 0
        mov eax, FALSE
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
        ;fild dw100
        ;fdiv
    .ENDIF
    fstp fBalance
    
    Invoke IMFPMediaPlayer_SetBalance, pMediaPlayer, fBalance
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetBalance ENDP

ALIGN 4
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
MFPMediaPlayer_GetMute PROC pMediaPlayer:DWORD, pbMute:DWORD
    .IF pMediaPlayer == 0 || pbMute == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetMute, pMediaPlayer, pbMute
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetMute ENDP

ALIGN 4
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
MFPMediaPlayer_SetMute PROC pMediaPlayer:DWORD, bMute:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetMute, pMediaPlayer, bMute
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetMute ENDP

ALIGN 4
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
MFPMediaPlayer_GetNativeVideoSize PROC pMediaPlayer:DWORD, pszVideo:DWORD, pszARVideo:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetNativeVideoSize, pMediaPlayer, pszVideo, pszARVideo
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetNativeVideoSize ENDP

ALIGN 4
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
MFPMediaPlayer_GetIdealVideoSize PROC pMediaPlayer:DWORD, pszMin:DWORD, pszMax:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetIdealVideoSize, pMediaPlayer, pszMin, pszMax
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetIdealVideoSize ENDP

ALIGN 4
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
MFPMediaPlayer_SetVideoSourceRect PROC pMediaPlayer:DWORD, pnrcSource:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetVideoSourceRect, pMediaPlayer, pnrcSource
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetVideoSourceRect ENDP

ALIGN 4
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
MFPMediaPlayer_GetVideoSourceRect PROC pMediaPlayer:DWORD, pnrcSource:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVideoSourceRect, pMediaPlayer, pnrcSource
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVideoSourceRect ENDP

ALIGN 4
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
MFPMediaPlayer_GetVideoWindow PROC pMediaPlayer:DWORD, phwndVideo:DWORD
    .IF pMediaPlayer == 0 || phwndVideo == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetVideoWindow, pMediaPlayer, phwndVideo
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetVideoWindow ENDP

ALIGN 4
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
MFPMediaPlayer_UpdateVideo PROC pMediaPlayer:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_UpdateVideo, pMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_UpdateVideo ENDP

ALIGN 4
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
MFPMediaPlayer_SetBorderColor PROC pMediaPlayer:DWORD, Color:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetBorderColor, pMediaPlayer, Color
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetBorderColor ENDP

ALIGN 4
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
MFPMediaPlayer_GetBorderColor PROC pMediaPlayer:DWORD, pColor:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetBorderColor, pMediaPlayer, pColor
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetBorderColor ENDP

ALIGN 4
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
MFPMediaPlayer_InsertEffect PROC pMediaPlayer:DWORD, pEffect:DWORD, bOptional:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_InsertEffect, pMediaPlayer, pEffect, bOptional
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_InsertEffect ENDP

ALIGN 4
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
MFPMediaPlayer_RemoveEffect PROC pMediaPlayer:DWORD, pEffect:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_RemoveEffect, pMediaPlayer, pEffect
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_RemoveEffect ENDP

ALIGN 4
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
MFPMediaPlayer_RemoveAllEffects PROC pMediaPlayer:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_RemoveAllEffects, pMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_RemoveAllEffects ENDP

ALIGN 4
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
MFPMediaPlayer_Shutdown PROC pMediaPlayer:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_Shutdown, pMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_Shutdown ENDP

ALIGN 4
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
; dwAspectRatioMode can contain a combination of the following:
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
MFPMediaPlayer_SetAspectRatioMode PROC pMediaPlayer:DWORD, dwAspectRatioMode:DWORD
    .IF pMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_SetAspectRatioMode, pMediaPlayer, dwAspectRatioMode
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_SetAspectRatioMode ENDP

ALIGN 4
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
; The variable pointed to by the pdwAspectRatioMode parameter can contain a 
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
MFPMediaPlayer_GetAspectRatioMode PROC pMediaPlayer:DWORD, pdwAspectRatioMode:DWORD
    .IF pMediaPlayer == 0 || pdwAspectRatioMode == 0
        mov eax, FALSE
        ret
    .ENDIF
    Invoke IMFPMediaPlayer_GetAspectRatioMode, pMediaPlayer, pdwAspectRatioMode
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaPlayer_GetAspectRatioMode ENDP



;==============================================================================
; MFPMediaItem Functions
;==============================================================================

ALIGN 4
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
MFPMediaItem_QueryInterface PROC USES EBX pMediaItem:DWORD, riid:DWORD, ppvObject:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.QueryInterface, pMediaItem, riid, ppvObject
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_QueryInterface ENDP

ALIGN 4
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
MFPMediaItem_AddRef PROC USES EBX pMediaItem:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.AddRef, pMediaItem
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_AddRef ENDP

ALIGN 4
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
MFPMediaItem_Release PROC USES EBX pMediaItem:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.Release, pMediaItem
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_Release ENDP

ALIGN 4
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
; * ppMediaPlayer - pointer to a DWORD variable to store the pMediaPlayer 
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
MFPMediaItem_GetMediaPlayer PROC USES EBX pMediaItem:DWORD, ppMediaPlayer:DWORD
    .IF pMediaItem == 0 || ppMediaPlayer == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetMediaPlayer, pMediaItem, ppMediaPlayer
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetMediaPlayer ENDP

ALIGN 4
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
; * ppszURL - pointed to a DWORD that holds a pointer to the URL string.
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
MFPMediaItem_GetURLA PROC USES EBX pMediaItem:DWORD, ppszURL:DWORD
    LOCAL ppwszURL:DWORD
    
    .IF pMediaItem == 0 || ppszURL == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetURL, pMediaItem, Addr ppwszURL
    .IF eax == S_OK
        ; convert to Ansi
        Invoke MFPConvertStringToAnsi, ppwszURL
        mov ebx, ppszURL
        mov [ebx], eax
        Invoke CoTaskMemFree, ppwszURL
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetURLA ENDP

ALIGN 4
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
; * ppszURL - pointed to a DWORD that holds a pointer to the URL string.
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
MFPMediaItem_GetURLW PROC USES EBX pMediaItem:DWORD, ppszURL:DWORD
    LOCAL ppwszURL:DWORD
    LOCAL gawszURL:DWORD
    LOCAL nlength:DWORD
    
    .IF pMediaItem == 0 || ppszURL == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetURL, pMediaItem, Addr ppwszURL
    .IF eax == S_OK
        Invoke lstrlenW, ppwszURL
        shl eax, 1 ; x2 for bytes
        mov nlength, eax
        add eax, 4 ; for null
        Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, eax
        mov gawszURL, eax
        Invoke RtlMoveMemory, gawszURL, ppwszURL, nlength
        mov ebx, ppszURL
        mov eax, gawszURL
        mov [ebx], eax
        Invoke CoTaskMemFree, ppwszURL
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetURLW ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_GetObject
; 
; Gets the object that was used to create the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * ppIUnknown - A pointer to a DWORD value used to store the object's IUnknown 
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
MFPMediaItem_GetObject PROC USES EBX pMediaItem:DWORD, ppIUnknown:DWORD
    .IF pMediaItem == 0 || ppIUnknown == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetObject, pMediaItem, ppIUnknown
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetObject ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_SetUserData
; 
; Stores an application-defined value in the media item.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * dwUserData - The application-defined value.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; You can assign this value when you first create the media item, by specifying 
; it in the dwUserData parameter of the MFPMediaPlayer_CreateMediaItemFromURL or 
; MFPMediaPlayer_CreateMediaItemFromObject method. 
;
; See Also:
;
; MFPMediaItem_GetUserData
;
;------------------------------------------------------------------------------
MFPMediaItem_SetUserData PROC USES EBX pMediaItem:DWORD, dwUserData:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.SetUserData, pMediaItem, dwUserData
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetUserData ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_GetUserData
; 
; Gets the application-defined value stored in the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pdwUserData - A pointer to a DWORD used to store user data.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; You can assign this value when you first create the media item, by specifying 
; it in the dwUserData parameter of the MFPMediaPlayer_CreateMediaItemFromURL or 
; MFPMediaPlayer_CreateMediaItemFromObject method. To update the value, call 
; MFPMediaItem_SetUserData.
;
; See Also:
;
; MFPMediaItem_SetUserData
;
;------------------------------------------------------------------------------
MFPMediaItem_GetUserData PROC USES EBX pMediaItem:DWORD, pdwUserData:DWORD
    .IF pMediaItem == 0 || pdwUserData == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetUserData, pMediaItem, pdwUserData
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetUserData ENDP

ALIGN 4
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
MFPMediaItem_SetStartStopPosition PROC USES EBX pMediaItem:DWORD, dwStartValue:DWORD, dwStopValue:DWORD
    LOCAL StartValue:PROPVARIANT
    LOCAL StopValue:PROPVARIANT
    
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov eax, 0
    mov dword ptr [StartValue+00], eax
    mov dword ptr [StartValue+04], eax
    mov dword ptr [StartValue+08], eax
    mov dword ptr [StartValue+12], eax
    mov StartValue.vt, VT_I8
    mov dword ptr [StopValue+00], eax
    mov dword ptr [StopValue+04], eax
    mov dword ptr [StopValue+08], eax
    mov dword ptr [StopValue+12], eax
    mov StopValue.vt, VT_I8
    
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr StartValue, dwStartValue
    Invoke _MFP_ConvertMSTimeTo100NSValue, Addr StopValue, dwStopValue
    
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.SetStartStopPosition, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr StartValue, Addr MFP_POSITIONTYPE_100NS, Addr StopValue
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStartStopPosition ENDP

ALIGN 4
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
MFPMediaItem_GetStartStopPosition PROC USES EBX pMediaItem:DWORD, pdwStartValue:DWORD, pdwStopValue:DWORD
    LOCAL StartValue:PROPVARIANT
    LOCAL StopValue:PROPVARIANT
    LOCAL dwStartValue:DWORD
    LOCAL dwStopValue:DWORD

    mov eax, 0
    mov dword ptr [StartValue+00], eax
    mov dword ptr [StartValue+04], eax
    mov dword ptr [StartValue+08], eax
    mov dword ptr [StartValue+12], eax
    mov StartValue.vt, VT_I8
    mov dword ptr [StopValue+00], eax
    mov dword ptr [StopValue+04], eax
    mov dword ptr [StopValue+08], eax
    mov dword ptr [StopValue+12], eax
    mov StopValue.vt, VT_I8

    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetStartStopPosition, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr StartValue, Addr MFP_POSITIONTYPE_100NS, Addr StopValue
    .IF eax == S_OK
        .IF pdwStartValue != 0
            Invoke _MFP_Convert100NSValueToMSTime, Addr StartValue, Addr dwStartValue
            mov ebx, pdwStartValue
            mov eax, dwStartValue
            mov [ebx], eax
        .ENDIF
        .IF pdwStopValue != 0
            Invoke _MFP_Convert100NSValueToMSTime, Addr StopValue, Addr dwStopValue
            mov ebx, pdwStopValue
            mov eax, dwStopValue
            mov [ebx], eax
        .ENDIF
        mov eax, TRUE
    .ELSE
        .IF pdwStartValue != 0
            mov ebx, pdwStartValue
            mov eax, -1
            mov [ebx], eax
        .ENDIF
        .IF pdwStopValue != 0
            mov ebx, pdwStopValue
            mov eax, -1
            mov [ebx], eax
        .ENDIF
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStartStopPosition ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_HasVideo
; 
; Queries whether the media item contains a video stream.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbHasVideo - A pointer to a DWORD that contains TRUE or FALSE.
;
; * pbSelected - A pointer to a DWORD that contains TRUE or FALSE.
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
MFPMediaItem_HasVideo PROC USES EBX pMediaItem:DWORD, pbHasVideo:DWORD, pbSelected:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.HasVideo, pMediaItem, pbHasVideo, pbSelected
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_HasVideo ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_HasAudio
; 
; Queries whether the media item contains an audio stream.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbHasAudio - A pointer to a DWORD that contains TRUE or FALSE.
;
; * pbSelected - A pointer to a DWORD that contains TRUE or FALSE.
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
MFPMediaItem_HasAudio PROC USES EBX pMediaItem:DWORD, pbHasAudio:DWORD, pbSelected:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.HasAudio, pMediaItem, pbHasAudio, pbSelected
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_HasAudio ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_IsProtected
; 
; Queries whether the media item contains protected content.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pbProtected - A pointer to a DWORD that contains TRUE or FALSE.
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
MFPMediaItem_IsProtected PROC USES EBX pMediaItem:DWORD, pbProtected:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.IsProtected, pMediaItem, pbProtected
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_IsProtected ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_GetDuration
; 
; Gets the duration of the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
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
; MFPMediaItem_GetStartStopPosition, MFPMediaItem_SetStartStopPosition, 
; MFPMediaPlayer_GetPosition, MFPMediaPlayer_SetPosition, 
; MFPMediaPlayer_GetDuration
;
;------------------------------------------------------------------------------
MFPMediaItem_GetDuration PROC USES EBX pMediaItem:DWORD, pdwMilliseconds:DWORD
    LOCAL DurValue:PROPVARIANT
    LOCAL dwMilliseconds:DWORD
    
    IFDEF DEBUG32
    PrintText 'MFPMediaItem_GetDuration'
    ENDIF
    
    mov eax, 0
    mov dword ptr [DurValue+00], eax
    mov dword ptr [DurValue+04], eax
    mov dword ptr [DurValue+08], eax
    mov dword ptr [DurValue+12], eax
    mov DurValue.vt, VT_I8

    .IF pMediaItem == 0 || pdwMilliseconds == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetDuration, pMediaItem, Addr MFP_POSITIONTYPE_100NS, Addr DurValue
    .IF eax == S_OK
        Invoke _MFP_Convert100NSValueToMSTime, Addr DurValue, Addr dwMilliseconds
        mov ebx, pdwMilliseconds
        mov eax, dwMilliseconds
        mov [ebx], eax
        mov eax, TRUE
    .ELSE
        mov ebx, pdwMilliseconds
        mov eax, -1
        mov [ebx], eax
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetDuration ENDP

ALIGN 4
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
MFPMediaItem_GetNumberOfStreams PROC USES EBX pMediaItem:DWORD, pdwStreamCount:DWORD
    .IF pMediaItem == 0 || pdwStreamCount == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetNumberOfStreams, pMediaItem, pdwStreamCount
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetNumberOfStreams ENDP

ALIGN 4
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
MFPMediaItem_SetStreamSelection PROC USES EBX pMediaItem:DWORD, dwStreamIndex:DWORD, bEnabled:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.SetStreamSelection, pMediaItem, dwStreamIndex, bEnabled
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStreamSelection ENDP

ALIGN 4
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
MFPMediaItem_GetStreamSelection PROC USES EBX pMediaItem:DWORD, dwStreamIndex:DWORD, pbEnabled:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetStreamSelection, pMediaItem, dwStreamIndex, pbEnabled
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStreamSelection ENDP

ALIGN 4
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
MFPMediaItem_GetStreamAttribute PROC USES EBX pMediaItem:DWORD, dwStreamIndex:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetStreamAttribute, pMediaItem, dwStreamIndex, guidMFAttribute, pvValue
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetStreamAttribute ENDP

ALIGN 4
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
MFPMediaItem_GetPresentationAttribute PROC USES EBX pMediaItem:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
    .IF pMediaItem == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetPresentationAttribute, pMediaItem, guidMFAttribute, pvValue
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetPresentationAttribute ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_GetCharacteristics
; 
; Gets various flags that describe the media item.
; 
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * pCharacteristics - a pointer to a DWORD variable to recieve the bitflags of
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
MFPMediaItem_GetCharacteristics PROC USES EBX pMediaItem:DWORD, pCharacteristics:DWORD
    .IF pMediaItem == 0 || pCharacteristics == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetCharacteristics, pMediaItem, pCharacteristics
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetCharacteristics ENDP

ALIGN 4
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
MFPMediaItem_SetStreamSink PROC USES EBX pMediaItem:DWORD, dwStreamIndex:DWORD, pMediaSink:DWORD
    .IF pMediaItem == 0 || pMediaSink == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.SetStreamSink, pMediaItem, dwStreamIndex, pMediaSink
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_SetStreamSink ENDP

ALIGN 4
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
; * ppMetadataStore - A pointer to a DWORD variable to store the pMetadataStore
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
MFPMediaItem_GetMetadata PROC USES EBX pMediaItem:DWORD, ppMetadataStore:DWORD
    .IF pMediaItem == 0 || ppMetadataStore == 0
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, pMediaItem
    mov ebx, [eax]
    Invoke [ebx].IMFPMediaItemVtbl.GetMetadata, pMediaItem, ppMetadataStore
    .IF eax == S_OK
        mov eax, TRUE
    .ELSE
        mov eax, FALSE
    .ENDIF
    ret
MFPMediaItem_GetMetadata ENDP


;==============================================================================
; Initialize Functions
;==============================================================================


ALIGN 4
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
IMFPMediaPlayerInit PROC USES EBX pMediaPlayer:DWORD
    
    .IF pMediaPlayer == 0
        jmp IMFPMediaPlayerInit_Error
    .ENDIF
    
    ; Get functions:
    mov eax, pMediaPlayer
    mov ebx, [eax]
    .IF ebx == 0
        IFDEF DEBUG32
        PrintText 'IMFPMediaPlayerInit pMediaPlayer::ebx == 0'
        ENDIF
        jmp IMFPMediaPlayerInit_Error
    .ENDIF
    
    mov eax, [ebx].IMFPMediaPlayerVtbl.QueryInterface
    mov IMFPMediaPlayer_QueryInterface, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.AddRef
    mov IMFPMediaPlayer_AddRef, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.Release
    mov IMFPMediaPlayer_Release, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.Play
    mov IMFPMediaPlayer_Play, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.Pause
    mov IMFPMediaPlayer_Pause, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.Stop
    mov IMFPMediaPlayer_Stop, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.FrameStep
    mov IMFPMediaPlayer_FrameStep, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetPosition
    mov IMFPMediaPlayer_SetPosition, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetPosition
    mov IMFPMediaPlayer_GetPosition, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetDuration
    mov IMFPMediaPlayer_GetDuration, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetRate
    mov IMFPMediaPlayer_SetRate, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetRate
    mov IMFPMediaPlayer_GetRate, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetSupportedRates
    mov IMFPMediaPlayer_GetSupportedRates, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetState
    mov IMFPMediaPlayer_GetState, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.CreateMediaItemFromURL
    mov IMFPMediaPlayer_CreateMediaItemFromURL, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.CreateMediaItemFromObject
    mov IMFPMediaPlayer_CreateMediaItemFromObject, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetMediaItem
    mov IMFPMediaPlayer_SetMediaItem, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.ClearMediaItem
    mov IMFPMediaPlayer_ClearMediaItem, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetMediaItem
    mov IMFPMediaPlayer_GetMediaItem, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetVolume
    mov IMFPMediaPlayer_GetVolume, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetVolume
    mov IMFPMediaPlayer_SetVolume, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetBalance
    mov IMFPMediaPlayer_GetBalance, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetBalance
    mov IMFPMediaPlayer_SetBalance, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetMute
    mov IMFPMediaPlayer_GetMute, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetMute
    mov IMFPMediaPlayer_SetMute, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetNativeVideoSize
    mov IMFPMediaPlayer_GetNativeVideoSize, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetIdealVideoSize
    mov IMFPMediaPlayer_GetIdealVideoSize, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetVideoSourceRect
    mov IMFPMediaPlayer_SetVideoSourceRect, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetVideoSourceRect
    mov IMFPMediaPlayer_GetVideoSourceRect, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetAspectRatioMode
    mov IMFPMediaPlayer_SetAspectRatioMode, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetAspectRatioMode
    mov IMFPMediaPlayer_GetAspectRatioMode, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetVideoWindow
    mov IMFPMediaPlayer_GetVideoWindow, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.UpdateVideo
    mov IMFPMediaPlayer_UpdateVideo, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.SetBorderColor
    mov IMFPMediaPlayer_SetBorderColor, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.GetBorderColor
    mov IMFPMediaPlayer_GetBorderColor, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.InsertEffect
    mov IMFPMediaPlayer_InsertEffect, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.RemoveEffect
    mov IMFPMediaPlayer_RemoveEffect, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.RemoveAllEffects
    mov IMFPMediaPlayer_RemoveAllEffects, eax
    mov eax, [ebx].IMFPMediaPlayerVtbl.Shutdown
    mov IMFPMediaPlayer_Shutdown, eax

    jmp IMFPMediaPlayerInit_Exit

IMFPMediaPlayerInit_Error:
    
    mov eax, FALSE
    ret
    
IMFPMediaPlayerInit_Exit:
    
    mov eax, TRUE
    ret

IMFPMediaPlayerInit ENDP

ALIGN 4
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
IMFPMediaItemInit PROC USES EBX pMediaItem:DWORD
    
    .IF pMediaItem == 0
        jmp IMFPMediaItemInit_Error
    .ENDIF
    
    ; Get functions:
    mov eax, pMediaItem
    mov ebx, [eax]
    .IF ebx == 0
        IFDEF DEBUG32
        PrintText 'IMFPMediaItemInit pMediaItem::ebx == 0'
        ENDIF
        jmp IMFPMediaItemInit_Error
    .ENDIF
    
    mov eax, [ebx].IMFPMediaItemVtbl.QueryInterface
    mov IMFPMediaItem_QueryInterface, eax
    mov eax, [ebx].IMFPMediaItemVtbl.AddRef
    mov IMFPMediaItem_AddRef, eax
    mov eax, [ebx].IMFPMediaItemVtbl.Release
    mov IMFPMediaItem_Release, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetMediaPlayer
    mov IMFPMediaItem_GetMediaPlayer, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetURL
    mov IMFPMediaItem_GetURL, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetObject
    mov IMFPMediaItem_GetObject, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetUserData
    mov IMFPMediaItem_GetUserData, eax
    mov eax, [ebx].IMFPMediaItemVtbl.SetUserData
    mov IMFPMediaItem_SetUserData, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetStartStopPosition
    mov IMFPMediaItem_GetStartStopPosition, eax
    mov eax, [ebx].IMFPMediaItemVtbl.SetStartStopPosition
    mov IMFPMediaItem_SetStartStopPosition, eax
    mov eax, [ebx].IMFPMediaItemVtbl.HasVideo
    mov IMFPMediaItem_HasVideo, eax
    mov eax, [ebx].IMFPMediaItemVtbl.HasAudio
    mov IMFPMediaItem_HasAudio, eax
    mov eax, [ebx].IMFPMediaItemVtbl.IsProtected
    mov IMFPMediaItem_IsProtected, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetDuration
    mov IMFPMediaItem_GetDuration, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetNumberOfStreams
    mov IMFPMediaItem_GetNumberOfStreams, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetStreamSelection
    mov IMFPMediaItem_GetStreamSelection, eax
    mov eax, [ebx].IMFPMediaItemVtbl.SetStreamSelection
    mov IMFPMediaItem_SetStreamSelection, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetStreamAttribute
    mov IMFPMediaItem_GetStreamAttribute, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetPresentationAttribute
    mov IMFPMediaItem_GetPresentationAttribute, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetCharacteristics
    mov IMFPMediaItem_GetCharacteristics, eax
    mov eax, [ebx].IMFPMediaItemVtbl.SetStreamSink
    mov IMFPMediaItem_SetStreamSink, eax
    mov eax, [ebx].IMFPMediaItemVtbl.GetMetadata
    mov IMFPMediaItem_GetMetadata, eax

    jmp IMFPMediaItemInit_Exit

IMFPMediaItemInit_Error:
    
    mov eax, FALSE
    ret
    
IMFPMediaItemInit_Exit:
    
    mov eax, TRUE
    ret

IMFPMediaItemInit ENDP


;==============================================================================
; Media Information Functions
;==============================================================================

ALIGN 4
;------------------------------------------------------------------------------
; MFPMediaItem_StreamTable
;
; Creates a table of stream records.
;
; Parameters:
;
; * pMediaItem - A pointer to the Media Item (IMFPMediaItem) object.
;
; * lpdwStreamCount - A pointer to a DWORD variable used to store the steam 
;   count of the media item.
;
; * lpdwStreamTable - A pointer to a DWORD variable used to store the pointer
;   to the Stream Table - An array of MFP_STREAM_RECORD stream records.
;
; Returns:
;
; TRUE if successful or FALSE otherwise.
;
; Notes:
;
; Automatically frees previously allocated StreamTable
;
; See Also:
;
; _MFP_GetMajorType, _MFP_GetAudioSubType, _MFP_GetVideoSubType
;
;------------------------------------------------------------------------------
MFPMediaItem_StreamTable PROC USES EBX EDX pMediaItem:DWORD, lpdwStreamCount:DWORD, lpdwStreamTable:DWORD
    LOCAL dwStreamCount:DWORD
    LOCAL pStreamTable:DWORD
    LOCAL pStreamRecord:DWORD
    LOCAL nStreamRecord:DWORD
    LOCAL dwStreamTableSize:DWORD
    LOCAL nStream:DWORD
    LOCAL pvValue:PROPVARIANT
    LOCAL pGUID:DWORD
    LOCAL dwMajorType:DWORD
    LOCAL dwBitratekbps:DWORD
    LOCAL dwfps:DWORD
    LOCAL dwfpsnum:DWORD
    LOCAL dwfpsden:DWORD
    LOCAL lpszStreamName:DWORD
    LOCAL lpszStreamLang:DWORD
    LOCAL pwszStreamNumber:DWORD
    LOCAL pwszStringLang:DWORD
    LOCAL dwStringLangLength:DWORD
    LOCAL szStreamNumber[8]:BYTE
    
    .IF pMediaItem == 0
        jmp MFPMediaItem_StreamTable_Error
    .ENDIF

    ;--------------------------------------------------------------------------
    ; Get number of streams in media item and allocate memory for the Stream
    ; Table / array of MFP_STREAM_RECORD records.
    ;--------------------------------------------------------------------------
    Invoke MFPMediaItem_GetNumberOfStreams, pMediaItem, Addr dwStreamCount
    mov eax, dwStreamCount
    mov ebx, SIZEOF MFP_STREAM_RECORD
    mul ebx
    mov dwStreamTableSize, eax
    
    .IF lpdwStreamTable != 0
        mov ebx, lpdwStreamTable
        mov eax, [ebx]
        mov pStreamTable, eax
        .IF pStreamTable != 0
            Invoke GlobalFree, pStreamTable
            mov pStreamTable, 0
        .ENDIF
    .ENDIF
    
    Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, dwStreamTableSize
    .IF eax == NULL
        IFDEF DEBUG32
        PrintText 'MFPMediaItem_StreamTable::GlobalAlloc Error'
        ENDIF
        jmp MFPMediaItem_StreamTable_Error
    .ENDIF
    mov pStreamTable, eax
    mov pStreamRecord, eax
    
    ;--------------------------------------------------------------------------
    ; For each stream number, get stream attributes and information and store
    ; in the corresponding MFP_STREAM_RECORD.
    ;--------------------------------------------------------------------------

    mov eax, 0
    mov nStream, 0
    .WHILE eax < dwStreamCount
        
        IFDEF DEBUG32
        PrintDec nStream
        ENDIF
        
        ; StreamID
        mov ebx, pStreamRecord
        mov eax, nStream
        mov [ebx].MFP_STREAM_RECORD.dwStreamID, eax
        
        ; Stream Selected
        Invoke MFPMediaItem_GetStreamSelection, pMediaItem, nStream, Addr [ebx].MFP_STREAM_RECORD.bSelected
        
        ; Major Type
        Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_MAJOR_TYPE, Addr pvValue
        lea ebx, pvValue
        mov eax, [ebx].PROPVARIANT.puuid
        mov pGUID, eax
        Invoke _MFP_GetMajorType, pGUID
        mov ebx, pStreamRecord
        mov dwMajorType, eax
        mov [ebx].MFP_STREAM_RECORD.dwMajorType, eax
        Invoke PropVariantClear, Addr pvValue
        
        ; Sub Type
        Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_SUBTYPE, Addr pvValue
        mov eax, dwMajorType
        .IF eax == MFMT_Audio
            IFDEF DEBUG32
            PrintText 'MFMT_Audio'
            ENDIF
            ; Audio Sub Type 
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.puuid
            mov pGUID, eax
            Invoke _MFP_GetAudioSubType, pGUID
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwSubType, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Bitrate - in kilobits per second
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AUDIO_AVG_BYTES_PER_SECOND, Addr pvValue
            lea ebx, pvValue
            finit
            fwait
            fild dword ptr [ebx].PROPVARIANT.uintVal
            fmul MFP_DIV125
            fistp dword ptr dwBitratekbps
            mov ebx, pStreamRecord
            mov eax, dwBitratekbps
            mov [ebx].MFP_STREAM_RECORD.dwBitRate, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Channels
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AUDIO_NUM_CHANNELS, Addr pvValue
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.uintVal
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwChannels, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Speakers
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AUDIO_CHANNEL_MASK, Addr pvValue
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.uintVal
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwSpeakers, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Bits per sample
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AUDIO_BITS_PER_SAMPLE, Addr pvValue
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.uintVal
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwBitsPerSample, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Samples per second kHz
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AUDIO_SAMPLES_PER_SECOND, Addr pvValue
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.uintVal
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwSamplesPerSec, eax
            Invoke PropVariantClear, Addr pvValue
        
        .ELSEIF eax == MFMT_Video
            IFDEF DEBUG32
            PrintText 'MFMT_Video'
            ENDIF
            ; Video Sub Type 
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.puuid
            mov pGUID, eax
            Invoke _MFP_GetVideoSubType, pGUID
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwSubType, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Bitrate - in kilobits per second
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_AVG_BITRATE, Addr pvValue
            lea ebx, pvValue
            finit
            fwait
            fild dword ptr [ebx].PROPVARIANT.uintVal
            fmul MFP_DIV1000
            fistp dword ptr dwBitratekbps
            mov ebx, pStreamRecord
            mov eax, dwBitratekbps
            mov [ebx].MFP_STREAM_RECORD.dwBitRate, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Frame rate - fps
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_FRAME_RATE, Addr pvValue
            lea ebx, pvValue
            mov eax, dword ptr [ebx].PROPVARIANT.uint64Val
            .IF eax == 1
                mov eax, dword ptr [ebx+4].PROPVARIANT.uint64Val
                mov dwfps, eax
            .ELSE
                lea ebx, pvValue
                mov eax, dword ptr [ebx+4].PROPVARIANT.uint64Val
                mov ebx, dword ptr [ebx].PROPVARIANT.uint64Val
                .IF eax == 0 || ebx == 0
                    mov eax, 0
                .ELSE
                    xor edx, edx
                    div ebx
                    .IF edx > 0000FFFFh
                        inc eax
                    .ENDIF
                .ENDIF
                mov dwfps, eax
            .ENDIF
            IFDEF DEBUG32
            PrintDec dwfps
            ENDIF
            mov ebx, pStreamRecord
            mov eax, dwfps
            mov [ebx].MFP_STREAM_RECORD.dwFrameRate, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Frame Height & Width
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_FRAME_SIZE, Addr pvValue
            lea ebx, pvValue
            mov eax, dword ptr [ebx].PROPVARIANT.uint64Val
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwFrameHeight, eax
            lea ebx, pvValue
            mov eax, dword ptr [ebx+4].PROPVARIANT.uint64Val
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwFrameWidth, eax
            Invoke PropVariantClear, Addr pvValue
            
            ; Interlace Mode
            Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_MT_INTERLACE_MODE, Addr pvValue
            lea ebx, pvValue
            mov eax, [ebx].PROPVARIANT.uintVal
            mov ebx, pStreamRecord
            mov [ebx].MFP_STREAM_RECORD.dwInterlace, eax
            Invoke PropVariantClear, Addr pvValue
            
        .ELSE
            IFDEF DEBUG32
            PrintText 'MFPMediaItem_StreamTable::Other Sub Type'
            ENDIF
            Invoke PropVariantClear, Addr pvValue
        .ENDIF
        
        IFDEF DEBUG32
        PrintText 'Stream Name'
        ENDIF
        ; Stream Name - wide/unicode
        mov ebx, pStreamRecord
        lea eax, [ebx].MFP_STREAM_RECORD.szStreamName
        mov lpszStreamName, eax
        Invoke lstrcpyW, lpszStreamName, Addr szStream
        Invoke _MFP_utoa_ex, nStream, Addr szStreamNumber
        Invoke MFPConvertStringToWide, Addr szStreamNumber
        mov pwszStreamNumber, eax
        Invoke lstrcatW, lpszStreamName, pwszStreamNumber
        Invoke MFPConvertStringFree, pwszStreamNumber
        
        IFDEF DEBUG32
        PrintText 'Stream Language'
        ENDIF
        ; Stream Language - wide/unicode
        Invoke MFPMediaItem_GetStreamAttribute, pMediaItem, nStream, Addr MF_SD_LANGUAGE, Addr pvValue
        lea ebx, pvValue
        mov eax, [ebx].PROPVARIANT.pwszVal
        mov pwszStringLang, eax
        .IF pwszStringLang != 0
            mov ebx, pStreamRecord
            lea eax, [ebx].MFP_STREAM_RECORD.szStreamLang
            mov lpszStreamLang, eax

            Invoke lstrlenW, pwszStringLang
            shl eax, 1 ; x2 for unicode chars to bytes
            .IF eax > STREAMLANG_LENGTH
                mov eax, STREAMLANG_LENGTH
            .ENDIF
            mov dwStringLangLength, eax
            
            Invoke RtlMoveMemory, lpszStreamLang, pwszStringLang, dwStringLangLength
            mov ebx, lpszStreamLang
            add ebx, dwStringLangLength
            mov eax, 0
            mov dword ptr [ebx], eax ; null
        .ENDIF
        Invoke PropVariantClear, Addr pvValue
        
        ; Update for next stream and record 
        add pStreamRecord, SIZEOF MFP_STREAM_RECORD
        inc nStream
        mov eax, nStream
    .ENDW
    
    IFDEF DEBUG32 
    PrintDec dwStreamCount
    PrintDec pStreamTable
    PrintDec dwStreamTableSize
    PrintDec SIZEOF MFP_STREAM_RECORD
    DbgDump pStreamTable, dwStreamTableSize
    ENDIF
    
    jmp MFPMediaItem_StreamTable_Exit
    
MFPMediaItem_StreamTable_Error:
    .IF lpdwStreamCount != 0
        mov ebx, lpdwStreamCount
        mov eax, 0
        mov [ebx], eax
    .ENDIF
    
    .IF lpdwStreamTable != 0
        mov ebx, lpdwStreamTable
        mov eax, 0
        mov [ebx], eax
    .ENDIF
    mov eax, FALSE
    ret

MFPMediaItem_StreamTable_Exit:
    .IF lpdwStreamCount != 0
        mov ebx, lpdwStreamCount
        mov eax, dwStreamCount
        mov [ebx], eax
    .ENDIF
    
    .IF lpdwStreamTable != 0
        mov ebx, lpdwStreamTable
        mov eax, pStreamTable
        mov [ebx], eax
    .ENDIF
    mov eax, TRUE
    
    ret
MFPMediaItem_StreamTable ENDP

ALIGN 4
;------------------------------------------------------------------------------
; _MFP_GetMajorType
;------------------------------------------------------------------------------
_MFP_GetMajorType PROC pGUID:DWORD
    
    ;Invoke RtlCompareMemory, pGUID, Addr MFMediaType_Audio, 16
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Audio, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Audio
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Video, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Video
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Stream, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Stream
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Metadata, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Metadata
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Protected, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Protected
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_SAMI, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_SAMI
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Image, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Image
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Binary, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Binary
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_HTML, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_HTML
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Perception, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_Perception
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_FileTransfer, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_FileTransfer
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFMediaType_Script, 16
    .IF eax != 0 ; == 16
        mov eax, MFMT_FileTransfer
        ret
    .ENDIF
    mov eax, MFMT_Script
    
    ret
_MFP_GetMajorType ENDP

ALIGN 4
;------------------------------------------------------------------------------
; _MFP_GetAudioSubType
;------------------------------------------------------------------------------
_MFP_GetAudioSubType PROC pGUID:DWORD

    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_MP3, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_MP3
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_AAC, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_AAC
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_ALAC, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_ALAC
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC3, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC3
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC3_SPDIF, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC3_SP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_DDPlus, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_DDPlus
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC4, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC4
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC4_V1, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC4_V1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC4_V2, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC4_V2
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC4_V1_ES, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC4_V1_ES
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC4_V2_ES, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC4_V2_ES
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_DDPlus, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_DDPlus
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_RAW, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_RAW
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_HD, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_HD
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_XLL, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_XLL
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_LBR, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_LBR
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_UHD, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_UHD
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DTS_UHDY, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DTS_UHDY
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_WMASPDIF, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_WMASPDIF
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_WMAudio_Lossless, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_WMAudio_LL
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_WMAudioV8, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_WMAudioV8
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_WMAudioV9, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_WMAudioV9
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_FLAC, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_FLAC
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_PCM, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_PCM
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_LPCM, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_LPCM
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_MPEG, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_MPEG
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_MPEGH, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_MPEGH
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_MPEGH_ES, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_MPEGH_ES
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_MSP1, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_MSP1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_AMR_NB, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_AMR_NB
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_AMR_WB, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_AMR_WB
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_AMR_WP, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_AMR_WP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_DRM, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_DRM
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Vorbis, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Vorbis
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Opus, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Opus
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Float, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Float
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Float_SpatialObjects, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Float_SO
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_Dolby_AC3_HDCP, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_Dolby_AC3_HDCP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_AAC_HDCP, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_AAC_HDCP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_PCM_HDCP, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_PCM_HDCP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_ADTS_HDCP, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_ADTS_HDCP
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFAudioFormat_ADTS, 16
    .IF eax != 0 ; == 16
        mov eax, MFAF_ADTS
        ret
    .ENDIF
  
    mov eax, MFAF_Unknown
    ret

    ret
_MFP_GetAudioSubType ENDP

ALIGN 4
;------------------------------------------------------------------------------
; _MFP_GetVideoSubType
;------------------------------------------------------------------------------
_MFP_GetVideoSubType PROC pGUID:DWORD

    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_M4S2, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_M4S2
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MP4V, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MP4V
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_H264, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_H264
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_H265, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_H265
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_H264_ES, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_H264_ES
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_WMV1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_WMV1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_WMV2, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_WMV2
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_WMV3, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_WMV3
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MP4S, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MP4S
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_AV1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_AV1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_VP80, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_VP80
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_VP90, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_VP90
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_HEVC, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_HEVC
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_HEVC_ES, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_HEVC_ES
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_H263, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_H263
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MSS1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MSS1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MSS2, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MSS2
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MJPG, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MJPG
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MPG1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MPG1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MPEG2, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MPEG2
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DV25, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DV25
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DV50, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DV50
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DVC, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DVC
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DVH1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DVH1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DVHD, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DVHD
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DVSD, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DVSD
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_DVSL, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_DVSL
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_WVC1, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_WVC1
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_420O, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_420O
        ret
    .ENDIF
    Invoke _MFP_MemoryCompare, pGUID, Addr MFVideoFormat_MP43, 16
    .IF eax != 0 ; == 16
        mov eax, MFVF_MP43
        ret
    .ENDIF

    mov eax, MFVF_Unknown

    ret
_MFP_GetVideoSubType ENDP


;==============================================================================
; Misc Functions
;==============================================================================

ALIGN 4
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
MFPConvertMSTimeToTimeStringA PROC USES EBX ECX EDX EDI ESI dwMilliseconds:DWORD, lpszTime:DWORD, dwTimeFormat:DWORD
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
        mov eax, FALSE
        ret
    .ENDIF
    
    ;Invoke Div1000, dwTimeMS
    mov eax, dwMilliseconds
    mov edx, 274877907
    mul edx
    mov eax, edx
    shr eax, 6
    mov dwSeconds, eax
    
    ;Invoke Div60, dwSeconds
    mov eax, dwSeconds
    mov edx, -2004318071
    mul edx
    mov eax, edx
    shr eax, 5
    mov dwMinutes, eax
    
    ;Invoke Div60, dwMinutes
    mov eax, dwMinutes
    mov edx, -2004318071
    mul edx
    mov eax, edx
    shr eax, 5
    mov dwHours, eax
    
    ;Invoke Div24, dwHours
    mov eax, dwHours
    mov edx, -1431655765
    mul edx
    mov eax, edx
    shr eax, 4
    mov days, eax
    mov dwDays, eax
    
    ;Invoke Rem1000, dwTimeMS
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
    
    ;Invoke Rem60, dwSeconds
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
    
    ;Invoke Rem60, dwMinutes
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
    
    ;Invoke Rem24, dwHours
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
    lea ebx, szDays
    mov [ebx], eax
    lea ebx, szHours
    mov [ebx], eax
    lea ebx, szMinutes
    mov [ebx], eax
    lea ebx, szSeconds
    mov [ebx], eax
    lea ebx, szMilliseconds
    mov [ebx], eax
    
    .IF days != 0 ; output: days, hours, minutes, seconds, milliseconds
        .IF sdword ptr days < 10
            lea ebx, szDays
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, days, ebx
        .ELSE
            Invoke _MFP_utoa_ex, days, Addr szDays
        .ENDIF
        
        .IF sdword ptr hours < 10
            lea ebx, szHours
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, hours, ebx
        .ELSE
            Invoke _MFP_utoa_ex, hours, Addr szHours
        .ENDIF
        
        .IF sdword ptr minutes < 10
            lea ebx, szMinutes
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, minutes, ebx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea ebx, szSeconds
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, seconds, ebx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea ebx, szMilliseconds
            mov byte ptr [ebx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [ebx+1], '0'
                inc ebx
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ELSE ; 100s
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
        
        ; 10 22:33:44:123
        mov edi, lpszTime
        
        lea esi, szDays
        movzx eax, word ptr [esi]
        ; Days
        mov word ptr [edi+0], ax
        ; Space
        mov byte ptr [edi+2], ' '
        
        lea esi, szHours
        movzx eax, word ptr [esi]
        ; Hours
        mov word ptr [edi+3], ax
        ; Colon
        mov byte ptr [edi+5], ':'
        
        lea esi, szMinutes
        movzx eax, word ptr [esi]
        ; Minutes
        mov word ptr [edi+6], ax
        ; Colon
        mov byte ptr [edi+8], ':'
        
        lea esi, szSeconds
        movzx eax, word ptr [esi]
        ; Seconds
        mov word ptr [edi+9], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [edi+11], ':'
        
            lea esi, szMilliseconds
            mov eax, dword ptr [esi]
            ; Milliseconds
            mov dword ptr [edi+12], eax
            ; null
            mov byte ptr [edi+15], 0
        .ELSE
            mov byte ptr [edi+11], 0
        .ENDIF
        
    .ELSEIF hours != 0 ; output: hours, minutes, seconds, milliseconds
        
        .IF sdword ptr hours < 10
            lea ebx, szHours
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, hours, ebx
        .ELSE
            Invoke _MFP_utoa_ex, hours, Addr szHours
        .ENDIF
        
        .IF sdword ptr minutes < 10
            lea ebx, szMinutes
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, minutes, ebx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea ebx, szSeconds
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, seconds, ebx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea ebx, szMilliseconds
            mov byte ptr [ebx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [ebx+1], '0'
                inc ebx
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ELSE ; 100s
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
    
        ; 22:33:44:123
        mov edi, lpszTime

        lea esi, szHours
        movzx eax, word ptr [esi]
        ; Hours
        mov word ptr [edi+0], ax
        ; Colon
        mov byte ptr [edi+2], ':'
        
        lea esi, szMinutes
        movzx eax, word ptr [esi]
        ; Minutes
        mov word ptr [edi+3], ax
        ; Colon
        mov byte ptr [edi+5], ':'
        
        lea esi, szSeconds
        movzx eax, word ptr [esi]
        ; Seconds
        mov word ptr [edi+6], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [edi+8], ':'
        
            lea esi, szMilliseconds
            mov eax, dword ptr [esi]
            ; Milliseconds
            mov dword ptr [edi+9], eax
            ; null
            mov byte ptr [edi+12], 0
        .ELSE
            mov byte ptr [edi+8], 0
        .ENDIF
        
    .ELSE ;IF minutes != 0 ; output: minutes, seconds, milliseconds

        .IF sdword ptr minutes < 10
            lea ebx, szMinutes
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, minutes, ebx
        .ELSE
            Invoke _MFP_utoa_ex, minutes, Addr szMinutes
        .ENDIF
        
        .IF sdword ptr seconds < 10
            lea ebx, szSeconds
            mov byte ptr [ebx], '0'
            inc ebx
            Invoke _MFP_utoa_ex, seconds, ebx
        .ELSE
            Invoke _MFP_utoa_ex, seconds, Addr szSeconds
        .ENDIF
        
        .IF sdword ptr milliseconds < 100
            lea ebx, szMilliseconds
            mov byte ptr [ebx], '0'
            .IF sdword ptr milliseconds < 10
                mov byte ptr [ebx+1], '0'
                inc ebx
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ELSE ; 100s
                inc ebx
                Invoke _MFP_utoa_ex, milliseconds, ebx
            .ENDIF
        .ELSE
            Invoke _MFP_utoa_ex, milliseconds, Addr szMilliseconds
        .ENDIF
    
        ; 33:44:123
        mov edi, lpszTime

        lea esi, szMinutes
        movzx eax, word ptr [esi]
        ; Minutes
        mov word ptr [edi+0], ax
        ; Colon
        mov byte ptr [edi+2], ':'
        
        lea esi, szSeconds
        movzx eax, word ptr [esi]
        ; Seconds
        mov word ptr [edi+3], ax
        
        .IF dwTimeFormat == 0
            ; Colon
            mov byte ptr [edi+5], ':'
            
            lea esi, szMilliseconds
            mov eax, dword ptr [esi]
            ; Milliseconds
            mov dword ptr [edi+6], eax
            ; null
            mov byte ptr [edi+9], 0
        .ELSE
            mov byte ptr [edi+5], 0
        .ENDIF
        
    .ENDIF
    
    mov eax, TRUE  
    ret
MFPConvertMSTimeToTimeStringA ENDP

ALIGN 4
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
MFPConvertMSTimeToTimeStringW PROC USES EBX dwMilliseconds:DWORD, lpszTime:DWORD, dwTimeFormat:DWORD
    LOCAL szAnsiTime[24]:BYTE
    LOCAL pWideTime:DWORD
    
    .IF lpszTime == 0
        mov eax, FALSE
        ret
    .ENDIF
    
    Invoke MFPConvertMSTimeToTimeStringA, dwMilliseconds, Addr szAnsiTime, dwTimeFormat
    .IF eax == TRUE
        Invoke MFPConvertStringToWide, Addr szAnsiTime
        .IF eax != NULL
            mov pWideTime, eax
            Invoke lstrcpyW, lpszTime, pWideTime
            Invoke MFPConvertStringFree, pWideTime
            mov eax, TRUE
        .ELSE
            mov eax, FALSE
        .ENDIF
    .ENDIF
    
    ret
MFPConvertMSTimeToTimeStringW ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPConvertStringToAnsi 
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
; a call to the MFPConvertStringFree function.
;
; See Also:
;
; MFPConvertStringToWide, MFPConvertStringFree
; 
;------------------------------------------------------------------------------
MFPConvertStringToAnsi PROC lpszWideString:DWORD
    LOCAL dwAnsiStringSize:DWORD
    LOCAL lpszAnsiString:DWORD

    .IF lpszWideString == NULL
        mov eax, NULL
        ret
    .ENDIF
    Invoke WideCharToMultiByte, CP_UTF8, 0, lpszWideString, -1, NULL, 0, NULL, NULL
    .IF eax == 0
        ret
    .ENDIF
    mov dwAnsiStringSize, eax
    ;shl eax, 1 ; x2 to get non wide char count
    add eax, 4 ; add 4 for good luck and nulls
    Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, eax
    .IF eax == NULL
        ret
    .ENDIF
    mov lpszAnsiString, eax    
    Invoke WideCharToMultiByte, CP_UTF8, 0, lpszWideString, -1, lpszAnsiString, dwAnsiStringSize, NULL, NULL
    .IF eax == 0
        ret
    .ENDIF
    mov eax, lpszAnsiString
    ret
MFPConvertStringToAnsi ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPConvertStringToWide
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
; a call to the MFPConvertStringFree function.
;
; See Also:
;
; MFPConvertStringToAnsi, MFPConvertStringFree
; 
;------------------------------------------------------------------------------
MFPConvertStringToWide PROC lpszAnsiString:DWORD
    LOCAL dwWideStringSize:DWORD
    LOCAL lpszWideString:DWORD
    
    .IF lpszAnsiString == NULL
        mov eax, NULL
        ret
    .ENDIF
    Invoke MultiByteToWideChar, CP_UTF8, 0, lpszAnsiString, -1, NULL, 0
    .IF eax == 0
        ret
    .ENDIF
    mov dwWideStringSize, eax
    shl eax, 1 ; x2 to get non wide char count
    add eax, 4 ; add 4 for good luck and nulls
    Invoke GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, eax
    .IF eax == NULL
        ret
    .ENDIF
    mov lpszWideString, eax
    Invoke MultiByteToWideChar, CP_UTF8, 0, lpszAnsiString, -1, lpszWideString, dwWideStringSize
    .IF eax == 0
        ret
    .ENDIF
    mov eax, lpszWideString
    ret
MFPConvertStringToWide ENDP

ALIGN 4
;------------------------------------------------------------------------------
; MFPConvertStringFree
;
; Frees a string created by MFPConvertStringToWide or
; MFPConvertStringToAnsi
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
; MFPConvertStringToWide, MFPConvertStringToAnsi
; 
;------------------------------------------------------------------------------
MFPConvertStringFree PROC lpString:DWORD
    mov eax, lpString
    .IF eax == NULL
        mov eax, FALSE
        ret
    .ENDIF
    Invoke GlobalFree, eax
    mov eax, TRUE
    ret
MFPConvertStringFree ENDP


;==============================================================================
; Internal Functions
;==============================================================================

ALIGN 4
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
; -1 if there is an error, otherwise returns the milliseconds value in eax.
;
; See Also:
;
; _MFP_ConvertMSTimeTo100NSValue, ConvertMSTimeToTimeString
;
;------------------------------------------------------------------------------
_MFP_Convert100NSValueToMSTime PROC USES EBX pvValue:DWORD, pdwMilliseconds:DWORD
    LOCAL qwTime:QWORD
    LOCAL dwTimeMS:DWORD
    ;LOCAL dw100NSToMS:DWORD; DD 10000

    IFDEF DEBUG32
    PrintText '_MFP_Convert100NSValueToMSTime'
    ENDIF

    .IF pvValue == 0 || pdwMilliseconds == 0
        mov eax, -1
        ret
    .ENDIF
    
    ; If high word of pvValue is >= 10000 then
    ; div wont be accurate, so most we return
    ; is -2 (4294967294 | FFFFFFFEh): 49d 17:02:47.29
    ;  (-1 is used for errors)
    mov ebx, pvValue
    mov eax, dword ptr [ebx].PROPVARIANT.hVal.HighPart
    .IF sdword ptr eax >= 10000d
        IFDEF DEBUG32
        PrintText 'eax >= 10000d'
        ENDIF
        mov eax, -2 ; (FFFFFFFEh): 49d 17:02:47.29
        ret
    .ENDIF
    
    ; Convert 100ns units to milliseconds
    ;mov eax, 10000d
    ;mov dw100NSToMS, eax
    mov ebx, pvValue
    mov eax, dword ptr [ebx].PROPVARIANT.hVal.LowPart
    mov dword ptr [qwTime+0], eax
    mov eax, dword ptr [ebx].PROPVARIANT.hVal.HighPart
    mov dword ptr [qwTime+4], eax
    
    finit
    fwait
    fild qwTime
    fmul MFP_DIV10000
    ;fild dw100NSToMS
    ;fdiv
    fistp dwTimeMS
    IFDEF DEBUG32
    PrintDec dwTimeMS
    ENDIF
    
    mov ebx, pdwMilliseconds
    mov eax, dwTimeMS
    mov [ebx], eax
    
    ret
_MFP_Convert100NSValueToMSTime ENDP

ALIGN 4
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
; -1 if there is an error, otherwise returns the milliseconds value in eax.
;
; See Also:
;
; _MFP_Convert100NSValueToMSTime, ConvertMSTimeToTimeString
;
;------------------------------------------------------------------------------
_MFP_ConvertMSTimeTo100NSValue PROC USES EBX pvValue:DWORD, dwMilliseconds:DWORD
    LOCAL qwTime:QWORD
    LOCAL dwTimeMS:DWORD
    LOCAL dwMSTo100NS:DWORD
    
    .IF pvValue == 0
        mov eax, -1
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
        
        mov ebx, pvValue
        mov eax, 0
        mov dword ptr [ebx+00], eax
        mov dword ptr [ebx+04], eax
        mov dword ptr [ebx+08], eax
        mov dword ptr [ebx+12], eax
        
        mov eax, dword ptr [qwTime+0]
        mov dword ptr [ebx].PROPVARIANT.hVal.LowPart, eax
        mov eax, dword ptr [qwTime+4]
        mov dword ptr [ebx].PROPVARIANT.hVal.HighPart, eax
        mov word ptr [ebx].PROPVARIANT.vt, VT_I8
        
    .ELSE
        mov ebx, pvValue
        mov eax, 0
        mov dword ptr [ebx+0], eax
        mov dword ptr [ebx+4], eax
        mov dword ptr [ebx+08], eax
        mov dword ptr [ebx+12], eax
    .ENDIF
    
    mov eax, dwMilliseconds
    ret
_MFP_ConvertMSTimeTo100NSValue ENDP

ALIGN 4
;------------------------------------------------------------------------------
; _MFP_MemoryCompare
;
; Compare two memory addresses of the same known length.
; 
; Parameters:
; 
; * pMemoryAddress1 - The first memory location to test.
; 
; * pMemoryAddress2 - The second memory location to test against the first.
; 
; * dwMemoryLength - The length of the buffers in BYTES.
; 
; Returns:
; 
; 0 = different. non 0 = byte identical.
; 
; Notes:
;
; This function as based on the MASM32 Library function: cmpmem
;
;------------------------------------------------------------------------------
_MFP_MemoryCompare PROC USES ECX EDX EDI ESI pMemoryAddress1:DWORD, pMemoryAddress2:DWORD, dwMemoryLength:DWORD
    mov ecx, pMemoryAddress1        ; buf1
    mov edx, pMemoryAddress2        ; buf2

    xor esi, esi
    xor eax, eax
    mov edi, dwMemoryLength         ; bcnt
    cmp edi, 4
    jb under

    shr edi, 2                      ; div by 4

  align 4
  @@:
    mov eax, [ecx+esi]              ; DWORD compare main file
    cmp eax, [edx+esi]
    jne fail
    add esi, 4
    sub edi, 1
    jnz @B

    mov edi, dwMemoryLength         ; bcnt; calculate any remainder
    and edi, 3
    jz match                        ; exit if its zero

  under:
    movzx eax, BYTE PTR [ecx+esi]   ; BYTE compare tail
    cmp al, [edx+esi]
    jne fail
    add esi, 1
    sub edi, 1
    jnz under

    jmp match

  fail:
    xor eax, eax                    ; return zero if DIFFERENT
    jmp quit

  match:
    mov eax, 1                      ; return NON zero if SAME

  quit:
    ret
_MFP_MemoryCompare ENDP

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE
align 16
;------------------------------------------------------------------------------
; _MFP_utoa_ex
;
; Convert unsigned value to ascii
;
; Parameters:
;
; * uvar - The variable that holds the unsigned value to convert to ascii.
;
; * pbuffer - Pointer to a buffer to hold the ascii string.
;
; Returns:
;
; None.
;
; Notes:
;
; This algorithm was written by Paul Dixon. Ensure the buffer is large enough.
;
; See Also:
;
; N/A
;
;------------------------------------------------------------------------------
_MFP_utoa_ex proc uvar:DWORD, pbuffer:DWORD

  ; --------------------------------------------------------------------------------
  ; this algorithm was written by Paul Dixon and has been converted to MASM notation
  ; --------------------------------------------------------------------------------

    mov eax, [esp+4]                ; uvar      : unsigned variable to convert
    mov ecx, [esp+8]                ; pbuffer   : pointer to result buffer

    push esi
    push edi

    jmp udword

  align 4
  chartab:
    dd "00","10","20","30","40","50","60","70","80","90"
    dd "01","11","21","31","41","51","61","71","81","91"
    dd "02","12","22","32","42","52","62","72","82","92"
    dd "03","13","23","33","43","53","63","73","83","93"
    dd "04","14","24","34","44","54","64","74","84","94"
    dd "05","15","25","35","45","55","65","75","85","95"
    dd "06","16","26","36","46","56","66","76","86","96"
    dd "07","17","27","37","47","57","67","77","87","97"
    dd "08","18","28","38","48","58","68","78","88","98"
    dd "09","19","29","39","49","59","69","79","89","99"

  udword:
    mov esi, ecx                    ; get pointer to answer
    mov edi, eax                    ; save a copy of the number

    mov edx, 0D1B71759h             ; =2^45\10000    13 bit extra shift
    mul edx                         ; gives 6 high digits in edx

    mov eax, 68DB9h                 ; =2^32\10000+1

    shr edx, 13                     ; correct for multiplier offset used to give better accuracy
    jz short skiphighdigits         ; if zero then don't need to process the top 6 digits

    mov ecx, edx                    ; get a copy of high digits
    imul ecx, 10000                 ; scale up high digits
    sub edi, ecx                    ; subtract high digits from original. EDI now = lower 4 digits

    mul edx                         ; get first 2 digits in edx
    mov ecx, 100                    ; load ready for later

    jnc short next1                 ; if zero, supress them by ignoring
    cmp edx, 9                      ; 1 digit or 2?
    ja   ZeroSupressed              ; 2 digits, just continue with pairs of digits to the end

    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dh                   ; but only write the 1 we need, supress the leading zero
    inc esi                         ; update pointer by 1
    jmp  ZS1                        ; continue with pairs of digits to the end

  align 16
  next1:
    mul ecx                         ; get next 2 digits
    jnc short next2                 ; if zero, supress them by ignoring
    cmp edx, 9                      ; 1 digit or 2?
    ja   ZS1a                       ; 2 digits, just continue with pairs of digits to the end

    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dh                   ; but only write the 1 we need, supress the leading zero
    add esi, 1                      ; update pointer by 1
    jmp  ZS2                        ; continue with pairs of digits to the end

  align 16
  next2:
    mul ecx                         ; get next 2 digits
    jnc short next3                 ; if zero, supress them by ignoring
    cmp edx, 9                      ; 1 digit or 2?
    ja   ZS2a                       ; 2 digits, just continue with pairs of digits to the end

    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dh                   ; but only write the 1 we need, supress the leading zero
    add esi, 1                      ; update pointer by 1
    jmp  ZS3                        ; continue with pairs of digits to the end

  align 16
  next3:

  skiphighdigits:
    mov eax, edi                    ; get lower 4 digits
    mov ecx, 100

    mov edx, 28F5C29h               ; 2^32\100 +1
    mul edx
    jnc short next4                 ; if zero, supress them by ignoring
    cmp edx, 9                      ; 1 digit or 2?
    ja  short ZS3a                  ; 2 digits, just continue with pairs of digits to the end

    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dh                   ; but only write the 1 we need, supress the leading zero
    inc esi                         ; update pointer by 1
    jmp short  ZS4                  ; continue with pairs of digits to the end

  align 16
  next4:
    mul ecx                         ; this is the last pair so don; t supress a single zero
    cmp edx, 9                      ; 1 digit or 2?
    ja  short ZS4a                  ; 2 digits, just continue with pairs of digits to the end

    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dh                   ; but only write the 1 we need, supress the leading zero
    mov byte ptr [esi+1], 0         ; zero terminate string

    pop edi
    pop esi
    ret 8

  align 16
  ZeroSupressed:
    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dx
    add esi, 2                      ; write them to answer

  ZS1:
    mul ecx                         ; get next 2 digits
  ZS1a:
    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dx                   ; write them to answer
    add esi, 2

  ZS2:
    mul ecx                         ; get next 2 digits
  ZS2a:
    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dx                   ; write them to answer
    add esi, 2

  ZS3:
    mov eax, edi                    ; get lower 4 digits
    mov edx, 28F5C29h               ; 2^32\100 +1
    mul edx                         ; edx= top pair
  ZS3a:
    mov edx, chartab[edx*4]         ; look up 2 digits
    mov [esi], dx                   ; write to answer
    add esi, 2                      ; update pointer

  ZS4:
    mul ecx                         ; get final 2 digits
  ZS4a:
    mov edx, chartab[edx*4]         ; look them up
    mov [esi], dx                   ; write to answer

    mov byte ptr [esi+2], 0         ; zero terminate string

  sdwordend:

    pop edi
    pop esi

    ret 8

_MFP_utoa_ex endp
OPTION PROLOGUE:PrologueDef
OPTION EPILOGUE:EpilogueDef


;------------------------------------------------------------------------------
; IMFPMPCallback functions
;------------------------------------------------------------------------------
IMFPMPCallback_QueryInterfaceProc   PROTO pThis:DWORD, riid:DWORD, ppvObject:DWORD
IMFPMPCallback_AddRefProc           PROTO pThis:DWORD
IMFPMPCallback_ReleaseProc          PROTO pThis:DWORD

ALIGN 4
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
IMFPMPCallback_QueryInterfaceProc PROC pThis:DWORD, riid:DWORD, ppvObject:DWORD
    mov eax, E_NOINTERFACE
    ret
IMFPMPCallback_QueryInterfaceProc ENDP

ALIGN 4
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
IMFPMPCallback_AddRefProc PROC pThis:DWORD
    xor eax, eax
    ret
IMFPMPCallback_AddRefProc ENDP

ALIGN 4
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
IMFPMPCallback_ReleaseProc PROC pThis:DWORD
    xor eax, eax
    ret
IMFPMPCallback_ReleaseProc ENDP



END
