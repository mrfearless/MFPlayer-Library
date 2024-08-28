.. _IMFPMediaPlayerInit:

===================
IMFPMediaPlayerInit
===================

Initializes the IMFPMediaPlayer object and its methods.

::

   IMFPMediaPlayerInit PROTO pMediaPlayer:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Used to assign pointers to the various `IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_ methods to variables which are prototyped to the match the method parameters. This allows us to use Invoke to call the methods directly. This function is called by the :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` function.


**See Also**

:ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>`, :ref:`IMFPMediaItemInit<IMFPMediaItemInit>`
