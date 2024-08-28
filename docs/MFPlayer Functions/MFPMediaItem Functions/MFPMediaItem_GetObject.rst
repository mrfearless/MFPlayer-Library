.. _MFPMediaItem_GetObject:

======================
MFPMediaItem_GetObject
======================

Gets the object that was used to create the media item.

::

   MFPMediaItem_GetObject PROTO pMediaItem:DWORD, ppIUnknown:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``ppIUnknown`` - A pointer to a DWORD value used to store the object's `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ interface.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The caller must release the interface. 

The object pointer is set if the application uses CreateMediaItemFromObject to create the media item.


**See Also**

:ref:`MFPMediaPlayer_CreateMediaItemFromObject<MFPMediaPlayer_CreateMediaItemFromObject>`
