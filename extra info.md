# Documentatie papa2

## Opdracht

Een member server in het domein red.local. Deze server is een Microsoft System Center Server.
Gebruik steeds de meest recente versie.
Deze server is verantwoordelijk voor het deployen van Windows 7 Enterprise en/of Windows 10
Enterprise images naar de Windows clients in VLAN 200.
Daarnaast zorgt deze server voor alle Windows en Office updates voor zowel de clients als de
servers.
Deze Server moet ook in staat zijn om een aantal basis applicaties te deployen op de client PC’s.
Volgende apllicaties moeten zeker kunnen uitgerold worden:
* Office 2013 of Office 2016
* Adobe Acrobat Reader laatste versie.
* Java Packages laatste versie.
* Adobe Flash componenten voor IE en Firefox.

##  Inleiding


Het installeren van System Center Configuration Manager is langdradig omdat er veel werk aan vooraf gaat zoals:
- Het installeren van de vele prerequisites
- De installatie van ADK for Windows 10
- De installatie van SQL Server 2017

Hierna kan pas de echte installatie en configuratie beginnen van SCCM en zijn componenten.

- De installatie en het configureren van SCCM
- De Client install config
- De PXE boot configuratie


We hebben elk component op verschillende manieren proberen installeren en automatiseren op hun beurt en zo tot deze documentatie bekomen om onze server binnen de gevraagde tijd klaar te zetten voor deployment binnen het domein red.local.

## VM Prerequisites

### PC Hernoemen
#### Handmatig
1. Ga hiervoor naar de 'File Explorer'.
2. Doe rechtermuisknop op "This PC" en kies "Properties".
3. Onder de tab "Computer Name", kies "Change Settings"
4. Kies als PC naam "PAPA2".
#### Automatisatie
Hiervoor gebruik je het script: **1_hostname.ps1**. Het systeem herstart automatisch.

### Netwerkadapter instellingen

1. Zorg ervoor dat de netwerkadapter juist gepatcht is naar de server van de Domeincontroller via een Bridged adapter.
2. Gebruik volgende handmatige instellingen voor de IPv4 configuratie:

		RED.local IP Settings:
		- IP: 172.18.0.7
		- Subnet: 255.255.255.224
		- Default Gateway: 172.18.0.1
		- DNS1: 172.18.0.34
		- DNS2: 172.18.0.35

> VLAN 300 *(Netwerk info)*

### Active Directory Joinen

#### Handmatig

1. Ga hiervoor naar de 'File Explorer'.
2. Doe rechtermuisknop op "This PC" en kies "Properties".
3. Onder de tab "Computer Name", kies "Change Settings"
4. Kies op het nieuw venster dat opent de tab 'Change'
5. Kies domein, en vul bij domein 'red.local', log in met de administrator van de domein controller.
6. De server is nu gejoind, herstart de server.


 #### Automatisatie
 Hiervoor gebruik je het script: **2_domain_join.ps1**, als dit zonder fouten lukt herstart de server zoals prompted.

Vanaf nu kan je inloggen op papa2 met:

   		Account name: RED\Administrator
		Password: Project2018


## Prerequisites Installatie

### Alfa2
Voor we beginnen met de installatie zorgen we zeker dat de Administrator account alle mogelijke rechten heeft binnen het domein & zullen we System Management container aanmaken op de domeincontroller, ALFA2.

Dit moet op de domeincontroller worden uitgevoerd alvorens je kan beginnen met de installatie van PAPA2.

Via **Tools** **Users and Computers by Users**, **Administrator** , **properties** maken we de Administrator account member van **Enterprise Administrator** als **primary group**.

Voor de System Managment Container volg je de voorziene documentatie [hier.](../Afhankelijkheden/Create_System_Manager_Container.md)


### IIS

Nadat we de container ingesteld hebben kunnen we de serverrole Web Server(IIS) installeren met features:
#### Handmatig

* .Net Framework 3.5 Features[alles]
* .Net Framework 4.5 Features[alles]
* BITS
* Remote Differential Compression.
**Onder Web Server Role (IIS) gaan we ook Role Services installeren, namelijk:**
* Common HTPP Features
* Application Development
  * ASP.NET 3.5
  * .NET Extensibility 3.5
  * ASP.NET 4.5
  * .NET Extensibility 4.5
  * ISAPI extensions
  * Security-Windows Authentication
