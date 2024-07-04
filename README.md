# SvxlinkBuilder
<h1>Menu build for Raspberry Pi - Repeater or Hotspot node. EchoLink MetarInfo and SVXReflector Options</h1>
<h2> Pour l'instruction en Français, README_FR.md. Para instrucción en español README_ES.md.</h2>
<h3>Introduction</h3>
<p>This SVXLink build presently contains a connection only to the <b>svxportal-uk (SvxReflector)</b> only . If this changes then so will this introduction. You can leave it without, and install an svxreflector later through the Dashboard.</p>
<p>The connection to the svxreflector provides connectivity using pseudo-talkgroups to other nodes and repeaters on the network. for more information select this link http://svxportal-uk.ddns.net:81.</p>
<h3>Your First Steps</h3>
<p><b>The Requirements:</b> A Raspberry Pi of any mark, a USB Soundcard, and an interface card (or a modified USB Soundcard and no interface). One or two transceivers. Experience with Shell Commands will help, but is not essential.</p>
<p>If you are suitably experienced, you will be able to modify the installation once it is complete. But this system will provide you with a working system, and you can then modify it to your own needs should you want to.</p>
<p>There are very few other raspberry images that work succesfully for this type of build, where there is a potential for using the application in several directions. An image is fixed, leaving you with a lot of puzzling. This is not an image, but a menu-driven easy build.</p>
<p>This New SVXLINKBUILDER uses an apt install, especially created to avoid the long and tedious approach of a compilation.</p>

<h2>Always use Raspberry OS Bookworm Lite (Debian 12) 32 Bit then you won't go wrong.</h2>
<p>Using Raspberry Pi Imager, select the Raspberry Pi OS (32-bit) Lite image. But ensure your user name is 'pi' and nothing else.</p>
<p>The Imager will also allow you to configure your password, and WiFi if required. Ensure that the tab permitting SSH is enabled.</p>
<h3>Before running the software</h>
<p>There are a number of available interface boards that have a variety of uses, either as a hotspot or a repeater, or even a fill-in receiver/transceiver for an existing SVXLink repeater. The settings in this build are for a homebrew interface board using GPIOD 23/17/8 for the Receive COS and GPIOD 24/18/7 for the PTT controller, or alternative a fully modified CM-108 that can use 'udev' and drive the PTT and COS from the modification components. There is an also intermediate version for the CM-108 where only the transmit modification has been done that will you use 'udev' for the transmit, and give you options for the receive GPIOD 23/17/8. There is also an option for your own GPIO port selection.</p>
<p>When using the GPIO and GPIOD Pins, an earth pin is also require, so using this combination for example, pins 14,16 and 18 are all adjacent and ideally placed for these functions. Pin 14 is the Earth, Pin 16 is GPIO 23 and Pin 18 is GPIO 24.</p>
<p>For a second set of transceivers, you can consider GPIO 17 and 18 as COS & PTT for those.</p> 
<p>A copy of the design for an interface can be found on g4nab.co.uk. There is also a link to a web page showing the modification instructions for a CM-108 USB Sound Card.</p>
<h2>The programming of the SDCard</h2>

<p>As discussed, start with a download of <b>Raspberry OS Bookworm Lite</b> from RaspberryPi.org. Use a 8 or 16 GB MicroSD Card and transfer the image to the card, best using the <b>Raspberry Pi Image builder</b> from the same source. <b> You MUST make the user 'pi' - PLEASE DO NOT DEVIATE from this advice, as you will get issues. </b> You can however use your own password. There are versions of Raspberry Pi Imager for all operating systems. It allows for full WiFi usage. Do not forget the SSH tab in 'Services'.</p> 
<p>In the first box <b>device</b> select 'No Filtering'</p>
<p>In the second box <b>Choose OS</b> select 'Raspberry Pi OS (Other)' then 'Raspberry Pi Os 32 Bit' under which you will see 'Debian Bookworm with no desktop environment'. Select this</p>
<p>Now select <b>Choose Storage</b> where you will be invited to select the sdcard.</p>
<p>In <b>Next</b> Complete the 'edit' box, but <b>pi</b> must be the user. If this is not correct, then your install will fail. You can have any password you like.</p>
<p>You can set your Wi-Fi settings here if your wish.</p>
<b>Always check the SSH box on the second tab of the next box, otherwise that will also cause your installation to fail.</b>  you can use a password or set a key if you wish.</p> 

