# SvxlinkBuilder 
<h2>Menu build for Raspberry Pi - Repeater or Hotspot node. Pour l'instruction en Français, voir en bas.</h2>
<h3>This SVXLink build presently contains a connection only to the <b>svxportal-uk (SvxReflector)</b> only . If this changes then so will this introduction.</p>
<p>The connection to the svxreflector provided connectivity using pseudo-talkgroups to other nodes and repeaters on the network. for more information select this link http://svxportal-uk.ddns.net:81.</p>
<b>Your First Steps</b>
<p>The Requirements: A Raspberry Pi of any mark, a USB Soundcard, and an interface card (or a modified USB Soundcard and no interface). One or two transceivers. An experience with Shell Commands will help, but is not essential.</p>
<p>If your are suitably experienced, you will be able to modify the installation once it is complete. But this system will provide you with a working system, and you can then modify it to your own needs.</p>
<p>There are very few other raspberry images that work succesfully for this type of build, where there is a potential for using the application in several directions.</p>
<p>Whilst this in itself is not an image, it will take the hard work out of the physical compilation, although it may leave you a little work to do, if you need to change your immediate specification.</p>
<h2>Always use Raspberry OS Bookworm Lite (Debian 12) 32 Bit then you won't go wrong.</h2>
<p>There are a number of available interface boards that have a variety of uses, either as a hotspot or a repeater, or even a fill-in receiver/transceiver for an existing SVXLink repeater. The settings in this build are for a homebrew interface board using GPIOD 23/17/8 for the Receive COS and GPIOD 24/18/7 for the PTT controller, or alternative a fully modified CM-108 that can use 'udev' and drive the PTT and COS from the modification components. There is an also intermediate version for the CM-108 where only the transmit modification has been done that will you use 'udev' for the transmit, and give you options for the receive GPIOD 23/17/8.</p>
<p>When using the GPIO and GPIOD Pins, an earth pin is also require, so using this combination, pins 14,16 and 18 are all adjacent and ideally placed for these functions. Pin 14 is the Earth, Pin 16 is GPIO 23 and Pin 18 is GPIO 24.</p>
<p>For a second set of transceivers, you can consider GPIO 17 and 18 as COS & PTT for those.</p> 
<p>A copy of the design can be found on g4nab.co.uk. There is also a page showing the modification instructions for a CM-108 USB Sound Card.</p>
<h2>The programming of the SDCard</h2>

<p>As discussed start with a download of <b>Raspberry OS Bookworm Lite</b> from RaspberryPi.org. Then use a 8 or 16 GB MicroSD Card and transfer the image to the card, best using the <b>Raspberry Pi Image builder</b> from the same source. <b> You MUST make the user 'pi' - please do not deviate from my advice above, as you will get issues. </b> You can however use your own password. There are versions of Raspberry Pi Imager for all operating systems. It allows for full WiFi usage.</p> 
<p>In the first box <b>device</b> select 'No Filtering'</p>
<p>In the second box <b>Choose OS</b> select 'Raspberry Pi OS (Other)' then 'Raspberry Pi Os 32 Bit' under which you will see 'Debian Bookworm with no desktop environment'. Select this</p>
<p>Now select <b>Choose Storage</b> where you will be invited to select the sdcard.</p>
<p>In <b>Next</b> Complete the 'edit' box, but <b>pi</b> must be the user. If this is not correct, then your install will fail. You can have any password you like.</p>
<p>You can set your Wi-Fi settings here if your wish.</p>
<b>Always check the SSH box on the second tab of the next box, otherwise that will also cause your installation to fail.</b>  you can use a password or set a key if you wish.</p> 

<p>Once complete, eject the card and install it in the raspberry pi and power it up. Enter the user <b>pi</b> and your password.</p> 
<h2>The compilation</h2>
<p>This script will also install a dummy sound card for the use of Darkice and Icecast2.</p> 
<p>The first step will be the following command: <b>sudo apt-get install -y git</b> as without this you cannot download from the GitHub.</p>  

