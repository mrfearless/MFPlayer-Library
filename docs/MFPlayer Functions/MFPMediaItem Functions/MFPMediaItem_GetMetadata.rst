.. _MFPMediaItem_GetMetadata:

========================
MFPMediaItem_GetMetadata
========================

Gets a property store that contains metadata for the source, such as author or title.

::

   MFPMediaItem_GetMetadata PROTO pMediaItem:DWORD, ppMetadataStore:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``ppMetadataStore`` - A pointer to a DWORD variable to store the pMetadataStore object (`IPropertyStore <https://learn.microsoft.com/en-us/windows/win32/api/propsys/nn-propsys-ipropertystore>`_)


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

TRUE if successful or FALSE otherwise.

The caller must release the interface.


**See Also**

:ref:`MFPMediaItem_GetCharacteristics<MFPMediaItem_GetCharacteristics>`, :ref:`MFPMediaItem_GetPresentationAttribute<MFPMediaItem_GetPresentationAttribute>`, :ref:`MFPMediaItem_GetStreamAttribute<MFPMediaItem_GetStreamAttribute>`
