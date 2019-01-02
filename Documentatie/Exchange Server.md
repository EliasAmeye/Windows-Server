# Documentatie Exchange Server

## Instalatie

### VirtualBox Configuratie
- Ga door de standaard configuratiestappen zoals beschreven in de [documentatie over VirtualBox](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Virtualbox%20%26%20Windows%20Installatie.md)

## Configuratie

### Computer configuratie

1) Hernoem de computer
  * De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerSQLEX`
  * De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
  
2) Tijdzone instellen
  * De tijdzone kunnen we instellen met het volgende commando: `Set-TimeZone -Name "Romance Standard Time"`. Dit zal direct de tijd juist zetten.
  
3) TCP/IP instellingen
  * We stellen het ip van de netwerkaddapter in het host-only netwerk, `Ethernet`, in op 192.168.1.3/24 met deafault gateway 192.168.1.1: 
    `netsh interface ip set address "Ethernet" static 192.168.1.3 255.255.255.0 192.168.1.1`
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

### Automatisatie door middel van scripts
Uit de manuele configuratie hierboven kunnen we nu een script maken. De commando's zijn hierboven al uitgelegd dus dit nog eens doen in deze sectie zou dubbel werk zijn. 
De scripts zijn te vinden in [/scripts/SQLEX_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/SQLEX_Hostname%26IP.ps1). Met gebruik van comments en `write-host`'s worden alle stappen nog kort uitgelegd.

### Installatie Microsoft Exchange 2016

De installatie van Microsoft Exchange 2016 wordt volledig manueel gedaan door de GUI. Met behulp van screenshots zullen we alle nodige stappen overlopen.

#### Prerequisites

Het eerste wat we gaan installeren is het **Microsoft .NET Framework 4.7.2**:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
Voer de setup uit, lees de gebruiksvoorwaarden en check *I have read and accept the license terms.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(5).png)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(6).png)
Als er een pop-up op komt voor het sluiten van een programma om de installatie uit te voeren klik je op *Yes*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(7).png)
De installatie van **Microsoft .NET Framework 4.7.2** is compleet.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(8).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(9).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png)





### Configuratie Microsoft Exchange 2016

## Extra
Admin Password: K3anu

Keanu Nys Mail Password: K3anuK3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
