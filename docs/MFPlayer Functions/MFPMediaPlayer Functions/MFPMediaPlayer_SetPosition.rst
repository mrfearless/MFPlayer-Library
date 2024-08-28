.. _MFPMediaPlayer_SetPosition:

==========================
MFPMediaPlayer_SetPosition
==========================

Sets the playback position.

::

   MFPMediaPlayer_SetPosition PROTO pMediaPlayer:DWORD, dwMilliseconds:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``dwMilliseconds`` - The position to set in the media item, in milliseconds.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

This function converts the milliseconds value to nano seconds.

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_POSITION_SET``

**See Also**

:ref:`MFPMediaPlayer_GetPosition<MFPMediaPlayer_GetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
