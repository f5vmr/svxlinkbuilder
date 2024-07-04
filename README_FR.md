#SvxlinkBuilder
<h1>Création du menu pour Raspberry Pi - Répéteur ou nœud Hotspot. Options EchoLink MetarInfo et SVXReflector</h1>
<h2> Pour l'instruction en Français, README_FR.md. Pour les instructions en espagnol README_ES.md.</h2>
<h3>Présentation</h3>
<p>Cette version de SVXLink contient actuellement une connexion uniquement au <b>svxportal-uk (SvxReflector)</b> uniquement. Si cela change, cette introduction aussi. Vous pouvez le laisser sans et installer un svxreflector plus tard via le tableau de bord.</p>
<p>La connexion au svxreflector fournit une connectivité à l'aide de pseudo-groupes de discussion vers d'autres nœuds et répéteurs du réseau. pour plus d'informations, sélectionnez ce lien http://svxportal-uk.ddns.net:81.</p>
<h3>Vos premiers pas</h3>
<p><b>Les exigences :</b> Un Raspberry Pi de n'importe quelle marque, une carte son USB et une carte d'interface (ou une carte son USB modifiée et sans interface). Un ou deux émetteurs-récepteurs. Une expérience avec les commandes Shell sera utile, mais n'est pas essentielle.</p>
<p>Si vous êtes suffisamment expérimenté, vous pourrez modifier l'installation une fois celle-ci terminée. Mais ce système vous fournira un système fonctionnel, et vous pourrez ensuite le modifier selon vos propres besoins si vous le souhaitez.</p>
<p>Il existe très peu d'autres images Raspberry qui fonctionnent avec succès pour ce type de build, où il existe un potentiel d'utilisation de l'application dans plusieurs directions. Une image est figée, vous laissant avec beaucoup de perplexités. Il ne s'agit pas d'une image, mais d'une construction facile pilotée par menu.</p>
<p>Ce nouveau SVXLINKBUILDER utilise une installation apt, spécialement créée pour éviter l'approche longue et fastidieuse d'une compilation.</p>

<h2>Utilisez toujours Raspberry OS Bookworm Lite (Debian 12) 32 bits, vous ne vous tromperez pas.</h2>
<p>À l'aide de Raspberry Pi Imager, sélectionnez l'image Raspberry Pi OS (32 bits) Lite. Mais assurez-vous que votre nom d'utilisateur est « pi » et rien d'autre.</p>
<p>L'imageur vous permettra également de configurer votre mot de passe et le WiFi si nécessaire. Assurez-vous que l'onglet autorisant SSH est activé.</p>
<h3>Avant d'exécuter le logiciel</h>
<p>Il existe un certain nombre de cartes d'interface disponibles qui ont diverses utilisations, soit comme point d'accès, soit comme répéteur, ou même comme récepteur/émetteur-récepteur de remplacement pour un répéteur SVXLink existant. Les paramètres de cette version concernent une carte d'interface homebrew utilisant GPIOD 23/17/8 pour le COS de réception et GPIOD 24/18/7 pour le contrôleur PTT, ou une alternative à un CM-108 entièrement modifié qui peut utiliser 'udev' et piloter. le PTT et le COS à partir des composants de modification. Il existe également une version intermédiaire pour le CM-108 où seule la modification de transmission a été effectuée : vous utiliserez 'udev' pour la transmission et vous donnerez des options pour la réception GPIOD 23/17/8. Il existe également une option pour votre propre sélection de port GPIO.</p>
<p>Lors de l'utilisation des broches GPIO et GPIOD, une broche de terre est également requise. Ainsi, en utilisant cette combinaison par exemple, les broches 14, 16 et 18 sont toutes adjacentes et idéalement placées pour ces fonctions. La broche 14 est la Terre, la broche 16 est le GPIO 23 et la broche 18 est le GPIO 24.</p>
<p>Pour un deuxième ensemble d'émetteurs-récepteurs, vous pouvez considérer les GPIO 17 et 18 comme COS et PTT pour ceux-ci.</p>
<p>Une copie de la conception d'une interface est disponible sur g4nab.co.uk. Il existe également un lien vers une page Web affichant les instructions de modification d'une carte son USB CM-108.</p>
<h2>La programmation de la SDCard</h2>

