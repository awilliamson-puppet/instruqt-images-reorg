$url = "https://github.com/cedrozor/myrtille/releases/download/v2.9.1/Myrtille_2.9.1_x86_x64_Setup.msi"
$msi = "C:\myrtille.msi"
$log = "C:\myrtille.log"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $msi)

$msiProc = Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/i $msi ALLUSERS=1 REBOOT=ReallySuppress /l $log /quiet" -NoNewWindow -PassThru
$logProc = Start-Process "powershell" "Get-Content -Path $log -Wait" -NoNewWindow -PassThru
$msiProc.WaitForExit()
$logProc.Kill()

Remove-Item -Path $msi -Force
Remove-Item -Path $log -Force