#SvxlinkBuilder
<h1>Creación de menú para Raspberry Pi: nodo repetidor o punto de acceso. Opciones de EchoLink MetarInfo y SVXReflector</h1>
<h2> Para instrucciones en francés, README_FR.md. Para instrucciones en inglesa README.md.</h2>
<h3>Introducción</h3>
<p>Esta compilación de SVXLink actualmente contiene una conexión solo con <b>svxportal-uk (SvxReflector)</b> únicamente. Si esto cambia, también lo hará esta introducción. Puedes dejarlo sin e instalar un svxreflector más tarde a través del Panel.</p>
<p>La conexión al svxreflector proporciona conectividad mediante pseudogrupos de conversación a otros nodos y repetidores de la red. Para obtener más información, seleccione este enlace http://portal.svxlink.uk:81.</p>
<p>Esta compilación ahora contiene un tiempo de espera automático de tres minutos para los usuarios de RF. Esto es para educar a los usuarios para que eviten que sus discursos sean demasiado largos.</p>
<p>Este mecanismo de tiempo de espera no bloquea al usuario mientras habla, sino que superpone una serie de pitidos con la emisión, que finalizan cuando el hablante suelta el PTT. El mecanismo de silenciamiento detecta esto y envía un "Tiempo de espera" verbalmente en la transmisión, antes de emitir una "K" para el uso continuado del repetidor.</p>
<h3>Tus primeros pasos</h3>
<p><b>Los requisitos:</b> Una Raspberry Pi de cualquier marca, una tarjeta de sonido USB y una tarjeta de interfaz (o una tarjeta de sonido USB modificada y sin interfaz). Uno o dos transceptores. La experiencia con los comandos de Shell ayudará, pero no es esencial.</p>
<p>Si tiene la experiencia adecuada, podrá modificar la instalación una vez completada. Pero este sistema le proporcionará un sistema que funcione y luego podrá modificarlo según sus propias necesidades si así lo desea.</p>
<p>Hay muy pocas imágenes de Raspberry que funcionen con éxito para este tipo de compilación, donde existe la posibilidad de utilizar la aplicación en varias direcciones. Se fija una imagen, lo que te deja con muchos desconcertantes. Esto no es una imagen, sino una construcción sencilla basada en menús.</p>
<p>Este nuevo SVXLINKBUILDER utiliza una instalación adecuada, especialmente creada para evitar el proceso largo y tedioso de una compilación.</p>
<h2>Utilice siempre Raspberry OS Bookworm Lite (Debian 12) de 32 bits y no se equivocará.</h2>
<p>Utilizando Raspberry Pi Imager, seleccione la imagen Lite del sistema operativo Raspberry Pi (32 bits). Pero asegúrese de que su nombre de usuario sea 'pi' y nada más.</p>
<p>La cámara también le permitirá configurar su contraseña y WiFi si es necesario. Asegúrese de que la pestaña que permite SSH esté habilitada.</p>
<h3>Antes de ejecutar el software</h>
<p>Hay varias placas de interfaz disponibles que tienen una variedad de usos, ya sea como punto de acceso o repetidor, o incluso como receptor/transceptor de relleno para un repetidor SVXLink existente. Las configuraciones en esta compilación son para una placa de interfaz casera que usa GPIOD 23/17/8 para recibir COS y GPIOD 24/18/7 para el controlador PTT, o alternativamente un CM-108 completamente modificado que puede usar 'udev' y conducir el PTT y COS de los componentes de modificación. También hay una versión intermedia para el CM-108 donde solo se ha realizado la modificación de transmisión que usará 'udev' para la transmisión y le brindará opciones para la recepción GPIOD 23/17/8. También hay una opción para su propia selección de puerto GPIO.</p>
<p>Cuando se utilizan los pines GPIO y GPIOD, también se requiere un pin de tierra, por lo que al usar esta combinación, por ejemplo, los pines 14, 16 y 18 son todos adyacentes y están ubicados idealmente para estas funciones. El pin 14 es la Tierra, el pin 16 es GPIO 23 y el pin 18 es GPIO 24.</p>
<p>Para un segundo conjunto de transceptores, puede considerar GPIO 17 y 18 como COS y PTT para ellos.</p>
<p>Puede encontrar una copia del diseño de una interfaz en g4nab.co.uk. También hay un enlace a una página web que muestra las instrucciones de modificación para una tarjeta de sonido USB CM-108.</p>
<h2>La programación de la tarjeta SD</h2>

