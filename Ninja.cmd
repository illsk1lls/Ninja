@ECHO OFF
>nul 2>&1 reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul 2>&1 fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
>nul 2>&1 reg delete hkcu\software\classes\.Admin\ /f & >nul 2>&1 del %temp%\runas.Admin /f /q
POWERSHELL -nop -ep bypass -c "$f=(GC '%~f0') -replace '\S+$','$& ;' -replace '"""','"""""""""' | Select-Object -Skip 7; POWERSHELL -c $f"
GOTO :EOF
::BEGIN POWERSHELL::
$Url='http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/2000920063/AcroRdrDC2000920063_en_US.exe'
function Size-To-Human-Readable([uint64]$size){
	$suffix = "bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
	$i = 0
	while ($size -gt 1kb) {
		$size = $size / 1kb
		$i++
	}
"{0:N1} {1}" -f $size, $suffix[$i]
}
$pattern='.*\/(.*\.exe).*'
$File=[regex]::Match($Url, $pattern).Groups[1].Value
$str_size=(Invoke-WebRequest -UseBasicParsing -Uri $Url -Method Head).Headers.'Content-Length'
$tmp_size=[uint64]::Parse($str_size)
$Size=Size-To-Human-Readable $tmp_size
Write-Host "Downloading '$File' ($Size)..."
Start-BitsTransfer -Priority Foreground -Source $Url -Destination $File