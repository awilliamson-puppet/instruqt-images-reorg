Write-Output "Downloading latest version of VScode 64bit Machine wide installer"

Write-Output "Checking for Temp directory"

if (!(Test-Path -LiteralPath "C:\temp")) {
    Write-Output "Creating temp dir at C:\temp"

    New-Item -Type Directory -Path "C:\temp"

}

if (!(Test-Path -LiteralPath "C:\temp\VSCodeExtensions")) {
    Write-Output "Creating temp dir at C:\temp\VSCodeExtensions"

    New-Item -Type Directory -Path "C:\temp\VSCodeExtensions"

}

Invoke-WebRequest -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -OutFile "C:\temp\VSCodeSetup.exe"

Write-Output "VSCode installer downloaded"

Get-ChildItem "C:\temp"

Write-Output "Running VSCode installer in silent mode"

$vsInstallProcess = Start-Process -WorkingDirectory "C:\temp" -FilePath "C:\temp\VSCodeSetup.exe" -ArgumentList "/VERYSILENT /MERGETASKS=!runcode" -Wait -PassThru

Write-Output "Installer exit code: $($vsInstallProcess.ExitCode)"

Write-Output "Creating System Environment Variable for centralized extension installation"

[Environment]::SetEnvironmentVariable("VSCODE_EXTENSIONS", "C:\Temp\VSCodeExtensions", "Machine")