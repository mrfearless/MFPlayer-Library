.. _MFPMediaItem_SetUserData:

========================
MFPMediaItem_SetUserData
========================

Stores an application-defined value in the media item.

::

   MFPMediaItem_SetUserData PROTO pMediaItem:DWORD, dwUserData:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``dwUserData`` - The application-defined value.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

You can assign this value when you first create the media item, by specifying it in the ``dwUserData`` parameter of the :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>` or :ref:`MFPMediaPlayer_CreateMediaItemFromObject<MFPMediaPlayer_CreateMediaItemFromObject>` method. To update the value, call :ref:`MFPMediaItem_SetUserData<MFPMediaItem_SetUserData>`. 

**See Also**

:ref:`MFPMediaItem_GetUserData<MFPMediaItem_GetUserData>`, :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`, :ref:`MFPMediaPlayer_CreateMediaItemFromObject<MFPMediaPlayer_CreateMediaItemFromObject>`
