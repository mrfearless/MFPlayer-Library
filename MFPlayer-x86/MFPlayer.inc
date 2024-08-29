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

includelib MFPlay.lib

; MFPMediaPlayer Functions:
MFPMediaPlayer_Init               PROTO hMFPWindow:DWORD, pCallback:DWORD, ppMediaPlayer:DWORD
MFPMediaPlayer_Free               PROTO ppMediaPlayer:DWORD

MFPMediaPlayer_Play               PROTO pMediaPlayer:DWORD
MFPMediaPlayer_Pause              PROTO pMediaPlayer:DWORD
MFPMediaPlayer_Stop               PROTO pMediaPlayer:DWORD
MFPMediaPlayer_Step               PROTO pMediaPlayer:DWORD
MFPMediaPlayer_Toggle             PROTO pMediaPlayer:DWORD

MFPMediaPlayer_ClearMediaItem     PROTO pMediaPlayer:DWORD
MFPMediaPlayer_SetMediaItem       PROTO pMediaPlayer:DWORD, pMediaItem:DWORD
MFPMediaPlayer_GetMediaItem       PROTO pMediaPlayer:DWORD, ppMediaItem:DWORD
MFPMediaPlayer_CreateMediaItemA   PROTO pMediaPlayer:DWORD, lpszMediaItem:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
MFPMediaPlayer_CreateMediaItemW   PROTO pMediaPlayer:DWORD, lpszMediaItem:DWORD, dwUserData:DWORD, ppMediaItem:DWORD
MFPMediaPlayer_CreateMediaItemFromObject PROTO pMediaPlayer:DWORD, pIUnknownObj:DWORD, dwUserData:DWORD, ppMediaItem:DWORD

MFPMediaPlayer_GetState           PROTO pMediaPlayer:DWORD, pState:DWORD
MFPMediaPlayer_SetPosition        PROTO pMediaPlayer:DWORD, dwMilliseconds:DWORD
MFPMediaPlayer_GetPosition        PROTO pMediaPlayer:DWORD, pdwMilliseconds:DWORD
MFPMediaPlayer_GetDuration        PROTO pMediaPlayer:DWORD, pdwMilliseconds:DWORD

MFPMediaPlayer_SetRate            PROTO pMediaPlayer:DWORD, dwRate:DWORD
MFPMediaPlayer_GetRate            PROTO pMediaPlayer:DWORD, pdwRate:DWORD
MFPMediaPlayer_GetSupportedRates  PROTO pMediaPlayer:DWORD, bForwardDirection:DWORD, pdwSlowestRate:DWORD, pdwFastestRate:DWORD

MFPMediaPlayer_GetVolume          PROTO pMediaPlayer:DWORD, pdwVolume:DWORD
MFPMediaPlayer_SetVolume          PROTO pMediaPlayer:DWORD, dwVolume:DWORD
MFPMediaPlayer_GetBalance         PROTO pMediaPlayer:DWORD, pdwBalance:DWORD
MFPMediaPlayer_SetBalance         PROTO pMediaPlayer:DWORD, dwBalance:SDWORD
MFPMediaPlayer_GetMute            PROTO pMediaPlayer:DWORD, pbMute:DWORD
MFPMediaPlayer_SetMute            PROTO pMediaPlayer:DWORD, bMute:DWORD

MFPMediaPlayer_GetNativeVideoSize PROTO pMediaPlayer:DWORD, pszVideo:DWORD, pszARVideo:DWORD
MFPMediaPlayer_GetIdealVideoSize  PROTO pMediaPlayer:DWORD, pszMin:DWORD, pszMax:DWORD
MFPMediaPlayer_SetVideoSourceRect PROTO pMediaPlayer:DWORD, pnrcSource:DWORD
MFPMediaPlayer_GetVideoSourceRect PROTO pMediaPlayer:DWORD, pnrcSource:DWORD

MFPMediaPlayer_SetAspectRatioMode PROTO pMediaPlayer:DWORD, dwAspectRatioMode:DWORD
MFPMediaPlayer_GetAspectRatioMode PROTO pMediaPlayer:DWORD, pdwAspectRatioMode:DWORD

