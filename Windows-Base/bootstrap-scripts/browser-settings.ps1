# Write-Output "Disabling Internet Explorer"
# dism /online /Disable-Feature /NoRestart /FeatureName:Internet-Explorer-Optional-amd64

$url = "https://kolbi.cz/SetDefaultBrowser.zip"
$output = "C:\SetDefaultBrowser.zip"
$exe = "C:\SetDefaultBrowser\SetDefaultBrowser.exe"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Expand-Archive -Path $output -DestinationPath "C:\" -Force
Start-Process $exe -ArgumentList 'HKLM "Microsoft Edge" delay=1000' -Wait

Remove-Item -Path $output -Force
Remove-Item -Path "C:\SetDefaultBrowser" -Recurse -Force

New-Item -Path HKLM:\Software\Policies\Microsoft\Edge -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Edge -Name RestoreOnStartup -Value 0x00000004 -PropertyType DWORD -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Edge -Name HideFirstRunExperience -Value 0x00000001 -PropertyType DWORD -Force

New-Item -Path HKLM:\Software\Policies\Microsoft\Edge -Name RestoreOnStartupURLs -Force
Set-Itemproperty -Path HKLM:\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs -Name 1 -Value "https://instruqt.com"

Write-Output ""
Write-Output "Browser settings applied successfully!"