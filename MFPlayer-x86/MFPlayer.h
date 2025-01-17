//==============================================================================
//
// MFPlayer x86 Library
//
// http://github.com/mrfearless
//
// This software is provided 'as-is', without any express or implied warranty. 
// In no event will the author be held liable for any damages arising from the 
// use of this software.
//
//==============================================================================

#ifdef __cplusplus
extern "C" {
#endif


#ifdef _MSC_VER     // MSVC compiler
#define MFP_EXPORT __declspec(dllexport) __stdcall
#else
#define MFP_EXPORT
#endif

//------------------------------------------------------------------------------
// MFPMediaPlayer Constants, Enums, Structures, Etc
//------------------------------------------------------------------------------
#ifndef HRESULT
typedef HRESULT TYPEDEF DWORD
#endif

#define STREAMLANG_LENGTH 28
#define STREAMNAME_LENGTH 28

typedef UINT32 MFP_CREATION_OPTIONS;

typedef /* [v1_enum] */ 
enum _MFP_CREATION_OPTIONS
    {
        MFP_OPTION_NONE	= 0,
        MFP_OPTION_FREE_THREADED_CALLBACK	= 0x1,
        MFP_OPTION_NO_MMCSS	= 0x2,
        MFP_OPTION_NO_REMOTE_DESKTOP_OPTIMIZATION	= 0x4
    } 	_MFP_CREATION_OPTIONS;

typedef /* [v1_enum] */ 
enum MFP_MEDIAPLAYER_STATE
    {
        MFP_MEDIAPLAYER_STATE_EMPTY	= 0,
        MFP_MEDIAPLAYER_STATE_STOPPED	= 0x1,
        MFP_MEDIAPLAYER_STATE_PLAYING	= 0x2,
        MFP_MEDIAPLAYER_STATE_PAUSED	= 0x3,
        MFP_MEDIAPLAYER_STATE_SHUTDOWN	= 0x4
    } 	MFP_MEDIAPLAYER_STATE;

typedef UINT32 MFP_MEDIAITEM_CHARACTERISTICS;

typedef /* [v1_enum] */ 
enum _MFP_MEDIAITEM_CHARACTERISTICS
    {
        MFP_MEDIAITEM_IS_LIVE	= 0x1,
        MFP_MEDIAITEM_CAN_SEEK	= 0x2,
        MFP_MEDIAITEM_CAN_PAUSE	= 0x4,
        MFP_MEDIAITEM_HAS_SLOW_SEEK	= 0x8
    } 	_MFP_MEDIAITEM_CHARACTERISTICS;

typedef UINT32 MFP_CREDENTIAL_FLAGS;

typedef /* [v1_enum] */ 
enum _MFP_CREDENTIAL_FLAGS
    {
        MFP_CREDENTIAL_PROMPT	= 0x1,
        MFP_CREDENTIAL_SAVE	= 0x2,
        MFP_CREDENTIAL_DO_NOT_CACHE	= 0x4,
        MFP_CREDENTIAL_CLEAR_TEXT	= 0x8,
        MFP_CREDENTIAL_PROXY	= 0x10,
        MFP_CREDENTIAL_LOGGED_ON_USER	= 0x20
    } 	_MFP_CREDENTIAL_FLAGS;

typedef 
enum MFP_EVENT_TYPE
    {
        MFP_EVENT_TYPE_PLAY	= 0,
        MFP_EVENT_TYPE_PAUSE	= 1,
        MFP_EVENT_TYPE_STOP	= 2,
        MFP_EVENT_TYPE_POSITION_SET	= 3,
        MFP_EVENT_TYPE_RATE_SET	= 4,
        MFP_EVENT_TYPE_MEDIAITEM_CREATED	= 5,
        MFP_EVENT_TYPE_MEDIAITEM_SET	= 6,
        MFP_EVENT_TYPE_FRAME_STEP	= 7,
        MFP_EVENT_TYPE_MEDIAITEM_CLEARED	= 8,
        MFP_EVENT_TYPE_MF	= 9,
        MFP_EVENT_TYPE_ERROR	= 10,
        MFP_EVENT_TYPE_PLAYBACK_ENDED	= 11,
        MFP_EVENT_TYPE_ACQUIRE_USER_CREDENTIAL	= 12
    } 	MFP_EVENT_TYPE;

typedef
enum MediaEventType
    {
        MEUnknown	= 0,
        MEError	= 1,
        MEExtendedType	= 2,
        MENonFatalError	= 3,
        MEGenericV1Anchor	= MENonFatalError,
        MESessionUnknown	= 100,
        MESessionTopologySet	= 101,
        MESessionTopologiesCleared	= 102,
        MESessionStarted	= 103,
        MESessionPaused	= 104,
        MESessionStopped	= 105,
        MESessionClosed	= 106,
        MESessionEnded	= 107,
        MESessionRateChanged	= 108,
        MESessionScrubSampleComplete	= 109,
        MESessionCapabilitiesChanged	= 110,
        MESessionTopologyStatus	= 111,
        MESessionNotifyPresentationTime	= 112,
        MENewPresentation	= 113,
        MELicenseAcquisitionStart	= 114,
        MELicenseAcquisitionCompleted	= 115,
        MEIndividualizationStart	= 116,
        MEIndividualizationCompleted	= 117,
        MEEnablerProgress	= 118,
        MEEnablerCompleted	= 119,
        MEPolicyError	= 120,
        MEPolicyReport	= 121,
        MEBufferingStarted	= 122,
        MEBufferingStopped	= 123,
        MEConnectStart	= 124,
        MEConnectEnd	= 125,
        MEReconnectStart	= 126,
        MEReconnectEnd	= 127,
        MERendererEvent	= 128,
        MESessionStreamSinkFormatChanged	= 129,
        MESessionV1Anchor	= MESessionStreamSinkFormatChanged,
        MESourceUnknown	= 200,
        MESourceStarted	= 201,
        MEStreamStarted	= 202,
        MESourceSeeked	= 203,
        MEStreamSeeked	= 204,
        MENewStream	= 205,
        MEUpdatedStream	= 206,
        MESourceStopped	= 207,
        MEStreamStopped	= 208,
        MESourcePaused	= 209,
        MEStreamPaused	= 210,
        MEEndOfPresentation	= 211,
        MEEndOfStream	= 212,
        MEMediaSample	= 213,
        MEStreamTick	= 214,
        MEStreamThinMode	= 215,
        MEStreamFormatChanged	= 216,
        MESourceRateChanged	= 217,
        MEEndOfPresentationSegment	= 218,
        MESourceCharacteristicsChanged	= 219,
        MESourceRateChangeRequested	= 220,
        MESourceMetadataChanged	= 221,
        MESequencerSourceTopologyUpdated	= 222,
        MESourceV1Anchor	= MESequencerSourceTopologyUpdated,
        MESinkUnknown	= 300,
        MEStreamSinkStarted	= 301,
        MEStreamSinkStopped	= 302,
        MEStreamSinkPaused	= 303,
        MEStreamSinkRateChanged	= 304,
        MEStreamSinkRequestSample	= 305,
        MEStreamSinkMarker	= 306,
        MEStreamSinkPrerolled	= 307,
        MEStreamSinkScrubSampleComplete	= 308,
        MEStreamSinkFormatChanged	= 309,
        MEStreamSinkDeviceChanged	= 310,
        MEQualityNotify	= 311,
        MESinkInvalidated	= 312,
        MEAudioSessionNameChanged	= 313,
        MEAudioSessionVolumeChanged	= 314,
        MEAudioSessionDeviceRemoved	= 315,
        MEAudioSessionServerShutdown	= 316,
        MEAudioSessionGroupingParamChanged	= 317,
        MEAudioSessionIconChanged	= 318,
        MEAudioSessionFormatChanged	= 319,
        MEAudioSessionDisconnected	= 320,
        MEAudioSessionExclusiveModeOverride	= 321,
        MESinkV1Anchor	= MEAudioSessionExclusiveModeOverride,
        MECaptureAudioSessionVolumeChanged	= 322,
        MECaptureAudioSessionDeviceRemoved	= 323,
        MECaptureAudioSessionFormatChanged	= 324,
        MECaptureAudioSessionDisconnected	= 325,
        MECaptureAudioSessionExclusiveModeOverride	= 326,
        MECaptureAudioSessionServerShutdown	= 327,
        MESinkV2Anchor	= MECaptureAudioSessionServerShutdown,
        METrustUnknown	= 400,
        MEPolicyChanged	= 401,
        MEContentProtectionMessage	= 402,
        MEPolicySet	= 403,
        METrustV1Anchor	= MEPolicySet,
        MEWMDRMLicenseBackupCompleted	= 500,
        MEWMDRMLicenseBackupProgress	= 501,
        MEWMDRMLicenseRestoreCompleted	= 502,
        MEWMDRMLicenseRestoreProgress	= 503,
        MEWMDRMLicenseAcquisitionCompleted	= 506,
        MEWMDRMIndividualizationCompleted	= 508,
        MEWMDRMIndividualizationProgress	= 513,
        MEWMDRMProximityCompleted	= 514,
        MEWMDRMLicenseStoreCleaned	= 515,
        MEWMDRMRevocationDownloadCompleted	= 516,
        MEWMDRMV1Anchor	= MEWMDRMRevocationDownloadCompleted,
        METransformUnknown	= 600,
        METransformNeedInput	= ( METransformUnknown + 1 ) ,
        METransformHaveOutput	= ( METransformNeedInput + 1 ) ,
        METransformDrainComplete	= ( METransformHaveOutput + 1 ) ,
        METransformMarker	= ( METransformDrainComplete + 1 ) ,
        METransformInputStreamStateChanged	= ( METransformMarker + 1 ) ,
        MEByteStreamCharacteristicsChanged	= 700,
        MEVideoCaptureDeviceRemoved	= 800,
        MEVideoCaptureDevicePreempted	= 801,
        MEStreamSinkFormatInvalidated	= 802,
        MEEncodingParameters	= 803,
        MEContentProtectionMetadata	= 900,
        MEDeviceThermalStateChanged	= 950,
        MEReservedMax	= 10000
    }   MediaEventType;

typedef 
enum MFVideoAspectRatioMode
    {
        MFVideoARMode_None	= 0,
        MFVideoARMode_PreservePicture	= 0x1,
        MFVideoARMode_PreservePixel	= 0x2,
        MFVideoARMode_NonLinearStretch	= 0x4,
        MFVideoARMode_Mask	= 0x7
    } 	MFVideoAspectRatioMode;

typedef 
enum _MFVideoInterlaceMode
    {
        MFVideoInterlace_Unknown	= 0,
        MFVideoInterlace_Progressive	= 2,
        MFVideoInterlace_FieldInterleavedUpperFirst	= 3,
        MFVideoInterlace_FieldInterleavedLowerFirst	= 4,
        MFVideoInterlace_FieldSingleUpper	= 5,
        MFVideoInterlace_FieldSingleLower	= 6,
        MFVideoInterlace_MixedInterlaceOrProgressive	= 7,
        MFVideoInterlace_Last	= ( MFVideoInterlace_MixedInterlaceOrProgressive + 1 ) ,
        MFVideoInterlace_ForceDWORD	= 0x7fffffff
    } 	MFVideoInterlaceMode;

#ifndef _MFP_STREAM_RECORD_
#define _MFP_STREAM_RECORD_
typedef struct MFP_STREAM_RECORD
    DWORD dwStreamID;
    BOOL bSelected;
    BYTE szStreamLang[STREAMLANG_LENGTH+4];
    BYTE szStreamName[STREAMNAME_LENGTH+4];
    DWORD dwMajorType;
    DWORD dwSubType;
    DWORD dwBitRate;
    union {
        struct {
        DWORD dwChannels;
        DWORD dwSpeakers;
        DWORD dwBitsPerSample;
        DWORD dwSamplesPerSec;
        } AudioSteamInfo;
        struct {
        DWORD dwFrameRate;
        DWORD dwFrameWidth;
        DWORD dwFrameHeight;
        DWORD dwInterlace;
        } VideoStreamInfo;
    } StreamInfo;
} 	MFP_STREAM_RECORD;
#endif

