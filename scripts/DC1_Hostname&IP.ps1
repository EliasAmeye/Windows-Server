#Set hostname to 'ServerDC1' as specified in the assignment.
write-host "Changing hostname"
#netdom renamecomputer %computername% /newname:ServerDC1
Rename-Computer -NewName ServerDC1

write-host "Setting timezone to Romance Standard Time (Brussels)"
Set-TimeZone -Name "Romance Standard Time"

#Set static ip address.
write-host "Setting static ip to '192.168.1.1'"
#New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.1.1 -PrefixLength 24
#netsh interface ip set address <name> static <address> <mask> <gateway> 
netsh interface ip set address "Ethernet 2" static 192.168.1.1 255.255.255.0 

write-host "Setting DNS server to '192.168.1.1'"
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 192.168.1.1

write-host "Script finished!"

#Restarts the server and then, it checks if powershell is available every 3 seconds for up to 300 seconds. Then it moves on to the next command.
write-host "Restarting!"
#Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 3 -Force
Restart-Computer -Force

pause