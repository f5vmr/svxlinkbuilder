# svxlinkbuilder
<h1>Introducción</h1>
<h2>Para mayor velocidad, he utilizado el traductor de Google. Mis disculpas si el sentido es incorrecto.</h2>
<h2>Creación de menú para Raspberry Pi: nodo repetidor o punto de acceso. Para instrucciones en francés, MELIRE.md.</h2>
<h3>Esta compilación de SVXLink actualmente contiene una conexión solo al <b>svxportal-uk (SvxReflector)</b> únicamente. Si esto cambia, también lo hará esta introducción.</p>
<p>La conexión al svxreflector proporcionó conectividad mediante pseudogrupos de conversación a otros nodos y repetidores de la red. Para obtener más información, seleccione este enlace http://svxportal-uk.ddns.net:81.</p>
<b>Tus primeros pasos</b>
<p>Los requisitos: una Raspberry Pi de cualquier marca, una tarjeta de sonido USB y una tarjeta de interfaz (o una tarjeta de sonido USB modificada y sin interfaz). Uno o dos transceptores. Tener experiencia con los comandos de Shell ayudará, pero no es esencial.</p>
<p>Si tiene la experiencia adecuada, podrá modificar la instalación una vez que esté completa. Pero este sistema le proporcionará un sistema que funcione y luego podrá modificarlo según sus propias necesidades.</p>
<p>Hay muy pocas otras imágenes de frambuesa que funcionen con éxito para este tipo de compilación, donde existe la posibilidad de usar la aplicación en varias direcciones.</p>
<p>Si bien esto en sí no es una imagen, eliminará el arduo trabajo de la compilación física, aunque puede dejarle un poco de trabajo por hacer si necesita cambiar su especificación inmediata.</p>
<h2>Utilice siempre Raspberry OS Bookworm Lite (Debian 12) de 32 bits y no se equivocará.</h2>
<p>Hay varias placas de interfaz disponibles que tienen una variedad de usos, ya sea como punto de acceso o repetidor, o incluso como receptor/transceptor de relleno para un repetidor SVXLink existente. Las configuraciones en esta compilación son para una placa de interfaz casera que usa GPIOD 23/17/8 para recibir COS y GPIOD 24/18/7 para el controlador PTT, o alternativamente un CM-108 completamente modificado que puede usar 'udev' y conducir el PTT y COS de los componentes de modificación. También hay una versión intermedia para el CM-108 donde solo se ha realizado la modificación de transmisión que usará 'udev' para la transmisión y le brindará opciones para la recepción GPIOD 23/17/8.</p>
<p>Cuando se usan los pines GPIO y GPIOD, también se requiere un pin de tierra, por lo que al usar esta combinación, los pines 14, 16 y 18 son todos adyacentes y están ubicados idealmente para estas funciones. El pin 14 es la Tierra, el pin 16 es GPIO 23 y el pin 18 es GPIO 24.</p>
<p>Para un segundo conjunto de transceptores, puede considerar GPIO 17 y 18 como COS y PTT para ellos.</p>
<p>Puede encontrar una copia del diseño en g4nab.co.uk. También hay una página que muestra las instrucciones de modificación para una tarjeta de sonido USB CM-108.</p>
<h2>La programación de la tarjeta SD</h2>

