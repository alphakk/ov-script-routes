@echo off
rem change the gateway and interface number in addcnroutes5.txt

setlocal enabledelayedexpansion
cd /d "%~dp0"
net session >nul 2>&1
rem Make sure the file add_cnroutes_to_win.bat is created by this BAT
if exist add_cnroutes_cmd_win3.txt (
			rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME add_cnroutes_cmd_win3.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
			exit 0
rem			del add_cnroutes_cmd_win3.txt
rem			echo add_cnroutes_to_win3.txt is deleted.
) 
rem extract default gateway %%g(form of ipaddress/netmask) and IF segment %f%(form of I=num),trash %z%
for /f "tokens=7-8 delims= " %%g in ('openvpn --show-gateway') do (
		set /a num+=1
		if !num!==1 (
		set w=%%g
		set f=%%h
		) else (set z=%%g)
)
rem extract IF number from %f% to %m
for /f "tokens=2 delims==" %%m in ("%f%") do set t=%%m
rem catch ip address from %w% to %%c
for /f "tokens=1 delims=\/" %%c in ("%w%") do (
if exist addcnroutes5.txt (
		for /f "delims=" %%a in (addcnroutes5.txt) do (
		set aa=%%a
rem	replace net_gateway with %%c
		echo !!aa:net_gateway=%%c!! %t% >>add_cnroutes_cmd_win3.txt
		
)
) else echo addcnroutes5.txt is not here.
)
rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME add_cnroutes_cmd_win3.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
exit 0