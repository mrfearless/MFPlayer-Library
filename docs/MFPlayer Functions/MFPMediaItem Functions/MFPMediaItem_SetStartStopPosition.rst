.. _MFPMediaItem_SetStartStopPosition:

=================================
MFPMediaItem_SetStartStopPosition
=================================

Sets the start and stop times for the media item.

::

   MFPMediaItem_SetStartStopPosition PROTO pMediaItem:DWORD, dwStartValue:DWORD, dwStopValue:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwStartValue`` - The start position to set in the media item, in milliseconds

* ``dwStopValue`` - The stop position to set in the media item, in milliseconds.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This function converts the milliseconds values to nano seconds.


**See Also**

:ref:`MFPMediaItem_GetStartStopPosition<MFPMediaItem_GetStartStopPosition>`, :ref:`MFPMediaItem_GetDuration<MFPMediaItem_GetDuration>`, :ref:`MFPMediaPlayer_GetPosition<MFPMediaPlayer_GetPosition>`, :ref:`MFPMediaPlayer_SetPosition<MFPMediaPlayer_SetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