<p>Now the following command: <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>

<p>The menus displayed will guide you through the installation, all the way to run-time. <b>You will need to know before you begin</b>, the status of your transceiver, whether the PTT and COS are Active High or Active Low, the status and type of your USB soundcard, modified, partly modified or unmodified. With a fully modified usb soundcard, there is no reason that would prevent this installation on another Linux based computer running Debian 12. It has to be Debian 12, or some of the features will fail. Decide also the callsign of your node. Do not use additional symbols or numbers at this stage. The callsign should be of standard notation. If you have decided to install EchoLink, then have ready your registration information. If you wish to use ModuleMetarInfo, the Airport Weather application, then read about the ICAO codes, and discover the major airports around you. It will not work for airports that do not provide a weather service in real time. If you wish to explore the ModulePropagationMonitor, then this can be installed later. Remember note everything down before you proceed.</p>
<p>Everything else will be constructed for you</p>
<h2>Beginning the install</h2>
<p>The script will compile the running configuration as you proceed. It can only be run once, due to the nature of the program. Allow yourself an uninterupted period of 1 hour, to answer the questions put to you, and the accompanying install. <b>Remember to note down any "usernames and passwords" that you provide</b>. A Raspberry Pi 3 or 4 will take less time, and a Raspberry Pi zero possibly longer than 90 minutes. However the Raspberry Pi Zero will present a challenge due to the lack of an external USB socket. I have NOT included the installation of the waveshare sound system, if you are using a Pi-Hat interface. Hopefully there should be no reported error. I have just completed a build on a raspberry pi 3A from card format to working node in 50 minutes, with no errors.</p>
<p>For the American User, the en_US Voice files will be pulled if you select 'English - USA' from the menu.</p>
<p>I hope that there will be someone out there that can add to the code for Spanish or Portuguese.</p>
<h2>We begin</h2>
<p>Type the following command at the current prompt: <b>./svxlinkbuilder/preinstall.sh</b> The system will reboot so login again as before.</p>
<p>Type the following command <b> ./svxlinkbuilder/install.sh</b> Special NOTE - <b>No sudo here in these commands.</b></p>
<p>Follow the menus, and enter the required information, which should should have noted, to assist you prior to running the program.</p>
<p>During the compilation, you will be notified of the Active IP Address of your node. Make a note of it. You will need it to proceed.</p>

<p>At the end of the compilation, the system will automatically reboot, about which you will be notified.</p>

<p>The next step will be to open an internet browser such as 'Chrome' and type in the IP Address and enter. The dashboard will be displayed.If your USB soundcard is flashing then the node should be fully operational.</p>

<h2> Troubleshooting </h2>

<p>You will need to understand the svxlink.conf file and how to make adjustments for Simplex or Repeater operation. In any case you may need to refer to the svxlink.org main page, or svxlink amateur radio users page on facebook, or contact me. For further information also consult the svxlink pages on g4nab.co.uk. In the terminal, type 'man svxlink.conf' and the on-board documentation will be displayed.</p>

<p>To stop svxlink running type in the terminal <b>sudo systemctl stop svxlink.service</b> and to restart it type <b>sudo systemctl restart svxlink.service</b> You can also do this if authorised in the Dashboard.</p>

