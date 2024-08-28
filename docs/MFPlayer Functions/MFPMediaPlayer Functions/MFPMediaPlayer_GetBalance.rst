.. _MFPMediaPlayer_GetBalance:

=========================
MFPMediaPlayer_GetBalance
=========================

Gets the current audio balance.

::

   MFPMediaPlayer_GetBalance PROTO MediaPlayer:DWORD, pdwBalance:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwBalance`` - A pointer to a DWORD variable to store the balance level.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

0 indicates balance, -100 indicates left, +100 indicates right.


**See Also**

:ref:`MFPMediaPlayer_GetBalance<MFPMediaPlayer_GetBalance>`, :ref:`MFPMediaPlayer_GetVolume<MFPMediaPlayer_GetVolume>`, :ref:`MFPMediaPlayer_GetMute<MFPMediaPlayer_GetMute>`, :ref:`MFPMediaPlayer_SetMute<MFPMediaPlayer_SetMute>`
