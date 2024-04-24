# svxlinkbuilder - en Français
<b><h2>Français - Mes Excuses, pour la vitesse, les pluparts sont grâce à Google Translate. </h2></b>
<p>Cette version de SVXLink contient actuellement une connexion au <b>svxportal-uk (SvxReflector)</b> uniquement. Si cela change, cette introduction changera également. Le réseau RRF n'est pas compatible avec ce méthode. C'était construit avec l'ancien protocole. </p>
<p>La connexion au svxreflector assure la connectivité à l'aide de pseudo-groupes de discussion vers d'autres nœuds et répéteurs du réseau. pour plus d'informations, sélectionnez ce lien http://svxportal-uk.ddns.net:81.</p>
<b>Vos premiers pas</b>
<p>Les exigences : un Raspberry Pi de n'importe quelle marque, une carte son USB et une carte d'interface (ou une carte son USB modifiée et sans interface). Un ou deux émetteurs-récepteurs. Une expérience avec les commandes Shell sera utile, mais n'est pas essentielle. Certainement c'est bien possible que un Orange Pi, ou Banana Pi sera compatible.</p>
<p>Si vous disposez de l'expérience nécessaire, vous pourrez modifier l'installation une fois celle-ci terminée. Mais ce système vous fournira un système fonctionnel, et vous pourrez ensuite le modifier selon vos propres besoins.</p>
<p>Il existe très peu d'autres images Raspberry qui fonctionnent avec succès pour ce type de build, où il existe un potentiel d'utilisation de l'application dans plusieurs directions.</p>
<p>Bien qu'il ne s'agisse pas en soi d'une image, cela simplifiera le travail de compilation physique, même si cela peut vous laisser un peu de travail à faire si vous devez modifier vos spécifications immédiates.</p>
<h2>Utilisez toujours Raspberry OS Bookworm Lite (Debian 12) 32 bits, vous ne vous tromperez pas.</h2>
<p>Il existe un certain nombre de cartes d'interface disponibles qui ont diverses utilisations, soit comme point d'accès, soit comme répéteur, ou même comme récepteur/émetteur-récepteur de remplacement pour un répéteur SVXLink existant. Les paramètres de cette version concernent une carte d'interface homebrew utilisant GPIOD 23/17/8 pour le COS de réception et GPIOD 24/18/7 pour le contrôleur PTT, ou une alternative à un CM-108 entièrement modifié qui peut utiliser 'udev' et piloter. le PTT et le COS à partir des composants de modification. Il existe également une version intermédiaire pour le CM-108 où seule la modification de transmission a été effectuée : vous utiliserez 'udev' pour la transmission et vous donnerez des options pour la réception GPIOD 23/17/8.</p>
<p>Lors de l'utilisation des broches GPIO et GPIOD, une broche de terre est également requise. Ainsi, en utilisant cette combinaison, les broches 14, 16 et 18 sont toutes adjacentes et idéalement placées pour ces fonctions. La broche 14 est la Terre, la broche 16 est le GPIO 23 et la broche 18 est le GPIO 24.</p>
<p>Pour un deuxième ensemble d'émetteurs-récepteurs, vous pouvez considérer les GPIO 17 et 18 comme COS et PTT pour ceux-ci.</p>
<p>Une copie du design peut être trouvée sur g4nab.co.uk. Il existe également une page montrant les instructions de modification pour une carte son USB CM-108.</p>
<h2>La programmation de la SDCard</h2>

<p>Comme indiqué, commencez par télécharger <b>Raspberry OS Bookworm Lite</b> depuis RaspberryPi.org. Utilisez ensuite une carte MicroSD de 8 ou 16 Go et transférez l'image sur la carte, de préférence en utilisant le <b>Raspberry Pi Image builder</b> de la même source. <b> Vous DEVEZ définir l'utilisateur « pi » - veuillez ne pas vous écarter de mes conseils ci-dessus, car vous rencontrerez des problèmes. </b> Vous pouvez cependant utiliser votre propre mot de passe. Il existe des versions de Raspberry Pi Imager pour tous les systèmes d'exploitation. Il permet une utilisation complète du WiFi.</p>
<p>Dans la première case <b>périphérique</b>, sélectionnez « Aucun filtrage »</p>
<p>Dans la deuxième case <b>Choisir le système d'exploitation</b>, sélectionnez « Raspberry Pi OS (Autre) » puis « Raspberry Pi Os 32 Bit » sous lequel vous verrez « Debian Bookworm sans environnement de bureau ». Sélectionnez ceci</p>
<p>Sélectionnez maintenant <b>Choisir le stockage</b> où vous serez invité à sélectionner la carte SD.</p>
<p>Dans <b>Suivant</b> Remplissez la case « modifier », mais <b>pi</b> doit être l'utilisateur. Si ce n'est pas correct, votre installation échouera. Vous pouvez avoir le mot de passe de votre choix.</p>
<p>Vous pouvez définir vos paramètres Wi-Fi ici si vous le souhaitez.</p>
<b>Cochez toujours la case SSH dans le deuxième onglet de la case suivante, sinon cela entraînera également l'échec de votre installation.</b> vous pouvez utiliser un mot de passe ou définir une clé si vous le souhaitez.</p>

