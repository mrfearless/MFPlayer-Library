.. _MFPMediaPlayer_RemoveEffect:

===========================
MFPMediaPlayer_RemoveEffect
===========================

Removes an effect that was added with the MFPMediaPlayer_InsertEffect function.

::

   MFPMediaPlayer_RemoveEffect PROTO MediaPlayer:DWORD, pEffect:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pEffect`` - Pointer to the `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ interface of the effect object. Use the same pointer that you passed to the :ref:`MFPMediaPlayer_InsertEffect<MFPMediaPlayer_InsertEffect>` function.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The change applies to the next media item that is set on the player. The effect is not removed from the current media item.


**See Also**

:ref:`MFPMediaPlayer_InsertEffect<MFPMediaPlayer_InsertEffect>`, :ref:`MFPMediaPlayer_RemoveAllEffects<MFPMediaPlayer_RemoveAllEffects>`
