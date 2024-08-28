.. _MFPMediaItem_GetMediaPlayer:

===========================
MFPMediaItem_GetMediaPlayer
===========================

Gets a pointer to the MFPlay player object (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) that created the media item.

::

   MFPMediaItem_GetMediaPlayer PROTO pMediaItem:DWORD, ppMediaPlayer:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``ppMediaPlayer`` - pointer to a DWORD variable to store the pMediaPlayer object (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_).


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

N/A

**See Also**

:ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>`