#ifndef _MFP_EVENT_HEADER_
#define _MFP_EVENT_HEADER_
typedef struct MFP_EVENT_HEADER
    {
    MFP_EVENT_TYPE eEventType;
    HRESULT hrEvent;
    IMFPMediaPlayer *pMediaPlayer;
    MFP_MEDIAPLAYER_STATE eState;
    IPropertyStore *pPropertyStore;
    } 	MFP_EVENT_HEADER;
#endif

#ifndef _MFP_PLAY_EVENT_
#define _MFP_PLAY_EVENT_
typedef struct MFP_PLAY_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_PLAY_EVENT;
#endif

#ifndef _MFP_PAUSE_EVENT_
#define _MFP_PAUSE_EVENT_
typedef struct MFP_PAUSE_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_PAUSE_EVENT;
#endif

#ifndef _MFP_STOP_EVENT_
#define _MFP_STOP_EVENT_
typedef struct MFP_STOP_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_STOP_EVENT;
#endif

#ifndef _MFP_POSITION_SET_EVENT_
#define _MFP_POSITION_SET_EVENT_
typedef struct MFP_POSITION_SET_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_POSITION_SET_EVENT;
#endif

#ifndef _MFP_RATE_SET_EVENT_
#define _MFP_RATE_SET_EVENT_
typedef struct MFP_RATE_SET_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    float flRate;
    } 	MFP_RATE_SET_EVENT;
