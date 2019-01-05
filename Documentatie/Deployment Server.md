# Documentatie Deployment Server

## Instalatie

### VirtualBox Configuratie
- Ga door de standaard configuratiestappen zoals beschreven in de [documentatie over VirtualBox](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Virtualbox%20%26%20Windows%20Installatie.md)

## Configuratie

### Computer configuratie

1) Hernoem de computer
  * De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerSCCM`
  * De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
  
2) Tijdzone instellen
  * De tijdzone kunnen we instellen met het volgende commando: `Set-TimeZone -Name "Romance Standard Time"`. Dit zal direct de tijd juist zetten.
  
3) TCP/IP instellingen
  * We stellen het ip van de netwerkaddapter in het host-only netwerk, `Ethernet`, in op 192.168.1.4/24 met deafault gateway 192.168.1.1: 
    `netsh interface ip set address "Ethernet" static 192.168.1.4 255.255.255.0 192.168.1.1`
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
De scripts zijn te vinden in [/scripts/SCCM_Hostname&IP.ps1](https://github.com/KeanuNys/Windows-Server/blob/master/scripts/SCCM_Hostname%26IP.ps1). Met gebruik van comments en `write-host`'s worden alle stappen nog kort uitgelegd.

### Installatie System Center 2012 Configuration Manager

De installatie van **System Center 2012 Configuration Manager** wordt volledig manueel gedaan door de GUI. Met behulp van screenshots zullen we alle nodige stappen overlopen.

#### Prerequisites

Het eerste wat we moeten doen is de **System Management Container** aanmaken en de SCCM server de benodigde rechten toe te kennen. Dit aanmaken van de Containers is de taak van de Domain Controller en zal dus op DC1 gebeuren. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(164).png?raw=true)
Ga naar de Server Manager op DC1 en klik rechts vanboven op *Tools* en open *ADSI Edit*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(165).png?raw=true)
Rechterklik op *ADSI Edit* en klk op *Connect to...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(166).png?raw=true)
Zorg dat de naam *Default naming context* is en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(167).png?raw=true)
Open de nieuwe context en het domein. Rechterklik op *CN=System* en klik op *New* en dan *Object...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(168).png?raw=true)
Selecteer *container* uit de lijst en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(169).png?raw=true)
Vul als value *System Management* in en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(170).png?raw=true)
Klik op *Finish* om het object aan te maken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(171).png?raw=true)
Nu kunnen we permissions over de container aanmaken. Ga terug naar de Server Manager en klik op *Tools* en daarna op *Active Directory Users and Computers*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(172).png?raw=true)
Klik in de linker bovenhoek op *View* en zet *Advanced Features* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(173).png?raw=true)
Rechterklik op *System > System Management* en klik op *Delegate Control...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(174).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(175).png?raw=true)
Klik op *Add..*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(176).png?raw=true)
Klik op *Object Types.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(177).png?raw=true)
Selecteer *Computers* en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(178).png?raw=true)
Klik op *Advanced*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(179).png?raw=true)
Zoek de SCCM server door op *Find Now* te klikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(180).png?raw=true)
Selecteer de SCCM server uit de lijst en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(181).png?raw=true)
Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(182).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(183).png?raw=true)
Selecteer *Create a custom task to delegate* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(184).png?raw=true)
Selecteer *This folder, existing objects in this folder ...* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(185).png?raw=true)
Selecteer alle permission types en klik vervolgens op *Full Control* om alle permissions te selecteren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(186).png?raw=true)
Klik op *Finish*. Dat was alles voor de Domain Controller. Nu kunnen we beginnen aan de prerequisites op de SCCM server.

Het volgende wat moet gebeuren is het **uitbreiden van het AD schema.**
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(187).png?raw=true)
Ga naar de instalatieschijf van SCCM en open het door te dubbelklikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(188).png?raw=true)
Navigeer naar `/SMSSETUP/BIN/x64`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(189).png?raw=true)
Open een nieuw powershell window op deze locatie door in de navigatiebalk van windows explorer *powershell* in te typen en op enter te drukken. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(190).png?raw=true)
Voer `.\extadsch.exe` uit wat staat voor **ext**end **a**ctive **d**irectory **sch**ema.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(191).png?raw=true)
Als alles loopt zoals verwacht zou er nu *Succesfully extended the Active Directory schema* moeten weergegeven worden. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(192).png?raw=true)
Het is ook mogelijk om het log bestand te bekijken op `C:\ExtADSch.txt` indien er fouten zijn gebeurt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(193).png?raw=true)
Hier kunnen we nogmaals zien dat het schema succesvol uitgebreid is.

De volgende stap is het **installeren van de Roles en Features** die nodig zijn voor SCCM. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(194).png?raw=true)
Ga naar de Server Manager en klik op *Manage* en dan op *Add Roles and Features*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(195).png?raw=true)
Klik op *Server Selection* en slecteer de sccm server uit de server pool. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(196).png?raw=true)
Vink *Web Server (IIS)* aan en klik op *Add Features* om de benodigdheden te installeren. Include ook altijd de management tools indien mogelijk. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(197).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(198).png?raw=true)
Selecteer de volgende Features:
  1) .Net Framework 3.5 Features [Install all sub features]
  2) .Net Framework 4.5 Features[Install all sub features]
  3) BITS
  4) Remote Differential Compression
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(199).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(200).png?raw=true)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(201).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(202).png?raw=true)
Selecteer volgende Role Services:

  1) Common HTTP Features –Default Document, Static Content
  2) Application Development –ASP.NET 3.5,.NET Extensibility 3.5, ASP.NET 4.5,.NET Extensibility 4.5, ISAPI extensions
  3) Security –Windows Authentication
  4) IIS 6 Management Compatibility –IIS Management Console,IIS 6 Metabase Compatibility,IIS6 WMI Compatibility, IIS Management Scripts and Tools
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(203).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(204).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(205).png?raw=true)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(206).png?raw=true)
Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(207).png?raw=true)
Geef het pad naar de SxS folder op de installatieschijf in en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(208).png?raw=true)
Klik op *Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(209).png?raw=true)
Wacht tot de installatie klaar is. Hier is nog een overzicht te zien van alle Roles en Features.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(210).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(211).png?raw=true)
Klik op *Close* als de installatie succesvol beëindigd is.

Volgende in de rij is de **Windows Assessment and Deployment Kit**. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(212).png?raw=true)
Voer de installatieschijf in en open de *adksetup.exe*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(213).png?raw=true)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(214).png?raw=true)
Selecteer *No* om geen data naar Microsoft te verzenden. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(215).png?raw=true)
Lees en accepteer de License Agreement.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(217).png?raw=true)
Selecteer *Deployment Tools, Windows Preinstallation Environment* en *User State Migration Tool* en klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(218).png?raw=true)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(219).png?raw=true)
Als je dit scherm ziet wil het zeggen dat de installatie compleet is. Klik op *Close*.


SCCM heeft eigenlijk geen **Java** nodig maar SQL Server, wat wel een benodigde is voor SCCM, wel.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(221).png?raw=true)
Download en open de java installer.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(222).png?raw=true)
Klik op *Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(223).png?raw=true)
Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(224).png?raw=true)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(225).png?raw=true)
Klik op ok om de installatie te beeïndigen. Java is nu succesvol geïnstalleerd.

SCCM heeft een **SQL Server** nodig om te werken. Voor dit voorbeeld gaan we de SQL Server op dezelfde machine van SCCM zelf installeren voor betere snelheid en omdat resources (vooral RAM) beperkt zijn. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(220).png?raw=true)
Voer de installatieschijf van SQL Server in en voer de Setup uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(226).png?raw=true)
Om zeker te zijn dat de basis benodigdheden aanwezig zijn voeren we eerste de *System Configuration Checker* uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(227).png?raw=true)
Als alle testen slagen, klik je op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(228).png?raw=true)
Bij *Installation* kiezen we voor een *New SQL Server stand-alone installation*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(229).png?raw=true)
Voer een product key in of kies voor een gratis editie en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(230).png?raw=true)
Lees en accepteer de license terms en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(231).png?raw=true)
Kies of je Microsoft updates voor updates wil laten checken en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(232).png?raw=true)
Bij de installation rules krijgen we momenteel nog een warning. Een warnings betekend niet dat de instalatie niet door kan gaan. Na de installatie zullen we de firewall configureren. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(233).png?raw=true)
Selecteer *Database Engine Services, Reporting Services-Native* en *Management Tools –Complete*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(234).png?raw=true)
Selecteer *Default Instance* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(235).png?raw=true)
Klik op de *Collation* tab en dan op *Customize...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(236).png?raw=true)
Selecteer *SQL_Latin1_General_CP1_CI_AS* en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(237).png?raw=true)
Ga terug naar de *Service Accounts* tab en verander de Accounts.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(238).png?raw=true)
Klik op *Advanced...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(239).png?raw=true)
Klik op *Find Now*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(240).png?raw=true)
Selecteer het account dat je wil gebruiken en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(241).png?raw=true)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(243).png?raw=true)
Geef het wachtwoord voor de accounts in en selecteer als Startup Type *Automatic*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(244).png?raw=true)
Selecteer *Windows authentication mode* en klik op *Add Current User*. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(246).png?raw=true)
Bekijk het overzicht en klik op *Install* als alles correct is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(247).png?raw=true)
De installatie van SQL Server is succesvol. Klik op *Close*.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(248).png?raw=true)
We hebben ook **SQL Server Management Tools** nodig om de databank te configureren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(249).png?raw=true)
Download SSMS van Microsoft's website.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(250).png?raw=true)
Voer de setup uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(251).png?raw=true)
Klik op *Run*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(252).png?raw=true)
Klik op *Install* om de installatie te starten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(253).png?raw=true)
Open SSMS wanneer de installatie compleet is en connecteer met de SQL Server.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(254).png?raw=true)
Rechterklik op de databank en open de *Properties*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(255).png?raw=true)
Stel de Maximum server memory in op 8192 MB. Klik op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(256).png?raw=true)
SSMS mag nu gesloten worden.

Ten laatste hebben we **WSUS** nodig.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(257).png?raw=true)
Om dit te installeren, klik je op *Manage* in de Server Manager en klik op *Add Roles and Features*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(258).png?raw=true)
Selecteer de lokale server en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(259).png?raw=true)
Vink *Windows Server Update Services* aan en klik op *Add Features* om zijn benodigdheden ook te installeren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(260).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(261).png?raw=true)
 Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(262).png?raw=true)
 Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(263).png?raw=true)
Selecteer *WSUS Services* en *SQL Server Connectivity* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(264).png?raw=true)
Vink *Store updates in the following location* aan en voer een locatie in. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(265).png?raw=true)
Specifieer een database en klik op *Check Connection*. Zorg ervoor dat er zeker *Successfully connected to server* op komt. In ons geval is de database geïnstalleerd op de SCCM server zelf. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(266).png?raw=true)
Check *Restart the destination server automatically if required* en klik op *Yes* als er een pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(267).png?raw=true)
Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(268).png?raw=true)
Als de installatie klaar is klik je op *Close.* Klik **niet** op de pop-up om de configuratiewizard te openen!

Nu alle prerequisite software geïnstalleerd is, rest er zich nog één zaak voor we aan de SCCM installatie kunnen beginnen. Namelijk de **Firewall Settings**. Dit moet geconfigureeerd worden op onze Domain Controller DC1!
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(269).png?raw=true)
Da naar de Server Manager op DC1 en klik op *Tools* en dan op *Group Policy Management.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(270).png?raw=true)
Rechterklik op je domain in de linker navigatiebalk en klik op *Create GPO in this domain...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(271).png?raw=true)
Geef een naam voor de nieuwe GPO en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(272).png?raw=true)
Rechterklik op de nieuwe GPO en klik op *Edit...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(273).png?raw=true)
Navigeer naar `Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advanced Security`. Rechterklik op *Inbound Rules* en klik op *New Rule...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(274).png?raw=true)
Selecteer *File and Printer Sharing* onder *Predefined*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(275).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(276).png?raw=true)
Slecteer *Allow the connection* en klik op *Finish.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(277).png?raw=true)
Doe hetzelfde voor de Outbound Rules
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(278).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(279).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(280).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(281).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(282).png?raw=true)
Maak een nieuwe Inbound Rule.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(283).png?raw=true)
Selecteer deze keer *Windows Management Instrumentation (WMI)* onder *Predefined* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(284).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(285).png?raw=true)
Allow the connection en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(286).png?raw=true)
Sluit de *Group Policy Management Editor* en maak een nieuwe GPO aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(287).png?raw=true)
Geef de GPO een naam en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(288).png?raw=true)
Rechterklik op de nieuwe GPO en klik op *Edit...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(289).png?raw=true)
Maak een nieuwe Inbound Rule.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(290).png?raw=true)
Selecteer deze keer *Port* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(291).png?raw=true)
Slecteer TCP en specifieer de local port *1433*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(292).png?raw=true)
Allow de connection en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(293).png?raw=true)
Vink zowel *Domain, Private* en *Public* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(294).png?raw=true)
Geef de regel een naam en klik op *Finish.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(295).png?raw=true)
Doe hetzelfde voor TCP poort *4022*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(296).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(297).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(298).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(299).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(300).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(301).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(302).png?raw=true)
Om de nieuwe group policies operationeel te maken gebruiken we het batch commando `gpupdate /force`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(303).png?raw=true)
De policies zijn succesvol toegepast op DC1. We kunnen terug werken op de SCCM server nu.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(304).png?raw=true)
Ook op de SCCM server voeren we `gpupdate /force` uit. Vervolgens kunnen we dit controlleren met `rsop.msc`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(305).png?raw=true)
Links navigeren we naar `Computer Configuration > Administrative Templates > Extra Registry Settings`. Hier kunnen we de aangemaakte group policies zien en het efit dat ze active zijn. 


#### Installing SCCM 2012
Nu alle prerequisites succesvol afgerond zijn kun er begonnen worden met de effectieve installatie van SCCM 2012. 

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(306).png?raw=true)
Voer de SCCM installatieschijf in en open de *splash* applicatie.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(307).png?raw=true)
Klik op install om de installatie te starten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(308).png?raw=true)
Met alle informatie rekeninghoudend, klikken we op *Next* om te beginnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(309).png?raw=true)
We willen een SCCM primary site installeren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(310).png?raw=true)
Als je een product key hebt, voer deze hier in, anders selecteer je de evaluation edition. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(311).png?raw=true)
Lees en accepteer alle License Terms en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(312).png?raw=true)
We hebben nog geen files gedownload dus selecteren we de eerste optie en geven we een locatie mee waar de files kunnen gedownload worden. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(313).png?raw=true)
Slecteer de gewenste talen voor de server. We gaan enkel Engels installeren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(314).png?raw=true)
Kies nu de talen voor de clients en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(315).png?raw=true)
Voer een Site code en name in naar wens. We willen ook de console aangezien we toch niet remote willen werken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(316).png?raw=true)
Selecteer *Install the primary site as a stand-alonde site* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(317).png?raw=true)
Klik op *Yes* als er een pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(318).png?raw=true)
Bij deze stappen hoeft niks aangepast te worden en kan gewoon op *Next* geklikt worden.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(319).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(320).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(321).png?raw=true)
Selecteer *Configure the communication method on each site system role* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(322).png?raw=true)
Check de boxes om zowel *management* en *distribution point* te installeren. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(323).png?raw=true)
Lees en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(324).png?raw=true)
Selecteer *Yes, let's get connected* en geef een server op. We gaan de lokale server gebruiken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(325).png?raw=true)
Ga door de samenvatting om te controlleren of alles juist is en klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(326).png?raw=true)
Als alle Prerequisite Rules doorlopen zijn zonder probleem kan de installatie beginnen. Zorg dat je zeker voldoende tijd hebt en hou er rekening me dat de computer voor zeker een uur aan zal moeten blijven. Klik op *Begin Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(327).png?raw=true)
De installatie heeft 80 minuten geduurd en is succesvol afgerond. Klik op *Close* om de installer te sluiten.


### Configuratie SCCM 2012
In deze sectie gaan we over de configuratie gaan specifiek voor deze opdracht. We zullen er voor zorgen dat er een client kan gedeployed worden met Windows 10, het mogelijk maken om updates te deployen en Adobe Reader deployen op de client. Daarnaast gaan we ook over wat best practice configurations gaan in het begin van een nieuwe SCCM server.

#### Discovery en Boundaries configureren

In deze sectie zullen we er voor zorgen dat machines en servers in het domain kunnen ontdekt worden. Dit is het eerste wat we zullen doen, dus de eerste stap is het openen van SCCM.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(328).png?raw=true)
Als SCCM geopend is, open je in de linker navigatiebalk de tab *Administration*. Open *overview*, *Hierarchy Configuration* en klik op *Discovery Methods*. Dubbelklik op *Active Directory Forest Discovery*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(329).png?raw=true)
Vink alle checkboxes en sla op *Apply.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(330).png?raw=true)
Klik op *Yes* om zo snel mogelijk full discovery te runnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(331).png?raw=true)
Open nu *Active Directory Group Discovery* en vink *Enable Active Directory Group Discovery* aan. Klik daarna op *Add* en op *Location...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(333).png?raw=true)
Geef een naam op en een locatie. De locatie kan makelijk gevonden worden met de *Browse...* knop. Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(334).png?raw=true)
Klik op *Apply* om toe te passen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(335).png?raw=true)
Klik op *Yes* om zo snel mogelijk full discovery te runnen.

Note: Enable op dezelfde manier *System* alsook *User* Discovery.

#### Site System Roles installeren
In deze sectie gaan we een paar Site System roles installeren. Dit zijn : Application Catalog web service point en website point, en Fallback Status Point. Later zullen we ook Software Update Point moeten installeren om updates te kunnen deployen.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(336).png?raw=true)
Navigeer naar `Administration > Overview > Site Configuration > Sites`. Rechterklik op de enige site en klik op *Add Site System Roles*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(337).png?raw=true)
Op de eerste pagina moet niks veranderd worden. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(338).png?raw=true)
We willen geen proxy gebruiken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(339).png?raw=true)
Selecteer de gewenste Roles om te installeren. We kiezen Application Catalog web service point en website point, en Fallback Status Point. Klik op *Next* om verder te gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(341).png?raw=true)
We houden de standaard instellingen voor de fallback status point en klikken op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(342).png?raw=true)
Hetzelfde geldt voor de Aplication Catalog. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(343).png?raw=true)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(344).png?raw=true)
Kies een organisatie naam een een kleur. Deze zullen gebruikt worden voor de Application Catalog website. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(345).png?raw=true)
Lees de samenvatting en ga na of alles correct is. Klik op *Next* als dit het geval is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(346).png?raw=true)
De installatie van de Roles is succesvol. Klik op *close* om de wizard te sluiten.

#### Customize de Client Instellingen

In deze sectie zullen we een paar custom client settings instellen. De standaard instellingen zijn zeer schappelijk, dus veel gaan we niet veranderen. We gaan toch proberen om voor zoveel mogelijk onderdeel iets aan te passen om zoveel mogelijk te proberen zien van SCCM.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(347).png?raw=true)
Net onder de *Site Configurations* van daarnet staan de *Client Settings*. Rechterklik hierop en klik vervolgens op *Create Custom Client Device Settings*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(348).png?raw=true)
 Selecteer alle onderdelen waarvan we de default settings willen aanpassen. In dit voorbeeld doen we er zeven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(349).png?raw=true)
Geef een naam mee aan de custom settings zodat achteraf makkelijk terug kan worden gevonden welke custom settings wat doen. We gaan maar één custom settings maken en noemen het daarom gewoon *Custom Device Settings 1*. Klik nog **niet** op *OK*. Eerst willen we nog alle settings aanpassen. Dit doe je door naar de volgende tab te gaan in het linker menu. Klik op *Client Policy*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(350).png?raw=true)
We verlagen het interval naar 5 minuten. Klik op *Compliance Settings*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(351).png?raw=true)
Zet *Enable compliance ecaluation on clients* op *Yes*. Klik op *Computer Agent*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(352).png?raw=true)
In deze stap gaan we een Application Catalog website point instellen. Klik op *Set Website...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(353).png?raw=true)
Selecteer deze server als de *Application Catalog website point* en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(354).png?raw=true)
Zorg ervoor dat de Application Catalog website trusted is in Internet Explorer en geef de organization name die weergegeven zal worden in. Ga naar *Computer Restart.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(355).png?raw=true)
We verlagen de eerste notification naar 60 minutes. Ga naar *Remote Tools*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(356).png?raw=true)
Klik op *Configure...* en check alle boxes om Remote Control aan te zetten. Klik op *OK*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(357).png?raw=true)
Zorg ervoor dat er toestemming gevraagd wordt om Remote Control te starten en klik op *Set Viewers...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(358).png?raw=true)
Vind de gebruikers of groepen die je toegang wil geven tot Remote Control met *Browse...* en *Advanced...*. Selecteer de accounts die je wil en klik op *OK*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(361).png?raw=true)
Klik op *OK* en ga naar *Software Deployment*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(362).png?raw=true)
Klik op *Schedule...* en stel de frequentie van de deployments in op 2 dagen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(363).png?raw=true)
Klik op *Software Updates*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(364).png?raw=true)
We doen hetzelfde voor *Software Updates*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(365).png?raw=true)
Klik op *OK* als alle settings ingesteld zijn.

#### Client Installatie (Push Installation)

In deze sectie zullen we Automatic Sitewide Client Push Installation configureren.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(366).png?raw=true)
Ga terug naar *Site Configuration* en klik op *Sites*. Klik op *Client Installation Settings* in het menu vanboven en selecteer *Client Push Installation.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(367).png?raw=true)
Enable Automatic Sitewide Client Push Installation en check *Servers* en *Workstations*. Also choose to never install on a domain controller, unless specified.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(369).png?raw=true)
On the Accounts tab, create a new account.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(370).png?raw=true)
Klik op *Browse...* om een account te zoeken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(371).png?raw=true)
Klik op *Find Now* om alle accounts weer te geven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(372).png?raw=true)
We zullen, zoals altijd, het administrator account in het domein gebruiken. Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(373).png?raw=true)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(374).png?raw=true)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(375).png?raw=true)
Klik op *Apply* om alle instellingen toe te passen.


#### PXE, Boot Image en Software Distribution configureren.

In deze sectie zullen we de configuratie doen om een Client te deployen met PXE.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(378).png?raw=true)
Onder *Sites* van daarnet, open *Servers and Site System Roles* en dan *Distribution Point.* Klik vervolgens op *Properties* in de linker bovenhoek. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(379).png?raw=true)
Ga naar de *PXE* tab en vink *Enable PXE support for clients* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(380).png?raw=true)
Klik op *OK* als er een warning pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(381).png?raw=true)
Vink de overige checkboxes aan en geef een wachtwoord in. We willen *geen* user device affinity maar wel op alle network interfaces antwoorden op PXE requests. Klik op *Apply* en *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(382).png?raw=true)
Open de *Software Library* tab in het linker navigatiemenu en navigeer naar `Overview > Operating Systems > Boot Images`. Rechterklik op de (x64) Boot Image en klik op *Properties*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(383).png?raw=true)
Vink *Enable command support* aan en klik op *Apply* om toe te passen. Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(384).png?raw=true)
Klik op *Yes* als er een pop-up op komt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(385).png?raw=true)
Er zal een nieuw venster openen. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(386).png?raw=true)
Als de wizard beeïndigd is, klik dan op *Close*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(387).png?raw=true)
Ga nu naar de *Data Sources* tab en zorg ervoor dat *Deploy this boot image from the PXE-enabled distribution point* is aangevinkt. Klik vervolgens op *Apply* en *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(388).png?raw=true)
Rechterklik nogmaals op de Boot Image en Distribute de Content.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(389).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(390).png?raw=true)
Voeg een Distribution Point toe door op *Add* en *Distribution Point* te klikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(391).png?raw=true)
Selecteer het Distribution Point en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(392).png?raw=true)
Klik op *Next* om verder te gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(393).png?raw=true)
Ga na of alles in orde is in de samenvatting en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(394).png?raw=true)
Klik op *Close* om de wizard te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(395).png?raw=true)
We kunnen de status van het *Distributen* bekijken in de *Monitor* tab en navigeer naar `Overview > Distribution Status > Content Status`. Als we nu klikken op de Boot Image zien we dat de status *Success* is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(396).png?raw=true)
Navigeer terug naar *Sites* onder de *Administration* tab en klik op *Configure Site Components* en vervolgends op *Software Distribution* in het menu bovenaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(397).png?raw=true)
Selecteer *Specify the account that accesses network locations*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(398).png?raw=true)
Voeg een *Existing Account* toe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(399).png?raw=true)
Selecteer het account en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(400).png?raw=true)
Klik op *Apply* en *OK* om de veranderingen toe te passen.

#### Deploying Adobe Reader

In deze sectie zullen we Adobe Reader deployen op een client. Hiervoor zullen we eerst een `.msi` moeten extracten uit een `.exe` file.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(411).png?raw=true)
Om een package te deployen hebben we eerst een `.msi` bestand van de adobe installer nodig. In dit voorbeeld zullen we dit uit de 11.0.10 adobe installer halen, en daarna updaten naar de 11.0.14 update zodat we een 11.0.14 `.msi` installer hebben. Ga naar de locatie waar de installer en de update zijn in command prompt en voer het volgende commando uit: `AdbeRdr11010_en_US.exe  -nos_ne -nos_o"C:\AdobeDeployment\Adobe AIP"`. Dit zal de installer uitvoeren en het `.msi` bestand extracten in de nieuwe folder *Adobe AIP*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(412).png?raw=true)
Ga in de nieuwe map en voer het commando `msiexec /a AcroRead.msi`. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(413).png?raw=true)
Dit zal de msi installer uitvoeren. Geef een **nieuwe** map op waar de bestanden van de installer in zullen geplaatst worden en ga door de installatie van Adobe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(414).png?raw=true)
Voer nu het commando `msiexec /a "C:\AdobeDeployment\Adobe Reader\AcroRead.msi" /p "C:\AdobeDeployment\AdbeRdrUpd11014.msp"` in. dit zal de nieuwe update installeren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(415).png?raw=true)
Kies **dezelfde** locatie als daarnet om de bestanden te installeren en ga door de installer. De adobe bestanden zijn nu klaar voor gebruik.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(410).png?raw=true)
In SCCM, ga naar *Software Library* en navigeer naar `Overview > Application Management`. Rechterklik op *Packages* en maak een nieuwe package aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(419).png?raw=true)
Geef een naam op voor de package en vink *This package contains source files* aan. Klik op *Browse...* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(418).png?raw=true)
Klik nogmaals op *Browse...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(417).png?raw=true)
Selecteer de locatie van de Adobe Reader bestanden en klik op *Select Folder*. In dit voorbeeld hebben we de bestanden gekopieerd naar de volgende netwerklocatie.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(420).png?raw=true)
Klik op *Next.* Selecteer *Standard program* en klik nogmaals op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(421).png?raw=true)
Geef een naam mee in en voer als command line het volgende in: `msiexec /i "AcroRead.msi" /q`. Selecteer Program can run: *Whether or not a user is logged on* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(422).png?raw=true)
Selecteer dat het programa op alle platformen kan uitgevoerd worden en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(423).png?raw=true)
Lees de samenvatting om na te gaan of alles in orde is en klik in dat geval op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(424).png?raw=true)
De package en het programma zijn succesvol aangemaakt. Klik op *Close* om de wizard af te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(425).png?raw=true)
Onder *Packages* is nu de nieuwe Adobe Package te vinden. Rechterklik op de package en kies om de Content te Distributen. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(426).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(427).png?raw=true)
Klik op *Add* en voeg een *Distribution Point* toe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(428).png?raw=true)
Selecteer het Distribution Point en klik op *OK*. Note: Als er geen Distribution Point weergegeven wordt wil het zeggen dat je vorige stappen hebt overgeslaan en terug moet gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(429).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(430).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(431).png?raw=true)
De Content is succesvol Distributed, klik op *close* om de wizard af te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(432).png?raw=true)
Nu kan de package Deployed worden. Rechterklik op de package en klik op *Deploy.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(433).png?raw=true)
Selecteer de collection waarop je wil deployen door op *Browse...* te klikken en klik vervolgens op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(434).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(435).png?raw=true)
Kies voor *Available* om safe te zijn. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(436).png?raw=true)
We willen zo snel mogelijk deployen dus specifieren geen tijd. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(437).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(438).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(439).png?raw=true)
Lees de samenvatting en klik op *Next* als alels in orde is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(440).png?raw=true)
De deployment wizard is succesvol, klik op *Close.*

#### Deploying software updates

Het laatste wat we zullen doen is er voor zorgen dat software updates deployed kunnen worden. Hiervoor moeten we eerst een *Software update point* aanmaken.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(441).png?raw=true)
Ga terug naar *Sites* onder de *Administration* tab en klik op *Add Site System Roles* uit het menu vanboven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(442).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(443).png?raw=true)
We hebben geen proxy, klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(444).png?raw=true)
Selecteer het *Software update point* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(445).png?raw=true)
We hebben WSUS geconfigureerd om poorten 8530 en 8531 te gebruiken voor het client verkeer. Slecteer deze en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(446).png?raw=true)
Check *Use credentials* en klik op *Set...* en kies voor *Existing Account.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(447).png?raw=true)
Selecteer het account en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(448).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(449).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(450).png?raw=true)
We willen synchronization om de 7 uur laten gebeuren. Check ook om een Alert te sturen indien de sync failt en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(451).png?raw=true)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(452).png?raw=true)
Selecteer de soort updates die je wilt synchronizeren en klik vervolgens op *Next.* Hier kiezen we voor *Critical, Definition* en *Security Updates*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(453).png?raw=true)
Selecteer de producten die je wilt synchronizeren en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(454).png?raw=true)
Voor talen selecteren we *Nederlands* en *Engels*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(455).png?raw=true)
Bekijk de samenvatting en klik op *Next* als alles in orde is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(456).png?raw=true)
De wizard is succesvol beeïndigd, klik op *close*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(457).png?raw=true)
Ga nu naar de *All Software Updates* onder de *Software Library* tab en klik op *Synchronize Software Updates* in het bovenste menu. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(458).png?raw=true)
Klik op *Yes* om de synchronizatie uit te voeren.


## Extra
Admin Password: K3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
- Cursus SCCM
- Cursus MS SQL 2017 
- http://prajwaldesai.com