<p>If you wish to modify the Svxlink.conf, EchoLink, MetarInfo and NodeInfo files, you can do so, if authorised, from from the dashboard.</p>
<p>Be careful whilst editing, as to change the structure, can cause the node to fail. However a copy of the last working configuration can be found in the /etc/svxlink folder with a time and date, or in the case of the EchoLink and MetarInfo in the /etc/svxlink/svxlink.d folder.</p>
<p>To obtain information for the node_info.json go to a PC Browser and enter <b>http://svxportal-uk.ddns.net:81</b> where you will find a dashboard.</p>
<p>Click <b>Register</b> at the top, completing the information. This information is held only to enable you to complete the next stage. Log in with the information you have just supplied, click on <b>My Stations</b>, and click on <b font=color blue>Generate node_info.json</f></b>
<p>By completing all the information, <b>ignoring</b> any reference to CTCSS at this time, this will generate a file called node_info.json. Save it in a location in your computer. You can copy and paste from it later to the file in the node.</p>
<p>Open the terminal of the Raspberry Pi, and type <b>cd /etc/svxlink</b> followed by return. Then type <b>sudo nano node_info.json</b> and edit the information with the content of the file you have just saved on your PC. You can open the file with a text editor or notepad.</p>
<p>In the Raspberry Terminal or in the Dashboard if you have opened the NodeInfo file there, and delete all the contents. Go to the Notepad or text Editor and select all the text there, and copy (cntrl-c). Highlight the terminal (or the dashboard window) and paste (cntrl-v). </p>
<p>When the editing is complete type <b>cntrl-o</b> and return at the keyboard for the terminal followed by <b>cntrl-x</b>.</p>
<p>In the Dashboard, simply use the save button. The new information will be saved to the file in the node.</p>
<p>Next to incorporate the new information, type <b>sudo systemctl restart svxlink.service</b> and return if in the terminal, or if in the Dashboard click on Power and 'Restart SVXLink Service'</p>
<p>The next stage is to check and edit where necessary the <b>svxlink.conf</b> file. Type <b>sudo nano svxlink.conf</b> followed by return.This will be necessary for the addition or removal of TalkGroups in [ReflectorLogic]. Discuss that with me.</p>
<p>Check the content and importantly complete your location information near the bottom of the file. type <b>cntrl-o</b> and return then <b>cntrl-x</b> when finished to save your changes.</p>
<p>To modify the Echolink information type <b>sudo nano svxlink.d/ModuleEchoLink.conf</b> and return. Make your changes to your EchoLink access here. then save the file as you did above with <b>svxlink.conf</b>. If you have not yet enabled svxlink in the <b>svxlink.conf</b> to may need to do this now, and remove the <b>#</b> comment header from the relevant lines.</p>
<p>To incorporated the changes you will need to restart the svxlink.service</b></p>
<p>You do not need to make changes to the <b>gpio.conf</b>. The old methods of adding the gpio configuration and setting a daemon start in /etc/rc.local are deprecated (no longer required). We are using GPIOD. If the version of the Dashboard does not show GPIO in the menu, then this has already been removed.</p>
<h2>EchoLink</h2>
<p>The usual rules apply with the outgoing ports for your RaspberryPi IP address set in the Router to which you are connected</p>
<p>You can only have one EchoLink set up on your own home IP Address.</p>
<p>You will need to set up the callsign and password with which you registered in EchoLink. This is in the file /etc/svxlink/svxlink.d/ModuleEchoLink.conf. You edit the file with the command 'sudo nano' preceding the file name inclusive of the directory information.</p>
<p>If you did not set up EchoLink during the building phase, then you will also need to modify two lines in /etc/svxlink/svxlink.conf again using 'sudo nano'. For the Simplex Node the first of the lines is within the [SimplexLogic] at MODULES= and you must include ModuleEchoLink within the line. For the Repeater user the same will apply except the MODULES= line will be in [RepeaterLogic]

<p>Everything introduced here is directly from the original presentation by Tobias SM0SVX.</p>


