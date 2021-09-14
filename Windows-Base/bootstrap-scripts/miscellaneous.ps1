# Disable automatic start ServerManager
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose

# Remove link to GCloud SDK Shell
Remove-Item -Path 'C:\Users\Public\Desktop\Google Cloud SDK Shell.lnk' -Force