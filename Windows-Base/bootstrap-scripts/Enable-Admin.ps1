Write-Output "Enable Administrator user"

net user "Administrator" ([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('UHVwcGV0bGFicyE='))) /active:yes

Get-LocalUser "Administrator"