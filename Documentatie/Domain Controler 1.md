# Documentatie van DC1

## Instalatie

### VirtualBox Configuratie
DC1 heeft een speciale stap bij het opzetten in VirtualBox omdat deze twee netwerkaddapters moet hebben. Eén van deze is voor het interne netwerk en is dus met gevolg een Host-Only Ethernet Adapter zoals bij de andere machines. De tweede adapter, die de andere machines niet hebben, is een NAT adapter. Deze NAT adapter zal ervoor zorgen dat er internet toegang is door de host. Volgende stappen moeten dus doorlopen worden:

- Maak een nieuwe VM aan en noem hem `Server1`
- Ga door de standaard configuratiestappen zoals beschreven in de [documentatie over VirtualBox](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Virtualbox%20%26%20Windows%20Installatie.md)
- Ga naar de instellingen van de nieuwe machine 
- Klik op `Netwerk` om de netwerkinstellingen aan te passen en zorg voor de volgende configuratie:
  - Adapter 1 : NAT
  - Adapter 2 : Host-Only (met 192.168.1.1/24 netwerk)

## Configuratie

### Manuele configuratie

1) Hernoem de computer
  * De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerDC1`
  * De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
  
2) Tijdzone instellen
  * De tijdzone kunnen we instellen met het volgende commando: `Set-TimeZone -Name "Romance Standard Time"`. Dit zal direct de tijd juist zetten.
  
3) TCP/IP instellingen
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
  * Forward Dns requests naar dns server van school en google:
    ```
    Add-DnsServerForwarder -IPAddress 193.190.173.1 
    Add-DnsServerForwarder -IPAddress 8.8.8.8 
    ```
    * Controlleren met `Get-DnsServerForwarder`:
    ```
    PS C:\Users\Administrator> Get-DnsServerForwarder

    UseRootHint        : True
    Timeout(s)         : 3
    EnableReordering   : True
    IPAddress          : {193.190.173.1, 8.8.8.8, fec0:0:0:ffff::2, fec0:0:0:ffff::3...}
    ReorderedIPAddress : {193.190.173.1, 8.8.8.8, fec0:0:0:ffff::2, fec0:0:0:ffff::3...}
    ```
    
4) Installeer AD DS
  * Volgend commando: `install-windowsfeature AD-Domain-Services -IncludeManagementTools` installeert de AD-Domain_Services.
  * `Install-ADDSForest -DomainName keanys.gent -InstallDns -Force` installeert ADDSForest met domain name `keanu.gent` en configureerd de dns server.

5) DHCP
  * Installeer DHCP op de server met `Install-WindowsFeature DHCP -IncludeManagementTools`.
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

6) Routing en NAT
  * Installeer de windows feature `Routing` en voer een restart uit als dit nodig is: `Install-windowsFeature Routing -IncludeManagementTools -Restart` 

* Configureer NAT:
  ```
  Install-RemoteAccess -VpnType Vpn

  netsh routing ip nat install

  netsh routing ip nat add interface Ethernet
  netsh routing ip nat set interface Ethernet mode=full

  netsh routing ip nat add interface "Ethernet 2"
  ```
  De Ethernet interface moet volledige address en port translation krijgen omdat dit de NAT interface is. Ethernet 2 is de host-only interface en is voor ons private netwerk.
    * Controlleer de nat configuratie:
    ```
    PS C:\Users\Administrator> netsh routing ip nat show interface

    NAT Ethernet Configuration
    ---------------------------
    Mode              : Address and Port Translation

    NAT Ethernet 2 Configuration
    ---------------------------
    Mode              : Private Interface
    ```
    

### Automatisatie door middel van scripts
Uit de manuele configuratie kunnen we nu een script maken. De commando's zijn hierboven al uitgelegd dus dit nog eens doen in deze sectie zou dubbel werk zijn. 
De scripts zijn te vinden in [/scripts/DC1_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Hostname%26IP.ps1) en [/scripts/DC1_Domain&DHCP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Domain%26DHCP%26NAT.ps1). Met gebruik van comments en `write-host`'s worden alle stappen nog kort uitgelegd.

Volgorde van uitvoeren:

1) [DC1_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Hostname%26IP.ps1)
2) [DC1_Domain&DHCP&NAT.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_Domain%26DHCP%26NAT.ps1)

De reden waarom er twee scripts nodig zijn is omdat de server moet herstarten nadat de hostname veranderd is. Anders kan er niet verder gegaan worden met het tweede script waar AD DS geïnstalleerd wordt.

## Extra
Admin Password: K3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
