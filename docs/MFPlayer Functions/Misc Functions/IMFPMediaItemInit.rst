.. _IMFPMediaItemInit:

=================
IMFPMediaItemInit
=================

Initializes the IMFPMediaItem object and its methods.

::

   IMFPMediaItemInit PROTO pMediaItem:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Used to assign pointers to the various `IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_ methods to variables which are prototyped to the match the method parameters. This allows us to use Invoke to call the methods directly.

Probably easier to call the IMFPMedia functions directly instead of using this function.


**See Also**

:ref:`IMFPMediaPlayerInit<IMFPMediaPlayerInit>`
