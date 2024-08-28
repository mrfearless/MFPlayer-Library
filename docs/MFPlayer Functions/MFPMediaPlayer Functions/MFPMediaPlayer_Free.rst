.. _MFPMediaPlayer_Free:

===================
MFPMediaPlayer_Free
===================

Shuts down the MFPlay IMFPMediaPlayer COM object and frees any resources used by it. 

::

   MFPMediaPlayer_Free PROTO ppMediaPlayer:DWORD


**Parameters**

* ``ppMediaPlayer`` - pointer to a DWORD value that contains a pointer to the pMediaPlayer (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object. The pMediaPlayer variable is returned from the :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` function.


**Returns**

None.


**Notes**

The pMediaPlayer variable, pointed to by the ``ppMediaPlayer`` parameter is set to 0 by this function.


**See Also**

:ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>`
