# SvxlinkBuilder
<h1>Menu di build per Raspberry Pi - Nodo Repeater o Hotspot. Opzioni EchoLink, MetarInfo e SVXReflector</h1>
<h2>Per le istruzioni in francese, README_FR.md. Per le istruzioni in spagnolo, README_ES.md.</h2>
<h3>Introduzione</h3>
<p>Questa build di SVXLink contiene attualmente solo una connessione a <b>svxportal-uk (SvxReflector)</b>. Se ciò cambierà, cambierà anche questa introduzione. Puoi lasciare la connessione assente ed installare uno svxreflector successivamente tramite la Dashboard.</p> <p>La connessione allo svxreflector permette la connettività tramite pseudo-talkgroup verso altri nodi e ripetitori della rete. Per ulteriori informazioni, seleziona questo link: http://portal.svxlink.uk:81.</p>
<p>Questa build include ora un timeout automatico di tre minuti per gli utenti RF. Questo serve ad educare gli utenti a non parlare troppo a lungo.</p>
<p>Il meccanismo di timeout non blocca l’utente mentre parla, ma sovrappone una serie di toni "pip" durante la trasmissione, che terminano quando l’oratore rilascia il PTT. Il meccanismo di squelch rileva questo ed invia verbalmente "Time-out" sulla trasmissione, prima di emettere un "K" per l’uso continuato del ripetitore.</p>
<h3>Per gli utenti del dispositivo SA818</h3>
<p>Ci sarà la possibilità di selezionare la programmazione durante il processo di installazione. Questo è particolarmente importante per gli utenti della uSvxCard con uDraCard di F8ASB e per il Guru-RF Hotspot. Per questi dispositivi, potrebbero essere necessarie istruzioni e accorgimenti aggiuntivi, che saranno indicati di seguito.</p>
<h3>I tuoi primi passi</h3>
<p><b>Requisiti:</b> un Raspberry Pi di qualsiasi modello, una scheda audio USB e una scheda interfaccia (oppure una scheda audio USB modificata senza interfaccia). Uno o due ricetrasmettitori. L’esperienza con comandi Shell è utile ma non è essenziale.</p>
<p>Se sei esperto, potrai modificare l’installazione una volta completata. Questo sistema fornisce, comunque, un’installazione funzionante che puoi poi adattare alle tue esigenze.</p> <p>Pochissime altre immagini per Raspberry funzionano con successo per questo tipo di build, dove l’applicazione può essere usata in più direzioni. Un’immagine fissa ti lascia con molti problemi. Questa non è un’immagine, ma una build guidata da menu facile da usare.</p>
<p>Il nuovo SVXLINKBUILDER utilizza apt install, creato appositamente per evitare il lungo e noioso processo di compilazione.</p>

<h2>Usa sempre Raspberry OS Bookworm Lite (Debian 12) 32-bit, così non sbagli.</h2>
<p>Usando Raspberry Pi Imager, seleziona l’immagine Raspberry Pi OS (32-bit) Lite. Assicurati che il nome utente sia 'pi' e nulla altro.</p>
<p>L’Imager permette anche di configurare la password e il WiFi, se necessario. Assicurati che la scheda per SSH sia abilitata.</p>
<h3>Prima di eseguire il software</h3>
<p>Esistono diverse schede interfaccia disponibili, con vari utilizzi: hotspot, ripetitore o ricevitore/trasmettitore aggiuntivo per un ripetitore SVXLink esistente. Le impostazioni di questa build sono per una scheda interfaccia homebrew usando GPIOD 23/17/8 per il COS in ricezione e GPIOD 24/18/7 per il controllo PTT, oppure una CM-108 completamente modificata che può usare 'udev' per pilotare PTT e COS dai componenti modificati. Esiste anche una versione intermedia per la CM-108 in cui è stata fatta solo la modifica di trasmissione, usando 'udev' per il trasmettitore e dando opzioni per il COS di ricezione GPIOD 23/17/8. È possibile anche selezionare le proprie porte GPIO. Questo è particolarmente utile per gli utenti dei vari hotspot come F8ASB o RF-Guru. Le precedenti immagini per questi dispositivi erano rigide, mentre questo builder permette di integrare completamente gli add-on aggiornati.</p>
<p>Quando si usano i pin GPIO e GPIOD, serve anche un pin di massa. Ad esempio, i pin 14,16 e 18 sono adiacenti e ideali: Pin 14 = massa, Pin 16 = GPIO 23, Pin 18 = GPIO 24.</p>
<p>Per un secondo set di ricetrasmettitori, si possono usare GPIO 17 e 18 come COS & PTT.</p> <p>Un esempio di progetto di interfaccia si trova su g4nab.co.uk, con istruzioni di modifica per una CM-108 USB Sound Card.</p>
<h2>Programmazione della SDCard</h2>