<b><h2>Français - Mes Excuses, pour la rapidité, les pluparts grâce à Google Translate. </h2></b>
<b><h2>Vos premiers pas</h2></b>
<p>Exigences : Raspberry Pi de toute marque. Carte son USB et une carte d'interface (ou une carte son USB modifiée et sans interface). Un ou deux émetteurs-récepteurs. Une expérience avec les commandes Shell sera utile, mais n'est pas essentielle.</p>
<p>Si vous êtes suffisamment expérimenté, vous pourrez modifier l'installation une fois celle-ci terminée. Mais ce système vous fournira un système fonctionnel, et vous pourrez ensuite le modifier selon vos propres besoins.</p>
<p>Il existe très peu d'images Raspberry qui fonctionnent avec succès pour ce type de build, où il existe un potentiel d'utilisation de l'application éventuelle dans plusieurs directions.</p>
<p>Bien qu'il ne s'agisse pas en soi d'une image, cela simplifiera la compilation physique, même si cela peut vous laisser un peu de travail à faire si vous devez modifier vos spécifications immédiates.</p>
<h2><p>Utilisez toujours Raspberry OS Bookworm Lite (Debian 12) 32 bits alors tout sera correct.</p></h2>
<p>Il existe un certain nombre de cartes d'interface disponibles qui ont diverses utilisations, soit comme point d'accès, soit comme répéteur, ou même comme récepteur/émetteur-récepteur de remplacement pour un répéteur SVXLink existant. Les paramètres de cette version concernent une carte d'interface homebrew utilisant GPIOD 23/18/8 pour le COS de réception et GPIOD 24/17/7 pour le contrôleur PTT, ou une alternative à un CM-108 entièrement modifié qui peut utiliser 'udev' et piloter. le PTT et le COS à partir des composants de modification. Il existe également une version intermédiaire pour le CM-108 où seule la modification de transmission a été effectuée : vous utiliserez 'udev' pour la transmission et vous donnerez des options pour la réception GPIOD 23/18/8.</p>
<p>Lors de l'utilisation des broches GPIO et GPIOD, une broche de terre est également requise. Ainsi, en utilisant cette combinaison, les broches 14, 16 et 18 sont toutes adjacentes et idéalement placées pour ces fonctions. La broche 14 est la terre, la broche 16 est le GPIO 23 et la broche 18 est le GPIO 24.</p>
<p>Pour un deuxième ensemble d'émetteurs-récepteurs, vous pouvez considérer les GPIO 17 et 18 comme COS & PTT pour ceux-ci.</p>
<p>Une copie du design peut être trouvée sur g4nab.co.uk. Il existe également une page montrant les instructions de modification pour une carte son USB CM-108. Mais tous sont en anglais.</p>
<h2>La Programmation de la Carte-SD</h2>
<p>Comme indiqué, commencez par télécharger <b>Raspberry OS Bookworm Lite</b> depuis RaspberryPi.org. Utilisez ensuite une carte MicroSD de 8 ou 16 Go et transférez l'image sur la carte à l'aide du <b>Raspberry Pi Image builder</b> de la même source. <b> Vous DEVEZ définir l'utilisateur « pi » - veuillez ne pas vous écarter de mes conseils ci-dessus, car vous rencontrerez des problèmes. </b> Vous pouvez cependant utiliser votre propre mot de passe. Il existe des versions de Raspberry Pi Imager pour tous les systèmes d'exploitation. Il permet une utilisation complète du WiFi. <b>Cochez toujours la case SSH sur le deuxième onglet.</b> </p>
<p>Une fois terminé, éjectez la carte, installez-la dans le Raspberry Pi et allumez-la. Entrez l'utilisateur <b>pi</b> et votre mot de passe.</p>
<h2>La Compilation</h2>
<p>Ce script installera également une carte son factice pour l'utilisation de Darkice et Icecast2.</p>
<p>La première étape sera la commande suivante : <b>sudo apt-get install -y git</b> car sans cela, vous ne pouvez pas télécharger depuis GitHub.</p>
<p>Maintenant, la commande suivante : <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>