<p>Como se mencionó, comience con una descarga de <b>Raspberry OS Bookworm Lite</b> desde RaspberryPi.org. Luego use una tarjeta MicroSD de 8 o 16 GB y transfiera la imagen a la tarjeta; lo mejor es usar el <b>Raspberry Pi Image Builder</b> de la misma fuente. <b> DEBE convertir el usuario en 'pi'; no se desvíe de mi consejo anterior, ya que tendrá problemas. </b> Sin embargo, puedes utilizar tu propia contraseña. Existen versiones de Raspberry Pi Imager para todos los sistemas operativos. Permite el uso completo de WiFi.</p>
<p>En el primer cuadro <b>dispositivo</b> seleccione 'Sin filtrado'</p>
<p>En el segundo cuadro <b>Elija SO</b> seleccione 'Raspberry Pi OS (Otro)' y luego 'Raspberry Pi Os 32 Bit' debajo del cual verá 'Debian Bookworm sin entorno de escritorio'. Selecciona esto</p>
<p>Ahora seleccione <b>Elegir almacenamiento</b> donde se le invitará a seleccionar la tarjeta SD.</p>
<p>En <b>Siguiente</b> Complete el cuadro 'editar', pero <b>pi</b> debe ser el usuario. Si esto no es correcto, la instalación fallará. Puedes tener la contraseña que quieras.</p>
<p>Puedes configurar tu configuración de Wi-Fi aquí si lo deseas.</p>
<b>Siempre marque la casilla SSH en la segunda pestaña del cuadro siguiente; de lo contrario, eso también provocará que la instalación falle.</b> puede usar una contraseña o establecer una clave si lo desea.</p>
<p>Una vez completado, expulse la tarjeta, instálela en la Raspberry Pi y enciéndala. Introduce el usuario <b>pi</b> y tu contraseña.</p>
<h2>La compilación</h2>
<p>Este script también instalará una tarjeta de sonido ficticia para el uso de Darkice y Icecast2.</p>
<p>El primer paso será el siguiente comando: <b>sudo apt-get install -y git</b> ya que sin este no puedes descargar desde GitHub.</p>

<p>Ahora el siguiente comando: <b>sudo git clone https://github.com/f5vmr/svxlinkbuilder.git</b>.</p>
<p>Los menús mostrados lo guiarán a través de la instalación, hasta el tiempo de ejecución. <b>Necesitará saber antes de comenzar</b> el estado de su transceptor, si el PTT y COS están activos altos o activos bajos, el estado y el tipo de su tarjeta de sonido USB, modificada, parcialmente modificada o sin modificar. Con una tarjeta de sonido USB completamente modificada, no hay ninguna razón que impida esta instalación en otra computadora basada en Linux que ejecute Debian 12. Tiene que ser Debian 12, o algunas de las funciones fallarán. Decide también el indicativo de llamada de tu nodo. No utilice símbolos o números adicionales en esta etapa. El indicativo debe ser de notación estándar. Si ha decidido instalar EchoLink, tenga lista su información de registro. Si desea utilizar ModuleMetarInfo, la aplicación Airport Weather, lea sobre los códigos OACI y descubra los principales aeropuertos a su alrededor. No funcionará para aeropuertos que no brinden un servicio meteorológico en tiempo real. Si desea explorar ModulePropagationMonitor, puede instalarlo más adelante. Recuerde anotar todo antes de continuar.</p>
<p>Todo lo demás será construido para ti</p>
<h2>Comenzando la instalación</h2>
<p>El script compilará la configuración en ejecución a medida que avance. Sólo se puede ejecutar una vez, debido a la naturaleza del programa. Permítase un período ininterrumpido de 1 hora para responder las preguntas que le hagan y la instalación que lo acompaña. <b>Recuerde anotar los "nombres de usuario y contraseñas" que proporcione</b>. Una Raspberry Pi 3 o 4 tardará menos, y una Raspberry Pi zero posiblemente más de 90 minutos. Sin embargo, la Raspberry Pi Zero presentará un desafío debido a la falta de una toma USB externa. NO he incluido la instalación del sistema de sonido Waveshare, si estás usando una interfaz Pi-Hat. Con suerte, no debería haber ningún error reportado. Acabo de completar una compilación en una Raspberry Pi 3A desde el formato de tarjeta hasta el nodo de trabajo en 50 minutos, sin errores.</p>
<p>Para el usuario estadounidense, los archivos de voz en_US se extraerán si selecciona 'Inglés - EE. UU.' en el menú.</p>
<p>Espero que haya alguien que pueda agregar código en español o portugués.</p>
<h2>Comenzamos</h2>
<p>Escriba el siguiente comando en el indicador actual: <b>./svxlinkbuilder/preinstall.sh</b> El sistema se reiniciará, así que inicie sesión nuevamente como antes.</p>
<p>Escriba el siguiente comando <b> ./svxlinkbuilder/install.sh</b> NOTA especial: <b>No hay sudo aquí en estos comandos.</b></p>
<p>Siga los menús e ingrese la información requerida, que debería haber anotado, para ayudarlo antes de ejecutar el programa.</p>
<p>Durante la compilación, se le notificará la dirección IP activa de su nodo. Toma nota de ello. Lo necesitarás para continuar.</p>
<p>Al final de la compilación, el sistema se reiniciará automáticamente, sobre lo cual se le notificará.</p>