<p>Scarica <b>Raspberry OS Bookworm Lite</b> da RaspberryPi.org. Usa una MicroSD da 8 o 16 GB e trasferisci l’immagine sulla scheda, meglio usando il <b>Raspberry Pi Image builder</b>.</p> <p><b>Il nome utente DEVE essere 'pi'. NON modificarlo, altrimenti avrai problemi.</b> Puoi usare la tua password. Esistono versioni di Raspberry Pi Imager per tutti i sistemi operativi, con pieno supporto WiFi. Non dimenticare la scheda SSH in 'Services'.</p>
<p>Nella prima casella <b>Device</b>, seleziona 'No Filtering'.</p>
<p>Nella seconda casella <b>Choose OS</b>, seleziona 'Raspberry Pi OS (Other)' → 'Raspberry Pi OS 32-bit' → 'Debian Bookworm senza desktop'.</p>
<p>Seleziona <b>Choose Storage</b> e scegli la SDCard.</p>
<p>In <b>Next</b>, completa la casella 'edit', ma <b>pi</b> deve essere l’utente. Puoi usare qualsiasi password.</p>
<p>Configura il WiFi, se lo desideri.</p>
<b>Assicurati di abilitare SSH nella seconda scheda del menu, altrimenti l’installazione fallirà.</b></p>

<p>Una volta completato, espelli la scheda, inseriscila nel Raspberry Pi e accendilo. Accedi con utente <b>pi</b> e la password scelta.</p>
<p>Prima di tutto, esegui: <b>sudo apt update && sudo apt upgrade -y</b>, poi <b>sudo apt install -y git</b>.</p> 

<h2>Gli utenti di una usvxcard e della udracard di Juan Hagen F8ASB e del RF-Guru devono seguire questo passaggio aggiuntivo prima della build. Gli altri utenti possono saltare al paragrafo successivo (La Build).</h2>

<p>Usando <b>sudo raspi-config</b> nel terminale, assicurati che l’interfaccia seriale sia prima abilitata.</p>
<p>Riavvia il sistema, quindi effettua nuovamente il login come utente <b>pi</b> ed esegui i seguenti comandi nel terminale:</p>
<p>sudo nano /boot/firmware/config.txt</p>
<p>Aggiungi le seguenti righe alla fine del file:</p>
<p>dtoverlay=pi3-miniuart-bt</p>
<p>enable_uart=1</p>
<p>Salva il file. Poi esegui <b>sudo raspi-config</b> e abilita solo la seconda parte della porta seriale.</p>
<p>Ora riavvia, chiudendo rasp-config.</p>
<p>Accedi di nuovo come utente <b>pi</b> ed esegui i seguenti comandi nel terminale:</p>
<p>sudo apt install git -y</p>
<p>git clone https://github.com/f5vmr/seeed-voicecard</p>
<p>cd seeed-voicecard</p>
<p>sudo ./install.sh</p>
<p>Questo installerà i driver audio per la usvxcard e la udracard.</p>
<p>Puoi ora procedere al passo successivo.</p>
<p>Durante il processo di installazione, ci sarà un ulteriore passaggio per programmare la scheda SA818.</p>
<h2>La Build</h2>
<p>Questo script installerà anche una scheda audio fittizia per l’uso di un Web Socket.</p>
<p>Passo 1: <b>sudo apt install -y git</b>, perché senza questo non puoi scaricare da GitHub.</p>

