.. _MFPMediaPlayer_GetSupportedRates:

================================
MFPMediaPlayer_GetSupportedRates
================================

Gets the range of supported playback rates.

::

   MFPMediaPlayer_GetSupportedRates PROTO pMediaPlayer:DWORD, bForwardDirection:DWORD, pdwSlowestRate:DWORD, pdwFastestRate:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``bForwardDirection`` - TRUE for forward playback or FALSE for reverse playback

* ``pdwSlowestRate`` - A pointer to a DWORD to store the slowest rate value.

* ``pdwFastestRate`` - A pointer to a DWORD to store the fastest rate value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

100 indicates normal playback speed, 50 indicates half speed, and 200 indicates twice speed, etc.


**See Also**

:ref:`MFPMediaPlayer_GetRate<MFPMediaPlayer_GetRate>`, :ref:`MFPMediaPlayer_SetRate<MFPMediaPlayer_SetRate>`
