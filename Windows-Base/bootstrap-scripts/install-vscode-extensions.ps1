$ErrorActionPreference="SilentlyContinue"

Write-Output "Installing VSCode puppet.puppet-vscode extension"

code --install-extension "puppet.puppet-vscode" --force

Write-Output "Ensuring puppet extension is installed"

code --list-extensions