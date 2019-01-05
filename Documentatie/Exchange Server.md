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
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(4).png?raw=true)
Voer de setup uit, lees de gebruiksvoorwaarden en check *I have read and accept the license terms.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(5).png?raw=true)
Wacht tot de installatie compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(6).png?raw=true)
Als er een pop-up op komt voor het sluiten van een programma om de installatie uit te voeren klik je op *Yes*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(7).png?raw=true)
De installatie van **Microsoft .NET Framework 4.7.2** is compleet.

Daarna moet **Microsoft Visual C++ 2012** geïnstalleerd worden:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(8).png?raw=true)
Voer de setup uit, lees de gebruiksvoorwaarden en check *I agree to the license terms and conditions.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(9).png?raw=true)
De installatie van **Microsoft Visual C++ 2012** is compleet.

Nu installeren we UCMA 4.0 of **Microsoft Unified Communications Managed API 4.0**:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(10).png?raw=true)
Voer de setup uit. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(11).png?raw=true)
Klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(12).png?raw=true)
Lees de gebruiksvoorwaarden en check *I have read and accept the license terms.* Klik op *Install*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(13).png?raw=true)
Wacht tot de installer klaar is. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(14).png?raw=true)
Klik op *Finish*. De installatie van **Microsoft Unified Communications Managed API 4.0** is compleet.


![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(20).png?raw=true)
Open powershell en installeer **RSAT-ADDS** met het commando: `Install-WindowsFeature RSAT-ADDS` 


![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(21).png?raw=true)
Download `prerequisits_exchange.ps1` en voer het uit op de Server.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(22).png?raw=true)
Klik op *Open*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(23).png?raw=true)
Voer *A* in om de execution policy te veranderen zodat het script kan uitgevoerd worden.

#### Installing Exchange 2016

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(59).png?raw=true)
Download de laatste **Cumulative Update for Exchange Server 2016** van de website van microsoft. Hier hebben we CU8 gebruikt.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(60).png?raw=true)
Dubbel klik op het iso bestand om het te mounten. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(61).png?raw=true)
Voer *Setup.exe* uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(63).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(64).png?raw=true)
Check *Connect to the Internet and check for updates* om de laatste updates te downloaden of check voor updates later. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(65).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(66).png?raw=true)
Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(67).png?raw=true)
Lees en accepteer daarna de license agreement mat de radio button. Klik op *next*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(68).png?raw=true)
Selecteer *Don't use recommended settings* en klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(69).png?raw=true)
Selecteer de *Mailbox role* en de optie om automatisch andere benodigdheden te installeren (die we misschien vergeten zijn). Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(70).png?raw=true)
Kies de locatie waar Exchange geïnstalleerd zal worden. Klik op *next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(71).png?raw=true)
Geef de naam mee van de organisatie, wij nemen *keanys* voor dit voorbeeld. Klik op *next*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(72).png?raw=true)
Kies ervoor om Malware Scanning **niet** uit te zetten. Klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(73).png?raw=true)
Wacht tot de Readiness Checks klaar zijn. Klik [hier](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Exchange%20Troubleshooting.md) als je een error krijgt en de stappen te zien die ik ondernomen heb om degene die ik tegen gekomen ben op te lossen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(89).png?raw=true)
Klik op *install* als er geen errors zijn. De twee warnings die we krijgen zijn niet belangrijk in dit geval. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(92).png?raw=true)
Wacht tot de setup compleet is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(93).png?raw=true)
De installatie van **Exchange Server 2016** is klaar. Klik op *Finish*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(95).png?raw=true)
Als het *Exchange-beheercentrum* weergegeven wordt in de browser wil dit zeggen dat Exchange 2016 correct is opgestart.

### Configuratie Microsoft Exchange 2016

In deze sectie gaan we over de essentiële stappen om exchange te configureren en klaar te maken voor gebruik op het internet.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(95).png?raw=true)
Log in als administrator van het domein.

#### Een gebruikerspostvak toevoegen
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(97).png?raw=true)
Eens ingelogd worden we begroet met bovenstaand scherm. Hierin zal alle belangrijke configuratie gebeuren. Het eerste wat we gaan doen is een gebruikerspostvak toevoegen. Klik in de linker navigatielijst op *geadresseerden* en dan op *postvakken* vanboven. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(98).png?raw=true)
Klik op het *plus-icoontje* en vervolgens op *Gebruikerspostvak*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(99).png?raw=true)
Selecteer een bestaande gebruiker in AD waarvoor je een postvak wil aanmaken of klik op *Nieuwe gebruiker* om een nieuwe gebruiker aan te maken. In dit voorbeeld gaan we een nieuwe gebruiker aanmaken, dit zal de gebruiker ook automatisch toevoegen in AD. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(100).png?raw=true)
Klik op *Bladeren...* en selecteer de *Users* OU uit je domein. Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(102).png?raw=true)
Vul de nodige velden in en kies een aanmeldingsnaam en wachtwoord waarmee de gebruiker nadien kan inloggen in zijn postvak. Klik op *Opslaan*. 

