.. _MFPMediaItem_GetStreamAttribute:

===============================
MFPMediaItem_GetStreamAttribute
===============================

Queries the media item for a stream attribute.

::

   MFPMediaItem_GetStreamAttribute PROTO pMediaItem:DWORD, dwStreamIndex:DWORD, guidMFAttribute:DWORD, pvValue:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwStreamIndex`` - Zero-based index of the stream.

* ``guidMFAttribute`` - GUID that identifies the attribute value to query.

* ``pvValue`` - Pointer to a `PROPVARIANT <https://learn.microsoft.com/en-us/windows/win32/api/propidlbase/ns-propidlbase-propvariant>`_ that receives the value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Call `PropVariantClear <https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-propvariantclear>`_ to free the memory allocated and stored in variable pointed to by the ``pvValue`` parameter.

Includelib mfuuid.lib to reference the already defined and exported property GUIDs in that library. 

**See Also**

:ref:`MFPMediaItem_GetPresentationAttribute<MFPMediaItem_GetPresentationAttribute>`, :ref:`MFPMediaItem_GetCharacteristics<MFPMediaItem_GetCharacteristics>`
