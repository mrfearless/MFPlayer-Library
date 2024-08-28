.. _MFPMediaItem_GetCharacteristics:

===============================
MFPMediaItem_GetCharacteristics
===============================

Gets various flags that describe the media item.

::

   MFPMediaItem_GetCharacteristics PROTO pMediaItem:DWORD, pCharacteristics:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``pCharacteristics`` - a pointer to a DWORD variable to receive the bitflags of the characteristics of the media item.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The variable pointed to by the ``pCharacteristics`` parameter can contain a combination of the following values: 

* ``MFP_MEDIAITEM_IS_LIVE`` 
* ``MFP_MEDIAITEM_CAN_SEEK`` 
* ``MFP_MEDIAITEM_CAN_PAUSE`` 
* ``MFP_MEDIAITEM_HAS_SLOW_SEEK``

**See Also**

:ref:`MFPMediaItem_GetPresentationAttribute<MFPMediaItem_GetPresentationAttribute>`, :ref:`MFPMediaItem_GetStreamAttribute<MFPMediaItem_GetStreamAttribute>`
