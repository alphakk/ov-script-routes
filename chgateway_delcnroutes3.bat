@echo off
rem Change the gateway and interface number in delcnroutes5.txt

setlocal enabledelayedexpansion
cd /d "%~dp0"
net session >nul 2>&1
rem If add_command file exists,add routes directly.
if exist del_cnroutes_cmd_win3.txt (
		rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME del_cnroutes_cmd_win3.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
rem			del del_cnroutes_cmd_win3.txt
rem			echo del_cnroutes_cmd_win3.txt
exit 0
) 
rem extract default gateway %%g(form of ipaddress/netmask) segment and IF segment %f%(form of I=num),trash %z%
for /f "tokens=7-8 delims= " %%g in ('openvpn --show-gateway') do (
		set /a num+=1
		if !num!==1 (
		set w=%%g
		set f=%%h
		) else (set z=%%g)
)
rem Extract IF number from %f% to %m
for /f "tokens=2 delims==" %%m in ("%f%") do set t=%%m
rem Extract ip address from %w% to %%c
for /f "tokens=1 delims=\/" %%c in ("%w%") do (
if exist delcnroutes5.txt (
		for /f "delims=" %%a in (delcnroutes5.txt) do (
		set aa=%%a
rem	Replace net_gateway with %%c,add IF number %t% to file.
		echo !!aa:net_gateway=%%c!! %t% >>del_cnroutes_cmd_win3.txt
)
) else echo delcnroutes5.txt is not here.
)
rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME del_cnroutes_cmd_win3.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
exit 0