<p>Como se mencionó anteriormente, comience con una descarga de <b>Raspberry OS Bookworm Lite</b> desde RaspberryPi.org. Utilice una tarjeta MicroSD de 8 o 16 GB y transfiera la imagen a la tarjeta; lo mejor es utilizar el <b>Raspberry Pi Image Builder</b> de la misma fuente. <b> DEBE convertir el usuario en 'pi'. NO SE DESVÍE de este consejo, ya que tendrá problemas. </b> Sin embargo, puedes utilizar tu propia contraseña. Existen versiones de Raspberry Pi Imager para todos los sistemas operativos. Permite el uso completo de WiFi. No olvides la pestaña SSH.</p>
<p>En el primer cuadro <b>dispositivo</b> seleccione 'Sin filtrado'</p>
<p>En el segundo cuadro <b>Elija SO</b> seleccione 'Raspberry Pi OS (Otro)' y luego 'Raspberry Pi Os 32 Bit' debajo del cual verá 'Debian Bookworm sin entorno de escritorio'. Selecciona esto</p>
<p>Ahora seleccione <b>Elegir almacenamiento</b> donde se le invitará a seleccionar la tarjeta SD.</p>
<p>En <b>Siguiente</b> Complete el cuadro 'editar', pero <b>pi</b> debe ser el usuario. Si esto no es correcto, la instalación fallará. Puedes tener la contraseña que quieras.</p>
<p>Puedes configurar tu configuración de Wi-Fi aquí si lo deseas.</p>
<b>Siempre marque la casilla SSH en la segunda pestaña del cuadro siguiente; de ​​lo contrario, eso también provocará que la instalación falle.</b> puede usar una contraseña o establecer una clave si lo desea.</p>
<p>Una vez completado, expulse la tarjeta, instálela en la Raspberry Pi y enciéndala. Introduce el usuario <b>pi</b> y tu contraseña.</p>
<h2>Los usuarios de una tarjeta usvxcard y la tarjeta udracard de Juan Hagen F8ASB deben seguir este paso adicional antes de la compilación. Los demás usuarios saltan al siguiente párrafo.</h2>
<p>Primero ejecute sudo apt update && sudo apt upgrade -y antes de continuar, luego sudo apt install -y git</p>
<p>Utilizando sudo raspb-config en la terminal, asegúrese de que tanto la interfaz serial como el i2C estén habilitados.</p>
<p>Reinicie el sistema y vuelva a iniciar sesión como usuario <b>pi</b> y ejecute los siguientes comandos en la terminal:</p>
<p>sudo nano /boot/firmware/config.txt</p>
<p>Agregue las siguientes líneas al final del archivo:</p>
<p>dtoverlay=pi3-miniuart-bt</p>
<p>enable_uart=1</p>
<p>sudo reboot</p>
<p>Inicie sesión nuevamente como el usuario <b>pi</b> y ejecute los siguientes comandos en la terminal:</p>
<p>git clone https://github.com/HinTak/seeed-voicecard</p>
<p>cd seeed-voicecard</p>
<p>git checkout v6.6</p>
<p>sudo ./install.sh</p>
<p>Esto instalará los controladores de audio para la tarjeta usvxcard y la tarjeta udracard.</p>
<p>Ahora puede continuar con el siguiente paso.</p>
<p>Habrá un paso más para programar la tarjeta SA818, luego de finalizar la instalación.</p>
<h2>La construcción</h2>
<b>No actualice el sistema en esta etapa.</b>
<p>Este script también instalará una tarjeta de sonido ficticia para el uso de Darkice y Icecast2.</p>
<p>Paso 1: <b>sudo apt-get install -y git</b> ya que sin esto no puedes descargar desde GitHub.</p>

<p>Paso 2: <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b>.</p>
<p>Paso 3: <b>./svxlinkbuilder/preinstall.sh</b> </p>
<p>No necesita ninguna información en esta etapa, hasta que el sistema se apague para reiniciarlo. Tardará un poco en completarse: entre 20 y 30 minutos.</p>
<p>Paso 4: <b>./svxlinkbuilder/install.sh</b> </p>
<p>Aquí se le pedirá que responda a una serie de preguntas en el menú.</p>