<p>Once complete, eject the card and install it in the raspberry pi and power it up. Enter the user <b>pi</b> and your password.</p> 
<h2>The Build</h2>
<b>Do Not update/upgrade the system at this stage.</b>
<p>This script will install a dummy sound card for the use of Darkice and Icecast2.</p> 
<p>Step 1: <b>sudo apt-get install -y git</b> as without this you cannot download from the GitHub.</p>  

<p>Step 2: <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b> .</p>
<p>Step 3: <b>./svxlinkbuilder/preinstall.sh</b> </p>
<p>You need no input at this stage, until the system shutsdown for a reboot. It will take a while to complete - 20 - 30 minutes.</p>
<p>Step 4: <b>./svxlinkbuilder/install.sh</b> </p>
<p>Here you will be required to respond to a number of questions in the menu.</p>

<p>They will guide you through the installation, all the way to run-time.</p>
<b>You will need to know before you begin</b> 
<p>1. The status of your transceiver, whether the PTT and COS are Active High or Active Low.</p>
<p>2. The status and type of your USB soundcard, modified, partly modified or unmodified. With a fully modified usb soundcard, there is no reason that would prevent this installation on another Linux based computer running Debian 12. It has to be Debian 12, or some of the features will fail.</p>
<p>3. Decide <b>The callsign of your node</b>.<p>Do not use additional symbols or numbers at this stage. The callsign should be of standard notation.</p>
<p>4. If you have decided to install EchoLink, then have ready your registration information.</p> 
<p>5. If you wish to use ModuleMetarInfo, the Airport Weather application, then read about the ICAO codes, and discover the major airports around you. It will not work for airports that do not provide a weather service in real time.</p>
<p>6. If you wish to explore the ModulePropagationMonitor, then this can be installed later.</p>
<b>Remember note everything down before you proceed.</b>
<p>Everything else will be constructed for you</p>
<h2>Beginning the install</h2>
<p>The script will compile the running configuration as you proceed. It can only be run once, due to the nature of the program.</p>
<p>Allow yourself an uninterupted period of 30 minutes, to answer the questions put to you, and the accompanying install.</p>
<p>A Raspberry Pi 3 or 4 will take less time, and a Raspberry Pi zero possibly slightly longer. However the Raspberry Pi Zero will present a challenge due to the lack of an external USB socket.</p> 
<p>I have NOT included the installation of the waveshare sound system, if you are using a Pi-Hat interface.</p> 
<p>Hopefully there should be no reported error. I have just completed a build on a raspberry pi 3A from card format to working node in about 25 minutes, with no errors.</p>
<p>For the American User, the en_US Voice files will be pulled if you select 'English - USA' from the menu.</p>
<p>I hope that there will be someone out there that can add to the code for Portuguese.</p>
<p>During the compilation, you will be notified of the Active IP Address of your node. Make a note of it. You will need it to proceed.</p>

<p>At the end of the compilation, the system will ready to use. You may now 'exit' the terminal.</p>

<p>The next step will be to open an internet browser such as 'Chrome' or 'Firefox' and type in the IP Address and enter. The dashboard will be displayed. If your USB soundcard is flashing then the node should be fully operational.</p>

<h2> Troubleshooting </h2>

<p>You will need to understand the svxlink.conf file and how to make adjustments for Simplex or Repeater operation. In any case you may need to refer to the svxlink.org main page, or svxlink amateur radio users page on facebook, or contact me. For further information also consult the svxlink pages on g4nab.co.uk. In the terminal, type 'man svxlink.conf' and the on-board documentation will be displayed.</p>

