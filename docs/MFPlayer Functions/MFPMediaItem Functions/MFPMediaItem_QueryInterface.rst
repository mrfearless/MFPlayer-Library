.. _MFPMediaItem_QueryInterface:

===========================
MFPMediaItem_QueryInterface
===========================

Queries a COM object for a pointer to one of its interface; identifying the interface by a reference to its interface identifier (IID). If the COM object implements the interface, then it returns a pointer to that interface after calling IUnknown::AddRef on it.

::

   MFPMediaItem_QueryInterface PROTO pMediaItem:DWORD, riid:DWORD, ppvObject:DWORD


**Parameters**

* ``pMediaItem`` - A pointer to the Media Item (`IMFPMediaItem <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/api/mfplay/nn-mfplay-imfpmediaitem>`_) object.

* ``riid`` - A reference to the interface identifier (IID) of the interface being queried for.

* ``ppvObject`` - The address of a pointer to an interface with the IID specified in the ``riid`` parameter. Because you pass the address of an interface pointer the method can overwrite that address with the pointer to the interface being queried for. Upon successful return, ``ppvObject`` (the dereferenced address) contains a pointer to the requested interface. If the object doesn't support the interface, the method sets ``ppvObject`` (the dereferenced address) to nullptr.


**Returns**

TRUE if successful or FALSE otherwise.


**Notes**

For any given COM object (also known as a COM component), a specific query for the `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ interface on any of the object's interfaces must always return the same pointer value. This enables a client to determine whether two pointers point to the same component by calling QueryInterface with IID_IUnknown and comparing the results. It is specifically not the case that queries for interfaces other than `IUnknown <https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown>`_ (even the same interface through the same pointer) must return the same pointer value.


**See Also**

:ref:`MFPMediaItem_AddRef<MFPMediaItem_AddRef>`, :ref:`MFPMediaItem_Release<MFPMediaItem_Release>`