#endif

#ifndef _MFP_MEDIAITEM_CREATED_EVENT_
#define _MFP_MEDIAITEM_CREATED_EVENT_
typedef struct MFP_MEDIAITEM_CREATED_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    DWORD_PTR dwUserData;
    } 	MFP_MEDIAITEM_CREATED_EVENT;
#endif

#ifndef _MFP_MEDIAITEM_SET_EVENT_
#define _MFP_MEDIAITEM_SET_EVENT_
typedef struct MFP_MEDIAITEM_SET_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_MEDIAITEM_SET_EVENT;
#endif

#ifndef _MFP_FRAME_STEP_EVENT_
#define _MFP_FRAME_STEP_EVENT_
typedef struct MFP_FRAME_STEP_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_FRAME_STEP_EVENT;
#endif

#ifndef _MFP_MEDIAITEM_CLEARED_EVENT_
#define _MFP_MEDIAITEM_CLEARED_EVENT_
typedef struct MFP_MEDIAITEM_CLEARED_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_MEDIAITEM_CLEARED_EVENT;
#endif

#ifndef _MFP_MF_EVENT_
#define _MFP_MF_EVENT_
typedef struct MFP_MF_EVENT
    {
    MFP_EVENT_HEADER header;
    MediaEventType MFEventType;
    IMFMediaEvent *pMFMediaEvent;
    IMFPMediaItem *pMediaItem;
    } 	MFP_MF_EVENT;
