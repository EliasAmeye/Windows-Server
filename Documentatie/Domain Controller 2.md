# Documentatie van DC2

## Instalatie

### VirtualBox Configuratie
- Ga door de standaard configuratiestappen zoals beschreven in de [documentatie over VirtualBox](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Virtualbox%20%26%20Windows%20Installatie.md)

## Configuratie

### Manuele configuratie

1) Hernoem de computer
  * De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerDC2`
  * De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
  
2) Tijdzone instellen
  * De tijdzone kunnen we instellen met het volgende commando: `Set-TimeZone -Name "Romance Standard Time"`. Dit zal direct de tijd juist zetten.
  
3) TCP/IP instellingen
  * We stellen het ip van de netwerkaddapter in het host-only netwerk, `Ethernet`, in op 192.168.1.2/24 met deafault gateway 192.168.1.1: 
    `netsh interface ip set address "Ethernet" static 192.168.1.2 255.255.255.0 192.168.1.1`
  * We stellen de DNS server in op DC1:
    `Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 192.168.1.1`
      * Controlleren met `Get-DnsClientServerAddress`:
      ```
      PS C:\Users\Administrator> Get-DnsClientServerAddress

      InterfaceAlias               Interface Address ServerAddresses
                                   Index     Family
      --------------               --------- ------- ---------------
      Ethernet                             3 IPv4    {192.168.1.1}
      Ethernet                             3 IPv6    {::1}
      ```
    
4) Installeer AD DS
  * Volgend commando: `install-windowsfeature AD-Domain-Services -IncludeManagementTools` installeert de AD-Domain_Services.
  * `Install-ADDSDomainController -DomainName keanys.gent -Force` installeert de tweede domaincontroller in het `keanu.gent` domain. Er zal gevraagd worden naar een safemode password en credentials. Na de installatie zal de computer automatisch herstarten.

5) DHCP
  * Installeer DHCP op de server met `Install-WindowsFeature DHCP -IncludeManagementTools`.
  * Geef de server rechten om DHCP server te zijn in het domain: `Add-DhcpServerInDC`
    * We kunnen dit controlleren met `Get-DhcpServerInDC`:
    ```
    PS C:\Users\Administrator> Get-DhcpServerInDC

    IPAddress            DnsName
    ---------            -------
    192.168.1.1          serverdc1.keanys.gent
    192.168.1.2          serverdc2.keanys.gent
    ```
  * `Add-DhcpServerv4Scope -name "keanysClients" -StartRange 192.168.1.20 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0` voegt een nieuwe dhcp scope toe voor de clients. De range specifieerd welke IP addressen de dhcp server mag toe wijzen aan zijn clients.
    * Controlleren met `Get-DhcpServerv4Scope`:
    ```
    PS C:\Users\Administrator> Get-DhcpServerv4Scope

    ScopeId         SubnetMask      Name           State    StartRange      EndRange        LeaseDuration
    -------         ----------      ----           -----    ----------      --------        -------------
    192.168.1.0     255.255.255.0   keanysClients  Active   192.168.1.20    192.168.1.200   8.00:00:00
    ```
  * `Set-DhcpServerv4OptionValue -Router 192.168.1.1 -DnsServer 192.168.1.1` stelt de router en dns server in op DC1 voor dhcp.
    * Controlleren met `Get-DhcpServerv4OptionValue`:
    ```
    PS C:\Users\Administrator> Get-DhcpServerv4OptionValue

    OptionId   Name            Type       Value                VendorClass     UserClass       PolicyName
    --------   ----            ----       -----                -----------     ---------       ----------
    3          Router          IPv4Add... {192.168.1.1}
    6          DNS Servers     IPv4Add... {192.168.1.1}
    ```
  * Herstart de dhcp server zodat verandering toegepast worden: `Restart-Service dhcpserver`
    * Controlleer of de service correct is herstart en running is met `Get-Service dhcpserver`:
    ```
    PS C:\Users\Administrator> Get-Service dhcpserver

    Status   Name               DisplayName
    ------   ----               -----------
    Running  dhcpserver         DHCP Server
    ```

### Automatisatie door middel van scripts
Uit de manuele configuratie kunnen we nu een script maken. De commando's zijn hierboven al uitgelegd dus dit nog eens doen in deze sectie zou dubbel werk zijn. 
De scripts zijn te vinden in [/scripts/DC2_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_Hostname%26IP.ps1), [/scripts/DC2_Domain.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_Domain.ps1) en [/scripts/DC2_DHCP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_DHCP.ps1). Met gebruik van comments worden alle stappen nog kort uitgelegd.

Volgorde van uitvoeren:

1) [DC2_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_Hostname%26IP.ps1)
2) [DC2_Domain.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_Domain.ps1)
3) [DC2_DHCP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/DC2_DHCP.ps1)

De reden waarom er voor DC2 drie scripts nodig zijn is omdat de server nu niet alleen moet herstarten nadat de hostname veranderd is, maar ook automatisch restart na het uitvoeren van `Install-ADDSDomainController` waar de tweede domain controller wordt geïnstalleerd. 

## Extra
Admin Password: K3anu
SafeMode Password: K3anuSafeMode

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
