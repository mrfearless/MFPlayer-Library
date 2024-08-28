.. _MFPMediaPlayer_GetRate:

======================
MFPMediaPlayer_GetRate
======================

Gets the current playback rate.

::

   MFPMediaPlayer_GetRate PROTO pMediaPlayer:DWORD, pdwRate:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwRate`` - A pointer to a DWORD variable that store the rate value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

100 indicates normal playback speed, 50 indicates half speed, and 200 indicates twice speed, etc.


**See Also**

:ref:`MFPMediaPlayer_SetRate<MFPMediaPlayer_SetRate>`, :ref:`MFPMediaPlayer_GetSupportedRates<MFPMediaPlayer_GetSupportedRates>`
