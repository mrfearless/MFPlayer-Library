.. _MFPMediaPlayer_Shutdown:

=======================
MFPMediaPlayer_Shutdown
=======================

Shuts down the MFPlay player object and releases any resources the object is using.

::

   MFPMediaPlayer_Shutdown PROTO MediaPlayer:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

The player object automatically shuts itself down when its reference count reaches zero. You can use the Shutdown method to shut down the player before all of the references have been released.


**See Also**

:ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>`, :ref:`MFPMediaPlayer_Free<MFPMediaPlayer_Free>`
