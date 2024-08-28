.. _MFPMediaItem_GetURLA:

====================
MFPMediaItem_GetURLA
====================

Gets the URL that was used to create the media item. This is the Ansi version of MFPMediaItem_GetURL. For the Wide/Unicode version see MFPMediaItem_GetURLW

::

   MFPMediaItem_GetURLA PROTO pMediaItem:DWORD, ppszURL:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``ppszURL`` - pointed to a DWORD that holds a pointer to the URL string.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Use `GlobalFree <https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globalfree>`_ on the ``ppszURL`` once no longer required.


**See Also**

:ref:`MFPMediaItem_GetURLW<MFPMediaItem_GetURLW>`
