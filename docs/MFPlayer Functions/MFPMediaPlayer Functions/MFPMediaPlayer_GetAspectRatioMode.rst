.. _MFPMediaPlayer_GetAspectRatioMode:

=================================
MFPMediaPlayer_GetAspectRatioMode
=================================

Gets the current aspect-ratio correction mode.

::

   MFPMediaPlayer_GetAspectRatioMode PROTO MediaPlayer:DWORD, pdwAspectRatioMode:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwAspectRatioMode`` - A pointer to a DWORD variable that contains aspect ratio bitflags.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The variable pointed to by the ``pdwAspectRatioMode`` parameter can contain a combination of the following:

* ``MFVideoARMode_None`` 
* ``MFVideoARMode_PreservePicture`` 
* ``MFVideoARMode_PreservePixel`` 
* ``MFVideoARMode_NonLinearStretch``

**See Also**

:ref:`MFPMediaPlayer_SetAspectRatioMode<MFPMediaPlayer_SetAspectRatioMode>`