<p>Passo 2: <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>
<p>Passo 3: <b>al prompt, digita ./svxlinkbuilder/preinstall.sh</b></p>
<p>Non è necessario alcun input in questa fase, fino a quando il sistema non si spegnerà per il riavvio. Il processo richiederà un po’ di tempo, circa 20 minuti.</p>
<p>Passo 4: <b>accedi di nuovo e, al prompt, digita ./svxlinkbuilder/install.sh</b></p>
<p>Qui ti verrà richiesto di rispondere ad una serie di domande nel menu.</p>
<p>Ti guideranno attraverso l’installazione, fino al momento dell’esecuzione del sistema.</p>
<b>Ciò che devi sapere prima di iniziare</b>
<p>1. Lo stato del tuo ricetrasmettitore, se il PTT e il COS sono Active High o Active Low. I numeri dei pin GPIO.</p>
<p>2. Lo stato ed il tipo della tua scheda audio USB, modificata, parzialmente modificata o non modificata. Con una scheda audio USB completamente modificata, nulla impedisce l’installazione su un altro computer basato su Linux con Debian 12. Deve essere Debian 12, altrimenti alcune funzionalità potrebbero non funzionare.</p>
<p>3. Decidi <b>il nominativo del tuo nodo</b>.<p>Non utilizzare simboli o numeri aggiuntivi in questa fase. Il nominativo deve seguire la notazione standard.</p>
<p>4. Se hai deciso di installare EchoLink, prepara le informazioni di registrazione.</p>
<p>5. Se desideri usare ModuleMetarInfo, l’applicazione meteo aeroportuale, consulta i codici ICAO ed individua i principali aeroporti intorno a te. Non funzionerà per aeroporti che non forniscono un servizio meteo in tempo reale.</p>
<p>6. Se desideri esplorare il ModulePropagationMonitor, può essere installato in un secondo momento.</p>
<b>Ricorda di annotare tutto prima di procedere.</b>
<p>Tutto il resto sarà predisposto automaticamente per te.</p>
<h2>Inizio dell’installazione</h2>
<p>Lo script compilerà la configurazione in esecuzione, man mano che procedi. Può essere eseguito solo una volta, a causa della natura del programma.</p>
<p>Concediti un periodo di circa 30 minuti senza interruzioni, per rispondere alle domande che ti verranno poste e per l’installazione che le accompagnerà.</p>
<p>Un Raspberry Pi 3 o 4 richiederà meno tempo, mentre un Raspberry Pi Zero potrebbe richiederne leggermente di più. Tuttavia, il Raspberry Pi Zero presenterà una difficoltà a causa della mancanza di una porta USB esterna.</p>
<p>NON ho incluso l’installazione del sistema audio Waveshare, nel caso tu stia utilizzando un’interfaccia Pi-Hat.</p>
<p>Si spera che non vengano segnalati errori. Ho appena completato una build su un Raspberry Pi 3A, dalla formattazione della scheda fino al nodo funzionante, in circa 25 minuti, senza errori.</p>
<p>Per l’utente americano, i file vocali en_US verranno scaricati se dal menu selezioni 'English - USA'.</p>
<p>Spero che ci sia qualcuno che possa contribuire al codice per il portoghese.</p>
<p>Durante la compilazione, ti verrà comunicato l’indirizzo IP attivo del tuo nodo. Prendine nota: ti servirà per continuare.</p>

<p>Al termine della compilazione, il sistema sarà pronto per l’uso. Ora puoi 'uscire' dal terminale.</p>

<p>Il passo successivo sarà quello di aprire un browser internet come 'Chrome' o 'Firefox', digitare l’indirizzo IP e premere invio. Verrà visualizzata la dashboard. Se la tua scheda audio USB sta lampeggiando, allora il nodo dovrebbe essere completamente operativo.</p>

<h2>Risoluzione dei problemi</h2>

