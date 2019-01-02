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

Daarna moet **Microsoft Visual C++ 2012** geïnstalleerd worden:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(8).png)
Voer de setup uit, lees de gebruiksvoorwaarden en check *I agree to the license terms and conditions.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(9).png)
De installatie van **Microsoft Visual C++ 2012** is compleet.

Nu installeren we UCMA 4.0 of **Microsoft Unified Communications Managed API 4.0**:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(10).png)
Voer de setup uit. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(11).png)
Klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(12).png)
Lees de gebruiksvoorwaarden en check *I have read and accept the license terms.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(13).png)
Wacht tot de installer klaar is. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(14).png)
Klik op *Finish*. De installatie van **Microsoft Unified Communications Managed API 4.0** is compleet.


![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(20).png)
Open powershell en installeer **RSAT-ADDS** met het commando: `Install-WindowsFeature RSAT-ADDS` 


![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(21).png)
Download `prerequisits_exchange.ps1` en voer het uit op de Server.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(22).png)
Klik op *Open*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(23).png)
Voer *A* in om de execution policy te veranderen zodat het script kan uitgevoerd worden.

#### Installing Exchange 2016

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(59).png)
Download de laatste **Cumulative Update for Exchange Server 2016** van de website van microsoft. Hier hebben we CU8 gebruikt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(60).png)
Dubbel klik op het iso bestand om het te mounten. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(61).png)
Voer *Setup.exe* uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(63).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(64).png)
Check *Connect to the Internet and check for updates* om de laatste updates te downloaden of check voor updates later. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(65).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(66).png)
Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(67).png)
Lees en accepteer daarna de license agreement mat de radio button. Klik op *next*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(68).png)
Selecteer *Don't use recommended settings* en klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(69).png)
Selecteer de *Mailbox role* en de optie om automatisch andere benodigdheden te installeren (die we misschien vergeten zijn). Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(70).png)
Kies de locatie waar Exchange geïnstalleerd zal worden. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(71).png)
Geef de naam mee van de organisatie, wij nemen *keanys* voor dit voorbeeld. Klik op *next*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(72).png)
Kies ervoor om Malware Scanning **niet** uit te zetten. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(73).png)
Wacht tot de Readiness Checks klaar zijn. Klik [hier](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Exchange%20Troubleshooting.md) als je een error krijgt en de stappen te zien die ik ondernomen heb om degene die ik tegen gekomen ben op te lossen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(89).png)
Klik op *install* als er geen errors zijn. De twee warnings die we krijgen zijn niet belangrijk in dit geval. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(92).png)
Wacht tot de setup compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(93).png)
De installatie van **Exchange Server 2016** is klaar. Klik op *Finish*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(95).png)
Als het *Exchange-beheercentrum* weergegeven wordt in de browser wil dit zeggen dat Exchange 2016 correct is opgestart.

### Configuratie Microsoft Exchange 2016

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(97).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(98).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(99).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(90).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(91).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(92).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(93).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(94).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(95).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(96).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(97).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(98).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(99).png)


## Extra
Admin Password: K3anu

Keanu Nys Mail Password: K3anuK3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
