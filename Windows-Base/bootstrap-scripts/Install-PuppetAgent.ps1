Set-Location "C:\temp"

Write-Output "Downloading latest puppet agent installer"
wget http://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.22.1-x64.msi -OutFile puppet-agent.msi 

Get-ChildItem C:\temp


Write-Output "Running agent installer msi with /quiet and /qn"
Write-Output "Logging to C:\temp\agent.install "
$agentInstallProcess = Start-Process -FilePath msiexec -ArgumentList "/quiet /qn /norestart /i puppet-agent.msi /L*V C:\temp\agent.install PUPPET_AGENT_STARTUP_MODE=manual" -Wait -PassThru

Write-Output "Install process complete - returned exit code: $($agentInstallProcess.ExitCode)"

Write-Output "Checking for SSL path "

Get-ChildItem "C:\ProgramData\PuppetLabs" -Recurse

Write-Output "Getting puppet agent installed version"

Get-WmiObject -Class Win32_Product | Where-Object vendor -like "*Puppet*"| Select-Object Name, Version