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
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(164).png)
Ga naar de Server Manager op DC1 en klik rechts vanboven op *Tools* en open *ADSI Edit*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(165).png)
Rechterklik op *ADSI Edit* en klk op *Connect to...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(166).png)
Zorg dat de naam *Default naming context* is en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(167).png)
Open de nieuwe context en het domein. Rechterklik op *CN=System* en klik op *New* en dan *Object...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(168).png)
Selecteer *container* uit de lijst en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(169).png)
Vul als value *System Management* in en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(170).png)
Klik op *Finish* om het object aan te maken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(171).png)
Nu kunnen we permissions over de container aanmaken. Ga terug naar de Server Manager en klik op *Tools* en daarna op *Active Directory Users and Computers*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(172).png)
Klik in de linker bovenhoek op *View* en zet *Advanced Features* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(173).png)
Rechterklik op *System > System Management* en klik op *Delegate Control...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(174).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(175).png)
Klik op *Add..*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(176).png)
Klik op *Object Types.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(177).png)
Selecteer *Computers* en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(178).png)
Klik op *Advanced*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(179).png)
Zoek de SCCM server door op *Find Now* te klikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(180).png)
Selecteer de SCCM server uit de lijst en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(181).png)
Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(182).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(183).png)
Selecteer *Create a custom task to delegate* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(184).png)
Selecteer *This folder, existing objects in this folder ...* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(185).png)
Selecteer alle permission types en klik vervolgens op *Full Control* om alle permissions te selecteren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(186).png)
Klik op *Finish*. Dat was alles voor de Domain Controller. Nu kunnen we beginnen aan de prerequisites op de SCCM server.

Het volgende wat moet gebeuren is het **uitbreiden van het AD schema.**
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(187).png)
Ga naar de instalatieschijf van SCCM en open het door te dubbelklikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(188).png)
Navigeer naar `/SMSSETUP/BIN/x64`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(189).png)
Open een nieuw powershell window op deze locatie door in de navigatiebalk van windows explorer *powershell* in te typen en op enter te drukken. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(190).png)
Voer `.\extadsch.exe` uit wat staat voor **ext**end **a**ctive **d**irectory **sch**ema.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(191).png)
Als alles loopt zoals verwacht zou er nu *Succesfully extended the Active Directory schema* moeten weergegeven worden. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(192).png)
Het is ook mogelijk om het log bestand te bekijken op `C:\ExtADSch.txt` indien er fouten zijn gebeurt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(193).png)
Hier kunnen we nogmaals zien dat het schema succesvol uitgebreid is.

De volgende stap is het **installeren van de Roles en Features** die nodig zijn voor SCCM. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(194).png)
Ga naar de Server Manager en klik op *Manage* en dan op *Add Roles and Features*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(195).png)
Klik op *Server Selection* en slecteer de sccm server uit de server pool. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(196).png)
Vink *Web Server (IIS)* aan en klik op *Add Features* om de benodigdheden te installeren. Include ook altijd de management tools indien mogelijk. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(197).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(198).png)
Selecteer de volgende Features:
  1) .Net Framework 3.5 Features [Install all sub features]
  2) .Net Framework 4.5 Features[Install all sub features]
  3) BITS
  4) Remote Differential Compression
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(199).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(200).png)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(201).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(202).png)
Selecteer volgende Role Services:
  1) Common HTTP Features –Default Document, Static Content
  2) Application Development –ASP.NET 3.5,.NET Extensibility 3.5, ASP.NET 4.5,.NET Extensibility 4.5, ISAPI extensions
  3) Security –Windows Authentication
  4) IIS 6 Management Compatibility –IIS Management Console,IIS 6 Metabase Compatibility,IIS6 WMI Compatibility, IIS Management Scripts and Tools
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(203).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(204).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(205).png)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(206).png)
Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(207).png)
Geef het pad naar de SxS folder op de installatieschijf in en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(208).png)
Klik op *Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(209).png)
Wacht tot de installatie klaar is. Hier is nog een overzicht te zien van alle Roles en Features.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(210).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(211).png)
Klik op *Close* als de installatie succesvol beëindigd is.

