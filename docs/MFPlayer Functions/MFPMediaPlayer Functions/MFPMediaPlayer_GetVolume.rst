.. _MFPMediaPlayer_GetVolume:

========================
MFPMediaPlayer_GetVolume
========================

Gets the current audio volume.

::

   MFPMediaPlayer_GetVolume PROTO pMediaPlayer:DWORD, pdwVolume:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwVolume`` - A pointer to a DWORD variable to store the volume level.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

0 indicates silence and 100 indicates full volume.


**See Also**

:ref:`MFPMediaPlayer_SetVolume<MFPMediaPlayer_SetVolume>`, :ref:`MFPMediaPlayer_GetMute<MFPMediaPlayer_GetMute>`, :ref:`MFPMediaPlayer_SetMute<MFPMediaPlayer_SetMute>`
