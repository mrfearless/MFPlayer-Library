.. _MFPMediaItem_SetStreamSink:

==========================
MFPMediaItem_SetStreamSink
==========================

Sets a media sink for the media item. A media sink is an object that consumes the data from one or more streams.

::

   MFPMediaItem_SetStreamSink PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, pMediaSink:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwStreamIndex`` - Zero-based index of a stream on the media source. The media sink will receive the data from this stream.

* ``pMediaSink`` - `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ pointer that specifies the media sink. Pass in one of the following:

  * A pointer to a stream sink. Every media sink contains one or more stream sinks. Each stream sink receives the data from one stream. The stream sink must expose the `IMFStreamSink <https://learn.microsoft.com/en-us/windows/win32/api/mfidl/nn-mfidl-imfstreamsink>`_ interface.
  
  * A pointer to an activation object that creates the media sink. The activation object must expose the `IMFActivate <https://learn.microsoft.com/en-us/windows/win32/api/mfobjects/nn-mfobjects-imfactivate>`_ interface. The media item uses the first stream sink on the media sink (that is, the stream sink at index 0).
  
  * NULL. If you set ``pMediaSink`` to NULL, the default media sink for the stream type is used.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

By default, the MFPlay player object renders audio streams to the Streaming Audio Renderer (SAR) and video streams to the Enhanced Video Renderer (EVR).

Call this method before calling :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`. Calling this method after :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>` has no effect, unless you stop playback and call :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>` again.

To reset the media item to use the default media sink, set ``pMediaSink`` to NULL

**See Also**

:ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`
