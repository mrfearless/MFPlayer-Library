.. _MFPMediaPlayer_GetMediaItem:

===========================
MFPMediaPlayer_GetMediaItem
===========================

Gets a pointer to the current media item.

::

   MFPMediaPlayer_GetMediaItem PROTO MediaPlayer:DWORD, ppMediaItem:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``ppMediaItem`` - A pointer to the media item's `IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_ interface.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The caller must release the interface.


**See Also**

:ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`, :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`