<p>Comme indiqué, commencez par télécharger <b>Raspberry OS Bookworm Lite</b> depuis RaspberryPi.org. Utilisez une carte MicroSD de 8 ou 16 Go et transférez l'image sur la carte, de préférence en utilisant le <b>Raspberry Pi Image builder</b> de la même source. <b> Vous DEVEZ définir l'utilisateur « pi » - VEUILLEZ NE PAS VOUS DÉVIER de ce conseil, car vous rencontrerez des problèmes. </b> Vous pouvez cependant utiliser votre propre mot de passe. Il existe des versions de Raspberry Pi Imager pour tous les systèmes d'exploitation. Il permet une utilisation complète du WiFi. N'oubliez pas l'onglet SSH.</p>
<p>Dans la première case <b>appareil</b>, sélectionnez « Aucun filtrage »</p>
<p>Dans la deuxième case <b>Choisir le système d'exploitation</b>, sélectionnez « Raspberry Pi OS (Autre) » puis « Raspberry Pi Os 32 Bit » sous lequel vous verrez « Debian Bookworm sans environnement de bureau ». Sélectionnez ceci</p>
<p>Sélectionnez maintenant <b>Choisir le stockage</b> où vous serez invité à sélectionner la carte SD.</p>
<p>Dans <b>Suivant</b> Remplissez la case « modifier », mais <b>pi</b> doit être l'utilisateur. Si ce n'est pas correct, votre installation échouera. Vous pouvez avoir le mot de passe de votre choix.</p>
<p>Vous pouvez définir vos paramètres Wi-Fi ici si vous le souhaitez.</p>
<b>Cochez toujours la case SSH dans le deuxième onglet de la case suivante, sinon cela entraînera également l'échec de votre installation.</b> vous pouvez utiliser un mot de passe ou définir une clé si vous le souhaitez.</p>

<p>Une fois terminé, éjectez la carte, installez-la dans le Raspberry Pi et allumez-la. Entrez l'utilisateur <b>pi</b> et votre mot de passe.</p>
<h2>La construction</h2>
<p>Ce script installera également une carte son factice pour l'utilisation de Darkice et Icecast2.</p>
<p>Étape 1 : <b>sudo apt-get install -y git</b> car sans cela, vous ne pouvez pas télécharger depuis GitHub.</p>

<p>Étape 2 : <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>
<p>Étape 3 : <b>./svxlinkbuilder/preinstall.sh</b> </p>
<p>Vous n'avez besoin d'aucune intervention à ce stade, jusqu'à ce que le système s'arrête pour redémarrer. Cela prendra un certain temps - 20 à 30 minutes.</p>
<p>Étape 4 : <b>./svxlinkbuilder/install.sh</b> </p>
<p>Ici, vous devrez répondre à un certain nombre de questions dans le menu.</p>

