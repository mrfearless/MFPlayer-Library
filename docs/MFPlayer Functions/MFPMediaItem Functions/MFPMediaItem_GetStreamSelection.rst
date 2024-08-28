.. _MFPMediaItem_GetStreamSelection:

===============================
MFPMediaItem_GetStreamSelection
===============================

Queries whether a stream is selected to play.

::

   MFPMediaItem_GetStreamSelection PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, pbEnabled:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwStreamIndex`` - A zero based index of the stream.

* ``pbEnabled`` - A pointer to a DWORD that contains TRUE or FALSE.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

To select or deselect a stream, call :ref:`MFPMediaItem_SetStreamSelection<MFPMediaItem_SetStreamSelection>`.


**See Also**

:ref:`MFPMediaItem_SetStreamSelection<MFPMediaItem_SetStreamSelection>`, :ref:`MFPMediaItem_GetNumberOfStreams<MFPMediaItem_GetNumberOfStreams>`