MFPMediaPlayer_GetVideoWindow     PROTO pMediaPlayer:DWORD, phwndVideo:DWORD
MFPMediaPlayer_UpdateVideo        PROTO pMediaPlayer:DWORD
MFPMediaPlayer_SetBorderColor     PROTO pMediaPlayer:DWORD, Color:DWORD
MFPMediaPlayer_GetBorderColor     PROTO pMediaPlayer:DWORD, pColor:DWORD

MFPMediaPlayer_InsertEffect       PROTO pMediaPlayer:DWORD, pEffect:DWORD, bOptional:DWORD
MFPMediaPlayer_RemoveEffect       PROTO pMediaPlayer:DWORD, pEffect:DWORD
MFPMediaPlayer_RemoveAllEffects   PROTO pMediaPlayer:DWORD
MFPMediaPlayer_Shutdown           PROTO pMediaPlayer:DWORD

; MFPMediaItem Functions:
MFPMediaItem_Release              PROTO pMediaItem:DWORD
MFPMediaItem_GetMediaPlayer       PROTO pMediaItem:DWORD, ppMediaPlayer:DWORD
MFPMediaItem_GetURLA              PROTO pMediaItem:DWORD, ppszURL:DWORD
MFPMediaItem_GetURLW              PROTO pMediaItem:DWORD, ppszURL:DWORD

MFPMediaItem_SetUserData          PROTO pMediaItem:DWORD, dwUserData:DWORD
MFPMediaItem_GetUserData          PROTO pMediaItem:DWORD, pdwUserData:DWORD

MFPMediaItem_SetStartStopPosition PROTO pMediaItem:DWORD, dwStartValue:DWORD, dwStopValue:DWORD
MFPMediaItem_GetStartStopPosition PROTO pMediaItem:DWORD, pdwStartValue:DWORD, pdwStopValue:DWORD

MFPMediaItem_HasVideo             PROTO pMediaItem:DWORD, pbHasVideo:DWORD, pbSelected:DWORD
MFPMediaItem_HasAudio             PROTO pMediaItem:DWORD, pbHasAudio:DWORD, pbSelected:DWORD
MFPMediaItem_IsProtected          PROTO pMediaItem:DWORD, pbProtected:DWORD

MFPMediaItem_GetDuration          PROTO pMediaItem:DWORD, pdwMilliseconds:DWORD
MFPMediaItem_GetNumberOfStreams   PROTO pMediaItem:DWORD, pdwStreamCount:DWORD
MFPMediaItem_SetStreamSelection   PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, bEnabled:DWORD
MFPMediaItem_GetStreamSelection   PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, pbEnabled:DWORD

MFPMediaItem_GetStreamAttribute   PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
MFPMediaItem_GetPresentationAttribute PROTO pMediaItem:DWORD, guidMFAttribute:DWORD, pvValue:DWORD
MFPMediaItem_GetCharacteristics   PROTO pMediaItem:DWORD, pCharacteristics:DWORD
MFPMediaItem_GetMetadata          PROTO pMediaItem:DWORD, ppMetadataStore:DWORD

MFPMediaItem_SetStreamSink        PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, pMediaSink:DWORD

; Misc
MFPConvertMSTimeToTimeStringA     PROTO dwMilliseconds:DWORD, lpszTime:DWORD, dwTimeFormat:DWORD
MFPConvertMSTimeToTimeStringW     PROTO dwMilliseconds:DWORD, lpszTime:DWORD, dwTimeFormat:DWORD

IFDEF __UNICODE__
    MFPMediaPlayer_CreateMediaItem  EQU <MFPMediaPlayer_CreateMediaItemW>
    MFPMediaItem_GetURL             EQU <MFPMediaItem_GetURLW>
    MFPConvertMSTimeToTimeString    EQU <MFPConvertMSTimeToTimeStringW>
ELSE ; ANSI
    MFPMediaPlayer_CreateMediaItem  EQU <MFPMediaPlayer_CreateMediaItemA>
    MFPMediaItem_GetURL             EQU <MFPMediaItem_GetURLA>
    MFPConvertMSTimeToTimeString    EQU <MFPConvertMSTimeToTimeStringA>
