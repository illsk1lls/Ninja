>nul 2>&1 REG ADD HKCU\Software\classes\.PSninja\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"&SET _= %*
>nul 2>&1 FLTMC|| IF "%f0%" NEQ "%~f0" (CD.>"%temp%\RunAs.PSninja"&START "%~n0" /high "%temp%\RunAs.PSninja" "%~f0" "%_:"=""%"&EXIT /b)
>nul 2>&1 REG DELETE HKCU\Software\classes\.PSninja\ /f &>nul 2>&1 del %temp%\runas.PSninja /F /Q
@(set "0=%~f0"^)#) & @powershell -nop -c iex([io.file]::ReadAllText($env:0)) & @GOTO :EOF
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