<p>Dovrai comprendere il file svxlink.conf e come apportare modifiche, per l’operatività in modalità Simplex o Ripetitore. In ogni caso, potrebbe essere necessario fare riferimento alla pagina principale di svxlink.org, alla pagina Facebook degli utenti radioamatoriali svxlink, oppure contattarmi. Per ulteriori informazioni, consulta anche le pagine svxlink su g4nab.co.uk. Nel terminale, digita 'man svxlink.conf' e verrà visualizzata la documentazione integrata.</p>

<p>Per fermare svxlink, digita nel terminale <b>sudo systemctl stop svxlink.service</b> e per riavviarlo digita <b>sudo systemctl restart svxlink.service</b>. Puoi anche farlo, se autorizzato, dalla Dashboard nel menu POWER. Non è necessario riavviare il sistema in nessun momento.</p>

<p>Se desideri modificare i file Svxlink.conf, EchoLink, MetarInfo e NodeInfo, puoi farlo, se autorizzato, dalla dashboard. Salvando le modifiche, svxlink verrà immediatamente riavviato con le nuove impostazioni e le modifiche saranno visualizzate dopo un clic sull’apposito pulsante nella dashboard.</p>
<p>Fai attenzione durante la modifica poiché, alterare la struttura, può causare il malfunzionamento del nodo. Tuttavia, una copia dell’ultima configurazione funzionante è disponibile nella cartella /var/www/html/backups, con data e ora.</p>
<p>Per ottenere le informazioni del file node_info.json, apri un browser e digita <b>http://portal.svxlink.uk:81</b>, dove troverai una dashboard.</p>
<p>Clicca su <b>Register</b> in alto e compila le informazioni. Questi dati vengono conservati solo per permetterti di completare la fase successiva. Accedi con le informazioni appena fornite, clicca su <b>My Stations</b> e poi su <b>Generate node_info.json</f></b>
<p>Completando tutte le informazioni, <b>ignorando</b> eventuali riferimenti al CTCSS in questa fase, verrà generato un file chiamato node_info.json. Salvalo in una posizione sul tuo computer. In seguito, potrai copiarne il contenuto nel file del nodo.</p>
<p>Apri il terminale del Raspberry Pi e digita <b>cd /etc/svxlink</b> seguito da invio. Poi digita <b>sudo nano node_info.json</b> e modifica le informazioni con il contenuto del file che hai appena salvato sul tuo PC. Puoi aprire il file con un qualsiasi editor di testo o con il blocco note.</p>
<p>Nel terminale del Raspberry o nella Dashboard, se hai aperto lì il file NodeInfo, cancella tutto il contenuto. Vai al blocco note o all’editor di testo, seleziona tutto il testo e copialo (Ctrl-C). Evidenzia il terminale (o la finestra della dashboard) e incolla (Ctrl-V).</p>
<p>Quando la modifica è completa, digita <b>Ctrl-O</b> e premi invio sulla tastiera del terminale, poi digita <b>Ctrl-X</b>.</p>
<p>Nella Dashboard, usa semplicemente il pulsante Salva. Le nuove informazioni verranno salvate nel file del nodo.</p>

