.. _MFPMediaPlayer_SetBorderColor:

=============================
MFPMediaPlayer_SetBorderColor
=============================

Sets the color for the video border. The border color is used to letterbox the video.

::

   MFPMediaPlayer_SetBorderColor PROTO MediaPlayer:DWORD, Color:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``Color`` - Specifies the border color as a `COLORREF <https://learn.microsoft.com/en-us/windows/win32/gdi/colorref>`_ value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Default color is black.


**See Also**

:ref:`MFPMediaPlayer_GetBorderColor<MFPMediaPlayer_GetBorderColor>`