<p>Le guiarán a través de la instalación, hasta el tiempo de ejecución.</p>
<b>Necesitarás saberlo antes de comenzar</b>
<p>1. El estado de su transceptor, ya sea que el PTT y el COS estén activos altos o activos bajos.</p>
<p>2. El estado y tipo de su tarjeta de sonido USB, modificada, parcialmente modificada o sin modificar. Con una tarjeta de sonido USB completamente modificada, no hay ninguna razón que impida esta instalación en otra computadora basada en Linux que ejecute Debian 12. Tiene que ser Debian 12, o algunas de las funciones fallarán.</p>
<p>3. Decide <b>El indicativo de tu nodo</b>.<p>No utilices símbolos o números adicionales en esta etapa. El indicativo debe ser de notación estándar.</p>
<p>4. Si ha decidido instalar EchoLink, tenga lista su información de registro.</p>
<p>5. Si desea utilizar ModuleMetarInfo, la aplicación Airport Weather, lea sobre los códigos OACI y descubra los principales aeropuertos a su alrededor. No funcionará para aeropuertos que no proporcionen un servicio meteorológico en tiempo real.</p>
<p>6. Si desea explorar ModulePropagationMonitor, puede instalarlo más tarde.</p>
<b>Recuerde anotar todo antes de continuar.</b>
<p>Todo lo demás será construido para ti</p>
<h2>Comenzando la instalación</h2>
<p>El script compilará la configuración en ejecución a medida que avance. Sólo se puede ejecutar una vez, debido a la naturaleza del programa.</p>
<p>Permítase un período ininterrumpido de 30 minutos para responder las preguntas que le hagan y la instalación adjunta.</p>
<p>Una Raspberry Pi 3 o 4 tardará menos, y una Raspberry Pi zero posiblemente un poco más. Sin embargo, Raspberry Pi Zero presentará un desafío debido a la falta de una toma USB externa.</p>
<p>NO he incluido la instalación del sistema de sonido waveshare, si estás utilizando una interfaz Pi-Hat.</p>
<p>Esperemos que no se informe de ningún error. Acabo de completar una compilación en una raspberry pi 3A desde el formato de tarjeta hasta el nodo de trabajo en aproximadamente 25 minutos, sin errores.</p>
<p>Para el usuario estadounidense, los archivos de voz en_US se extraerán si selecciona 'Inglés - EE. UU.' en el menú.</p>
<p>Espero que haya alguien que pueda agregar algo al código para portugués.</p>
<p>Durante la compilación, se le notificará la dirección IP activa de su nodo. Toma nota de ello. Lo necesitarás para continuar.</p>
<p>Al final de la compilación, el sistema estará listo para usar. Ahora puedes "salir" de la terminal.</p>

<p>El siguiente paso será abrir un navegador de Internet como 'Chrome' o 'Firefox', escribir la dirección IP e ingresar. Se mostrará el tablero. Si su tarjeta de sonido USB parpadea, entonces el nodo debería estar completamente operativo.</p>

<h2> Solución de problemas </h2>

<p>Necesitará comprender el archivo svxlink.conf y cómo realizar ajustes para la operación Simplex o Repetidora. En cualquier caso, es posible que necesites consultar la página principal de svxlink.org, o la página de usuarios de radioaficionados de svxlink en Facebook, o contactarme. Para obtener más información, consulte también las páginas de svxlink en g4nab.co.uk. En la terminal, escriba 'man svxlink.conf' y se mostrará la documentación integrada.</p>

<p>Para detener la ejecución de svxlink, escriba en la terminal <b>sudo systemctl stop svxlink.service</b> y para reiniciarlo escriba <b>sudo systemctl restart svxlink.service</b>. También puede hacer esto si está autorizado en el Tablero en el menú ENERGÍA. No es necesario reiniciar el sistema en ningún momento.</p>

<p>Si desea modificar los archivos Svxlink.conf, EchoLink, MetarInfo y NodeInfo, puede hacerlo, si está autorizado, desde el panel de control. Al guardar los cambios, se reinicia inmediatamente svxlink con la nueva configuración, y los nuevos cambios se muestran después de hacer clic en el botón en el panel.</p>
<p>Tenga cuidado al editar, ya que cambiar la estructura puede provocar que el nodo falle. Sin embargo, se puede encontrar una copia de la última configuración funcional en la carpeta /var/www/html/backups con la hora y la fecha.</p>
<p>Para obtener información sobre node_info.json, vaya al navegador de una PC e ingrese <b>http://portal.svxlink.uk:81</b> donde encontrará un panel.</p>
<p>Haz clic en <b>Registrarse</b> en la parte superior, completando la información. Esta información se conserva únicamente para permitirle completar la siguiente etapa. Inicie sesión con la información que acaba de proporcionar, haga clic en <b>Mis estaciones</b> y haga clic en <b>Generar node_info.json</f></b>.
<p>Al completar toda la información, <b>ignorando</b> cualquier referencia a CTCSS en este momento, esto generará un archivo llamado node_info.json. Guárdelo en una ubicación de su computadora. Puedes copiarlo y pegarlo más tarde en el archivo del nodo.</p>
<p>Abra la terminal de Raspberry Pi y escriba <b>cd /etc/svxlink</b> seguido de return. Luego escribe <b>sudo nano node_info.json</b> y edita la información con el contenido del archivo que acabas de guardar en tu PC. Puedes abrir el archivo con un editor de texto o un bloc de notas.</p>
<p>En la Terminal Raspberry o en el Panel de control si ha abierto el archivo NodeInfo allí y elimine todo el contenido. Vaya al Bloc de notas o al editor de texto, seleccione todo el texto allí y cópielo (cntrl-c). Resalte la terminal (o la ventana del tablero) y péguela (cntrl-v). </p>
<p>Cuando se complete la edición, escriba <b>cntrl-o</b> y regrese al teclado del terminal seguido de <b>cntrl-x</b>.</p>
<p>En el Panel de control, simplemente use el botón Guardar. La nueva información se guardará en el archivo del nodo.</p>

