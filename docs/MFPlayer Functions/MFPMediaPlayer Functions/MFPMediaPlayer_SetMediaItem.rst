.. _MFPMediaPlayer_SetMediaItem:

===========================
MFPMediaPlayer_SetMediaItem
===========================

Queues a media item for playback.

::

   MFPMediaPlayer_SetMediaItem PROTO MediaPlayer:DWORD, pMediaItem:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pMediaItem`` - A pointer to the media item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) to queue for play.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_MEDIAITEM_SET``

**See Also**

:ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`, :ref:`MFPMediaPlayer_GetMediaItem<MFPMediaPlayer_GetMediaItem>`