<p>Ils vous guideront tout au long de l'installation, jusqu'à l'exécution.</p>
<b>Vous devrez le savoir avant de commencer</b>
<p>1. L'état de votre émetteur-récepteur, que le PTT et le COS soient Active High ou Active Low.</p>
<p>2. L'état et le type de votre carte son USB, modifié, partiellement modifié ou non modifié. Avec une carte son USB entièrement modifiée, il n'y a aucune raison qui empêcherait cette installation sur un autre ordinateur Linux exécutant Debian 12. Il doit s'agir de Debian 12, sinon certaines fonctionnalités échoueront.</p>
<p>3. Décidez <b>L'indicatif de votre nœud</b>.<p>N'utilisez pas de symboles ou de chiffres supplémentaires à ce stade. L'indicatif doit être de notation standard.</p>
<p>4. Si vous avez décidé d'installer EchoLink, préparez vos informations d'enregistrement.</p>
<p>5. Si vous souhaitez utiliser ModuleMetarInfo, l'application Météo Aéroportuaire, alors renseignez-vous sur les codes OACI, et découvrez les principaux aéroports autour de vous. Cela ne fonctionnera pas pour les aéroports qui ne fournissent pas de service météo en temps réel.</p>
<p>6. Si vous souhaitez explorer ModulePropagationMonitor, celui-ci pourra être installé ultérieurement.</p>
<b>N'oubliez pas de tout noter avant de continuer.</b>
<p>Tout le reste sera construit pour vous</p>
<h2>Démarrage de l'installation</h2>
<p>Le script compilera la configuration en cours au fur et à mesure. Il ne peut être exécuté qu'une seule fois, en raison de la nature du programme.</p>
<p>Accordez-vous une période ininterrompue de 30 minutes, pour répondre aux questions qui vous sont posées, et à l'installation qui l'accompagne.</p>
<p>Un Raspberry Pi 3 ou 4 prendra moins de temps, et un Raspberry Pi zéro peut-être un peu plus longtemps. Cependant, le Raspberry Pi Zero présentera un défi en raison de l'absence de prise USB externe.</p>
<p>Je n'ai PAS inclus l'installation du système audio waveshare, si vous utilisez une interface Pi-Hat.</p>
<p>J'espère qu'aucune erreur ne devrait être signalée. Je viens de terminer une construction sur un Raspberry Pi 3A du format de carte au nœud de travail en 25 minutes environ, sans erreur.</p>
<p>Pour l'utilisateur américain, les fichiers vocaux en_US seront extraits si vous sélectionnez « Anglais - États-Unis » dans le menu.</p>
<p>J'espère qu'il y aura quelqu'un qui pourra ajouter du code pour le portugais.</p>
<p>Lors de la compilation, vous serez informé de l'adresse IP active de votre nœud. Prenez-en note. Vous en aurez besoin pour continuer.</p>

<p>A la fin de la compilation, le système sera prêt à être utilisé. Vous pouvez maintenant « quitter » le terminal.</p>

<p>L'étape suivante consistera à ouvrir un navigateur Internet tel que « Chrome » ou « Firefox », à saisir l'adresse IP et à la saisir. Le tableau de bord s'affichera. Si votre carte son USB clignote, le nœud devrait être pleinement opérationnel.</p>

<h2> Dépannage </h2>

<p>Vous devrez comprendre le fichier svxlink.conf et savoir comment effectuer des ajustements pour le fonctionnement Simplex ou Répéteur. Dans tous les cas, vous devrez peut-être vous référer à la page principale de svxlink.org, ou à la page des utilisateurs de radio amateur svxlink sur Facebook, ou me contacter. Pour plus d’informations, consultez également les pages svxlink sur g4nab.co.uk. Dans le terminal, tapez 'man svxlink.conf' et la documentation intégrée s'affichera.</p>
<p>Pour arrêter l'exécution de svxlink, tapez dans le terminal <b>sudo systemctl stop svxlink.service</b> et pour le redémarrer, tapez <b>sudo systemctl restart svxlink.service</b> Vous pouvez également le faire si vous y êtes autorisé dans le tableau de bord dans le menu POWER. Vous n'avez à aucun moment besoin de redémarrer le système.</p>

<p>Si vous souhaitez modifier les fichiers Svxlink.conf, EchoLink, MetarInfo et NodeInfo, vous pouvez le faire, si autorisé, depuis le tableau de bord. L'enregistrement des modifications redémarre immédiatement le svxlink avec le nouveau paramètre, les nouvelles modifications s'affichant après un clic sur le bouton dans le tableau de bord.</p>
<p>Soyez prudent lors de l'édition, car modifier la structure peut entraîner l'échec du nœud. Cependant, une copie de la dernière configuration fonctionnelle peut être trouvée dans le dossier /var/www/html/backups avec une heure et une date.</p>
<p>Pour obtenir des informations sur node_info.json, accédez à un navigateur PC et entrez <b>http://svxportal-uk.ddns.net:81</b> où vous trouverez un tableau de bord.</p>
<p>Cliquez sur <b>S'inscrire</b> en haut pour compléter les informations. Ces informations sont conservées uniquement pour vous permettre de passer à l'étape suivante. Connectez-vous avec les informations que vous venez de fournir, cliquez sur <b>Mes Stations</b>, puis cliquez sur <b>Générer node_info.json</f></b>
<p>En complétant toutes les informations, <b>en ignorant</b> toute référence à CTCSS pour le moment, cela générera un fichier appelé node_info.json. Enregistrez-le dans un emplacement de votre ordinateur. Vous pourrez le copier et le coller ultérieurement dans le fichier du nœud.</p>
<p>Ouvrez le terminal du Raspberry Pi et tapez <b>cd /etc/svxlink</b> suivi de return. Tapez ensuite <b>sudo nano node_info.json</b> et modifiez les informations avec le contenu du fichier que vous venez d'enregistrer sur votre PC. Vous pouvez ouvrir le fichier avec un éditeur de texte ou un bloc-notes.</p>
<p>Dans le Raspberry Terminal ou dans le Dashboard si vous y avez ouvert le fichier NodeInfo, et supprimez tout le contenu. Accédez au Bloc-notes ou à l'éditeur de texte, sélectionnez-y tout le texte et copiez-le (cntrl-c). Mettez en surbrillance le terminal (ou la fenêtre du tableau de bord) et collez (cntrl-v). </p>
<p>Lorsque l'édition est terminée, tapez <b>cntrl-o</b> et revenez au clavier du terminal suivi de <b>cntrl-x</b>.</p>
<p>Dans le tableau de bord, utilisez simplement le bouton Enregistrer. Les nouvelles informations seront enregistrées dans le fichier du nœud.</p>

