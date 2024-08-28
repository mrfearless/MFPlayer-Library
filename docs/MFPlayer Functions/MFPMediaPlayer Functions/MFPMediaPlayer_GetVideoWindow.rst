.. _MFPMediaPlayer_GetVideoWindow:

=============================
MFPMediaPlayer_GetVideoWindow
=============================

Gets the window where the video is displayed.

::

   MFPMediaPlayer_GetVideoWindow PROTO MediaPlayer:DWORD, phwndVideo:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``phwndVideo`` - A pointer to a variable to hold the window handle.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The video window is specified when you first call :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` to create the MFPlay player object.


**See Also**

:ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>`, :ref:`MFPMediaPlayer_UpdateVideo<MFPMediaPlayer_UpdateVideo>`
