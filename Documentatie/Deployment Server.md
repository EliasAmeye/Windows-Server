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


#### Installing SCCM 2012
Nu alle prerequisites succesvol afgerond zijn kun er begonnen worden met de effectieve installatie van SCCM 2012. 

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(306).png)
Voer de SCCM installatieschijf in en open de *splash* applicatie.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(307).png)
Klik op install om de installatie te starten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(308).png)
Met alle informatie rekeninghoudend, klikken we op *Next* om te beginnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(309).png)
We willen een SCCM primary site installeren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(310).png)
Als je een product key hebt, voer deze hier in, anders selecteer je de evaluation edition. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(311).png)
Lees en accepteer alle License Terms en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(312).png)
We hebben nog geen files gedownload dus selecteren we de eerste optie en geven we een locatie mee waar de files kunnen gedownload worden. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(313).png)
Slecteer de gewenste talen voor de server. We gaan enkel Engels installeren. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(314).png)
Kies nu de talen voor de clients en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(315).png)
Voer een Site code en name in naar wens. We willen ook de console aangezien we toch niet remote willen werken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(316).png)
Selecteer *Install the primary site as a stand-alonde site* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(317).png)
Klik op *Yes* als er een pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(318).png)
Bij deze stappen hoeft niks aangepast te worden en kan gewoon op *Next* geklikt worden.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(319).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(320).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(321).png)
Selecteer *Configure the communication method on each site system role* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(322).png)
Check de boxes om zowel *management* en *distribution point* te installeren. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(323).png)
Lees en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(324).png)
Selecteer *Yes, let's get connected* en geef een server op. We gaan de lokale server gebruiken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(325).png)
Ga door de samenvatting om te controlleren of alles juist is en klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(326).png)
Als alle Prerequisite Rules doorlopen zijn zonder probleem kan de installatie beginnen. Zorg dat je zeker voldoende tijd hebt en hou er rekening me dat de computer voor zeker een uur aan zal moeten blijven. Klik op *Begin Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(327).png)
De installatie heeft 80 minuten geduurd en is succesvol afgerond. Klik op *Close* om de installer te sluiten.


### Configuratie SCCM 2012
In deze sectie gaan we over de configuratie gaan specifiek voor deze opdracht. We zullen er voor zorgen dat er een client kan gedeployed worden met Windows 10, het mogelijk maken om updates te deployen en Adobe Reader deployen op de client. Daarnaast gaan we ook over wat best practice configurations gaan in het begin van een nieuwe SCCM server.

#### Discovery en Boundaries configureren

In deze sectie zullen we er voor zorgen dat machines en servers in het domain kunnen ontdekt worden. Dit is het eerste wat we zullen doen, dus de eerste stap is het openen van SCCM.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(328).png)
Als SCCM geopend is, open je in de linker navigatiebalk de tab *Administration*. Open *overview*, *Hierarchy Configuration* en klik op *Discovery Methods*. Dubbelklik op *Active Directory Forest Discovery*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(329).png)
Vink alle checkboxes en sla op *Apply.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(330).png)
Klik op *Yes* om zo snel mogelijk full discovery te runnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(331).png)
Open nu *Active Directory Group Discovery* en vink *Enable Active Directory Group Discovery* aan. Klik daarna op *Add* en op *Location...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(333).png)
Geef een naam op en een locatie. De locatie kan makelijk gevonden worden met de *Browse...* knop. Klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(334).png)
Klik op *Apply* om toe te passen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(335).png)
Klik op *Yes* om zo snel mogelijk full discovery te runnen.

Note: Enable op dezelfde manier *System* alsook *User* Discovery.

