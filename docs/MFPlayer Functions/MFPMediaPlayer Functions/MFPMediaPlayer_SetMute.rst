.. _MFPMediaPlayer_SetMute:

======================
MFPMediaPlayer_SetMute
======================

Mutes or unmutes the audio.

::

   MFPMediaPlayer_SetMute PROTO MediaPlayer:DWORD, bMute:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``bMute`` - TRUE to mute the audio, or FALSE to unmute the audio.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Get volume level before setting mute, then restore that level apon unmute.


**See Also**

:ref:`MFPMediaPlayer_GetMute<MFPMediaPlayer_GetMute>`, :ref:`MFPMediaPlayer_GetVolume<MFPMediaPlayer_GetVolume>`, :ref:`MFPMediaPlayer_SetVolume<MFPMediaPlayer_SetVolume>`