ENDIF


;------------------------------------------------------------------------------
; MFPMediaPlayer Structures
;------------------------------------------------------------------------------
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
IFNDEF HRESULT
HRESULT TYPEDEF DWORD
ENDIF

IFNDEF MFP_EVENT_HEADER
MFP_EVENT_HEADER    STRUCT
    eEventType      MFP_EVENT_TYPE ?
    hrEvent         HRESULT ?
    pMediaPlayer    DWORD ? ; ptr to IMFPMediaPlayer
    eState          MFP_MEDIAPLAYER_STATE ?
    pPropertyStore  DWORD ? ; ptr to IPropertyStore
MFP_EVENT_HEADER    ENDS
ENDIF

IFNDEF MFP_PLAY_EVENT
MFP_PLAY_EVENT      STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_PLAY_EVENT      ENDS
ENDIF

IFNDEF MFP_PAUSE_EVENT
MFP_PAUSE_EVENT     STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_PAUSE_EVENT     ENDS
ENDIF

IFNDEF MFP_STOP_EVENT
MFP_STOP_EVENT      STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_STOP_EVENT      ENDS
ENDIF

IFNDEF MFP_POSITION_SET_EVENT
MFP_POSITION_SET_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_POSITION_SET_EVENT ENDS
ENDIF

IFNDEF MFP_RATE_SET_EVENT
MFP_RATE_SET_EVENT  STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
    flRate          REAL4 ?
MFP_RATE_SET_EVENT  ENDS
ENDIF

IFNDEF MFP_MEDIAITEM_CREATED_EVENT
MFP_MEDIAITEM_CREATED_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
    dwUserData      DWORD ?
MFP_MEDIAITEM_CREATED_EVENT ENDS
ENDIF

IFNDEF MFP_MEDIAITEM_SET_EVENT
MFP_MEDIAITEM_SET_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_MEDIAITEM_SET_EVENT ENDS
ENDIF

IFNDEF MFP_FRAME_STEP_EVENT
MFP_FRAME_STEP_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_FRAME_STEP_EVENT ENDS
ENDIF

IFNDEF MFP_MEDIAITEM_CLEARED_EVENT
MFP_MEDIAITEM_CLEARED_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_MEDIAITEM_CLEARED_EVENT ENDS
ENDIF

IFNDEF MFP_MF_EVENT
MFP_MF_EVENT        STRUCT
    header          MFP_EVENT_HEADER <>
    MFEventType     MediaEventType ?
    pMFMediaEvent   DWORD ? ; ptr to IMFMediaEvent
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_MF_EVENT        ENDS
ENDIF

IFNDEF MFP_ERROR_EVENT
MFP_ERROR_EVENT     STRUCT
    header          MFP_EVENT_HEADER <>
MFP_ERROR_EVENT     ENDS
ENDIF

IFNDEF MFP_PLAYBACK_ENDED_EVENT
MFP_PLAYBACK_ENDED_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    pMediaItem      DWORD ? ; ptr to IMFPMediaItem
MFP_PLAYBACK_ENDED_EVENT ENDS
ENDIF

IFNDEF MFP_ACQUIRE_USER_CREDENTIAL_EVENT
MFP_ACQUIRE_USER_CREDENTIAL_EVENT STRUCT
    header          MFP_EVENT_HEADER <>
    dwUserData      DWORD ?
    fProceedWithAuthentication  DWORD ?
    hrAuthenticationStatus  HRESULT ?
    pwszURL         DWORD ? ; LPCWSTR
    pwszSite        DWORD ? ; LPCWSTR
    pwszRealm       DWORD ? ; LPCWSTR
    pwszPackage     DWORD ? ; LPCWSTR
    nRetries        DWORD ?
    flags           MFP_CREDENTIAL_FLAGS ?
    pCredential     DWORD ? ; ptr to IMFNetCredential
MFP_ACQUIRE_USER_CREDENTIAL_EVENT ENDS
ENDIF

