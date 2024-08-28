.. _MFPMediaPlayer_SetBalance:

=========================
MFPMediaPlayer_SetBalance
=========================

Sets the current audio balance.

::

   MFPMediaPlayer_SetBalance PROTO MediaPlayer:DWORD, dwBalance:SDWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``dwBalance`` - The balance level to set, -100 to +100.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

0 indicates balance, -100 indicates left, +100 indicates right.


**See Also**

:ref:`MFPMediaPlayer_GetBalance<MFPMediaPlayer_GetBalance>`, :ref:`MFPMediaPlayer_GetVolume<MFPMediaPlayer_GetVolume>`, :ref:`MFPMediaPlayer_GetMute<MFPMediaPlayer_GetMute>`, :ref:`MFPMediaPlayer_SetMute<MFPMediaPlayer_SetMute>`
