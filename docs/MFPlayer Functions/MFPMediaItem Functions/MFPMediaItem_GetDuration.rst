.. _MFPMediaItem_GetDuration:

========================
MFPMediaItem_GetDuration
========================

Gets the duration of the media item.

::

   MFPMediaItem_GetDuration PROTO pMediaItem:DWORD, pdwMilliseconds:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pdwMilliseconds`` - A pointer to a DWORD variable to store the duration of the media item, returned in milliseconds.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This function converts the nano second time value to milliseconds. If an error occurs the value of the milliseconds is set to -1.


**See Also**

:ref:`MFPMediaItem_GetStartStopPosition<MFPMediaItem_GetStartStopPosition>`, :ref:`MFPMediaItem_SetStartStopPosition<MFPMediaItem_SetStartStopPosition>`, :ref:`MFPMediaPlayer_GetPosition<MFPMediaPlayer_GetPosition>`, :ref:`MFPMediaPlayer_SetPosition<MFPMediaPlayer_SetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
