#!/bin/sh

pip install selenium==3.141
pip install requests
pip install selenium-wire
pip install Faker
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0x00 /f
