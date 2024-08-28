.. _MFPMediaPlayer_GetState:

=======================
MFPMediaPlayer_GetState
=======================

Obtains the current state of the MFPlay Media Player.

::

   MFPMediaPlayer_GetState PROTO pMediaPlayer:DWORD, pdwState:DWORD


**Parameters**

* ``pMediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.

* ``pdwState`` - pointer to a DWORD value to store the state of the Media Player.


**Returns**

TRUE if successful or FALSE otherwise. The DWORD pointer to by the ``pdwState`` parameter will contain one of following value:

* ``MFP_MEDIAPLAYER_STATE_EMPTY`` 
* ``MFP_MEDIAPLAYER_STATE_STOPPED`` 
* ``MFP_MEDIAPLAYER_STATE_PLAYING`` 
* ``MFP_MEDIAPLAYER_STATE_PAUSED`` 
* ``MFP_MEDIAPLAYER_STATE_SHUTDOWN``

**See Also**

:ref:`MFPMediaPlayer_GetPosition<MFPMediaPlayer_GetPosition>`, :ref:`MFPMediaPlayer_GetDuration<MFPMediaPlayer_GetDuration>`
