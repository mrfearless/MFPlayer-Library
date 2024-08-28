.. _IMFPMPCallback_ReleaseProc:

==========================
IMFPMPCallback_ReleaseProc
==========================

Release method of IMFPMPCallback - a `IMFPMediaPlayerCallback <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayercallback>`_ object.

::

   IMFPMPCallback_ReleaseProc PROTO pThis:DWORD


**Parameters**

* ``pThis`` - pointer to this `IMFPMediaPlayerCallback <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayercallback>`_ object.


**Returns**

0

**Notes**

Used in :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` for the callback function address.


**See Also**

:ref:`IMFPMPCallback_QueryInterfaceProc<IMFPMPCallback_QueryInterfaceProc>`, :ref:`IMFPMPCallback_AddRefProc<IMFPMPCallback_AddRefProc>`
