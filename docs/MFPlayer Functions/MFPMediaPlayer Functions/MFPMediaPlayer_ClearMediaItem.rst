.. _MFPMediaPlayer_ClearMediaItem:

=============================
MFPMediaPlayer_ClearMediaItem
=============================

Clears the current media item.

::

   MFPMediaPlayer_ClearMediaItem PROTO MediaPlayer:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This method is currently not implemented. It still sends a notification to the Media Event callback as ``MFP_EVENT_TYPE_MEDIAITEM_CLEARED``, if the callback function is specified when creating the Media Player (IMFPMediaPlayer) object during the :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` function (MFPCreateMediaPlayer call)
Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_MEDIAITEM_CLEARED``

**See Also**

:ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`, :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`
