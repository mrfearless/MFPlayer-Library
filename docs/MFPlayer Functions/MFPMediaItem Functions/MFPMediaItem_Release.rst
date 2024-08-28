.. _MFPMediaItem_Release:

====================
MFPMediaItem_Release
====================

Decrements the reference count for an interface on a COM object.

::

   MFPMediaItem_Release PROTO pMediaItem:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

When the reference count on an object reaches zero, Release must cause the interface pointer to free itself. When the released pointer is the only (formerly) outstanding reference to an object (whether the object supports single or multiple interfaces), the implementation must free the object.


**See Also**

:ref:`MFPMediaItem_AddRef<MFPMediaItem_AddRef>`, :ref:`MFPMediaItem_QueryInterface<MFPMediaItem_QueryInterface>`