<p>To stop svxlink running type in the terminal <b>sudo systemctl stop svxlink.service</b> and to restart it type <b>sudo systemctl restart svxlink.service</b> You can also do this if authorised in the Dashboard at the POWER menu. You do not need to reboot the system at any time.</p>

<p>If you wish to modify the Svxlink.conf, EchoLink, MetarInfo and NodeInfo files, you can do so, if authorised, from the dashboard. Saving the changes immediately restarts the svxlink with the new setting, with the new changes show after a click on the button in the dashboard.</p>
<p>Be careful whilst editing, as to change the structure, can cause the node to fail. However a copy of the last working configuration can be found in the /var/www/html/backups folder with a time and date.</p>
<p>To obtain information for the node_info.json go to a PC Browser and enter <b>http://svxportal-uk.ddns.net:81</b> where you will find a dashboard.</p>
<p>Click <b>Register</b> at the top, completing the information. This information is held only to enable you to complete the next stage. Log in with the information you have just supplied, click on <b>My Stations</b>, and click on <b>Generate node_info.json</f></b>
<p>By completing all the information, <b>ignoring</b> any reference to CTCSS at this time, this will generate a file called node_info.json. Save it in a location in your computer. You can copy and paste from it later to the file in the node.</p>
<p>Open the terminal of the Raspberry Pi, and type <b>cd /etc/svxlink</b> followed by return. Then type <b>sudo nano node_info.json</b> and edit the information with the content of the file you have just saved on your PC. You can open the file with a text editor or notepad.</p>
<p>In the Raspberry Terminal or in the Dashboard if you have opened the NodeInfo file there, and delete all the contents. Go to the Notepad or text Editor and select all the text there, and copy (cntrl-c). Highlight the terminal (or the dashboard window) and paste (cntrl-v). </p>
<p>When the editing is complete type <b>cntrl-o</b> and return at the keyboard for the terminal followed by <b>cntrl-x</b>.</p>
<p>In the Dashboard, simply use the save button. The new information will be saved to the file in the node.</p>

<p>Check the content and importantly complete your location information near the bottom of the file. type <b>cntrl-o</b> and return then <b>cntrl-x</b> when finished to save your changes.</p>
<p>If you have not yet enabled Echolink in the <b>svxlink.conf</b> to may need to do this now, and remove the <b>#</b> comment header from the relevant lines simply by clicking on the check box. You can do this in the Svxlink Configurator</p>
<p>The restart of the svxlink.service is automatic on saving changes.</b></p>
<p>Do not make changes to the <b>gpio.conf</b>. The old methods of adding the gpio configuration and setting a daemon start in /etc/rc.local are deprecated (no longer required). We are using GPIOD or udev and they are set in the menus.</p>
<h2>EchoLink</h2>
<p>To modify the Echolink information, you can make your changes to your EchoLink Configurator here. then save the file as you did above with <b>svxlink.conf</b>.</p>
<p>The usual rules apply with the outgoing ports for your RaspberryPi IP address set in the Router to which you are connected</p>
<p>You can only have one EchoLink set up on your own home IP Address.</p>
<p>You will need to set up the callsign and password with which you registered in EchoLink.</p>
<p>If you did not set up EchoLink during the building phase, then you can add it the MODULES= line in the [SimplexLogic] section of the Svxlink Configurator and you must include ModuleEchoLink within the line. For the Repeater user the same will apply except the MODULES= line will be in [RepeaterLogic]</p>
<p>Finally the important step is to set the correct level of audio. This is now set using amixer in the menu at the top.<p>
<p>Alsamixer cannot be used by the dashboard so instead we address the amixer directly.</p>
<p> For best results, set 'Loudspeaker' to around 75, 'Mic' as 0 'Mic with Capture' at 19-38 and 'Autogain' should be 'OFF'. Simply adjust the values in the Configurator. </p>
<p>'Loudspeaker' is your transmitter volume, and 'Mic with capture' is the volume from the receiver. It is a little contra-intuitive.</p>
<p>Have an interesting day</p>

<p>73 - Chris G4NAB </p>
<p>Everything introduced here is directly from the original presentation by Tobias SM0SVX.</p>


