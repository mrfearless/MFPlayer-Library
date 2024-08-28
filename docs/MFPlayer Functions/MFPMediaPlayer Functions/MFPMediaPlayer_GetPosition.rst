.. _MFPMediaPlayer_GetPosition:

==========================
MFPMediaPlayer_GetPosition
==========================

Gets the current playback position.

::

   MFPMediaPlayer_GetPosition PROTO pMediaPlayer:DWORD, pdwMilliseconds:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwMilliseconds`` - A pointer to a DWORD variable to store the position of the media item, returned in milliseconds.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This function converts the nano second time value to milliseconds. If an error occurs the value of the milliseconds is set to -1.


**See Also**

:ref:`MFPMediaPlayer_SetPosition<MFPMediaPlayer_SetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