Volgende in de rij is de **Windows Assessment and Deployment Kit**. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(212).png)
Voer de installatieschijf in en open de *adksetup.exe*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(213).png)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(214).png)
Selecteer *No* om geen data naar Microsoft te verzenden. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(215).png)
Lees en accepteer de License Agreement.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(217).png)
Selecteer *Deployment Tools, Windows Preinstallation Environment* en *User State Migration Tool* en klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(218).png)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(219).png)
Als je dit scherm ziet wil het zeggen dat de installatie compleet is. Klik op *Close*.


SCCM heeft eigenlijk geen **Java** nodig maar SQL Server, wat wel een benodigde is voor SCCM, wel.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(221).png)
Download en open de java installer.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(222).png)
Klik op *Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(223).png)
Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(224).png)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(225).png)
Klik op ok om de installatie te beeïndigen. Java is nu succesvol geïnstalleerd.

SCCM heeft een **SQL Server** nodig om te werken. Voor dit voorbeeld gaan we de SQL Server op dezelfde machine van SCCM zelf installeren voor betere snelheid en omdat resources (vooral RAM) beperkt zijn. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(220).png)
Voer de installatieschijf van SQL Server in en voer de Setup uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(226).png)
Om zeker te zijn dat de basis benodigdheden aanwezig zijn voeren we eerste de *System Configuration Checker* uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(227).png)
Als alle testen slagen, klik je op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(228).png)
Bij *Installation* kiezen we voor een *New SQL Server stand-alone installation*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(229).png)
Voer een product key in of kies voor een gratis editie en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(230).png)
Lees en accepteer de license terms en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(231).png)
Kies of je Microsoft updates voor updates wil laten checken en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(232).png)
Bij de installation rules krijgen we momenteel nog een warning. Een warnings betekend niet dat de instalatie niet door kan gaan. Na de installatie zullen we de firewall configureren. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(233).png)
Selecteer *Database Engine Services, Reporting Services-Native* en *Management Tools –Complete*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(234).png)
Selecteer *Default Instance* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(235).png)
Klik op de *Collation* tab en dan op *Customize...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(236).png)
Selecteer *SQL_Latin1_General_CP1_CI_AS* en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(237).png)
Ga terug naar de *Service Accounts* tab en verander de Accounts.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(238).png)
Klik op *Advanced...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(239).png)
Klik op *Find Now*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(240).png)
Selecteer het account dat je wil gebruiken en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(241).png)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(243).png)
Geef het wachtwoord voor de accounts in en selecteer als Startup Type *Automatic*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(244).png)
Selecteer *Windows authentication mode* en klik op *Add Current User*. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(246).png)
Bekijk het overzicht en klik op *Install* als alles correct is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(247).png)
De installatie van SQL Server is succesvol. Klik op *Close*.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(248).png)
We hebben ook **SQL Server Management Tools** nodig om de databank te configureren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(249).png)
Download SSMS van Microsoft's website.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(250).png)
Voer de setup uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(251).png)
Klik op *Run*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(252).png)
Klik op *Install* om de installatie te starten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(253).png)
Open SSMS wanneer de installatie compleet is en connecteer met de SQL Server.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(254).png)
Rechterklik op de databank en open de *Properties*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(255).png)
Stel de Maximum server memory in op 8192 MB. Klik op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(256).png)
SSMS mag nu gesloten worden.

Ten laatste hebben we **WSUS** nodig.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(257).png)
Om dit te installeren, klik je op *Manage* in de Server Manager en klik op *Add Roles and Features*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(258).png)
Selecteer de lokale server en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(259).png)
Vink *Windows Server Update Services* aan en klik op *Add Features* om zijn benodigdheden ook te installeren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(260).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(261).png)
 Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(262).png)
 Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(263).png)
