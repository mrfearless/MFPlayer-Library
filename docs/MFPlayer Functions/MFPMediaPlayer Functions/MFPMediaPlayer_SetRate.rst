.. _MFPMediaPlayer_SetRate:

======================
MFPMediaPlayer_SetRate
======================

Sets the playback rate.

::

   MFPMediaPlayer_SetRate PROTO MediaPlayer:DWORD, dwRate:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``dwRate`` - A DWORD value of the rate to set.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

100 indicates normal playback speed, 50 indicates half speed, and 200 indicates twice speed, etc.

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_RATE_SET``

**See Also**

:ref:`MFPMediaPlayer_GetRate<MFPMediaPlayer_GetRate>`, :ref:`MFPMediaPlayer_GetSupportedRates<MFPMediaPlayer_GetSupportedRates>`
