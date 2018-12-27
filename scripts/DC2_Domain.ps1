write-host "Installing AD-Domain-Services"
install-windowsfeature AD-Domain-Services -IncludeManagementTools -Restart

write-host "Installing second Domain Controller in the keanys.gent domain."
write-host "Note: The machine will restart after the installation!"
Install-ADDSDomainController -DomainName keanys.gent -SafeModeAdministratorPassword (ConvertTo-SecureString -String "K3anuSafeMode" -AsPlainText -Force) -Credential (Get-Credential keanys\administrator) -Force

write-host "Script finished!"
pause