Selecteer *WSUS Services* en *SQL Server Connectivity* en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(264).png)
Vink *Store updates in the following location* aan en voer een locatie in. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(265).png)
Specifieer een database en klik op *Check Connection*. Zorg ervoor dat er zeker *Successfully connected to server* op komt. In ons geval is de database geïnstalleerd op de SCCM server zelf. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(266).png)
Check *Restart the destination server automatically if required* en klik op *Yes* als er een pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(267).png)
Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(268).png)
Als de installatie klaar is klik je op *Close.* Klik **niet** op de pop-up om de configuratiewizard te openen!

Nu alle prerequisite software geïnstalleerd is, rest er zich nog één zaak voor we aan de SCCM installatie kunnen beginnen. Namelijk de **Firewall Settings**. Dit moet geconfigureeerd worden op onze Domain Controller DC1!
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(269).png)
Da naar de Server Manager op DC1 en klik op *Tools* en dan op *Group Policy Management.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(270).png)
Rechterklik op je domain in de linker navigatiebalk en klik op *Create GPO in this domain...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(271).png)
Geef een naam voor de nieuwe GPO en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(272).png)
Rechterklik op de nieuwe GPO en klik op *Edit...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(273).png)
Navigeer naar `Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advanced Security`. Rechterklik op *Inbound Rules* en klik op *New Rule...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(274).png)
Selecteer *File and Printer Sharing* onder *Predefined*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(275).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(276).png)
Slecteer *Allow the connection* en klik op *Finish.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(277).png)
Doe hetzelfde voor de Outbound Rules
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(278).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(279).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(280).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(281).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(282).png)
Maak een nieuwe Inbound Rule.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(283).png)
Selecteer deze keer *Windows Management Instrumentation (WMI)* onder *Predefined* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(284).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(285).png)
Allow the connection en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(286).png)
Sluit de *Group Policy Management Editor* en maak een nieuwe GPO aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(287).png)
Geef de GPO een naam en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(288).png)
Rechterklik op de nieuwe GPO en klik op *Edit...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(289).png)
Maak een nieuwe Inbound Rule.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(290).png)
Selecteer deze keer *Port* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(291).png)
Slecteer TCP en specifieer de local port *1433*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(292).png)
Allow de connection en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(293).png)
Vink zowel *Domain, Private* en *Public* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(294).png)
Geef de regel een naam en klik op *Finish.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(295).png)
Doe hetzelfde voor TCP poort *4022*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(296).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(297).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(298).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(299).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(300).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(301).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(302).png)
Om de nieuwe group policies operationeel te maken gebruiken we het batch commando `gpupdate /force`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(303).png)
De policies zijn succesvol toegepast op DC1. We kunnen terug werken op de SCCM server nu.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(304).png)
Ook op de SCCM server voeren we `gpupdate /force` uit. Vervolgens kunnen we dit controlleren met `rsop.msc`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(305).png)
Links navigeren we naar `Computer Configuration > Administrative Templates > Extra Registry Settings`. Hier kunnen we de aangemaakte group policies zien en het efit dat ze active zijn. 

Nu alle prerequisites succesvol afgerond zijn kun er begonnen worden met de effectieve installatie van SCCM 2012. 

#### Installing SCCM 2012

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(306).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(307).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(308).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(309).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(310).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(311).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(312).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(313).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(314).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(315).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(316).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(317).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(318).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(319).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(320).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(321).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(322).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(323).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(324).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(325).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(326).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(327).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(328).png)

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(329).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(330).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(331).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(332).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(333).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(334).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(335).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(336).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(337).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(338).png)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(339).png)

### Configuratie SCCM 2012

...

#### Een gebruikerspostvak toevoegen

....


## Extra
Admin Password: K3anu

Keanu Nys Mail Password: K3anuK3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
- Cursus Exchange 2013
- www.mustbegeek.com
