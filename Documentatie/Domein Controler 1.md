# Documentatie van DC1

## Instalatie

### VirtualBox Configuratie
- Maak een nieuwe VM aan en noem hem `Server1`
- Ga door de standaard configuratiestappen
- Ga naar de instellingen van de nieuwe machine 
- Gebruik een windows server 2016 .iso als boot drive onder `Opslag`.
- Klik op `Netwerk` om de netwerkinstellingen aan te passen en zorg voor de volgende configuratie:
  - Adapter 1 : NAT
  - Adapter 2 : Host-Only (met 192.168.1.1/24 netwerk)

### Windows Server instalatie
- Start de nieuwe virtuele machine en voer de instalatie uit.
- Installeer Guest Additions:
  - Klik op `Apparaten` in de menubalk en dan `Invoegen Guest Additions CD-image...`
  - Ga naar de ingevoerde CD en voer `VBoxWindowsAdditions.exe` uit.
  - Activeer Gedeeld klembord zodat we uitvoer van commando's makkelijk kunnen kopieëren

## Configuratie

### Manuele configuratie

1) Hernoem de computer
  * De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerDC1`
  * De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
2) TCP/IP instellingen
  * We stellen het ip van de netwerkaddapter in het host-only netwerk, `Ethernet 2`, in op 192.168.1.1: 
    `netsh interface ip set address "Ethernet 2" static 192.168.1.1 255.255.255.0 `
  * We stellen de DNS server in op zichzelf:
    `Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 192.168.1.1`
      * Controlleren met `Get-DnsClientServerAddress`:
      ```
      PS C:\Users\Administrator> Get-DnsClientServerAddress

      InterfaceAlias               Interface Address ServerAddresses
                                   Index     Family
      --------------               --------- ------- ---------------
      Ethernet                             3 IPv4    {192.168.1.1}
      Ethernet                             3 IPv6    {::1}
      Ethernet 2                           7 IPv4    {127.0.0.1}
      Ethernet 2                           7 IPv6    {::1}
      ```
    
3) Installeer AD DS
  * Volgend commando: `install-windowsfeature AD-Domain-Services -IncludeManagementTools` installeert de AD-Domain_Services.
  * `Install-ADDSForest -DomainName keanys.gent -InstallDns -Force` installeert ADDSForest met domain name `keanu.gent` en configureerd de dns server.

4) DHCP
  * Geef de server rechten om DHCP server te zijn in het domain: `Add-DhcpServerInDC`
    * We kunnen dit controlleren met `Get-DhcpServerInDC`:
    ```
    PS C:\Users\Administrator> Get-DhcpServerInDC

    IPAddress            DnsName
    ---------            -------
    192.168.1.1          serverdc1.keanys.gent
    ```
  * `Add-DhcpServerv4Scope -name "keanysClients" -StartRange 192.168.1.20 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0` voegt een nieuwe dhcp scope toe voor de clients. De range specifieerd welke IP addressen de dhcp server mag toe wijzen aan zijn clients.
    * Controlleren met `Get-DhcpServerv4Scope`:
    ```
    PS C:\Users\Administrator> Get-DhcpServerv4Scope

    ScopeId         SubnetMask      Name           State    StartRange      EndRange        LeaseDuration
    -------         ----------      ----           -----    ----------      --------        -------------
    192.168.1.0     255.255.255.0   keanysClients  Active   192.168.1.20    192.168.1.200   8.00:00:00
    ```
  * `Set-DhcpServerv4OptionValue -Router 192.168.1.1 -DnsServer 192.168.1.1` stelt de router en dns server in voor dhcp.
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

### Script
Uit de manuele configuratie kunnen we nu een script maken. De commando's zijn hierboven al uitgelegd dus dit nog eens doen in deze sectie zou dubbel werk zijn. 
De scripts zijn te vinden in [/scripts/DC1_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Hostname&IP.ps1) en [/scripts/DC1_Domain&DHCP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Domain&DHCP.ps1). Met gebruik van comments worden alle stappen nog kort uitgelegd.

Volgorde van uitvoeren:

1) [DC1_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Hostname&IP.ps1)
2) [DC1_Domain&DHCP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Domain&DHCP.ps1)

De reden waarom er twee scripts nodig zijn is omdat de server moet herstarten nadat de hostname veranderd is. Anders kan er niet verder gegaan worden met het tweede script waar AD DS geïnstalleerd wordt.

## Extra
Admin Password: K3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps
