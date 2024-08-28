.. _MFPMediaItem_GetStartStopPosition:

=================================
MFPMediaItem_GetStartStopPosition
=================================

Gets the start and stop times for the media item.

::

   MFPMediaItem_GetStartStopPosition PROTO pMediaItem:DWORD, pdwStartValue:DWORD, pdwStopValue:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pdwStartValue`` - A pointer to a DWORD variable to store the start position of the media item, returned in milliseconds.

* ``pdwStopValue`` - A pointer to a DWORD variable to store the stop position of the media item, returned in milliseconds.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This function converts the nano second time values to milliseconds. If an error occurs the value of the milliseconds is set to -1.


**See Also**

:ref:`MFPMediaItem_SetStartStopPosition<MFPMediaItem_SetStartStopPosition>`, :ref:`MFPMediaItem_GetDuration<MFPMediaItem_GetDuration>`, :ref:`MFPMediaPlayer_GetPosition<MFPMediaPlayer_GetPosition>`, :ref:`MFPMediaPlayer_SetPosition<MFPMediaPlayer_SetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
