.. _MFPMediaPlayer_GetVideoSourceRect:

=================================
MFPMediaPlayer_GetVideoSourceRect
=================================

Gets the video source rectangle.

::

   MFPMediaPlayer_GetVideoSourceRect PROTO MediaPlayer:DWORD, pnrcSource:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pnrcSource`` - Pointer to an `MFVideoNormalizedRect <https://learn.microsoft.com/en-us/windows/win32/api/mfmediaengine/ns-mfmediaengine-mfvideonormalizedrect>`_ structure.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The upper-left corner of the video image is (0, 0).
The lower-right corner of the video image is (1, 1)
If the source rectangle is {0, 0, 1, 1}, the entire image is displayed. This is the default value.


**See Also**

:ref:`MFPMediaPlayer_SetVideoSourceRect<MFPMediaPlayer_SetVideoSourceRect>`
