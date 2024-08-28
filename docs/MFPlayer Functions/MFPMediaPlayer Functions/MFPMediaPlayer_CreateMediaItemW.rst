.. _MFPMediaPlayer_CreateMediaItemW:

===============================
MFPMediaPlayer_CreateMediaItemW
===============================

Creates a media item from a string.

::

   MFPMediaPlayer_CreateMediaItemW PROTO pMediaPlayer:DWORD, lpszMediaItem:DWORD, dwUserData:DWORD, ppMediaItem:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``lpszMediaItem`` - A pointer to an Wide/Unicode string containing the media file to create the media item from.

* ``dwUserData`` - A DWORD value used as custom data.

* ``ppMediaItem`` - A pointer to the media item's `IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_ interface.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_MEDIAITEM_CREATED``

**See Also**

:ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`, :ref:`MFPMediaPlayer_GetMediaItem<MFPMediaPlayer_GetMediaItem>`