IFNDEF MFVideoNormalizedRect
MFVideoNormalizedRect   STRUCT
    left                REAL4 ? ; float
    top                 REAL4 ? ; float
    right               REAL4 ? ; float
    bottom              REAL4 ? ; float
MFVideoNormalizedRect   ENDS
ENDIF

.CONST
;------------------------------------------------------------------------------
; MFPMediaPlayer Constants
;------------------------------------------------------------------------------

; MFP_CREATION_OPTIONS TYPEDEF DWORD
MFP_OPTION_NONE                 EQU 00h
MFP_OPTION_FREE_THREADED_CALLBACK EQU 01h
MFP_OPTION_NO_MMCSS             EQU 02h
MFP_OPTION_NO_REMOTE_DESKTOP_OPTIMIZATION EQU 04h

; MFP_MEDIAPLAYER_STATE TYPEDEF DWORD
MFP_MEDIAPLAYER_STATE_EMPTY     EQU 00h
MFP_MEDIAPLAYER_STATE_STOPPED   EQU 01h
MFP_MEDIAPLAYER_STATE_PLAYING   EQU 02h
MFP_MEDIAPLAYER_STATE_PAUSED    EQU 03h
MFP_MEDIAPLAYER_STATE_SHUTDOWN  EQU 04h

; MFP_MEDIAITEM_CHARACTERISTICS TYPEDEF DWORD
MFP_MEDIAITEM_IS_LIVE           EQU 01h
MFP_MEDIAITEM_CAN_SEEK          EQU 02h
MFP_MEDIAITEM_CAN_PAUSE         EQU 04h
MFP_MEDIAITEM_HAS_SLOW_SEEK     EQU 08h

; MFP_CREDENTIAL_FLAGS TYPEDEF DWORD
MFP_CREDENTIAL_PROMPT           EQU 01h
MFP_CREDENTIAL_SAVE             EQU 02h
MFP_CREDENTIAL_DO_NOT_CACHE     EQU 04h
MFP_CREDENTIAL_CLEAR_TEXT       EQU 08h
MFP_CREDENTIAL_PROXY            EQU 010h
MFP_CREDENTIAL_LOGGED_ON_USER   EQU 020h

; MFP_EVENT_TYPE TYPEDEF DWORD
MFP_EVENT_TYPE_PLAY              EQU 0
MFP_EVENT_TYPE_PAUSE             EQU 1
MFP_EVENT_TYPE_STOP              EQU 2
MFP_EVENT_TYPE_POSITION_SET      EQU 3
MFP_EVENT_TYPE_RATE_SET          EQU 4
MFP_EVENT_TYPE_MEDIAITEM_CREATED EQU 5
MFP_EVENT_TYPE_MEDIAITEM_SET     EQU 6
MFP_EVENT_TYPE_FRAME_STEP        EQU 7
MFP_EVENT_TYPE_MEDIAITEM_CLEARED EQU 8
MFP_EVENT_TYPE_MF                EQU 9
MFP_EVENT_TYPE_ERROR             EQU 10
MFP_EVENT_TYPE_PLAYBACK_ENDED    EQU 11
MFP_EVENT_TYPE_ACQUIRE_USER_CREDENTIAL EQU 12

