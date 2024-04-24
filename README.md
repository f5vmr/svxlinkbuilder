# SvxlinkBuilder
<h1>Menu build for Raspberry Pi - Repeater or Hotspot node. EchoLink MetarInfo and SVXReflector Options</h1>
<h2> Pour l'instruction en Français, MELIRE.md. Para instrucción en español LÉAME.md.</h2>
<p>This SVXLink build presently contains a connection only to the <b>svxportal-uk (SvxReflector)</b> only . If this changes then so will this introduction.</p>
<p>The connection to the svxreflector provides connectivity using pseudo-talkgroups to other nodes and repeaters on the network. for more information select this link http://svxportal-uk.ddns.net:81.</p>
<b>Your First Steps</b>
<p>The Requirements: A Raspberry Pi of any mark, a USB Soundcard, and an interface card (or a modified USB Soundcard and no interface). One or two transceivers. An experience with Shell Commands will help, but is not essential.</p>
<p>If you are suitably experienced, you will be able to modify the installation once it is complete. But this system will provide you with a working system, and you can then modify it to your own needs.</p>
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
<p>Click <b>Register</b> at the top, completing the information. This information is held only to enable you to complete the next stage. Log in with the information you have just supplied, click on <b>My Stations</b>, and click on <b>Generate node_info.json</f></b>
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
<p>If you did not set up EchoLink during the building phase, then you will also need to modify two lines in /etc/svxlink/svxlink.conf again using 'sudo nano'. For the Simplex Node the first of the lines is within the [SimplexLogic] at MODULES= and you must include ModuleEchoLink within the line. For the Repeater user the same will apply except the MODULES= line will be in [RepeaterLogic]</p>
<p>Finally the important step is to set the correct level of audio. You must do this from the terminal, logging in to your node, and typing 'sudo alsamixer' at the prompt.<p>
<p>By using function cntrl-f5 you shold display all inputs and outputs within the table. You should have 'Headphone', 'Mic', 'Mic with capture' and 'Auto Gain Control'.</p>
<p> For best results, set 'Loudspeaker' to around 60, 'Mic' as 0 'Mic with Capture' at 19-25 and 'Autogain' should be muted. Highlight each with the arrow keys on the keyboard. Mute 'Autogain' using the 'M' key. </p>
<p>'Loudspeaker' is your transmitter volume, and 'Mic with capture' is the volume from the receiver. It is a little confusing.</p>
<p>Everything introduced here is directly from the original presentation by Tobias SM0SVX.</p>


