# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Confirm the Firewall rule is configured. It should be created automatically by setup.
# Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
# New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

New-Item -Path "C:\ProgramData\ssh" -Name "administrators_authorized_keys" -ItemType "file" -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAtI8qt+nCpxupf9cR5N1ba3LXhNRO27Men5sk+wio6ofU3Hz4NsfP4Fd7HmSX9Qt5Q22WD8Bh2TlRmlq/JKyDtHBSh5rWCQkADiWNfou4zCIB+Agh79V6O/FMuCzVhq/xWhEGLNyX+zbokn8kO3TRbzJIDsfCSJbMXSyNLVjr1HaLsi783GySr/UDpRRPyzr4ygh1VEDBYN2DbiNN6VY8UR++J7XKNKN7BBpuO9IXJ6x7h6QpD14fO0OpKyMZtwGPOjuPBmcRW5iOuJL1npyTLvCV9qj9tYME0jOFaVeNs3U3NPG/pCJ0CVsQcIocG9LWPAUNTWiO0p82bYH2wH/9"

# Set-Service -Name sshd -StartupType 'Automatic'