<p>Une fois terminé, éjectez la carte, installez-la dans le Raspberry Pi et allumez-la. Entrez l'utilisateur <b>pi</b> et votre mot de passe.</p>
<h2>La compilation</h2>
<p>Ce script installera également une carte son factice pour l'utilisation de Darkice et Icecast2.</p>
<p>La première étape sera la commande suivante : <b>sudo apt-get install -y git</b> car sans cela, vous ne pouvez pas télécharger depuis GitHub.</p>

<p>Maintenant, la commande suivante : <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>
<p>Les menus affichés vous guideront tout au long de l'installation, jusqu'à l'exécution. <b>Vous aurez besoin de connaître avant de commencer</b> l'état de votre émetteur-récepteur, si le PTT et le COS sont Active High ou Active Low, l'état et le type de votre carte son USB, modifiée, partiellement modifiée ou non modifiée. Avec une carte son USB entièrement modifiée, il n'y a aucune raison qui empêcherait cette installation sur un autre ordinateur Linux exécutant Debian 12. Il doit s'agir de Debian 12, sinon certaines fonctionnalités échoueront. Décidez également de l'indicatif de votre nœud. N'utilisez pas de symboles ou de chiffres supplémentaires à ce stade. L'indicatif doit être de notation standard. Si vous avez décidé d'installer EchoLink, préparez vos informations d'enregistrement. Si vous souhaitez utiliser ModuleMetarInfo, l'application Météo Aéroportuaire, alors renseignez-vous sur les codes OACI, et découvrez les principaux aéroports autour de vous. Cela ne fonctionnera pas pour les aéroports qui ne fournissent pas de service météo en temps réel. Si vous souhaitez explorer ModulePropagationMonitor, celui-ci pourra être installé ultérieurement. N'oubliez pas de tout noter avant de continuer.</p>
<p>Tout le reste sera construit pour vous</p>
<h2>Démarrage de l'installation</h2>
<p>Le script compilera la configuration en cours au fur et à mesure. Il ne peut être exécuté qu'une seule fois, en raison de la nature du programme. Accordez-vous une période ininterrompue d'1 heure, pour répondre aux questions qui vous sont posées, et à l'installation qui l'accompagne. <b>N'oubliez pas de noter tous les « noms d'utilisateur et mots de passe » que vous fournissez</b>. Un Raspberry Pi 3 ou 4 prendra moins de temps, et un Raspberry Pi zéro peut-être plus de 90 minutes. Cependant, le Raspberry Pi Zero présentera un défi en raison de l'absence de prise USB externe. Je n'ai PAS inclus l'installation du système audio waveshare, si vous utilisez une interface Pi-Hat. Espérons qu'aucune erreur ne soit signalée. Je viens de terminer une construction sur un Raspberry Pi 3A du format carte au nœud de travail en 50 minutes, sans erreur.</p>
<p>Pour l'utilisateur américain, les fichiers vocaux en_US seront extraits si vous sélectionnez « Anglais - États-Unis » dans le menu.</p>
<p>J'espère qu'il y aura quelqu'un qui pourra ajouter du code pour l'espagnol ou le portugais.</p>
<h2>Nous commençons</h2>
<p>Tapez la commande suivante à l'invite actuelle : <b>./svxlinkbuilder/preinstall.sh</b> Le système redémarrera donc connectez-vous à nouveau comme avant.</p>
<p>Tapez la commande suivante <b> ./svxlinkbuilder/install.sh</b> REMARQUE spéciale - <b>Pas de sudo ici dans ces commandes.</b></p>
<p>Suivez les menus et saisissez les informations requises, qui auraient dû être notées, pour vous aider avant d'exécuter le programme.</p>
<p>Lors de la compilation, vous serez informé de l'adresse IP active de votre nœud. Prenez-en note. Vous en aurez besoin pour continuer.</p>

<p>À la fin de la compilation, le système redémarrera automatiquement, ce dont vous serez informé.</p>