#### Site System Roles installeren
In deze sectie gaan we een paar Site System roles installeren. Dit zijn : Application Catalog web service point en website point, en Fallback Status Point. Later zullen we ook Software Update Point moeten installeren om updates te kunnen deployen.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(336).png)
Navigeer naar `Administration > Overview > Site Configuration > Sites`. Rechterklik op de enige site en klik op *Add Site System Roles*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(337).png)
Op de eerste pagina moet niks veranderd worden. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(338).png)
We willen geen proxy gebruiken. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(339).png)
Selecteer de gewenste Roles om te installeren. We kiezen Application Catalog web service point en website point, en Fallback Status Point. Klik op *Next* om verder te gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(341).png)
We houden de standaard instellingen voor de fallback status point en klikken op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(342).png)
Hetzelfde geldt voor de Aplication Catalog. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(343).png)
Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(344).png)
Kies een organisatie naam een een kleur. Deze zullen gebruikt worden voor de Application Catalog website. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(345).png)
Lees de samenvatting en ga na of alles correct is. Klik op *Next* als dit het geval is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(346).png)
De installatie van de Roles is succesvol. Klik op *close* om de wizard te sluiten.

#### Customize de Client Instellingen

In deze sectie zullen we een paar custom client settings instellen. De standaard instellingen zijn zeer schappelijk, dus veel gaan we niet veranderen. We gaan toch proberen om voor zoveel mogelijk onderdeel iets aan te passen om zoveel mogelijk te proberen zien van SCCM.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(347).png)
Net onder de *Site Configurations* van daarnet staan de *Client Settings*. Rechterklik hierop en klik vervolgens op *Create Custom Client Device Settings*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(348).png)
 Selecteer alle onderdelen waarvan we de default settings willen aanpassen. In dit voorbeeld doen we er zeven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(349).png)
Geef een naam mee aan de custom settings zodat achteraf makkelijk terug kan worden gevonden welke custom settings wat doen. We gaan maar één custom settings maken en noemen het daarom gewoon *Custom Device Settings 1*. Klik nog **niet** op *OK*. Eerst willen we nog alle settings aanpassen. Dit doe je door naar de volgende tab te gaan in het linker menu. Klik op *Client Policy*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(350).png)
We verlagen het interval naar 5 minuten. Klik op *Compliance Settings*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(351).png)
Zet *Enable compliance ecaluation on clients* op *Yes*. Klik op *Computer Agent*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(352).png)
In deze stap gaan we een Application Catalog website point instellen. Klik op *Set Website...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(353).png)
Selecteer deze server als de *Application Catalog website point* en klik op *OK.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(354).png)
Zorg ervoor dat de Application Catalog website trusted is in Internet Explorer en geef de organization name die weergegeven zal worden in. Ga naar *Computer Restart.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(355).png)
We verlagen de eerste notification naar 60 minutes. Ga naar *Remote Tools*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(356).png)
Klik op *Configure...* en check alle boxes om Remote Control aan te zetten. Klik op *OK*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(357).png)
Zorg ervoor dat er toestemming gevraagd wordt om Remote Control te starten en klik op *Set Viewers...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(358).png)
Vind de gebruikers of groepen die je toegang wil geven tot Remote Control met *Browse...* en *Advanced...*. Selecteer de accounts die je wil en klik op *OK*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(361).png)
Klik op *OK* en ga naar *Software Deployment*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(362).png)
Klik op *Schedule...* en stel de frequentie van de deployments in op 2 dagen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(363).png)
Klik op *Software Updates*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(364).png)
We doen hetzelfde voor *Software Updates*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(365).png)
Klik op *OK* als alle settings ingesteld zijn.

#### Client Installatie (Push Installation)

In deze sectie zullen we Automatic Sitewide Client Push Installation configureren.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(366).png)
Ga terug naar *Site Configuration* en klik op *Sites*. Klik op *Client Installation Settings* in het menu vanboven en selecteer *Client Push Installation.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(367).png)
Enable Automatic Sitewide Client Push Installation en check *Servers* en *Workstations*. Also choose to never install on a domain controller, unless specified.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(369).png)
On the Accounts tab, create a new account.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(370).png)
Klik op *Browse...* om een account te zoeken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(371).png)
Klik op *Find Now* om alle accounts weer te geven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(372).png)
We zullen, zoals altijd, het administrator account in het domein gebruiken. Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(373).png)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(374).png)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(375).png)
Klik op *Apply* om alle instellingen toe te passen.


