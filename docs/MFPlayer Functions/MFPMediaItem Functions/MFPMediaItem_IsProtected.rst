.. _MFPMediaItem_IsProtected:

========================
MFPMediaItem_IsProtected
========================

Queries whether the media item contains protected content.

::

   MFPMediaItem_IsProtected PROTO pMediaItem:DWORD, pbProtected:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pbProtected`` - A pointer to a DWORD that contains TRUE or FALSE.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

If media item contains protected content any attempt to play it will cause a playback error.


**See Also**

:ref:`MFPMediaItem_HasAudio<MFPMediaItem_HasAudio>`, :ref:`MFPMediaItem_HasVideo<MFPMediaItem_HasVideo>`
