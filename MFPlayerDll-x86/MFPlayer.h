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

#include "mfplay.h"

#define MFPLAYER_DLL 1;

#ifdef _MSC_VER     // MSVC compiler
#ifdef MFPLAYER_DLL
#define MFP_EXPORT __stdcall
#else
#define MFP_EXPORT __declspec(dllexport) __stdcall
#endif
#else
#define MFP_EXPORT __declspec(dllimport) __stdcall
#endif

//------------------------------------------------------------------------------
// MFPMediaPlayer Constants, Enums, Structures, Etc
//------------------------------------------------------------------------------
#ifndef HRESULT
    typedef long HRESULT;
#endif

#define STREAMLANG_LENGTH 28
#define STREAMNAME_LENGTH 28

#ifndef _MFP_STREAM_RECORD_
#define _MFP_STREAM_RECORD_
typedef struct MFP_STREAM_RECORD
    {
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

//---------------------------------------------------------------------------------------------------------------------------
// Media Major Type         | Description                              | Subtype
//--------------------------------------------------------------------------------------------------------------------------- 
#define MFMT_None            0 // None.                                     None.
#define MFMT_Audio 	         1 // Audio. 	                                Audio Subtype GUIDs.
#define MFMT_Video 	         2 // Video. 	                                Video Subtype GUIDs.  
#define MFMT_Stream 	     3 // Multiplexed stream or elementary stream. 	Stream Subtype GUIDs
#define MFMT_Metadata 	     4 // Metadata stream. 	                        None.
#define MFMT_Protected 	     5 // Protected media. 	                        The subtype specifies the content protection scheme.
#define MFMT_SAMI 	         6 // SAMI captions. 	                        None.
#define MFMT_Image 	         7 // Still image stream. 	                    WIC GUIDs and CLSIDs.
#define MFMT_Binary 	     8 // Binary stream. 	                        None.
#define MFMT_HTML 	         9 // HTML stream. 	                            None.
#define MFMT_Perception 	10 // Streams from a camera sensor              None.
#define MFMT_FileTransfer 	11 // A stream that contains data files. 	    None.
#define MFMT_Script 	    12 // Script stream. 	                        None.

//---------------------------------------------------------------------------------------------------------------------------
// Audio Format Subtype     | Description                              
//--------------------------------------------------------------------------------------------------------------------------- 
#define MFAF_Unknown          0 // Unknown
#define MFAF_MP3 	          1 // MPEG Audio Layer-3 (MP3). MPEG-4 Part 3, AAC (ISO/IEC 14496-3)
#define MFAF_AAC 	          2 // Advanced Audio Coding (AAC).
#define MFAF_ALAC 	          3 // Apple Lossless Audio Codec (ALAC).
#define MFAF_Dolby_AC3 	      4 // Dolby Digital (AC-3).
#define MFAF_Dolby_AC3_SP     5 // Dolby AC-3 audio over Sony/Philips Digital Interface (S/PDIF).
#define MFAF_Dolby_DDPlus 	  6 // Dolby Digital Plus. EAC3
#define MFAF_Dolby_AC4        7 // Dolby (AC-4).
#define MFAF_Dolby_AC4_V1     8
#define MFAF_Dolby_AC4_V2     9
#define MFAF_Dolby_AC4_V1_ES 10
#define MFAF_Dolby_AC4_V2_ES 11
#define MFAF_DTS 	         12 // Digital Theater Systems (DTS) audio.
#define MFAF_DTS_RAW         13
#define MFAF_DTS_HD          14 // DTS-HD Master Audio
#define MFAF_DTS_XLL         15 // DTS-HD Master Audio Lossless
#define MFAF_DTS_LBR         16
#define MFAF_DTS_UHD         17
#define MFAF_DTS_UHDY        18
#define MFAF_WMAudio_LL      19 // Windows Media Audio 9 Lossless codec or Windows Media Audio 9.1 codec. (WMALOSSLESS)
#define MFAF_WMAudioV8 	     20 // Windows Media Audio 8 codec, Windows Media Audio 9 codec, or Windows Media Audio 9.1 codec. (WMAV2)
#define MFAF_WMAudioV9 	     21 // Windows Media Audio 9 Professional codec or Windows Media Audio 9.1 Professional codec. (WMAPRO)
#define MFAF_WMASPDIF 	     22 // Windows Media Audio 9 Professional codec over S/PDIF.
#define MFAF_FLAC 	         23 // Free Lossless Audio Codec (FLAC).
#define MFAF_PCM 	         24 // Uncompressed PCM audio.
#define MFAF_LPCM            25 // DVD audio data
#define MFAF_MPEG 	         26 // MPEG-1 audio payload. (MP1)
#define MFAF_MPEGH           27
#define MFAF_MPEGH_ES        28
#define MFAF_MSP1 	         29 // Windows Media Audio 9 Voice codec (WMAVOICE)
#define MFAF_AMR_NB 	     30 // Adaptive Multi-Rate Narrowband (AMR_NB)
#define MFAF_AMR_WB 	     31 // Adaptive Multi-Rate Wideband (AMR_WB)
#define MFAF_AMR_WP 	     32 // Adaptive Multi-Rate Wideband Plus (AMR_WP)
#define MFAF_DRM 	         33 // Encrypted audio data used with secure audio path.
#define MFAF_Vorbis          34 // VORBIS
#define MFAF_Opus 	         35 // Opus
#define MFAF_Float 	         36 // Uncompressed IEEE floating-point audio.
#define MFAF_Float_SO        37 // Uncompressed IEEE floating-point audio.
#define MFAF_RAW_AAC1 	     38 // Advanced Audio Coding (AAC). In AVI
#define MFAF_QCELP 	         39 // QCELP (Qualcomm Code Excited Linear Prediction) audio.
#define MFAF_Dolby_AC3_HDCP  40 // Dolby Digital (AC-3) (HDCP)
#define MFAF_AAC_HDCP        41 
#define MFAF_PCM_HDCP        42 
#define MFAF_ADTS_HDCP       43 // Advanced Audio Coding (AAC) in Audio Data Transport Stream (ADTS) format (HDCP)
#define MFAF_ADTS 	         44 // Advanced Audio Coding (AAC) in Audio Data Transport Stream (ADTS)


//---------------------------------------------------------------------------------------------------------------------------
// Video Format Subtype     | Description                              
//--------------------------------------------------------------------------------------------------------------------------- 
#define MFVF_Unknown         0 // 
#define MFVF_M4S2 	         1 // 'M4S2' 	MPEG-4 part 2 video.
#define MFVF_MP4V 	         2 // 'MP4V' 	MPEG-4 part 2 video.
#define MFVF_H264 	         3 // 'H264' 	H.264 video.
#define MFVF_H265 	         4 // 'H265' 	H.265 video.
#define MFVF_H264_ES         5 //           Not applicable H.264 elementary stream.
#define MFVF_WMV1 	         6 // 'WMV1' 	Windows Media Video codec version 7.
#define MFVF_WMV2 	         7 // 'WMV2' 	Windows Media Video 8 codec.
#define MFVF_WMV3 	         8 // 'WMV3' 	Windows Media Video 9 codec.
#define MFVF_MP4S 	         9 // 'MP4S' 	ISO MPEG 4 codec version 1.
#define MFVF_AV1 	        10 // 'AV01' 	AV1 video.
#define MFVF_VP80 	        11 // 'MPG1' 	VP8 video.
#define MFVF_VP90 	        12 // 'MPG1' 	VP9 video.
#define MFVF_HEVC 	        13 // 'HEVC' 	The HEVC Main profile and Main Still Picture profile.
#define MFVF_HEVC_ES        14 //'HEVS' 	This media type is the same as MFVF_HEVC, except media samples contain a fragmented HEVC bitstream.
#define MFVF_H263 	        15 // 'H263' 	H.263 video.
#define MFVF_MSS1 	        16 // 'MSS1' 	Windows Media Screen codec version 1.
#define MFVF_MSS2 	        17 // 'MSS2' 	Windows Media Video 9 Screen codec.
#define MFVF_MJPG 	        18 // 'MJPG' 	Motion JPEG.
#define MFVF_MPG1 	        19 // 'MPG1' 	MPEG-1 video.
#define MFVF_MPEG2          20 // 	        Not applicable 	MPEG-2 video. (Equivalent to MEDIASUBTYPE_MPEG2_VIDEO in DirectShow.)
#define MFVF_DV25 	        21 // 'dv25' 	DVCPRO 25 (525-60 or 625-50).
#define MFVF_DV50 	        22 // 'dv50' 	DVCPRO 50 (525-60 or 625-50).
#define MFVF_DVC 	        23 // 'dvc ' 	DVC/DV Video.
#define MFVF_DVH1 	        24 // 'dvh1' 	DVCPRO 100 (1080/60i, 1080/50i, or 720/60P).
#define MFVF_DVHD 	        25 // 'dvhd' 	HD-DVCR (1125-60 or 1250-50).
#define MFVF_DVSD 	        26 // 'dvsd' 	SDL-DVCR (525-60 or 625-50).
#define MFVF_DVSL 	        27 // 'dvsl' 	SD-DVCR (525-60 or 625-50).
#define MFVF_WVC1 	        28 // 'WVC1' 	SMPTE 421M ("VC-1").
#define MFVF_420O 	        29 // '420O' 	8-bit per channel planar YUV 4:2:0 video.
#define MFVF_MP43 	        30 // 'MP43' 	Microsoft MPEG 4 codec version 3. This codec is no longer supported.

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
bool MFP_EXPORT MFPConvertMSTimeToTimeStringA(DWORD dwMilliseconds, LPSTR *lpszTime, DWORD dwTimeFormat);
bool MFP_EXPORT MFPConvertMSTimeToTimeStringW(DWORD dwMilliseconds, LPWSTR *lpszTime, DWORD dwTimeFormat);

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