* IIS 6 Management Compatibility
  * IIS Management Console
  * IIS 6 Metabase Compatibility
  * IIS6 WMI Compatibility
  * IIS Management Scripts and Tools.

#### Automatisatie
Hiervoor gebruik je het script: **3_Pre.ps1**, zorg er zeker voor dat je Windows Server 2016 iso gemount is als D:\ drive

Naar onze bevindingen was het installeren van al deze roles/features sneller via de gui dan gebruik te maken van het script.

### SQL Server 2017

Het volgende wat we gaan installeren is SQL Server 2017, we gaan deze ook lokaal installeren op onze server omdat het minder overhead heeft op die manier.
#### Handmatig

1. Onder de **en_sql_server_2017_enterprise_x64_dvd_11293666.iso**, rechterklik je op **setup.exe** en kies om te uitvoeren als administrator.
2. Je begint bij **Installation** en daaronder neem je **New SQL Server stand-alone installation or add features to an existing installation**.
3. Specifieer een **free** edition met als keuze **Developer** en '**Next**'.
4. Accepteer de license terms en  '**Next**'.
5. Hij zal dan bij **Install rules** een warning geven bij de **Windows Firewall**, maar dit is van geen erg.
6. In de **Feature Selection** kies je voor: **1. Database Engine Services, 2. Analysis Services en 3. Integration Services** en dan op '**Next**'.
7. Laat de Instance ID staan op **MSSQLSERVER** en  '**Next**'.
8. Bij Server Configuration laat je bij Service Accounts alles zoals het staat en kijk je onder Collation of de SQLCollation gelijk is aan **SQL_Latin1_General_CP1_CI_AS** en klik dan op '**Next**'.
9. Bij de **Database Engine Configuration** kies je onder *Server Configuration* voor Mixed Mode en kies een wachtwoord en voer deze twee keer in. Nadat je dit gedaan hebt, druk je ook nog op **Add Current User** en dan op  '**Next**'.
10. Onder **Analysis Services Configuration** kies je onder *Server Configuration* voor Tabular Mode en druk je weer op **Add Current User** en dan op '**Next**'.
11. **Install**
Na de installatie zou je dit moeten te zien krijgen:
![Complete SQL](../Documentatie/Pictures/SQL%20Completed.PNG)


#### Automatisatie
Hiervoor gebruik je **één deel van** script: **4_SQL.ps1**, kijk hier goed welke user je nodig hebt en controleer altijd zorgvuldig je paden en namen.

Hier hebben we altijd gebruik gemaakt van het script want het is gewoon sneller, ook hebben we altijd SQL geïnstalleerd op de Domain Administrator account.

### ADK 10
Het volgende dat we gaan doen is de recentste versie van Windows Assessment and Deployment Kit (ADK 10) installeren.
Via dit kunnen we verschillende Windows operating systems deployen naar nieuwe computers.
#### Handmatig
Dit gaan we doen door de .exe file te downloaden en uitvoeren als Administrator en
installeer het onder C:\Program Files(x86)\Windows Kits\10\. Er zijn 3 features die je wilt installeren, namelijk:
* Deployment Tools
* Windows Preinstallation Environment (Windows PE)
* User State Migration Tool (USMT).

#### Automatisatie

Hiervoor gebruik je het script: **5_ADK.ps1** nadat je de Installers folder en adksetup.exe onder `C:\Users\Administrator\Documents` hebt gezet.
Kan je via CMD naar daar navigeren: `cd C:\Users\Administrator\Documents`
En dan de laatste regel van het script naar de CMD kopiëren en runnen.

**LET OP:** Als je geen internet hebt, kan je lokaal met de Installers folder dit installeren door te zeggen waar deze folder zit. Deze optie krijg je alleen als je niet met het internet verbonden bent.

### WSUS