#endif

#ifndef _MFP_ERROR_EVENT_
#define _MFP_ERROR_EVENT_
typedef struct MFP_ERROR_EVENT
    {
    MFP_EVENT_HEADER header;
    } 	MFP_ERROR_EVENT;
#endif

#ifndef _MFP_PLAYBACK_ENDED_EVENT_
#define _MFP_PLAYBACK_ENDED_EVENT_
typedef struct MFP_PLAYBACK_ENDED_EVENT
    {
    MFP_EVENT_HEADER header;
    IMFPMediaItem *pMediaItem;
    } 	MFP_PLAYBACK_ENDED_EVENT;
#endif

#ifndef _MFP_ACQUIRE_USER_CREDENTIAL_EVENT_
#define _MFP_ACQUIRE_USER_CREDENTIAL_EVENT_
typedef struct MFP_ACQUIRE_USER_CREDENTIAL_EVENT
    {
    MFP_EVENT_HEADER header;
    DWORD_PTR dwUserData;
    BOOL fProceedWithAuthentication;
    HRESULT hrAuthenticationStatus;
    LPCWSTR pwszURL;
    LPCWSTR pwszSite;
    LPCWSTR pwszRealm;
    LPCWSTR pwszPackage;
    LONG nRetries;
    MFP_CREDENTIAL_FLAGS flags;
    IMFNetCredential *pCredential;
    } 	MFP_ACQUIRE_USER_CREDENTIAL_EVENT;