De gebruiker is nu toegevoegd, herhaal deze stappen tot alle gebruikers die een gebruikerspostvak nodig hebben toegevoegd zijn.

#### Interne en Externe URL's configureren (Virtuele mappen)
De virtuele mappen definiëren hoe de URL's voor de verschillende mailtoepassingen eruit zullen zien voor zoweel intern en extern gebruik. 

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(113).png?raw=true)
Klik op *servers* in het linker menu en vervolgens op *Virtuele mappen*. Dubbelklik op *owa (Default Web Site)*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(114).png?raw=true)
Pas het veld voor de Interne en Externe URL aan. In dit geval willen we dat voor intern en extern telkens dezelfde URL gebruikt wordt. We zetten beide op `https://mail.keanys.gent/owa`. Klik op *Opslaan*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(115).png?raw=true)
Als dit de eerste virtuele map is waarvan de URL aangepast wordt (tussen owa en ecp), zal er een waarschuwing weergegeven worden dat dezelfde aanpassing bij ECP ook moet worden toegepast. Dit zullen we dus ook doen. Klik op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(116).png?raw=true)
Dubbelklik op ecp en verander de URL's naar wens: `https://mail.keanys.gent/ecp`. Klik op *Opslaan* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(117).png?raw=true)
Dubbelklik op Microsoft-Server-ActiveSync en verander de URL's naar wens: `https://mail.keanys.gent/Microsoft-Server-ActiveSync`. Klik op *Opslaan* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(118).png?raw=true)
Dubbelklik op OAB en verander de URL's naar wens: `https://mail.keanys.gent/OAB`. Klik op *Opslaan* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(119).png?raw=true)
Dubbelklik op EWS en verander de URL's naar wens: `https://mail.keanys.gent/EWS/Exchange.asmx`. Klik op *Opslaan* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(120).png?raw=true)
Om de URL's voor Outlook Anywhere in te stellen klik je op servers vanboven en dubbelklik daarna op de naam van de server.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(121).png?raw=true)
Verander de URL's naar wens: `mail.keanys.gent`. Klik op *Opslaan*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(122).png?raw=true)
Klik op *OK* als er een waarschuwing opkomt over Exchange Server 2013. Dit is voor ons niet belangrijk.

#### SSL and URL Redirection
Het zou gemakkelijk zijn als een gebruiker niet elke keer `https://mail.keanys.gent/owa` hoefde in te tikken elke keer hij zijn gebruikerspostvak wil openen. Gelukkig is er een manier om dit gemakkelijker te maken. Met URL Redirection kan ervoor gezorgd worden dat er automatisch https gebruikt wordt en de gebruiker doorgestuurd wordt naar de juiste subdirectory wanneer hij slechts `mail.keanys.gent` intikt. 

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(123).png?raw=true)
In de server manager, klik op *Tools* en vervolgens op *Internet Information Services (IIS) Manager*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(124).png?raw=true)
In het linker navigatiepaneel, klik op je domein, dan op Sites en op Default Web Site. Dubbelklik *SSL Settigns*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(125).png?raw=true)
Uncheck *Require SSL* en klik op *Apply* om de veranderingen toe te passen. (Of klik op een andere map en op Yes om op te slaan.) 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(126).png?raw=true)
Doe hetzelfde voor *Exchange Back End*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(127).png?raw=true)
Uncheck *Require SSL* en klik op *Apply*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(128).png?raw=true)
Terug bij *Default Web Site*, klik op *HTTP Redirect*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(129).png?raw=true)
Check *Redirect requests to this destination:* en *Only redirect requests to content in this directory (not subdirectories)*. Vul het owa adres in: `https://mail.keanys.gent/owa` en klik op *Apply*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(130).png?raw=true)
Doe hetzelfde voor *Exchange Back End*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(131).png?raw=true)
Check *Redirect requests to this destination:* en *Only redirect requests to content in this directory (not subdirectories)*. Vul het owa adres in: `https://mail.keanys.gent/owa` en klik op *Apply*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(132).png?raw=true)
Uncheck *Redirect requests to this destination:* in *HTTP Redirect* voor alle subdirectories van *Default Web Site*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(133).png?raw=true)
Doe hetzelfde voor *Exchange Back End*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(134).png?raw=true)
Ecp is langs waar alle configuratie door de administrators gedaan wordt. Dit willen we **NIET** via http doen maar hiervoor willen absoluut https gebruiken voor de veiligheid van de server. Check *Require SSL* in de *SSL Settings* van *ecp*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(135).png?raw=true)
Doe hetzelfde voor *Exchange Back End*.

