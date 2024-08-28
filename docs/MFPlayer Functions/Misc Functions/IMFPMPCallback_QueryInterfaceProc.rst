.. _IMFPMPCallback_QueryInterfaceProc:

=================================
IMFPMPCallback_QueryInterfaceProc
=================================

QueryInterface method of IMFPMPCallback - a `IMFPMediaPlayerCallback <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayercallback>`_ object.

::

   IMFPMPCallback_QueryInterfaceProc PROTO pThis:DWORD, riid:DWORD, ppvObject:DWORD


**Parameters**

* ``pThis`` - pointer to this `IMFPMediaPlayerCallback <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaplayercallback>`_ object.

* ``riid`` - A reference to the interface identifier (IID) of the interface being queried for.

* ``ppvObject`` - The address of a pointer to an interface with the IID specified in the riid parameter. Because you pass the address of an interface pointer the method can overwrite that address with the pointer to the interface being queried for. Upon successful return, ``ppvObject`` (the dereferenced address) contains a pointer to the requested interface. If the object doesn't support the interface, the method sets ``ppvObject`` (the dereferenced address) to nullptr.


**Returns**

``E_NOINTERFACE``

**Notes**

Used in :ref:`MFPMediaPlayer_Init<MFPMediaPlayer_Init>` for the callback function address.


**See Also**

:ref:`IMFPMPCallback_AddRefProc<IMFPMPCallback_AddRefProc>`, :ref:`IMFPMPCallback_ReleaseProc<IMFPMPCallback_ReleaseProc>`