#### PXE, Boot Image en Software Distribution configureren.

In deze sectie zullen we de configuratie doen om een Client te deployen met PXE.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(378).png)
Onder *Sites* van daarnet, open *Servers and Site System Roles* en dan *Distribution Point.* Klik vervolgens op *Properties* in de linker bovenhoek. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(379).png)
Ga naar de *PXE* tab en vink *Enable PXE support for clients* aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(380).png)
Klik op *OK* als er een warning pop-up verschijnt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(381).png)
Vink de overige checkboxes aan en geef een wachtwoord in. We willen *geen* user device affinity maar wel op alle network interfaces antwoorden op PXE requests. Klik op *Apply* en *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(382).png)
Open de *Software Library* tab in het linker navigatiemenu en navigeer naar `Overview > Operating Systems > Boot Images`. Rechterklik op de (x64) Boot Image en klik op *Properties*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(383).png)
Vink *Enable command support* aan en klik op *Apply* om toe te passen. Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(384).png)
Klik op *Yes* als er een pop-up op komt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(385).png)
Er zal een nieuw venster openen. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(386).png)
Als de wizard beeïndigd is, klik dan op *Close*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(387).png)
Ga nu naar de *Data Sources* tab en zorg ervoor dat *Deploy this boot image from the PXE-enabled distribution point* is aangevinkt. Klik vervolgens op *Apply* en *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(388).png)
Rechterklik nogmaals op de Boot Image en Distribute de Content.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(389).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(390).png)
Voeg een Distribution Point toe door op *Add* en *Distribution Point* te klikken.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(391).png)
Selecteer het Distribution Point en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(392).png)
Klik op *Next* om verder te gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(393).png)
Ga na of alles in orde is in de samenvatting en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(394).png)
Klik op *Close* om de wizard te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(395).png)
We kunnen de status van het *Distributen* bekijken in de *Monitor* tab en navigeer naar `Overview > Distribution Status > Content Status`. Als we nu klikken op de Boot Image zien we dat de status *Success* is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(396).png)
Navigeer terug naar *Sites* onder de *Administration* tab en klik op *Configure Site Components* en vervolgends op *Software Distribution* in het menu bovenaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(397).png)
Selecteer *Specify the account that accesses network locations*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(398).png)
Voeg een *Existing Account* toe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(399).png)
Selecteer het account en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(400).png)
Klik op *Apply* en *OK* om de veranderingen toe te passen.

#### Deploying Adobe Reader

