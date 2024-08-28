.. _MFPMediaPlayer_GetBorderColor:

=============================
MFPMediaPlayer_GetBorderColor
=============================

Gets the current color of the video border. The border color is used to letterbox the video.

::

   MFPMediaPlayer_GetBorderColor PROTO MediaPlayer:DWORD, pColor:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pColor`` - Pointer to a DWORD that stores the border color (`COLORREF <https://learn.microsoft.com/en-us/windows/win32/gdi/colorref>`_) value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Default color is black.


**See Also**

:ref:`MFPMediaPlayer_SetBorderColor<MFPMediaPlayer_SetBorderColor>`
