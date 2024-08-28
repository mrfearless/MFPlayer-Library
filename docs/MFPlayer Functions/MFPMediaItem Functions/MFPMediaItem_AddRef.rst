.. _MFPMediaItem_AddRef:

===================
MFPMediaItem_AddRef
===================

Increments the reference count for an interface pointer to a COM object. You should call this method whenever you make a copy of an interface pointer.

::

   MFPMediaItem_AddRef PROTO pMediaItem:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

A COM object uses a per-interface reference-counting mechanism to ensure that the object doesn't outlive references to it. You use AddRef to stabilize a copy of an interface pointer. It can also be called when the life of a cloned pointer must extend beyond the lifetime of the original pointer. The cloned pointer must be released by calling IUnknown_Release on it.

The internal reference counter that AddRef maintains should be a 32-bit unsigned integer.


**See Also**

:ref:`MFPMediaItem_Release<MFPMediaItem_Release>`, :ref:`MFPMediaItem_QueryInterface<MFPMediaItem_QueryInterface>`