<p>Vérifiez le contenu et, surtout, complétez vos informations de localisation en bas du fichier. tapez <b>cntrl-o</b> et revenez ensuite <b>cntrl-x</b> lorsque vous avez terminé pour enregistrer vos modifications.</p>
<p>Si vous n'avez pas encore activé Echolink dans <b>svxlink.conf</b>, vous devrez peut-être le faire maintenant, et supprimez l'en-tête de commentaire <b>#</b> des lignes pertinentes en cliquant simplement sur sur la case à cocher. Vous pouvez le faire dans le configurateur Svxlink</p>
<p>Le redémarrage du svxlink.service est automatique lors de l'enregistrement des modifications.</b></p>
<p>N'apportez aucune modification au <b>gpio.conf</b>. Les anciennes méthodes d'ajout de la configuration gpio et de définition d'un démarrage de démon dans /etc/rc.local sont obsolètes (plus nécessaires). Nous utilisons GPIOD ou udev et ils sont définis dans les menus.</p>
<h2>EchoLink</h2>
<p>Pour modifier les informations Echolink, vous pouvez apporter vos modifications à votre configurateur EchoLink ici. puis enregistrez le fichier comme vous l'avez fait ci-dessus avec <b>svxlink.conf</b>.</p>
<p>Les règles habituelles s'appliquent avec les ports sortants de votre adresse IP RaspberryPi définie dans le routeur auquel vous êtes connecté</p>
<p>Vous ne pouvez configurer qu'un seul EchoLink sur votre propre adresse IP domestique.</p>
<p>Vous devrez configurer l'indicatif et le mot de passe avec lesquels vous vous êtes inscrit dans EchoLink.</p>
<p>Si vous n'avez pas configuré EchoLink pendant la phase de construction, vous pouvez l'ajouter à la ligne MODULES= dans la section [SimplexLogic] du configurateur Svxlink et vous devez inclure ModuleEchoLink dans la ligne. Pour l'utilisateur du répéteur, la même chose s'appliquera sauf que la ligne MODULES= sera dans [RepeaterLogic]</p>
<p>Enfin, l'étape importante consiste à définir le niveau audio correct. Ceci est maintenant défini à l'aide d'amixer dans le menu en haut.<p>
<p>Alsamixer ne peut pas être utilisé par le tableau de bord, nous nous adressons donc directement à amixer.</p>
<p> Pour de meilleurs résultats, réglez « Haut-parleur » sur environ 75, « Micro » sur 0, « Micro avec capture » sur 19-38 et « Gain automatique » doit être sur « OFF ». Ajustez simplement les valeurs dans le configurateur. </p>
<p>« Haut-parleur » est le volume de votre émetteur et « Micro avec capture » ​​est le volume du récepteur. C'est un peu contre-intuitif.</p>
<p>Passez une journée intéressante</p>

<p>73 - Chris G4NAB </p>
<p>Tout ce qui est présenté ici provient directement de la présentation originale de Tobias SM0SVX.</p>