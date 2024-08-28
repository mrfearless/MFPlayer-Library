.. _MFPMediaPlayer_InsertEffect:

===========================
MFPMediaPlayer_InsertEffect
===========================

Applies an audio or video effect to playback.

::

   MFPMediaPlayer_InsertEffect PROTO MediaPlayer:DWORD, pEffect:DWORD, bOptional:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pEffect`` - Pointer to the `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ interface for one of the following: 

  * A Media Foundation transform (MFT) that implements the effect. MFTs expose the `IMFTransform <https://learn.microsoft.com/en-us/windows/win32/api/mftransform/nn-mftransform-imftransform>`_ interface.
  
  * An activation object that creates an MFT. Activation objects expose the `IMFActivate <https://learn.microsoft.com/en-us/windows/win32/api/mfobjects/nn-mfobjects-imfactivate>`_ interface.

* ``bOptional`` - Specifies whether the effect is optional.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The object specified in the ``pEffect`` parameter can implement either a video effect or an audio effect. The effect is applied to any media items set after the method is called. It is not applied to the current media item.


**See Also**

:ref:`MFPMediaPlayer_RemoveEffect<MFPMediaPlayer_RemoveEffect>`, :ref:`MFPMediaPlayer_RemoveAllEffects<MFPMediaPlayer_RemoveAllEffects>`