<p>El siguiente paso será abrir un navegador de Internet como 'Chrome', escribir la dirección IP e ingresar. Se mostrará el tablero. Si su tarjeta de sonido USB parpadea, entonces el nodo debería estar completamente operativo.</p>

<h2> Solución de problemas </h2>

<p>Necesitará comprender el archivo svxlink.conf y cómo realizar ajustes para la operación Simplex o Repetidora. En cualquier caso, es posible que necesites consultar la página principal de svxlink.org, o la página de usuarios de radioaficionados de svxlink en Facebook, o contactarme. Para obtener más información, consulte también las páginas de svxlink en g4nab.co.uk. En la terminal, escriba 'man svxlink.conf' y se mostrará la documentación integrada.</p>

<p>Para detener la ejecución de svxlink, escriba en la terminal <b>sudo systemctl stop svxlink.service</b> y para reiniciarlo escriba <b>sudo systemctl restart svxlink.service</b>. También puede hacer esto si está autorizado en el Panel de control.</p>

<p>Si desea modificar los archivos Svxlink.conf, EchoLink, MetarInfo y NodeInfo, puede hacerlo, si está autorizado, desde el panel de control.</p>
<p>Tenga cuidado al editar, ya que cambiar la estructura puede provocar que el nodo falle. Sin embargo, se puede encontrar una copia de la última configuración de trabajo en la carpeta /etc/svxlink con la hora y la fecha, o en el caso de EchoLink y MetarInfo en la carpeta /etc/svxlink/svxlink.d.</p>
<p>Para obtener información sobre node_info.json, vaya al navegador de una PC e ingrese <b>http://svxportal-uk.ddns.net:81</b> donde encontrará un panel.</p>
<p>Haz clic en <b>Registrarse</b> en la parte superior, completando la información. Esta información se conserva únicamente para permitirle completar la siguiente etapa. Inicie sesión con la información que acaba de proporcionar, haga clic en <b>Mis estaciones</b> y haga clic en <b>Generar node_info.json</f></b>.
<p>Al completar toda la información, <b>ignorando</b> cualquier referencia a CTCSS en este momento, esto generará un archivo llamado node_info.json. Guárdelo en una ubicación de su computadora. Puedes copiarlo y pegarlo más tarde en el archivo del nodo.</p>
<p>Abra la terminal de Raspberry Pi y escriba <b>cd /etc/svxlink</b> seguido de return. Luego escribe <b>sudo nano node_info.json</b> y edita la información con el contenido del archivo que acabas de guardar en tu PC. Puedes abrir el archivo con un editor de texto o un bloc de notas.</p>
<p>En la Terminal Raspberry o en el Panel de control si ha abierto el archivo NodeInfo allí y elimine todo el contenido. Vaya al Bloc de notas o al editor de texto, seleccione todo el texto allí y cópielo (cntrl-c). Resalte la terminal (o la ventana del tablero) y péguela (cntrl-v). </p>
<p>Cuando se complete la edición, escriba <b>cntrl-o</b> y regrese al teclado del terminal seguido de <b>cntrl-x</b>.</p>
<p>En el Panel de control, simplemente use el botón Guardar. La nueva información se guardará en el archivo del nodo.</p>
<p>A continuación para incorporar la nueva información, escriba <b>sudo systemctl restart svxlink.service</b> y regrese si está en la terminal, o si en el Dashboard haga clic en Encendido y 'Reiniciar servicio SVXLink'</p>
<p>El siguiente paso es comprobar y editar cuando sea necesario el archivo <b>svxlink.conf</b>. Escriba <b>sudo nano svxlink.conf</b> seguido de return. Esto será necesario para agregar o eliminar TalkGroups en [ReflectorLogic]. Discute eso conmigo.</p>
<p>Verifique el contenido y, lo que es más importante, complete la información de su ubicación cerca de la parte inferior del archivo. escriba <b>cntrl-o</b> y regrese luego <b>cntrl-x</b> cuando haya terminado para guardar los cambios.</p>
<p>Para modificar la información de Echolink, escriba <b>sudo nano svxlink.d/ModuleEchoLink.conf</b> y regrese. Realice sus cambios en su acceso a EchoLink aquí. luego guarde el archivo como lo hizo anteriormente con <b>svxlink.conf</b>. Si aún no ha habilitado svxlink en <b>svxlink.conf</b>, es posible que deba hacerlo ahora y eliminar el encabezado del comentario <b>#</b> de las líneas relevantes.</p>
<p>Para incorporar los cambios necesitarás reiniciar el svxlink.service</b></p>
<p>No es necesario realizar cambios en <b>gpio.conf</b>. Los métodos antiguos de agregar la configuración gpio y establecer un inicio de demonio en /etc/rc.local están en desuso (ya no son necesarios). Estamos usando GPIOD. Si la versión del Panel no muestra GPIO en el menú, entonces esto ya se ha eliminado.</p>
<h2>EchoLink/h2>
<p>Se aplican las reglas habituales con los puertos de salida para su dirección IP RaspberryPi configuradas en el enrutador al que está conectado</p>
<p>Solo puedes tener un EchoLink configurado en tu dirección IP doméstica.</p>
<p>Deberás configurar el indicativo y la contraseña con los que te registraste en EchoLink. Esto está en el archivo /etc/svxlink/svxlink.d/ModuleEchoLink.conf. Edita el archivo con el comando 'sudo nano' que precede al nombre del archivo, incluida la información del directorio.</p>
<p>Si no configuró EchoLink durante la fase de construcción, también deberá modificar dos líneas en /etc/svxlink/svxlink.conf nuevamente usando 'sudo nano'. Para el Nodo Simplex la primera de las líneas está dentro de [SimplexLogic] en MODULES= y debes incluir ModuleEchoLink dentro de la línea. Para el usuario del repetidor se aplicará lo mismo excepto que la línea MODULES= estará en [RepeaterLogic]</p>
<p>Finalmente, el paso importante es establecer el nivel correcto de audio. Debes hacer esto desde la terminal, iniciando sesión en tu nodo y escribiendo 'sudo alsamixer' cuando se te solicite.<p>
<p>Al usar la función cntrl-f5, debe mostrar todas las entradas y salidas dentro de la tabla. Deberías tener "Auriculares", "Micrófono", "Micrófono con captura" y "Control automático de ganancia".</p>
<p> Para obtener mejores resultados, configure 'Altavoz' en alrededor de 60, 'Micrófono' en 0, 'Micrófono con captura' en 19-25 y 'Autogain' debe estar silenciado. Resalte cada uno con las teclas de flecha del teclado. Silencia 'Autogain' usando la tecla 'M'. </p>
<p>'Altavoz' es el volumen del transmisor y 'Micrófono con captura' es el volumen del receptor. Es un poco confuso.</p>
<p>Todo lo que se presenta aquí proviene directamente de la presentación original de Tobias SM0SVX.</p>
