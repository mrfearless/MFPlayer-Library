.. _MFPMediaPlayer_Step:

===================
MFPMediaPlayer_Step
===================

Steps a frame of a media item that is currently set in the media player.

::

   MFPMediaPlayer_Step PROTO MediaPlayer:DWORD


**Parameters**

* ``MediaPlayer`` - A pointer to the Media Player (`IMFPMediaPlayer <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayer>`_) object.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

Media items have to be created and set before they can be played, paused, stepped or stopped. A media item is created with the :ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>` or :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>` function and is set in the queue to play with the :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>` function.

Sends a notification to the Media Event callback function as ``MFP_EVENT_TYPE_FRAME_STEP``

**See Also**

:ref:`MFPMediaPlayer_CreateMediaItemA<MFPMediaPlayer_CreateMediaItemA>`, :ref:`MFPMediaPlayer_CreateMediaItemW<MFPMediaPlayer_CreateMediaItemW>`, :ref:`MFPMediaPlayer_SetMediaItem<MFPMediaPlayer_SetMediaItem>`, :ref:`MFPMediaPlayer_Play<MFPMediaPlayer_Play>`, :ref:`MFPMediaPlayer_Pause<MFPMediaPlayer_Pause>`, :ref:`MFPMediaPlayer_Stop<MFPMediaPlayer_Stop>`, :ref:`MFPMediaPlayer_Toggle<MFPMediaPlayer_Toggle>`
