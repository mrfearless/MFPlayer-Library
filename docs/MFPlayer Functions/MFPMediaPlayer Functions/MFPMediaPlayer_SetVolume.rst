.. _MFPMediaPlayer_SetVolume:

========================
MFPMediaPlayer_SetVolume
========================

Sets the audio volume.

::

   MFPMediaPlayer_SetVolume PROTO MediaPlayer:DWORD, dwVolume:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``dwVolume`` - The volume level to set, 0 - 100.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

0 indicates silence and 100 indicates full volume.


**See Also**

:ref:`MFPMediaPlayer_GetVolume<MFPMediaPlayer_GetVolume>`, :ref:`MFPMediaPlayer_GetMute<MFPMediaPlayer_GetMute>`, :ref:`MFPMediaPlayer_SetMute<MFPMediaPlayer_SetMute>`