In deze sectie zullen we Adobe Reader deployen op een client. Hiervoor zullen we eerst een `.msi` moeten extracten uit een `.exe` file.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(411).png)
Om een package te deployen hebben we eerst een `.msi` bestand van de adobe installer nodig. In dit voorbeeld zullen we dit uit de 11.0.10 adobe installer halen, en daarna updaten naar de 11.0.14 update zodat we een 11.0.14 `.msi` installer hebben. Ga naar de locatie waar de installer en de update zijn in command prompt en voer het volgende commando uit: `AdbeRdr11010_en_US.exe  -nos_ne -nos_o"C:\AdobeDeployment\Adobe AIP"`. Dit zal de installer uitvoeren en het `.msi` bestand extracten in de nieuwe folder *Adobe AIP*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(412).png)
Ga in de nieuwe map en voer het commando `msiexec /a AcroRead.msi`. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(413).png)
Dit zal de msi installer uitvoeren. Geef een **nieuwe** map op waar de bestanden van de installer in zullen geplaatst worden en ga door de installatie van Adobe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(414).png)
Voer nu het commando `msiexec /a "C:\AdobeDeployment\Adobe Reader\AcroRead.msi" /p "C:\AdobeDeployment\AdbeRdrUpd11014.msp"` in. dit zal de nieuwe update installeren.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(415).png)
Kies **dezelfde** locatie als daarnet om de bestanden te installeren en ga door de installer. De adobe bestanden zijn nu klaar voor gebruik.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(410).png)
In SCCM, ga naar *Software Library* en navigeer naar `Overview > Application Management`. Rechterklik op *Packages* en maak een nieuwe package aan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(419).png)
Geef een naam op voor de package en vink *This package contains source files* aan. Klik op *Browse...* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(418).png)
Klik nogmaals op *Browse...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(417).png)
Selecteer de locatie van de Adobe Reader bestanden en klik op *Select Folder*. In dit voorbeeld hebben we de bestanden gekopieerd naar de volgende netwerklocatie.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(420).png)
Klik op *Next.* Selecteer *Standard program* en klik nogmaals op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(421).png)
Geef een naam mee in en voer als command line het volgende in: `msiexec /i "AcroRead.msi" /q`. Selecteer Program can run: *Whether or not a user is logged on* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(422).png)
Selecteer dat het programa op alle platformen kan uitgevoerd worden en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(423).png)
Lees de samenvatting om na te gaan of alles in orde is en klik in dat geval op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(424).png)
De package en het programma zijn succesvol aangemaakt. Klik op *Close* om de wizard af te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(425).png)
Onder *Packages* is nu de nieuwe Adobe Package te vinden. Rechterklik op de package en kies om de Content te Distributen. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(426).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(427).png)
Klik op *Add* en voeg een *Distribution Point* toe.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(428).png)
Selecteer het Distribution Point en klik op *OK*. Note: Als er geen Distribution Point weergegeven wordt wil het zeggen dat je vorige stappen hebt overgeslaan en terug moet gaan.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(429).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(430).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(431).png)
De Content is succesvol Distributed, klik op *close* om de wizard af te sluiten.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(432).png)
Nu kan de package Deployed worden. Rechterklik op de package en klik op *Deploy.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(433).png)
Selecteer de collection waarop je wil deployen door op *Browse...* te klikken en klik vervolgens op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(434).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(435).png)
Kies voor *Available* om safe te zijn. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(436).png)
We willen zo snel mogelijk deployen dus specifieren geen tijd. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(437).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(438).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(439).png)
Lees de samenvatting en klik op *Next* als alels in orde is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(440).png)
De deployment wizard is succesvol, klik op *Close.*

#### Deploying software updates

Het laatste wat we zullen doen is er voor zorgen dat software updates deployed kunnen worden. Hiervoor moeten we eerst een *Software update point* aanmaken.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(441).png)
Ga terug naar *Sites* onder de *Administration* tab en klik op *Add Site System Roles* uit het menu vanboven.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(442).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(443).png)
We hebben geen proxy, klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(444).png)
Selecteer het *Software update point* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(445).png)
We hebben WSUS geconfigureerd om poorten 8530 en 8531 te gebruiken voor het client verkeer. Slecteer deze en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(446).png)
Check *Use credentials* en klik op *Set...* en kies voor *Existing Account.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(447).png)
Selecteer het account en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(448).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(449).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(450).png)
We willen synchronization om de 7 uur laten gebeuren. Check ook om een Alert te sturen indien de sync failt en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(451).png)
Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(452).png)
Selecteer de soort updates die je wilt synchronizeren en klik vervolgens op *Next.* Hier kiezen we voor *Critical, Definition* en *Security Updates*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(453).png)
Selecteer de producten die je wilt synchronizeren en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(454).png)
Voor talen selecteren we *Nederlands* en *Engels*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(455).png)
Bekijk de samenvatting en klik op *Next* als alles in orde is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(456).png)
De wizard is succesvol beeïndigd, klik op *close*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(457).png)
Ga nu naar de *All Software Updates* onder de *Software Library* tab en klik op *Synchronize Software Updates* in het bovenste menu. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(458).png)
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
