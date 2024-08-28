.. _MFPMediaItem_HasVideo:

=====================
MFPMediaItem_HasVideo
=====================

Queries whether the media item contains a video stream.

::

   MFPMediaItem_HasVideo PROTO pMediaItem:DWORD, pbHasVideo:DWORD, pbSelected:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pbHasVideo`` - A pointer to a DWORD that contains TRUE or FALSE.

* ``pbSelected`` - A pointer to a DWORD that contains TRUE or FALSE.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

To select or deselect streams before playback starts, call :ref:`MFPMediaItem_SetStreamSelection<MFPMediaItem_SetStreamSelection>`.


**See Also**

:ref:`MFPMediaItem_HasAudio<MFPMediaItem_HasAudio>`, :ref:`MFPMediaItem_IsProtected<MFPMediaItem_IsProtected>`, :ref:`MFPMediaItem_SetStreamSelection<MFPMediaItem_SetStreamSelection>`
