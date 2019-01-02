# Troubleshooting Exchange Installation Errors

## Tegengekomen problemen en oplossingen.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(40).png)
De eerste keer dat ik Microsoft Exchange Server 2016 probeerde te installeren kreeg ik een volledige lijst met Warnings en Errors bij de Readiness Checks. Deze werden voornamelijk veroorzaakt door twee redenen:

  * Het eerste probleem was dat ik ingelogd was als administrator op de computer, maar niet als administrator in het domein, wat noodzakelijk is voor de installatie. Dit veroorzaakte de meeste errors maar was makkelijk op te lossen door in te loggen als administrator in het domein.
  * Het tweede probleem was iets minder voor de hand liggend. Er was een error die aangaf dat het Windows component *Server-Gui-Mgmt-Infra* niet geïnstalleerd was op de computer. 
  
 Dit kon niet zomaar geïnstalleerd worden met `Get-WindowsFeature` en bleek na wat googlen outdated te zijn en niet meer relevant te zijn op Windows Server 2016. 
 
 Een volgende poging was om volledig op nieuw te starten, maar deze keer proberen met *Exchange Server 2013 Service Pack 1*... 
 ![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(57).png)
 Spijtig genoeg zonder succes. Na nog wat meer research ben ik er achter gekomen dat dit een bug was die opgelost werdt met de CU4 van *Windows Server 2016*.
 
Derde keer goede keer... Opnieuw geprobeerd met *Microsoft Exchange Server 2018 Cumulative Update 8*:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(74).png)
De *Server-Gui-Mgmt-Infra* error is weg maar er is een nieuwe bij gekomen. Deze is zeer straight-forward en geeft aan dat de windows update KB32006632 niet geïnstalleerd is.

Redelijk snel vinden we een link waar deze update gedownload kan worden van de microsoft website. Deze installeren gaat als volgt:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(80).png)
Selecteer de map waarin de update gedownload moet worden.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(82).png)
Wacht tot de download klaar is en klik op *Sluiten*.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(84).png)
Voer de installer uit en klik op *Yes*
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(87).png)
Klik op *Restart Now* om de computer te herstarten zodat de update klaar is.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(89).png)
We proberen opnieuw en alle errors bij de Readiness Checks zijn weg! Enkel nog twee Warnings die geen probleem vormen.

We klikken op install om naar de volgende stap te gaan, enkel om een nieuwe error tegen te komen:
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(90).png)

Deze error gaf zeer weinig informatie en heeft veel tijd aan troubleshooting gekost om op te lossen. 

Door wat te googlen waren er een paar personen die op hetzelfde probleem vast zaten, maar nergens een werkende oplossing erbij.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(91).png)
Bijna altijd werd er voorgesteld om *gewoon* het schema manueel toe te voegen door de setup uit te voeren in powershell met `/PrepareSchema` en daarna `/PrepareAD`. Maar deze oplossing werkte nooit en gaf enkel dezelfde error, deze keer als powershell output.

Na talloze uren verschillende dingen proberen vond ik uiteindelijk dat het probleem bij de DNS instellingen van de Domain Controler lag? 

Enkel zorgen dat beide DC's aan staan was een deel van het probleem maar was niet genoeg.

Op DC1 had ik bij de DNS instellingen enkel 127.0.0.1 als preffered DNS server. DC2 preffered DNS server maken, en localhost als alternate, was de oplossing.
![Image](https://github.com/KeanuNys/Windows-Server/blob/master/Screenshots/Exchange/Screenshot%20(92).png)
De setup ging verder en is daarna niet meer op problemen gestoten.