#endif

#ifndef _MFVideoNormalizedRect_
#define _MFVideoNormalizedRect_
typedef struct MFVideoNormalizedRect
    {
    float left;
    float top;
    float right;
    float bottom;
    } 	MFVideoNormalizedRect;
#endif


/*------------------------------------------------------------------------------
// MFPlayer Library Function Prototypes
//----------------------------------------------------------------------------*/

// MFPMediaPlayer Functions:
bool MFP_EXPORT MFPMediaPlayer_Init(HWND hMFPWindow, void *pCallback, IMFPMediaPlayer **ppMediaPlayer);
void MFP_EXPORT MFPMediaPlayer_Free(IMFPMediaPlayer **ppMediaPlayer);

bool MFP_EXPORT MFPMediaPlayer_Play(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_Pause(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_Stop(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_Step(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_Toggle(IMFPMediaPlayer *pMediaPlayer);

bool MFP_EXPORT MFPMediaPlayer_ClearMediaItem(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_SetMediaItem(IMFPMediaPlayer *pMediaPlayer, IMFPMediaItem *pMediaItem);
bool MFP_EXPORT MFPMediaPlayer_GetMediaItem(IMFPMediaPlayer *pMediaPlayer, IMFPMediaItem **ppMediaItem);
bool MFP_EXPORT MFPMediaPlayer_CreateMediaItemA(IMFPMediaPlayer *pMediaPlayer, LPCSTR *lpszMediaItem, DWORD dwUserData, IMFPMediaItem **ppMediaItem);
bool MFP_EXPORT MFPMediaPlayer_CreateMediaItemW(IMFPMediaPlayer *pMediaPlayer, LPCWSTR *lpszMediaItem, DWORD dwUserData, IMFPMediaItem **ppMediaItem);
bool MFP_EXPORT MFPMediaPlayer_CreateMediaItemFromObject(IMFPMediaPlayer *pMediaPlayer, IUnknown *pIUnknownObj, DWORD dwUserData, IMFPMediaItem **ppMediaItem);

bool MFP_EXPORT MFPMediaPlayer_GetState(IMFPMediaPlayer *pMediaPlayer, MFP_MEDIAPLAYER_STATE *peState);
bool MFP_EXPORT MFPMediaPlayer_SetPosition(IMFPMediaPlayer *pMediaPlayer, DWORD dwMilliseconds);
bool MFP_EXPORT MFPMediaPlayer_GetPosition(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwMilliseconds);
bool MFP_EXPORT MFPMediaPlayer_GetDuration(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwMilliseconds);

bool MFP_EXPORT MFPMediaPlayer_SetRate(IMFPMediaPlayer *pMediaPlayer, DWORD dwRate);
bool MFP_EXPORT MFPMediaPlayer_GetRate(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwRate);
bool MFP_EXPORT MFPMediaPlayer_GetSupportedRates(IMFPMediaPlayer *pMediaPlayer, BOOL bForwardDirection, DWORD *pdwSlowestRate, DWORD *pdwFastestRate);

bool MFP_EXPORT MFPMediaPlayer_GetVolume(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwVolume);
bool MFP_EXPORT MFPMediaPlayer_SetVolume(IMFPMediaPlayer *pMediaPlayer, DWORD dwVolume);
bool MFP_EXPORT MFPMediaPlayer_GetBalance(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwBalance);
bool MFP_EXPORT MFPMediaPlayer_SetBalance(IMFPMediaPlayer *pMediaPlayer, DWORD dwBalance);
bool MFP_EXPORT MFPMediaPlayer_GetMute(IMFPMediaPlayer *pMediaPlayer, BOOL *pbMute);
bool MFP_EXPORT MFPMediaPlayer_SetMute(IMFPMediaPlayer *pMediaPlayer, BOOL bMute);

bool MFP_EXPORT MFPMediaPlayer_GetNativeVideoSize(IMFPMediaPlayer *pMediaPlayer, SIZE *pszVideo, SIZE *pszARVideo);
bool MFP_EXPORT MFPMediaPlayer_GetIdealVideoSize(IMFPMediaPlayer *pMediaPlayer, SIZE *pszMin, SIZE *pszMax);
bool MFP_EXPORT MFPMediaPlayer_SetVideoSourceRect(IMFPMediaPlayer *pMediaPlayer, const MFVideoNormalizedRect *pnrcSource);
bool MFP_EXPORT MFPMediaPlayer_GetVideoSourceRect(IMFPMediaPlayer *pMediaPlayer, MFVideoNormalizedRect *pnrcSource);

bool MFP_EXPORT MFPMediaPlayer_SetAspectRatioMode(IMFPMediaPlayer *pMediaPlayer, DWORD dwAspectRatioMode);
bool MFP_EXPORT MFPMediaPlayer_GetAspectRatioMode(IMFPMediaPlayer *pMediaPlayer, DWORD *pdwAspectRatioMode);

bool MFP_EXPORT MFPMediaPlayer_GetVideoWindow(IMFPMediaPlayer *pMediaPlayer, HWND *phwndVideo);
bool MFP_EXPORT MFPMediaPlayer_UpdateVideo(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_SetBorderColor(IMFPMediaPlayer *pMediaPlayer, COLORREF Color);
bool MFP_EXPORT MFPMediaPlayer_GetBorderColor(IMFPMediaPlayer *pMediaPlayer, COLORREF *pColor);

bool MFP_EXPORT MFPMediaPlayer_InsertEffect(IMFPMediaPlayer *pMediaPlayer, IUnknown *pEffect, BOOL bOptional);
bool MFP_EXPORT MFPMediaPlayer_RemoveEffect(IMFPMediaPlayer *pMediaPlayer, IUnknown *pEffect);
bool MFP_EXPORT MFPMediaPlayer_RemoveAllEffects(IMFPMediaPlayer *pMediaPlayer);
bool MFP_EXPORT MFPMediaPlayer_Shutdown(IMFPMediaPlayer *pMediaPlayer);

// MFPMediaItem Functions:
bool MFP_EXPORT MFPMediaItem_Release(IMFPMediaItem *pMediaItem);
bool MFP_EXPORT MFPMediaItem_GetMediaPlayer(IMFPMediaItem *pMediaItem, IMFPMediaPlayer **ppMediaPlayer);
bool MFP_EXPORT MFPMediaItem_GetURLA(IMFPMediaItem *pMediaItem, LPSTR *ppszURL);
bool MFP_EXPORT MFPMediaItem_GetURLW(IMFPMediaItem *pMediaItem, LPWSTR *ppszURL);

bool MFP_EXPORT MFPMediaItem_SetUserData(IMFPMediaItem *pMediaItem, DWORD dwUserData);
bool MFP_EXPORT MFPMediaItem_GetUserData(IMFPMediaItem *pMediaItem, DWORD_PTR *pdwUserData);

bool MFP_EXPORT MFPMediaItem_SetStartStopPosition(IMFPMediaItem *pMediaItem, DWORD dwStartValue, DWORD dwStopValue);
bool MFP_EXPORT MFPMediaItem_GetStartStopPosition(IMFPMediaItem *pMediaItem, DWORD_PTR *pdwStartValue, DWORD_PTR *pdwStopValue);

bool MFP_EXPORT MFPMediaItem_HasVideo(IMFPMediaItem *pMediaItem, BOOL *pbHasVideo, BOOL *pbSelected);
bool MFP_EXPORT MFPMediaItem_HasAudio(IMFPMediaItem *pMediaItem, BOOL *pbHasAudio, BOOL *pbSelected);
bool MFP_EXPORT MFPMediaItem_IsProtected(IMFPMediaItem *pMediaItem, BOOL *pbProtected);

bool MFP_EXPORT MFPMediaItem_GetDuration(IMFPMediaItem *pMediaItem, DWORD *pdwMilliseconds);
bool MFP_EXPORT MFPMediaItem_GetNumberOfStreams(IMFPMediaItem *pMediaItem, DWORD *pdwStreamCount);
bool MFP_EXPORT MFPMediaItem_SetStreamSelection(IMFPMediaItem *pMediaItem, DWORD dwStreamIndex, BOOL bEnabled);
bool MFP_EXPORT MFPMediaItem_GetStreamSelection(IMFPMediaItem *pMediaItem, DWORD dwStreamIndex, BOOL *pbEnabled);

bool MFP_EXPORT MFPMediaItem_GetStreamAttribute(IMFPMediaItem *pMediaItem, DWORD dwStreamIndex, REFGUID guidMFAttribute, PROPVARIANT *pvValue);
bool MFP_EXPORT MFPMediaItem_GetPresentationAttribute(IMFPMediaItem *pMediaItem, REFGUID guidMFAttribute, PROPVARIANT *pvValue);
bool MFP_EXPORT MFPMediaItem_GetCharacteristics(IMFPMediaItem *pMediaItem, MFP_MEDIAITEM_CHARACTERISTICS *pCharacteristics);
bool MFP_EXPORT MFPMediaItem_GetMetadata(IMFPMediaItem *pMediaItem, IPropertyStore **ppMetadataStore);

bool MFP_EXPORT MFPMediaItem_SetStreamSink(IMFPMediaItem *pMediaItem, DWORD dwStreamIndex, IUnknown *pMediaSink);

// Media Information
bool MFP_EXPORT MFPMediaItem_StreamTable(IMFPMediaItem *pMediaItem, DWORD *lpdwStreamCount, DWORD *lpdwStreamTable);

// Misc
bool MFP_EXPORT MFPConvertMSTimeToTimeStringA(dwMilliseconds:DWORD, LPSTR *lpszTime:DWORD, DWORD dwTimeFormat);
bool MFP_EXPORT MFPConvertMSTimeToTimeStringW(dwMilliseconds:DWORD, LPWSTR *lpszTime:DWORD, DWORD dwTimeFormat);

LPSTR * MFP_EXPORT MFPConvertStringToAnsi(LPWSTR *lpszWideString);
LPWSTR * MFP_EXPORT MFPConvertStringToWide(LPSTR *lpszAnsiString);
void MFP_EXPORT MFPConvertStringFree(LPWSTR *lpString);

#ifdef UNICODE
#define MFPMediaPlayer_CreateMediaItem      MFPMediaPlayer_CreateMediaItemW
#define MFPMediaItem_GetURL                 MFPMediaItem_GetURLW
#define MFPConvertMSTimeToTimeString        MFPConvertMSTimeToTimeStringW
#else // ANSI
#define MFPMediaPlayer_CreateMediaItem      MFPMediaPlayer_CreateMediaItemA
#define MFPMediaItem_GetURL                 MFPMediaItem_GetURLA
#define MFPConvertMSTimeToTimeString        MFPConvertMSTimeToTimeStringA
#endif


#ifdef __cplusplus
}
#endif