<p>Controlla il contenuto e, soprattutto, completa le informazioni sulla tua posizione verso il fondo del file. Digita <b>Ctrl-O</b> e premi invio, poi <b>Ctrl-X</b> per salvare le modifiche.</p>
<p>Se non hai ancora abilitato Echolink nel <b>svxlink.conf</b>, potresti farlo ora, rimuovendo il simbolo <b>#</b> dalle righe pertinenti, semplicemente cliccando sulla casella di controllo. Puoi farlo nel Svxlink Configurator.</p>
<p>Il riavvio del servizio svxlink.service avviene automaticamente, al salvataggio delle modifiche.</p>
<p>Non apportare modifiche al file <b>gpio.conf</b>. I vecchi metodi per aggiungere la configurazione GPIO ed impostare l’avvio di un daemon in /etc/rc.local sono deprecati (non più necessari). Stiamo usando GPIOD o udev e sono configurati nei menu.</p>
<h2>EchoLink</h2>
<p>Per modificare le informazioni di EchoLink, puoi apportare qui le modifiche nel tuo EchoLink Configurator. Poi salva il file, come hai fatto in precedenza, con <b>svxlink.conf</b>.</p>
<p>Si applicano le regole usuali per le porte in uscita, configurando l’indirizzo IP del tuo Raspberry Pi nel router a cui sei connesso.</p>
<p>Puoi avere solo un’installazione di EchoLink sul tuo indirizzo IP domestico.</p>
<p>Dovrai configurare il nominativo e la password con cui ti sei registrato in EchoLink.</p>
<p>Se non hai configurato EchoLink durante la fase di build, puoi aggiungerlo nella riga MODULES= nella sezione [SimplexLogic] del Svxlink Configurator e devi includere ModuleEchoLink all’interno della riga. Per l’utente ripetitore vale lo stesso, eccetto che la riga MODULES= sarà nella sezione [RepeaterLogic].</p>
<p>Infine, il passaggio importante è impostare il livello corretto dell’audio. Ora questo viene fatto utilizzando amixer nel menu in alto.</p>
<p>Alsamixer non può essere utilizzato dalla dashboard, quindi si utilizza direttamente amixer.</p>
<p>Per ottenere i migliori risultati, imposta 'Loudspeaker' intorno a 75, 'Mic' a 0, 'Mic with Capture' tra 19 e 38 e 'Autogain' su 'OFF'. Regola semplicemente i valori nel Configurator.</p>
<p>'Loudspeaker' è il volume del trasmettitore, e 'Mic with Capture' è il volume proveniente dal ricevitore. Non è molto intuitivo.</p>
<p>Buona giornata e divertiti!</p>

<p>73 - Chris G4NAB </p>

**Riconoscimenti**
<p>Software principale: SVXLink / SvxReflector — Tobias Blömberg SM0SVX</p>
<p>Framework della Dashboard: SP2ONG & SP0DZ</p>
<p>Altri contributori: Adi DL1HRC e la comunità SVXLink</p>
<p>Modernizzazione e integrazione (PHP 8.2, modifica configurazioni, controllo in tempo reale, streaming): Chris G4NAB</p>

**Addendum**
<p>I Talk Group dovrebbero essere aggiunti al Svxlink Configurator, nella sezione ReflectorLogic, assicurandosi che la casella di spunta sia selezionata. Aggiungere un + o ++ dopo il numero di un Talk Group ne aumenterà l’importanza, permettendo a un talk group di priorità più alta di sostituirne uno già in uso.</p>
<p>Gli aeroporti possono essere aggiunti o rimossi, secondo necessità, nel MetarInfo Configurator.</p>
<p>La dashboard audio sembra non funzionare al momento.</p>
<p>Il modulo EchoLink può essere aggiunto tramite la dashboard, prima nel configuratore EchoLink, poi aggiungi ModuleEchoLink alla riga MODULES= nella sezione [SimplexLogic] o [RepeaterLogic] del Svxlink Configurator.</p>
<p>Amixer può essere regolato tramite la dashboard ed è più efficiente di alsamixer nel terminale. Seleziona le impostazioni consigliate all’interno della finestra. Gli utenti F8ASB e RF-GURU dovranno comunque usare alsamixer nel terminale, a causa della complessità dei punti di ingresso. Dovresti aprire il terminale e digitare sudo alsamixer. Riduci tutte le impostazioni a circa il 60%.</p>
<p>Infine, per gli utenti F8ASB e RF-GURU, la regolazione del modulo SA818.</p>
<p>Dovresti aver già abilitato l’interfaccia USB che, nel menu del Raspberry Pi, dovrebbe essere /dev/ttyS0.</p>
<p>sudo git clone https://github.com/0x9900/sa818</p>
<p>cd sa818</p>
<p>sudo python3 setup.py install</p>
<p>sa818 --port /dev/ttyS0 radio --frequency 430.125 --squelch 2 --bw 0</p>
<p>Questo comando serve semplicemente a comunicare con la porta seriale per impostare la radio alla frequenza 430.125 MHz con livello di squelch 2 e larghezza di banda 12,5 kHz. Naturalmente, sostituisci con la tua frequenza. Per assistenza completa sul SA818, digita SA818 -h per visualizzare tutte le opzioni.</p>