<p>L'étape suivante consistera à ouvrir un navigateur Internet tel que « Chrome », à saisir l'adresse IP et à la saisir. Le tableau de bord s'affichera. Si votre carte son USB clignote, le nœud devrait être pleinement opérationnel.</p>
<h2> Dépannage </h2>

<p>Vous devrez comprendre le fichier svxlink.conf et savoir comment effectuer des ajustements pour le fonctionnement Simplex ou Répéteur. Dans tous les cas, vous devrez peut-être vous référer à la page principale de svxlink.org, ou à la page des utilisateurs de radio amateur svxlink sur Facebook, ou me contacter. Pour plus d’informations, consultez également les pages svxlink sur g4nab.co.uk. Dans le terminal, tapez 'man svxlink.conf' et la documentation intégrée s'affichera.</p>

<p>Pour arrêter l'exécution de svxlink, tapez dans le terminal <b>sudo systemctl stop svxlink.service</b> et pour le redémarrer, tapez <b>sudo systemctl restart svxlink.service</b> Vous pouvez également le faire si vous y êtes autorisé dans le tableau de bord.</p>

<p>Si vous souhaitez modifier les fichiers Svxlink.conf, EchoLink, MetarInfo et NodeInfo, vous pouvez le faire, si vous y êtes autorisé, depuis le tableau de bord.</p>
<p>Soyez prudent lors de l'édition, car modifier la structure peut entraîner l'échec du nœud. Cependant, une copie de la dernière configuration de travail peut être trouvée dans le dossier /etc/svxlink avec une heure et une date, ou dans le cas d'EchoLink et MetarInfo dans le dossier /etc/svxlink/svxlink.d.</p>
<p>Pour obtenir des informations sur node_info.json, accédez à un navigateur PC et entrez <b>http://svxportal-uk.ddns.net:81</b> où vous trouverez un tableau de bord.</p>
<p>Cliquez sur <b>S'inscrire</b> en haut pour compléter les informations. Ces informations sont conservées uniquement pour vous permettre de passer à l'étape suivante. Connectez-vous avec les informations que vous venez de fournir, cliquez sur <b>Mes stations</b>, puis cliquez sur <b>Générer node_info.json</f></b>
<p>En complétant toutes les informations, <b>en ignorant</b> toute référence à CTCSS pour le moment, cela générera un fichier appelé node_info.json. Enregistrez-le dans un emplacement de votre ordinateur. Vous pourrez le copier et le coller ultérieurement dans le fichier du nœud.</p>
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
<h2>EchoLink</h2>
<p>Les règles habituelles s'appliquent avec les ports sortants de votre adresse IP RaspberryPi définie dans le routeur auquel vous êtes connecté</p>
<p>Vous ne pouvez configurer qu'un seul EchoLink sur votre propre adresse IP domestique.</p>
<p>Vous devrez configurer l'indicatif et le mot de passe avec lesquels vous vous êtes inscrit dans EchoLink. Ceci se trouve dans le fichier /etc/svxlink/svxlink.d/ModuleEchoLink.conf. Vous modifiez le fichier avec la commande 'sudo nano' précédant le nom du fichier, y compris les informations sur le répertoire.</p>
<p>Si vous n'avez pas configuré EchoLink pendant la phase de construction, vous devrez également modifier à nouveau deux lignes dans /etc/svxlink/svxlink.conf en utilisant 'sudo nano'. Pour le nœud Simplex, la première des lignes se trouve dans [SimplexLogic] à MODULES= et vous devez inclure ModuleEchoLink dans la ligne. Pour l'utilisateur du répéteur, la même chose s'appliquera sauf que la ligne MODULES= sera dans [RepeaterLogic]</p>
<p>Enfin, l'étape importante consiste à définir le niveau audio correct. Vous devez le faire depuis le terminal, en vous connectant à votre nœud et en tapant « sudo alsamixer » à l'invite.<p>
<p>En utilisant la fonction cntrl-f5, vous devez afficher toutes les entrées et sorties dans le tableau. Vous devriez avoir « Casque », « Micro », « Micro avec capture » et « Contrôle automatique du gain ».</p>
<p> Pour de meilleurs résultats, réglez « Haut-parleur » sur environ 60, « Micro » sur 0, « Micro avec capture » sur 19-25 et « Gain automatique » doit être désactivé. Mettez chacun en surbrillance avec les touches fléchées du clavier. Désactivez « Autogain » à l'aide de la touche « M ». </p>
<p>« Haut-parleur » est le volume de votre émetteur et « Micro avec capture » est le volume du récepteur. C'est un peu déroutant.</p>
<p>Tout ce qui est présenté ici provient directement de la présentation originale de Tobias SM0SVX.</p>
