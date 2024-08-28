.. _MFPMediaPlayer_GetIdealVideoSize:

================================
MFPMediaPlayer_GetIdealVideoSize
================================

Gets the range of video sizes that can be displayed without significantly degrading performance or image quality.

::

   MFPMediaPlayer_GetIdealVideoSize PROTO MediaPlayer:DWORD, pszMin:DWORD, pszMax:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pszMin`` - Pointer to a `SIZE <https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size>`_ variable to store the minimum size of video that is preferable. Can be NULL.

* ``pszMax`` - Pointer to a `SIZE <https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size>`_ variable to store the maximum size of video that is preferable. Can be NULL.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

At least one parameter must be non-NULL. Sizes are given in pixels.


**See Also**

:ref:`MFPMediaPlayer_GetNativeVideoSize<MFPMediaPlayer_GetNativeVideoSize>`