<p>Les menus affichés vous guideront tout au long de l'installation, jusqu'à l'exécution. Vous aurez besoin de comprendre avant de commencer l'état de votre émetteur-récepteur, si le PTT et le COS sont Active High ou Active Low, l'état et le type de votre carte son USB, modifiée ou non. Avec une carte son USB entièrement modifiée, il n'y a aucune raison qui empêcherait cette installation sur un autre ordinateur Linux exécutant Debian 12. Il doit s'agir de Debian 12, sinon certaines fonctionnalités échoueront.</p>
<p>Vous devrez avoir décidé de l'indicatif de votre nœud avant l'installation. N'utilisez pas de symboles ou de chiffres supplémentaires à ce stade. L'indicatif doit être de notation standard. Si vous avez décidé d'installer EchoLink, préparez vos informations d'enregistrement. Si vous souhaitez utiliser ModuleMetarInfo, l'application Météo Aéroportuaire, alors renseignez-vous sur les codes OACI et découvrez les principaux aéroports autour de vous. Cela ne fonctionnera pas pour les aéroports qui ne fournissent pas de service météo en temps réel. Si vous souhaitez explorer ModulePropagationMonitor, celui-ci pourra être installé ultérieurement. </p>
<p>Tout le reste aura été construit pour vous</p>
<p>Le script compilera la configuration en cours au fur et à mesure. Il ne peut être exécuté qu'une seule fois, en raison de la nature du programme. Accordez-vous une période ininterrompue d'1 heure, pour répondre aux questions qui vous sont posées, et à l'installation qui l'accompagne. <b>N'oubliez pas de noter tous les « noms d'utilisateur et mots de passe » que vous fournissez</b>. Un Raspberry Pi 3 ou 4 prendra moins de temps, et un Raspberry Pi zéro peut-être plus de 90 minutes. Cependant, le Raspberry Pi Zero présentera un défi en raison de l'absence de prise USB externe. Espérons qu'aucune erreur ne soit signalée. Je viens de terminer une construction sur un Raspberry Pi 3A du format carte au nœud de travail en 50 minutes, sans erreur.</p>
<p>Une fois installé, tapez la commande suivante : <b>./svxlinkbuilder/install.sh</b></p>
<p>Lors de la compilation, vous serez informé de l'adresse IP active de votre nœud. Prenez-en note. Vous en aurez besoin pour continuer.</p>

<p>À la fin de la compilation, le système redémarrera automatiquement, ce dont vous serez informé.</p>

<p>L'étape suivante consistera à ouvrir un navigateur Internet tel que « Chrome », à saisir l'adresse IP et à la saisir. Le tableau de bord s'affichera. Si votre carte son USB clignote, le nœud devrait être pleinement opérationnel.</p>
<h2> Dépannage </h2>

<p>Vous devrez comprendre le fichier svxlink.conf et savoir comment effectuer des ajustements pour le fonctionnement Simplex ou Répéteur. Dans tous les cas, vous devrez peut-être vous référer à la page principale de svxlink.org, ou à la page des utilisateurs de radio amateur svxlink sur Facebook, ou me contacter. Pour plus d’informations, consultez également les pages svxlink sur g4nab.co.uk. Dans le terminal, tapez man svxlink.conf et la documentation intégrée sera affichée.</p>

