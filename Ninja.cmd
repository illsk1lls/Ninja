<# ::
@ECHO OFF
>nul 2>&1 REG ADD HKCU\Software\classes\.PSninja\shell\runas\command /f /ve /d "CMD /x /d /r SET \"f0=%%2\"& CALL \"%%2\" %%3"&SET _= %*
>nul 2>&1 FLTMC|| IF "%f0%" NEQ "%~f0" (cd.>"%temp%\runas.PSninja" & START "%~n0" /high "%temp%\runas.PSninja" "%~f0" "%_:"=""%"&EXIT /b)
>nul 2>&1 REG DELETE HKCU\Software\classes\.PSninja\ /f&>nul 2>&1 DEL %temp%\runas.PSninja /f /q
(IF EXIST "%temp%\%~n0.ps1" DEL "%temp%\%~n0.ps1" /f /q)&(MKLINK "%temp%\%~n0.ps1" "%~f0">nul)&POWERSHELL -nop -ep bypass -f "%temp%\%~n0.ps1" %*&DEL "%temp%\%~n0.ps1" /f /q&GOTO :EOF
#>$PSCommandPath=$PSCommandPath.Replace("/\.[^/.]+$/", ".cmd")
###POWERSHELL BELOW THIS LINE###
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
