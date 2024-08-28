.. _MFPMediaPlayer_GetMute:

======================
MFPMediaPlayer_GetMute
======================

Queries whether the audio is muted.

::

   MFPMediaPlayer_GetMute PROTO MediaPlayer:DWORD, pbMute:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pbMute`` - A pointer to a DWORD variable containing TRUE or FALSE.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The variable pointed to by the ``pbMute`` parameter will contain TRUE if the audio is muted, or FALSE otherwise.


**See Also**

:ref:`MFPMediaPlayer_SetMute<MFPMediaPlayer_SetMute>`, :ref:`MFPMediaPlayer_GetVolume<MFPMediaPlayer_GetVolume>`, :ref:`MFPMediaPlayer_SetVolume<MFPMediaPlayer_SetVolume>`
