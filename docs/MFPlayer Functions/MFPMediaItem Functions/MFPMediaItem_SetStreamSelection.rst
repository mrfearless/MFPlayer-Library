.. _MFPMediaItem_SetStreamSelection:

===============================
MFPMediaItem_SetStreamSelection
===============================

Selects or deselects a stream.

::

   MFPMediaItem_SetStreamSelection PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, bEnabled:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwStreamIndex`` - A zero based index of the stream.

* ``bEnabled`` - TRUE or FALSE.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

You can use this method to change which streams are selected. The change goes into effect the next time that :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>` is called with this media item. If the media item is already set on the player, the change does not happen unless you call :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>` again with this media item.


**See Also**

:ref:`MFPMediaItem_GetStreamSelection<MFPMediaItem_GetStreamSelection>`, :ref:`MFPMediaItem_GetNumberOfStreams<MFPMediaItem_GetNumberOfStreams>`, :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`
