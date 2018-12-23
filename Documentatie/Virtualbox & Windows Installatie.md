# Virtualbox en Windows Installatie stappen

## Inleiding

In dit document gaan we één maal over de instalatie van een nieuwe virtuele machine met windows server 2016 gaan. We gebruiken voor dit voorbeeld de Domein Controler, maar is in essentie zo goed als volledig hetzelfde voor alle andere servers. De enige verschillen zijn bijvoorbeeld de naam van de server en het aantal ram dat deze servers nodig hebben, maar de stappen die doorlopen moeten worden zijn identiek voor alle servers.

Volg de stappen in de volgorde dat ze neergeschreven zijn. Onder elke stap is ook nog een screenshot te zien om deze bij te klaren.

## Windows Server 2016 machine aanmaken in virualbox

1) Gebruik *Ctrl+N* in virtualbox om een nieuwe machine toe te voegen. Dit opent een nieuw venster dat hieronder weergegeven is. Vul in het eerste veld de naam van de server in, hier ServerDC2. Zorg dat het type op *Microsoft Windows* staat en de versie op *Windows Server 2016 (64 bit)*. Klik op *Volgende*.
![Virtualbox First Steps 1](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps1.png)

2) Selecteer de hoeveelheid RAM de virtuele machine moet toegewezen worden. Dit hangt af van welke services deze machine moet uitvoeren, maar dient zo laag mogelijk te blijven aangezien alle virtuele machines naast elkaar moeten kunnen bestaan. Voor de domein controller is 2 GigaBytes voldoende. Klik op *Volgende*.

![Virtualbox First Steps 2](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps2.png)

3) Selecteer *Maak virtuele harde schijf nu aan* als dit nog niet aangeduid is en klik vervolgens op *Aanmaken*.
![Virtualbox First Steps 3](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps3.png)

4) Selecteer *VDI (VirtualBox Disk Image)* als dit nog niet geselecteerd is en klik op *Volgende*.
![Virtualbox First Steps 4](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps4.png)

5) Selecteer *Dynamisch gealloceerd* en klik op *Volgende*.
![Virtualbox First Steps 5](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps5.png)

6) Selecteer hoe groot de virtuele harde schijf van de virtuele machine moet zijn. Dit hangt al weer af van server tot server, maar voor de domein controller is 50 GigaBytes voldoende. Klik vervolgens op *Aanmaken*.
![Virtualbox First Steps 6](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps6.png)

7) Selecteer de nieuwe machine die net aangemaakt is in de lijst rechts in VirtualBox en klik vervolgens op *Instelling* links boven. Ga in het venster dat net geopend is naar de sectie Opslag in het linker menu. Klik op het lege optische station en zorg dat bij *Attributen* het Optische station op *SATA-poort 1* staat. Klik dan op het cd icoontje links daarvan en selecteer daar de Windows Server 2016 .iso bestand vanop je machine. 
![Virtualbox First Steps 7](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps7.png)

8) In de *Netwerk* sectie is voor alle machines (met als uitzondering DC1, maar dit wordt besproken in de documentatie van DC1 zelf) maar één netwerkadapter nodig, namelijk een *Host-only adapter*. **Zeer belangrijk:** Zorg er voor dat de juist host-only adapter geselecteerd is, dit is de host-only adapter in het **192.168.1.1/24** netwerk! In ons voorbeeld is dit *Adapter #10*. 

Note: Als je niet weet welke te selecteren kan je dit controlleren bij *Algemene gereedschappen*. Als er nog geen Host-Only Adapter voor dit netwerk bestaat moet je eerst één aanmaken door op de *Aanmaken* knop te klikken.
![Virtualbox First Steps 8](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps8.png)

9) Ten laatste voeg je een nieuwe gedeelde map toe in de sectie *Gedeelde mappen*. Selecteer een map op je host systeem die je wilt sharen naar de VM en vink *Automatisch koppelen* en *Permanent maken* aan. Druk vervolgens op *OK* en daarna nog eens op *OK* zodat je terug op het hoofdscherm van VirtualBox komt.
![Virtualbox First Steps 9](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/FirstSteps/FirstSteps9.png)

10) De virtuele machine is nu klaar om opgestart te worden met een dubbelklik op de VM in het menu links. 

## Windows Server 2016 instalatie


1) De eerste stap in de Windows Setup van Windows Server 2016 is heet instellen van de taal. Het is een goede gewoonte om de taal in het engels te laten staan. *Time and currency format* zetten gaan we wel op *Dutch (Belgium)* zetten, en niet op Catalan zoals op de screenshot hier onder, om verwaring met datums te vermijden. Voor *Keyboard or input method* selecteren we *Belgian (Period)* om azerty te kunnen gebruiken. Klik op *Next*. 
![Windows Instalatie Screenshot 1](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie1.png)

2) Klik op *Install now*.
![Windows Instalatie Screenshot 2](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie2.png)

3) Vul een geldige product key in en klik vervolgens op *Next*. Om voor de hand liggende redenen heb ik de licence key niet in de screenshot getoond.
![Windows Instalatie Screenshot 3](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie3.png)

4) Selecteer *Windows Server 2016 Standard (Desktop Experience)* zodat we een grafische interface kunnen gebruiken. Klik op *Next*.
![Windows Instalatie Screenshot 4](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie4.png)

5) Lees de LICENCE TERMS en accepteer ze door de checkbox aan te vinken om verder te kunnen gaan. Klik op *Next*.
![Windows Instalatie Screenshot 5](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie5.png)

6) Klik op *Custom Install Wondows only (advanced)* aangezien we toch een nieuwe versie van Windows installeren en geen Upgrade willen.
![Windows Instalatie Screenshot 6](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie6.png)

7) In deze stap zou alles al correct moeten staan als de stappen over Virtual Box hierboven zijn gevolgd. Windows zal geïnstalleerd worden op Drive 0. Klik op *Next*.
![Windows Instalatie Screenshot 7](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie7.png)

8) In deze stap moet er niks gebeurt worden, ookal duurt deze wel het langst van allemaal. Wacht tot de installatie compleet is, het scherm zal automatisch naar de volgende stap gaan wanneer dit zo is.
![Windows Instalatie Screenshot 8](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie8.png)

9) Kies een administrator wachtwoord en klik vervolgens op *Finish* om de instalatie te voltooien.
![Windows Instalatie Screenshot 9](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie9.png)

10) De installatie is klaar en er kan nu ingelogd worden op het Administrator account met het wachtwoord dat gekozen is in de vorige stap.
![Windows Instalatie Screenshot 10](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/WindowsInstalatie/WindowsInstalatie10.png)

## Guest Additions

1) Klik in het taakmenu vanboven op *Apparaten* en vervolgens op *Invoegen Guest Additions CD-image...*
![Guest Additions Screenshot 1](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions1.png)

2) Open Windows Explorer en ga naar *This PC*. Open *CD Drive (D:) Virtualbox Guest Additions*.
![Guest Additions Screenshot 2](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions2.png)

3) Voer VBoxWindowsAdditions.exe uit.
![Guest Additions Screenshot 3](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions3.png)

4) Klik bij elke stap op *Next* en *Install* tot de installatie klaar is.
![Guest Additions Screenshot 4](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions4.png)

5) Selecteer *Reboot now* als de installatie klaar is. 
![Guest Additions Screenshot 5](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions5.png)

6) Na het herstarten zal de server in fullscreen staan zodat er makkelijker gewerkt kan worden. Klik nogmaals op *Apparaten* uit het taakmenu en klik op *Gedeeld klembord* en selecteer *bidirectioneel*. Nu kan kopieëren en plakken van host naar VM en omgekeerd gebruikt worden.
![Guest Additions Screenshot 6](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/GuestAdditions/GuestAdditions6.png)
GuestAdditions1.png