#### E-mailstroom
Er moeten nog een paar kleine veranderingen gebeuren om de Exchange Server te kunnen gebruiken om e-mails te kunnen ontvangen en versturen buiten ons eigen domein. In deze sectie zullen we over de stappen gaan die daarvoor moeten gebeuren.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(143).png?raw=true)
Klik op *e-mailstroom* uit het linker menu en vervolgens op *connectors ontvangen* vanboven. Dubbelklik op *Client Frontend ...* en daarna op *beveiliging*. Check *Anonieme gebruikers* zodat je van iedereen mails kan ontvangen. Klik op *Opslaan*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(144).png?raw=true)
Klik op *Connectors verzenden* en op het *plus-icoontje* om een nieuwe connector toe te voegen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(145).png?raw=true)
Geef een naam op voor de nieuwe Connectors en selecteer *internet*. Klik op *Volgende*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(146).png?raw=true)
Selecteer *MX-record gelinket aan het domein van de ontvanger* en klik op *Volgende*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(147).png?raw=true)
Klik op het *plus-icoontje* om een adresruimte toe te voegen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(148).png?raw=true)
Voer als type *SMTP* in en als FQDN '\*'. Klik op *Opslaan*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(149).png?raw=true)
Klik op *Volgende*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(150).png?raw=true)
Klik op het *plus-icoontje* om een bronserver toe te voegen. Selecteer de server en klik op *toevoegen ->* en op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(151).png?raw=true)
Klik op *Voltooien*.

### User testing van de mail server
Om te testen of de mail server geconfigureerd is zoals we willen zullen we inloggen in het gebruikerspostvak dat we hierboven aangemaakt hebben.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(136).png?raw=true)
In de browser gaan we naar `mail.keanys.gent/` om te testen of we doorgestuurd worden naar de juiste locatie.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(137).png?raw=true)
We worden doorgestuurd naar `https` en komen direct in de `/owa` directory uit. We krijgen wel een waarschuwing over een onveilig SSL Certificate en een rode zoekbalk omdat we geen geldig en signed Certificate hebben. Dit kunnen we negeren voor deze opdracht.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(138).png?raw=true)
Nu gaan we proberen inloggen in het gebruikerspostvak van de nieuwe gebruiker die we aangemaakt hebben. Gebruik als gebruikersnaam `alias@domain.name` en klik op *aanmelden*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(139).png?raw=true)
Als de authenticatie gelukt is zullen we gevraagd worden een taal en een tijdszone te selecteren. Klik op *Opslaan*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(140).png?raw=true)
We zijn succesvol ingelogd in het gebruikerspostvak. Om mails te kunnen ontvangen moeten er wel nog een paar records aan de DNS server toegevoegd worden. 


### DNS Configuratie voor de mail server.
E-mails naar ons domein komen toe bij de Domain Controler (DC1). De DNS server (ook DC1) moet daarom weten wie de mail server is in het domein. In deze sectie bespreken we de CNAME, MX en PTR records.

#### CNAME record
Een CNAME record dient om een alias in te stellen voor een A record. Zo kunnen we mail.keanys.gent als alias nemen voor SERVERSQLEX.keanys.gent.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(103).png?raw=true)
Open de DNS Manager op de DNS server. Navigeer naar `SERVER > Forward Loopup Zones > Domain`. Rechterklik op de domein naam *,hier keanys.gent,* en klik op *New Alias (CNAME)...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(104).png?raw=true)
Voer *mail* in als Alias en klik op *Browse...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(105).png?raw=true)
Selecteer de mail server in het domein en klik op *OK*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(106).png?raw=true)
Klik op *OK* om het record toe te voegen.

#### MX record
Een MX record geeft aan welke server in een domein verantwoordelijk is voor het ontvangen en versturen van e-mails. Dit is belangrijk voor het ontvangen van mails zodat er een MX lookup kan gedaan worden. 

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(107).png?raw=true)
Rechterklik op de domein naam *,hier keanys.gent,* en klik op *New Mail Exchanger (MX)...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(108).png?raw=true)
Klik op *Browse...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(109).png?raw=true)
Selecteer de mail server in her domein en klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(111).png?raw=true)
Klik op *OK*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(112).png?raw=true)

#### PTR record
Een PTR record is voor reverse lookups.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(152).png?raw=true)
Rechterklik op *Reverse Lookup Zones* en klik op *New Zone...*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(153).png?raw=true)
Klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(154).png?raw=true)
Selecteer *Primary zone* en klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(155).png?raw=true)
Selecteer *To all DNS servers running on domain controller in this domain: keanys.gent* en klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(156).png?raw=true)
Selecteer *IPv4 Reverse Lookup Zone* en klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(157).png?raw=true)
Voer get Network ID `192.168.1` in en klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(158).png?raw=true)
Selecteer *Allow only secure dynamic updates (recommended for Active Directory)* en klik op *Next >*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(159).png?raw=true)
Klik op *Finish*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(160).png?raw=true)
De DNS-table zal nu automatisch updaten. Dit kan een tijdje duren of een restart kan nodig zijn. Er kan ook manueel een record toe gevoegd worden. Er kan nu een reverse lookup gedaan worden. 

## Extra
Admin Password: K3anu

Keanu Nys Mail Password: K3anuK3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
- Cursus Exchange 2013
- www.mustbegeek.com
