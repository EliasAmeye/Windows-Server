# Documentatie van DC1

## Instalatie

### VirtualBox Configuratie
- Maak een nieuwe VM aan en noem hem `Server1`
- Ga door de standaard configuratiestappen
- Ga naar de instellingen van de nieuwe machine 
- Gebruik een windows server 2016 .iso als boot drive onder `Opslag`.
- Klik op `Netwerk` om de netwerkinstellingen aan te passen en zorg voor de volgende configuratie:
  - Adapter 1 : NAT
  - Adapter 2 : Host-Only (met 192.168.1.1/24 netwerk)

### Windows Server instalatie
- Start de nieuwe virtuele machine en voer de instalatie uit.
- Installeer Guest Additions:
  - Klik op `Apparaten` in de menubalk en dan `Invoegen Guest Additions CD-image...`
  - Ga naar de ingevoerde CD en voer `VBoxWindowsAdditions.exe` uit.
  - Activeer Gedeeld klembord zodat we uitvoer van commando's makkelijk kunnen kopieëren

## Configuratie

1) De eerste stap is altijd de computernaam instellen, hiervoor gebruiken we het commando `Rename-Computer -NewName ServerDC1`
2) De computernaam instellen komt altijd gepaard met een restart: `Restart-Computer -Force`
3) `install-windowsfeature AD-Domain-Services -IncludeManagementTools`
4) `Install-ADDSForest -DomainName keanys.gent -Force`


### Manuele configuratie

### Script
Uit de manuele configuratie kunnen we nu een script maken. De commando's zijn hierboven al uitgelegd dus dit nog eens doen in deze sectie zou dubbel werk zijn. 
Het script is te vinden in [/scripts/DC1_setup.ps1](https://github.com/KeanuNys/Windows-Server/scripts/DC1_setup.ps1) en met gebruik van comments worden alle stappen nog kort uitgelegd.


Admin Password: Ke3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps
