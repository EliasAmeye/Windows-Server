# Documentatie SQL Server

## Configuratie

### Computer configuratie

**Note:** De computer configuratie is reeds gedaan aangezien de SQL server op dezelfde machine zal draaien als de [Exchange Server](https://github.com/KeanuNys/Windows-Server/blob/master/Documentatie/Exchange%20Server.md). 

**IP Adres:** 192.168.1.3

### Installatie SQL Server 2017

De installatie van SQL Server 2017 wordt volledig manueel gedaan door de GUI. Met behulp van screenshots zullen we alle nodige stappen overlopen.

#### Prerequisites
Voordat we SQL Server kunnen installeren moeten we **Java** installeren. 
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

#### Installing SQL Server 2017

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(460).png?raw=true)
Voer de installatieschijf van SQL Server in en voer de Setup uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(461).png?raw=true)
Om zeker te zijn dat de basis benodigdheden aanwezig zijn voeren we eerste de *System Configuration Checker* uit.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(462).png?raw=true)
Als alle testen slagen, klik je op *OK*. 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(463).png?raw=true)
Bij *Installation* kiezen we voor een *New SQL Server stand-alone installation*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(464).png?raw=true)
Voer een product key in of kies voor een gratis editie en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(465).png?raw=true)
Lees en accepteer de license terms en klik op *Next*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(466).png?raw=true)
Kies of je Microsoft updates voor updates wil laten checken en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(467).png?raw=true)
Bij de installation rules krijgen we momenteel nog een warning. Een warnings betekend niet dat de instalatie niet door kan gaan. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(468).png?raw=true)
Selecteer *Database Engine Services, Analysis Services* en *Integretion Services*. Klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(469).png?raw=true)
Selecteer *Default Instance* en klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(470).png?raw=true)
De basis instellingen zijn oké hier, klik op *Next.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(471).png?raw=true)
Selecteer *Mixed Mode*, geef een wachtwoord in en klik op *Add Current User*. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(472).png?raw=true)
Selecteer *Tabular Mode* en klik op *Add Current User*. Klik op *Next.* 
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(473).png?raw=true)
Bekijk de samenvatting en klik op *Install* als alles correct is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(474).png?raw=true)
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(475).png?raw=true)
De installatie van SQL Server is succesvol. Klik op *Close*.

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(476).png?raw=true)
Het volgende wat we willen installeren is **SQL Server Management Studio**. Ga terug naar het SQL Server Installation Center en klik deze keer op *Install SQL Server Management Tools*. Dit zal de download pagina van microsoft openen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(477).png?raw=true)
Download de laatste versie van SSMS van de website.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(478).png?raw=true)
Open de setup.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(479).png?raw=true)
Klik op *Install* om de installatie te beginnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(480).png?raw=true)
De installatie is succesvol voltooid, klik op *Close.*

![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(481).png?raw=true)
Het laatste wat geïnstalleerd moet worden is *SQL Server Data Tools.* Ga terug naar het SQL Server Installation Center en klik op *Install SQL Server Data Tools*. Dit zal opnieuw een  download pagina van microsoft openen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(482).png?raw=true)
Download de laatste versie van SSDT van de website.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(483).png?raw=true)
Open de installer en klik op *Next* om de installatie te beginnen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(484).png?raw=true)
Geef een nickname voor de VS Instance en vink alle features aan. Klik op *Install.*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/SCCM/Screenshot%20(485).png?raw=true)
Een tweede manier om SSDT te installeren is via de Visual Studio installer zoals te zien op deze screenshot. Hier is het al geïnstalleerd.


## Extra
Admin Password: K3anu

## Resources:

- https://docs.microsoft.com/en-us/windows-server/networking/technologies/
- https://docs.microsoft.com/en-us/powershell/module/
- Cursus Win 2016
- Cursus SQL 2017
