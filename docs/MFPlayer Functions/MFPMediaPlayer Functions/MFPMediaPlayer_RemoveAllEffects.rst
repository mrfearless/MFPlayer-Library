.. _MFPMediaPlayer_RemoveAllEffects:

===============================
MFPMediaPlayer_RemoveAllEffects
===============================

Removes all effects that were added with the MFPMediaPlayer_InsertEffect function.

::

   MFPMediaPlayer_RemoveAllEffects PROTO MediaPlayer:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The change applies to the next media item that is set on the player. The effect is not removed from the current media item.


**See Also**

:ref:`MFPMediaPlayer_InsertEffect<MFPMediaPlayer_InsertEffect>`, :ref:`MFPMediaPlayer_RemoveEffect<MFPMediaPlayer_RemoveEffect>`