; MediaEventType TYPEDEF DWORD
MEUnknown                        EQU 0
MEError                          EQU 1
MEExtendedType                   EQU 2
MENonFatalError                  EQU 3
MEGenericV1Anchor                EQU MENonFatalError
MESessionUnknown                 EQU 100
MESessionTopologySet             EQU 101
MESessionTopologiesCleared       EQU 102
MESessionStarted                 EQU 103
MESessionPaused                  EQU 104
MESessionStopped                 EQU 105
MESessionClosed                  EQU 106
MESessionEnded                   EQU 107
MESessionRateChanged             EQU 108
MESessionScrubSampleComplete     EQU 109
MESessionCapabilitiesChanged     EQU 110
MESessionTopologyStatus          EQU 111
MESessionNotifyPresentationTime  EQU 112
MENewPresentation                EQU 113
MELicenseAcquisitionStart        EQU 114
MELicenseAcquisitionCompleted    EQU 115
MEIndividualizationStart         EQU 116
MEIndividualizationCompleted     EQU 117
MEEnablerProgress                EQU 118
MEEnablerCompleted               EQU 119
MEPolicyError                    EQU 120
MEPolicyReport                   EQU 121
MEBufferingStarted               EQU 122
MEBufferingStopped               EQU 123
MEConnectStart                   EQU 124
MEConnectEnd                     EQU 125
MEReconnectStart                 EQU 126
MEReconnectEnd                   EQU 127
MERendererEvent                  EQU 128
MESessionStreamSinkFormatChanged EQU 129
MESessionV1Anchor                EQU 129
MESourceUnknown                  EQU 200
MESourceStarted                  EQU 201
MEStreamStarted                  EQU 202
MESourceSeeked                   EQU 203
MEStreamSeeked                   EQU 204
MENewStream                      EQU 205
MEUpdatedStream                  EQU 206
MESourceStopped                  EQU 207
MEStreamStopped                  EQU 208
MESourcePaused                   EQU 209
MEStreamPaused                   EQU 210
MEEndOfPresentation              EQU 211
MEEndOfStream                    EQU 212
MEMediaSample                    EQU 213
MEStreamTick                     EQU 214
MEStreamThinMode                 EQU 215
MEStreamFormatChanged            EQU 216
MESourceRateChanged              EQU 217
MEEndOfPresentationSegment       EQU 218
MESourceCharacteristicsChanged   EQU 219
MESourceRateChangeRequested      EQU 220
MESourceMetadataChanged          EQU 221
MESequencerSourceTopologyUpdated EQU 222
MESourceV1Anchor                 EQU 222
MESinkUnknown                    EQU 300
MEStreamSinkStarted              EQU 301
MEStreamSinkStopped              EQU 302
MEStreamSinkPaused               EQU 303
MEStreamSinkRateChanged          EQU 304
MEStreamSinkRequestSample        EQU 305
MEStreamSinkMarker               EQU 306
MEStreamSinkPrerolled            EQU 307
MEStreamSinkScrubSampleComplete  EQU 308
MEStreamSinkFormatChanged        EQU 309
MEStreamSinkDeviceChanged        EQU 310
MEQualityNotify                  EQU 311
MESinkInvalidated                EQU 312
MEAudioSessionNameChanged        EQU 313
MEAudioSessionVolumeChanged      EQU 314
MEAudioSessionDeviceRemoved      EQU 315
MEAudioSessionServerShutdown     EQU 316
MEAudioSessionGroupingParamChanged EQU 317
MEAudioSessionIconChanged        EQU 318
MEAudioSessionFormatChanged      EQU 319
MEAudioSessionDisconnected       EQU 320
MEAudioSessionExclusiveModeOverride EQU 321
MESinkV1Anchor                   EQU 321
METrustUnknown                   EQU 400
MEPolicyChanged                  EQU 401
MEContentProtectionMessage       EQU 402
MEPolicySet                      EQU 403
METrustV1Anchor                  EQU 403
MEWMDRMLicenseBackupCompleted    EQU 500
MEWMDRMLicenseBackupProgress     EQU 501
MEWMDRMLicenseRestoreCompleted   EQU 502
MEWMDRMLicenseRestoreProgress    EQU 503
MEWMDRMLicenseAcquisitionCompleted EQU 506
MEWMDRMIndividualizationCompleted EQU 508
MEWMDRMIndividualizationProgress EQU 513
MEWMDRMProximityCompleted        EQU 514
MEWMDRMLicenseStoreCleaned       EQU 515
MEWMDRMRevocationDownloadCompleted EQU 516
MEWMDRMV1Anchor                  EQU 516
METransformUnknown               EQU 600
METransformNeedInput             EQU 601
METransformHaveOutput            EQU 602
METransformDrainComplete         EQU 603
METransformMarker                EQU 604
MEReservedMax                    EQU 10000

; MFVideoAspectRatioMode
MFVideoARMode_None              EQU 0h
MFVideoARMode_PreservePicture   EQU 1h
MFVideoARMode_PreservePixel     EQU 2h
MFVideoARMode_NonLinearStretch  EQU 4h
MFVideoARMode_Mask              EQU 7h









