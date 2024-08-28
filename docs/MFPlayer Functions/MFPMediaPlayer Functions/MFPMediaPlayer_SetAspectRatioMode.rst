.. _MFPMediaPlayer_SetAspectRatioMode:

=================================
MFPMediaPlayer_SetAspectRatioMode
=================================

Specifies whether the aspect ratio of the video is preserved during playback.

::

   MFPMediaPlayer_SetAspectRatioMode PROTO MediaPlayer:DWORD, dwAspectRatioMode:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``dwAspectRatioMode`` - Bitwise flags for aspect ratio.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

dwAspectRatioMode can contain a combination of the following:

* ``MFVideoARMode_None`` 
* ``MFVideoARMode_PreservePicture`` 
* ``MFVideoARMode_PreservePixel`` 
* ``MFVideoARMode_NonLinearStretch``

In practice only ``MFVideoARMode_None`` and (``MFVideoARMode_PreservePicture or MFVideoARMode_PreservePixel``) actually do anything. 

**See Also**

:ref:`MFPMediaPlayer_GetAspectRatioMode<MFPMediaPlayer_GetAspectRatioMode>`
