.. _MFPConvertMSTimeToTimeString:

============================
MFPConvertMSTimeToTimeString
============================

Converts a milliseconds value to a time string, which shows hours, minutes, seconds and milliseconds. 

::

   MFPConvertMSTimeToTimeString PROTO dwMilliseconds:DWORD, lpszTime:DWORD, dwTimeFormat:DWORD


**Parameters**

* ``dwMilliseconds`` - milliseconds value to convert.

* ``lpszTime`` - pointer to string buffer to store the converted time.

* ``dwTimeFormat`` - 0 to include milliseconds, 1 to exclude them.


**Returns**

TRUE if successful or FALSE otherwise

**Notes**

Ensure the string buffer pointed to by the ``lpszTime`` parameter is at least 16 bytes long.


**See Also**

