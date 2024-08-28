.. _MFPMediaPlayer_Init:

===================
MFPMediaPlayer_Init
===================

Create and initialize the MFPlay IMFPMediaPlayer COM object with the video window handle and the callback function (if specified).

::

   MFPMediaPlayer_Init PROTO hMFPWindow:DWORD, pCallback:DWORD, ppMediaPlayer:DWORD


**Parameters**

* ``hMFPWindow`` - handle to the window to use for the video output

* ``pCallback`` - Address of the MFPlay event notification callback function.

* ``ppMediaPlayer`` - pointer to a DWORD value to store the pMediaPlayer (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

Stores a pMediaPlayer object in the DWORD pointer to by the ``ppMediaPlayer`` parameter, or 0 if an error occurred. Returns TRUE if successful or FALSE otherwise. 

**Notes**

:ref:`MFPMediaPlayer_Free<MFPMediaPlayer_Free>` should be called on program close to free up any resources.


**See Also**

:ref:`MFPMediaPlayer_Free<MFPMediaPlayer_Free>`
