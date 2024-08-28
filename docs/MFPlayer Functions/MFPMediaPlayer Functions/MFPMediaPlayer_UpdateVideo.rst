.. _MFPMediaPlayer_UpdateVideo:

==========================
MFPMediaPlayer_UpdateVideo
==========================

Updates the video frame.

::

   MFPMediaPlayer_UpdateVideo PROTO MediaPlayer:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Is supposed to allow painting in ``WM_PAINT`` or ``WM_SIZE`` when video is not rendering, but tests show that this isn't the case. At a best guess the window that is used to render is sub-classed and doesn't pass back the chain of events for ``WM_PAINT`` once rendering starts. My workaround for this to allow a custom draw of the video window when not playing is to hide the window when stopped and show it when playing, this allows the background of the parent window to show any custom painting, including a fake video screen with a logo.


**See Also**

:ref:`MFPMediaPlayer_GetVideoWindow<MFPMediaPlayer_GetVideoWindow>`