Nadat SQL Server volledig geïnstalleerd is gaan we WSUS installeren.
WSUS is Windows Server Update Services, dit zorgt ervoor dat wij als configuratieserver updates en hotfixes kunnen sturen naar onze computers die we deployen.
#### Handmatig
Dit doen we door de Server role "Windows Server Update Services" te installeren met als Role Services:
* WSUS Services
* SQL Server Connectivity

Je moet ook aanduiden dat je de updates in een bepaald mapje stored.
Daarna moet je een Database selecteren waar je de WSUS database wil storen,
dit heeft dan te maken met je SQL Server die je hiervoor geïnstalleerd hebt.
Niet klikken op Post-installation tools! Dit kunnen we ook allemaal exporteren zodat dit volledig automatisch gebeurd.

#### Automatisatie
Hiervoor gebruik je het script: **6_WSUS.ps1** .

## Installeren System Center Configuration Manager
Na de vele prerequisites kunnen we eindelijk beginnen aan de installatie van SCCM.

### SCCM
Je hebt de .iso-file nodig om deze uit te voeren.
Deze kan je vinden op [https://e5.onthehub.com](https://e5.onthehub.com).
#### Handmatig
- Je wilt kiezen voor een primary site Configuration Manager.
- Na een paar keer je voorwaarden moet accepteren moet je kiezen welke prerequisites je wil downloaden.
- Je moet kiezen om eerder gedownloade files te installeren.
- Volg de verdere stappen verder en kies voor de Configuration Manager console te installeren.
- Na dat je dit gekozen hebt, kies je om de primary site als stand-alone site te installeren.
- Als men vraagt om de Site System Roles, duidt je management pint en distribution point allebei aan.
- Hierna worden je prerequisites gecheckd en wordt SCCM geïnstalleerd.

	**LET OP**

	Bij een fout over TCP, controleer in  SQL Server Configuration Manager in SQL Server Network Configuration en voor alle protocollen enable je TCP/IP protocol.

	**Hotfixes**

	Na deze installatie wil je nog de Hotfixes installeren. Dit zijn updates voor de Configuration Manager controller.
De link voor de download is: [klik](https://support.microsoft.com/en-us/help/2905002/an-update-is-available-for-the-operating-system-deployment-feature-of).
Volg de stappen van de installatie.

#### Automatisatie
Hiervoor gebruik je het script: **7_SCCM.ps1**, deze installatie zal voltooien zonder enige gui interactie, merk op deze installatie kan makkelijk meer als een uur duren.



### Discovery en Boundaries
Start de Configuration Manager console en zorg ervoor dat de discovery en boundaries ingesteld worden.
Voor de discvery kies je links onder
Administration => Hierarchy Configuration => Discovery Methods.

Op het rechterpaneel dubbelklik je op "Active Directory Forest Discovery". Duidt alle boxen hier aan!
Volgende is " Active Directory Group Discovery" en duidt hier "Enable Active Directory Group Discovery" aan.
Voeg ook een Active Directory Location toe en gebruik het domein je gebruikt hebt, op "Yes" en erna op het sterretje om het toe te voegen.

Het volgende is de Boundary Groups instellen, selecteer "Boundary Groups", rechterklik en creeër een boundary group,
klik op "Add". Normaal gezien moet onze Default-First-Site-Name hier staan om toe te voegen. Gebruik ook deze boundary group voor de site assignment.

### Installeren Site System Roles

We installeren dit om de management functionaliteit uit te breiden voor de site.

Begin op het startscherm van Configuration Manager console en klik bovenaan op "Add Site System Roles".
Laat de eerste pagina op default en klik op "Next", zelfde voor de volgende window.
Bij de System Role Selection kies je voor Application Catalog Web Service Point, Application Catalog Website Point en Fallback status point.
Voor de Fallback Status Point en Application Catalog Website point laat je alles default,
voor de Application Catalog Web Service Point geef je de organization name en kleur van het thema voor de website.
Na dit wordt alles geïnstalleerd.
Je kan dit verifiëren door te kijken in de logs van de Application catalog website point.


### Configureren Client Settings

In de Configuration Manager console klik je op "Administration"
dan rechterklik op "Client Settings" en klik "Create Custom Client Device Settings". Selecteer:
* Client Policy
* Compliance Settings
* Computer Agent
* Computer Restart
* Remote Tools en Software Deployment.

Bij het volgende window zet je de Polling to interval op 5 minuten.
Bij de Compliance Settings zet je de "Enable compliance evaluation on clients" op "Yes".
Bij "Computer Agent" klik je op "Default Application Catalog Website point"=> Set Website en kies Intranet FQDN.
Zet de "Add Default Application catalog website to IE trusted site zones" op "Yes".
Bij "Computer Restart" zet je de notification op 60 minutes.
Volgende window configureerje de "Remote Control on Client Computers" op "Domain, Private and Public".
Ook zet je de prompt aan voor Remote Control toelating.
Voor de Software Deployment zet je dit in op om de 2 dagen.
Voor de volgende zaken ga je gewoon verder.

## Client Installatie

Klik op "Administration=>Site Configuration=>Sites=>Client Initialize Settings=>Client Push Installation".
Onder General vink je Enable automatic site-wide client push installation en duidt je aan om nooit de Configuration Manager client te installeren op domeincontrollers,
de rest laat je zo, bij Accounts kies je voor je lokale administrator.
Na je dit gedaan hebt kan je zien dat de Configuration Manager client geïnstalleerd is op 2 machines + de Client Activity is Active.

## Boot images en Distribution Point Configuration
**Hoe kan je nu operating systels gaan deployen?**
Via PXE initiated deployment, Multicast deployment, Bootable Media Deployment, Stand-alone Deployment of Prestaged Media deployment.

### PXE initiated deployment

Bij de properties van SCCM kies je in het tabblad 'PXE' voor 'Enable PXE support for clients'.
Vink alles aan en kies een wachtwoord. Kies voor 'Do not use user device affinity' en
'Respond to PXE requests on all network interfaces' en klik 'OK'.

### Boot images
Om dit in te schakelen, ga je in de CM Console =>'Software Library', vergroot 'Operating System' en klik 'Boot images'.
Rechterklik op Boot Image (x64) en dan op 'Properties'.
Ga in het Customization Tabblad en vink de box Enable Command Support(testing only) aan.
Dan op 'Apply' en kijk dan onder het tabblad 'Data Source'
kijk of 'Deploy this boot image from the PXE-enabled DP is enabled,
als dit niet zo is inschakelen en 'Apply' en 'OK'. Doe dezelfde configuratie voor de Boot Image (x86).
Nadat je dit gedaan hebt moet je dit distributen naar de DP,
als je dit al eerder eens gedaan hebt rechterklik je op 'Boot Image(x64 of x86)'
en kies je 'Update Distribution Points', anders kies je 'Distribute Content'.
Bij 'Content Status' onder 'Distribution Status' onder Monitoring zie je ook of dit gelukt is.

**Zie verdere configuratie in System Center 2012 R2 Manual.pdf**



# Oplevering informatie

## Stappenplan

### Hostname

Voer deze commando's uit op de PAPA2 Server in Powershell ISE(ADMIN):
``
$hostname = "PAPA2"
Rename-Computer -ComputerName $env:COMPUTERNAME  -newName $hostname -Force -Restart
``

### Prereqs server roles

Zorg ervoor dat je een adapter op NAT hebt staan, want je hebt internet nodig voor deze roles.
Het optische station dat je moet toevoegen is die van Windows Server zelf.
We gaan dit via de GUI installeren omdat dit sneller verloopt dan het script:

1. Open Server Manager
2. Add Roles and Features
3. Kies voor 'Web Server(IIS)' onder Server roles
4. Bij Features kies je **Alles van .NET Framework 3.5 Features**, **Alles van .NET Framework 4.5 Features**, **Background Intelligent Transfer Service(BITS)** en **Remote Differential Compression**
5. Bij Role Services duidt je aan: **Common HTTP Features- Default Document, Static Content**, **Application Development- ASP.NET 3.5, ASP.NET4.5, .NET Extensibility 4.5 en ISAPI extensions**, **Security- Windows Authentication**, **IIS 6 Management Compatibility – IIS Management Console, IIS 6 Metabase Compatibility, IIS 6 WMI Compatibility, IIS Management Scripts and Tools.**
6. Kies voor een alternatief pad te specifiëren en kies voor **D:\source\sxs**
6. Installeer de Roles

### ADK 10

Zorg ervoor dat je de NAT-adapter hebt uitgeschakelt want we gaan dit offline installeren.

1. Kopieer de adksetup.exe van E:\ADK\adksetup.exe naar C:\Users\Administrator\Documents
2. Voer het volgende commando uit in CMD(ADMIN):
``
adksetup.exe /installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools OptionId.UserStateMigrationTool OptionId.WindowsPreinstallationEnvironment /ceip off /norestart
``
3. Je krijgt nu de setup te zien, druk op **Next** en **Accept**. Als je op **Install** drukt, komt er een nieuw window tevoorschijn die je vraagt waar je de files wilt van ga halen.
4. Kies voor **Content Locally** en verwijs naar E:\ADK\Installers\Toolkit_Documentation want hij vraagt naar deze .msi.
5. De ADK wordt nu lokaal geïnstalleerd en duurt zo een 9-10 minuten.

### Join Domain

1. Zorg dat je adapter op bridged network staat en de ip-instellingen van deze adapter hetzelfde zijn als het IP-schema van het netwerk. Kijk ook zeker na dat je in de switch zit voor VLAN 300.

2. Voer het volgende commando uit in Powershell ISE(ADMIN:
``
#join the domain and be superuser
$domain = "red.local"
$password = "Project2018" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
``

3. Je bent het domein gejoind en herstart de server hierna.

### SQL

1. Zorg dat je inlogt als **RED\Administrator** en wachtwoord **Project2018**.
2. Het optische station dat je moet toevoegen is die van **en_sql_server_2017_developer_x64_dvd_11296168**.
3. Ga naar Powershell ISE(ADMIN) en voer volgende commando uit:
``
D:\SQL\Setup.exe /qs /ACTION=Install /FEATURES=SQL,RS,Tools /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="red.local\Administrator" /SQLSVCPASSWORD="Project2018" /SQLSYSADMINACCOUNTS="red.local\Domain Admins" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" /IACCEPTSQLSERVERLICENSETERMS /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS
``
4. SQL wordt geïnstalleerd in een 7-tal minuten.

### WSUS

1.Terwijl SQL aan het installeren is kan je de commando's voor in Powershell ISE(ADMIN) al klaarzetten:
``
Install-WindowsFeature -Name UpdateServices-Services,UpdateServices-DB -IncludeManagementTools
``
2. WSUS wordt geïnstalleerd en dit duurt zo een 2-3 minuten.

### SCCM

1. Steek het optische station van mu_system_center_configuration_manager_endpoint_protection_version_1606_x86_x64_dvd_9384954(1).iso in.
2. Zorg ervoor dat de configuratie van ADSI Edit is uitgevoerd op ALFA2, hoe dit moet staat onder Afhankelijkheden/Create System Management Container.md in Github.
3. Kijk zeker nog eens of alle services in SQL Configuration Manager draaien en of alle poorten enabled zijn. Zoniet daarna ook herstarten van de services opnieuw.
3. Voer in Powershell ISE(ADMIN) dit commando uit:
``
D:\SCCM\SMSSETUP\BIN\X64\setup.exe /script E:\Scripts\config.ini
``
4. De installatie is gestart, je ziet hier alleen vooruitgang door in de logs te kijken onder C:\.
5. De installatie is voltooid als dit in de ConfigMgrSetup.txt erop komt.
6. Herstart de server.

### SCCM Configuratie

#### Discovery en Boundaries
Start de Configuration Manager console en zorg ervoor dat de discovery en boundaries ingesteld worden.
Voor de discvery kies je links onder
Administration => Hierarchy Configuration => Discovery Methods.

Op het rechterpaneel dubbelklik je op "Active Directory Forest Discovery". Duidt alle boxen hier aan!
Volgende is " Active Directory Group Discovery" en duidt hier "Enable Active Directory Group Discovery" aan.
Voeg ook een Active Directory Location toe en gebruik het domein je gebruikt hebt, op "Yes" en erna op het sterretje om het toe te voegen.

Het volgende is de Boundary Groups instellen, selecteer "Boundary Groups", rechterklik en creeër een boundary group,
klik op "Add". Normaal gezien moet onze Default-First-Site-Name hier staan om toe te voegen. Gebruik ook deze boundary group voor de site assignment.

#### Installeren Site System Roles

We installeren dit om de management functionaliteit uit te breiden voor de site.

Begin op het startscherm van Configuration Manager console en klik bovenaan op "Add Site System Roles".
Laat de eerste pagina op default en klik op "Next", zelfde voor de volgende window.
Bij de System Role Selection kies je voor Application Catalog Web Service Point, Application Catalog Website Point en Fallback status point.
Voor de Fallback Status Point en Application Catalog Website point laat je alles default,
voor de Application Catalog Web Service Point geef je de organization name en kleur van het thema voor de website.
Na dit wordt alles geïnstalleerd.
Je kan dit verifiëren door te kijken in de logs van de Application catalog website point.

### Configureren Client Settings

In de Configuration Manager console klik je op "Administration"
dan rechterklik op "Client Settings" en klik "Create Custom Client Device Settings". Selecteer:
* Client Policy
* Compliance Settings
* Computer Agent
* Computer Restart
* Remote Tools en Software Deployment.

Bij het volgende window zet je de Polling to interval op 5 minuten.
Bij de Compliance Settings zet je de "Enable compliance evaluation on clients" op "Yes".
Bij "Computer Agent" klik je op "Default Application Catalog Website point"=> Set Website en kies Intranet FQDN.
Zet de "Add Default Application catalog website to IE trusted site zones" op "Yes".
Bij "Computer Restart" zet je de notification op 60 minutes.
Volgende window configureerje de "Remote Control on Client Computers" op "Domain, Private and Public".
Ook zet je de prompt aan voor Remote Control toelating.
Voor de Software Deployment zet je dit in op om de 2 dagen.
Voor de volgende zaken ga je gewoon verder.

## Client Installatie

Klik op "Administration=>Site Configuration=>Sites=>Client Initialize Settings=>Client Push Installation".
Onder General vink je Enable automatic site-wide client push installation en duidt je aan om nooit de Configuration Manager client te installeren op domeincontrollers,
de rest laat je zo, bij Accounts kies je voor je lokale administrator.
Na je dit gedaan hebt kan je zien dat de Configuration Manager client geïnstalleerd is op 2 machines + de Client Activity is Active.

### Boot images

Je kopieert C:/Program Files(x86)/Windows Kits/10/Assessment and Deployment Kit/Windows Preinstallation Environment/64/en-us/wim-file naar de server share.
Er staan nog geen boot images als je nu kijkt in de CM Console =>'Software Library', vergroot 'Operating System' en klik 'Boot images'. Je drukt op **Create Boot Image** en kies de wim-file via de server share.
Je kopieert C:/Program Files(x86)/Windows Kits/10/Assessment and Deployment Kit/Windows Preinstallation Environment/64/en-us/wim-file naar de server share.

Rechterklik op Boot Image (x64) en dan op 'Properties'.
Ga in het Customization Tabblad en vink de box Enable Command Support(testing only) aan.
Dan op 'Apply' en kijk dan onder het tabblad 'Data Source'
kijk of 'Deploy this boot image from the PXE-enabled DP is enabled,
als dit niet zo is inschakelen en 'Apply' en 'OK'. Doe dezelfde configuratie voor de Boot Image (x86).
Nadat je dit gedaan hebt moet je dit distributen naar de DP,
als je dit al eerder eens gedaan hebt rechterklik je op 'Boot Image(x64 of x86)'
en kies je 'Update Distribution Points', anders kies je 'Distribute Content'.
Bij 'Content Status' onder 'Distribution Status' onder Monitoring zie je ook of dit gelukt is.

Ga nu naar Administrator => Site configuration => Sites => Configure Site Components => Software distribution. Ga in het tabblad **Network Access Account** en specify the account. Kies een bestaande user en kies dezelfde als je bij Client installatie hebt gedaan.