<p>Pour arrêter l'exécution de svxlink, tapez dans le terminal <b>sudo systemctl stop svxlink.service</b> et pour le redémarrer, tapez <b>sudo systemctl restart svxlink.service</b> Vous pouvez également le faire si vous y êtes autorisé dans le tableau de bord.</p>
<p>Si vous souhaitez modifier les fichiers Svxlink.conf, EchoLink, MetarInfo et NodeInfo, vous pouvez le faire, si vous y êtes autorisé, depuis le tableau de bord.</p>
<p>Soyez prudent lors de l'édition, car modifier la structure peut entraîner l'échec du nœud. Cependant, une copie de la dernière configuration de travail peut être trouvée dans le dossier /etc/svxlink avec une heure et une date, ou dans le cas d'EchoLink et MetarInfo dans le dossier /etc/svxlink/svxlink.d.</p>
<p>Pour obtenir des informations sur node_info.json, accédez à un navigateur PC et entrez <b>http://svxportal-uk.ddns.net:81</b> où vous trouverez un tableau de bord.</p>
<p>Cliquez sur <b>S'inscrire</b> en haut pour compléter les informations. Ces informations sont conservées uniquement pour vous permettre de passer à l'étape suivante. Connectez-vous avec les informations que vous venez de fournir, cliquez sur <b>Mes Stations</b>, puis cliquez sur <b font=color blue>Générer node_info.json</f></b>
<p>En complétant toutes les informations, <b>en ignorant</> toute référence à CTCSS à ce stade, cela générera un fichier appelé node_info.json. Enregistrez-le dans un emplacement de votre ordinateur. Vous pourrez le copier et le coller ultérieurement dans le fichier du nœud.</p>
<p>Ouvrez le terminal du Raspberry Pi et tapez <b>cd /etc/svxlink</b> suivi de return. Tapez ensuite <b>sudo nano node_info.json</b> et modifiez les informations avec le contenu du fichier que vous venez d'enregistrer sur votre PC. Vous pouvez ouvrir le fichier avec un éditeur de texte ou un bloc-notes.</p>
<p>Dans le Raspberry Terminal ou dans le Dashboard si vous y avez ouvert le fichier NodeInfo, et supprimez tout le contenu. Accédez au Bloc-notes ou à l'éditeur de texte, sélectionnez-y tout le texte et copiez-le (cntrl-c). Mettez en surbrillance le terminal (ou la fenêtre du tableau de bord) et collez (cntrl-v). </p>
<p>Lorsque l'édition est terminée, tapez <b>cntrl-o</b> et revenez au clavier du terminal suivi de <b>cntrl-x</b>.</p>
<p>Dans le tableau de bord, utilisez simplement le bouton Enregistrer. Les nouvelles informations seront enregistrées dans le fichier du nœud.</p>
<p>Ensuite, pour incorporer les nouvelles informations, tapez <b>sudo systemctl restart svxlink.service</b> et revenez si vous êtes dans le terminal, ou si dans le tableau de bord, cliquez sur Alimentation et « Redémarrer le service SVXLink »</p>
<p>L'étape suivante consiste à vérifier et éditer si nécessaire le fichier <b>svxlink.conf</b>. Tapez <b>sudo nano svxlink.conf</b> suivi de return. Cela sera nécessaire pour l'ajout ou la suppression de TalkGroups dans [ReflectorLogic]. Discutez-en avec moi.</p>
<p>Vérifiez le contenu et, surtout, complétez vos informations de localisation en bas du fichier. tapez <b>cntrl-o</b> et revenez ensuite <b>cntrl-x</b> lorsque vous avez terminé pour enregistrer vos modifications.</p>
<p>Pour modifier les informations Echolink, tapez <b>sudo nano svxlink.d/ModuleEchoLink.conf</b> et revenez. Apportez vos modifications à votre accès EchoLink ici. puis enregistrez le fichier comme vous l'avez fait ci-dessus avec <b>svxlink.conf</b>. Si vous n'avez pas encore activé svxlink dans <b>svxlink.conf</b>, vous devrez peut-être le faire maintenant et supprimer l'en-tête de commentaire <b>#</b> des lignes concernées.</p>
<p>Pour intégrer les modifications, vous devrez redémarrer svxlink.service</b></p>
<p>Vous n'avez pas besoin d'apporter de modifications au <b>gpio.conf</b>. Les anciennes méthodes d'ajout de la configuration gpio et de définition d'un démarrage de démon dans /etc/rc.local sont obsolètes (plus nécessaires). Nous utilisons GPIOD. Si la version du tableau de bord n'affiche pas GPIO dans le menu, cela a déjà été supprimé.</p>
<p>Tout ce qui est présenté ici provient directement de la présentation originale de Tobias Blomberg SM0SVX.</p>