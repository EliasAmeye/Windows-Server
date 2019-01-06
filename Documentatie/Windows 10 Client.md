# Documentatie Windows 10 Client

## Instalatie

### VirtualBox Configuratie
- Ga door de standaard configuratiestappen zoals beschreven in de [documentatie over VirtualBox](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Virtualbox%20%26%20Windows%20Installatie.md)

Note: De client is geen server en om hem op te starten moeten we een Windows 10.iso gebruiken inplaats van een Windows Server 2016 iso. We gebruiken *Windows 10 Education Edition* omdat je met deze een domain kan joinen.

## Configuratie

### Computer configuratie

1) Hernoem de computer en join het domein.
  * Ga naar de *Control Panel\System and Security\System* en klik op *Change Settings* naast de huidige computernaam. 
  * Verander de naam van de computer naar *Client1* en join ondertussen het *keanys.gent* domein.
  * Geef een gebruikersnaam en wachtwoord op van een gebruiker waarmee je het domein wil joinen.
  * De computer moet nu herstart worden om de veranderingen toe te passen.
  
2) TCP/IP instellingen
  * De computer zal automatisch een IP adres krijgen via DHCP aangezien we bij de virtualbox configuratie een host-only adapter hebben toegevoegd in het 192.168.1.0/24 netwerk.
  
### User Testing

# Testing the DHCP and DNS Server

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(493).png?raw=true)
In het linkse venster kunnen we een paar interessante zaken zien:
 * **DHCP** is ingeschakeld.
  * De DHCP server is `192.168.1.1`
  * Het IPv4 adres dat we gekregen hebben van de DHCP server is `192.168.1.21`. Note: [We hebben de range op de DHCP server ingesteld op](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Domain%20Controler%201.md) `192.168.1.20 - 192.168.1.200`. De reden waarom ik `.21` en niet `.20` is omdat dit de tweede poging was om een client te maken en de lease van `.20` was nog niet afgelopen. (Lease Duration = 8 dagen)
 * De **DNS** server is `192.168.1.1`.
 * We hebben het **domein** *keanys.gent* gejoined.

Uit de informatie op het rechtse venster kunnen we ook een paar zaken vaststellen:
 * **DNS resolutie intern** werkt: We kunnen pingen naar *ServerDC1* en we krijgen antwoord van het juiste IP adres.
 * **DNS resolutie extern** werkt: We kunnen pingen naar *facebook.com* en krijgen antwoord van hun IP adres.
 * Er is connectie met **internet**: We kunnen facebook en Chamilo pingen en krijgen antwoord.


#### Testing the SQL Server
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Client/Screenshot%20(486).png?raw=true)
Installeer *Microsoft SQL Server Studio*. Over deze installatie zijn we al gegaan in de documentatie van de [SQL Server](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/SQL%20Server.md).
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(488).png?raw=true)
Open SSMS en connecteer met de SQL Server door de server naam in te geven en op *Connect* te klikken. De SQL server is: `ServerSQLEX.keanys.gent`.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Client/Screenshot%20(489).png?raw=true)
We zijn succesvol verbonden met de SQL Server!

# Testing the mail server

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Client/Screenshot%20(487).png?raw=true)
Open de Mail app van Microsoft die standaard geïnstalleerd is op Windows 10. Selecteer dat je wil verbinden met een Exchange server en geef de gegevens van de gebruiker in. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Client/Screenshot%20(491).png?raw=true)
Het is mogelijk dat nog een paar extra instellingen gevraagd worden voor ingelogd kan worden, zoals het adres van de server, het domein de gebruikersnaam, ... 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Client/Screenshot%20(490).png?raw=true)
Op deze screenshot is te zien dat er succesvol ingelogd is in het gebruikerspostvak van *keanunys* via zowel de website en de mail applicatie. 

## Extra
Admin Password: K3anu

Keanu Nys Mail Password: K3anuK3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
- Cursus SQL 2017