<p>Verifique el contenido y, lo que es más importante, complete la información de su ubicación cerca de la parte inferior del archivo. escriba <b>cntrl-o</b> y regrese luego <b>cntrl-x</b> cuando haya terminado para guardar los cambios.</p>
<p>Si aún no ha habilitado Echolink en <b>svxlink.conf</b>, es posible que deba hacerlo ahora y eliminar el encabezado del comentario <b>#</b> de las líneas relevantes simplemente haciendo clic en la casilla de verificación. Puedes hacer esto en el Configurador de Svxlink</p>
<p>El reinicio de svxlink.service es automático al guardar los cambios.</b></p>
<p>No realice cambios en <b>gpio.conf</b>. Los métodos antiguos de agregar la configuración gpio y establecer un inicio de demonio en /etc/rc.local están en desuso (ya no son necesarios). Estamos usando GPIOD o udev y están configurados en los menús.</p>
<h2>EchoEnlace</h2>
<p>Para modificar la información de Echolink, puede realizar cambios en su Configurador de EchoLink aquí. luego guarde el archivo como lo hizo anteriormente con <b>svxlink.conf</b>.</p>
<p>Se aplican las reglas habituales con los puertos de salida para su dirección IP RaspberryPi configuradas en el enrutador al que está conectado</p>
<p>Solo puedes tener un EchoLink configurado en tu dirección IP doméstica.</p>
<p>Deberás configurar el indicativo y la contraseña con los que te registraste en EchoLink.</p>
<p>Si no configuró EchoLink durante la fase de construcción, puede agregarlo en la línea MODULES= en la sección [SimplexLogic] del Configurador Svxlink y debe incluir ModuleEchoLink dentro de la línea. Para el usuario del repetidor se aplicará lo mismo excepto que la línea MODULES= estará en [RepeaterLogic]</p>
<p>Finalmente, el paso importante es establecer el nivel correcto de audio. Esto ahora se configura usando amixer en el menú en la parte superior.<p>
<p>Alsamixer no se puede utilizar desde el panel de control, por lo que nos dirigimos directamente al amixer.</p>
<p> Para obtener mejores resultados, configure 'Altavoz' en alrededor de 75, 'Micrófono' en 0, 'Micrófono con captura' en 19-38 y 'Autogain' debe estar en 'OFF'. Simplemente ajuste los valores en el Configurador. </p>
<p>'Altavoz' es el volumen del transmisor y 'Micrófono con captura' es el volumen del receptor. Es un poco contraintuitivo.</p>
<p>Que tengas un día interesante</p>

<p>73 - Chris G4NAB</p>
<p>Todo lo que se presenta aquí proviene directamente de la presentación original de Tobias SM0SVX.</p>
<h2>Adenda</h2>
<p>Los grupos de conversación deben agregarse al configurador Svxlink en ReflectorLogic y asegurarse de que la marca de verificación esté marcada al lado.</p>
<p>Se pueden agregar y eliminar aeropuertos según sea necesario en el configurador MetarInfo.</p
<p>El panel de control de audio parece no funcionar por el momento.</p>
<p>El módulo EchoLink se puede agregar a través del panel de control, primero en el configurador EchoLink, luego agregue ModuleEchoLink a la línea MODULES= en la sección [SimplexLogic] o [RepeaterLogic] del configurador Svxlink.</p>
<p>Amixer se puede ajustar usando el panel de control y es más eficiente que alsamixer en la terminal. Seleccione la configuración recomendada dentro de la ventana.</p>
<p>Esta función no funciona para la tarjeta usvxcard de F8ASB. Debe ir a la terminal y escribir sudo alsamixer. Reduce todos los ajustes a alrededor del 60%.</p>
<p>Por último, para los usuarios de F8ASB, ajuste el módulo SA818.</p>
<p>Ya deberías haber habilitado la interfaz USB, que en el menú de Raspberry Pi debería ser /dev/ttyS0. </p>
<p>sudo git clone https://github.com/0x9900/sa818</p>
<p>cd sa818</p>
<p>sudo python3 setup.py install</p>
<p>sa818 --port /dev/ttyS0 radio --frequency 430.125 --squelch 2 --bw 0</p>
<p>Este comando es simplemente para comunicarse con el puerto serial para configurar la radio a una frecuencia de 430.125 MHz con un nivel de silenciamiento 2 y un ancho de banda de 12.5 kHz. Por supuesto, sustituye tu propia frecuencia. Para obtener asistencia completa sobre el tipo SA818, escriba SA818 -h para todas las opciones.</p>