.. _MFPMediaItem_GetURLW:

====================
MFPMediaItem_GetURLW
====================

Gets the URL that was used to create the media item. This is the Wide/Unicode version of MFPMediaItem_GetURL. For the Ansi version see MFPMediaItem_GetURLA

::

   MFPMediaItem_GetURLW PROTO pMediaItem:DWORD, ppszURL:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``ppszURL`` - pointed to a DWORD that holds a pointer to the URL string.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Use `GlobalFree <https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globalfree>`_ on the ``ppszURL`` once no longer required.


**See Also**

:ref:`MFPMediaItem_GetURLA<MFPMediaItem_GetURLA>`
