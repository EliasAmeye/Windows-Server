write-host "Installing DHCP"
Install-WindowsFeature DHCP -IncludeManagementTools

# Makes the server able to do dhcp in the domain
write-host "Configuring DHCP"
Add-DhcpServerInDC
Get-DhcpServerInDC

# Add ip range for dhcp clients
Add-DhcpServerv4Scope -name "keanysClients" -StartRange 192.168.1.20 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0
Get-DhcpServerv4Scope

# Set router and dns server for dhcp
Set-DhcpServerv4OptionValue -Router 192.168.1.1 -DnsServer 192.168.1.1
Get-DhcpServerv4OptionValue

# Restart the dhcpserver
write-host "Restarting the dhcp server"
Restart-Service dhcpserver
Get-Service dhcpserver

write-host "Script finished!"
pause