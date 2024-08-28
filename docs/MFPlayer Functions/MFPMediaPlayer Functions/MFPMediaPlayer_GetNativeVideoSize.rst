.. _MFPMediaPlayer_GetNativeVideoSize:

=================================
MFPMediaPlayer_GetNativeVideoSize
=================================

Gets the size and aspect ratio of the video. These values are computed before any scaling is done to fit the video into the destination window.

::

   MFPMediaPlayer_GetNativeVideoSize PROTO MediaPlayer:DWORD, pszVideo:DWORD, pszARVideo:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pszVideo`` - Pointer to a `SIZE <https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size>`_ variable to store the width and height of the video, in pixels. Can be NULL.

* ``pszARVideo`` - Pointer to a `SIZE <https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size>`_ variable to store the aspect ratio of the video. Can be NULL.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

At least one parameter must be non-NULL.


**See Also**

:ref:`MFPMediaPlayer_GetIdealVideoSize<MFPMediaPlayer_GetIdealVideoSize>`
