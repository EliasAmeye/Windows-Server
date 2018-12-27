#Set domain (This is not needed since you can specify the domainname bellow)
#write-host "Changing domain name"
#Add-Computer -DomainName AvalonSoft.net -Credential Administrator -Force -Restart

write-host "Installing AD-Domain-Services"
install-windowsfeature AD-Domain-Services -IncludeManagementTools -Restart

write-host "Installing ADDSForest with domain name keanys.gent"
Install-ADDSForest -DomainName keanys.gent -SafeModeAdministratorPassword (ConvertTo-SecureString -String "K3anu" -AsPlainText -Force) -InstallDns -Force

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

# Tries to forward dns requests it can't respond to the dns server of school and google
write-host "Adding Dns server Forwarders 193.190.173.1 and 8.8.8.8"
Add-DnsServerForwarder -IPAddress 193.190.173.1 
Add-DnsServerForwarder -IPAddress 8.8.8.8 
Get-DnsServerForwarder

write-host "Installing windows feauture 'Routing'"
Install-windowsFeature Routing -IncludeManagementTools -Restart


write-host "Configuring nat"
Install-RemoteAccess -VpnType Vpn

netsh routing ip nat install

netsh routing ip nat add interface Ethernet
netsh routing ip nat set interface Ethernet mode=full

netsh routing ip nat add interface "Ethernet 2"

netsh routing ip nat show interface

write-host "Script finished!"
pause