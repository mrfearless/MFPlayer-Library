.. _MFPMediaPlayer_CreateMediaItemFromObject:

========================================
MFPMediaPlayer_CreateMediaItemFromObject
========================================

Creates a media item from an object.

::

   MFPMediaPlayer_CreateMediaItemFromObject PROTO MediaPlayer:DWORD, pIUnknownObj:DWORD, dwUserData:DWORD, ppMediaItem:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pIUnknownObj`` - A pointer to an `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ object.

* ``dwUserData`` - A dword value used as custom data.

* ``ppMediaItem`` - A pointer to the media item's `IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_ interface.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_MEDIAITEM_CREATED``

**See Also**

:ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`, :ref:`MFPMediaPlayer_GetMediaItem<MFPMediaPlayer_GetMediaItem>`, :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`
