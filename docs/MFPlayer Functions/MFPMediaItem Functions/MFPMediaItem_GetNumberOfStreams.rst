.. _MFPMediaItem_GetNumberOfStreams:

===============================
MFPMediaItem_GetNumberOfStreams
===============================

Gets the number of streams (audio, video, and other) in the media item.

::

   MFPMediaItem_GetNumberOfStreams PROTO pMediaItem:DWORD, pdwStreamCount:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pdwStreamCount`` - A pointer to a DWORD variable used to store the steam count of the media item.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

N/A

**See Also**

:ref:`MFPMediaItem_GetStreamSelection<MFPMediaItem_GetStreamSelection>`, :ref:`MFPMediaItem_SetStreamSelection<MFPMediaItem_SetStreamSelection>`
