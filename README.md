# Asón ([A]mazon on [S]teamOS [O]ver [N]ile)
_**A GUI for an unofficial Amanzon Games Launcher (nile)**_

Esta utilidad **querrá** ser un frontend, GUI o asistente para Amazon Games Launcher en Linux. Para esto, Asón se apoya en nile https://github.com/imLinguin/nile ¡Todos los aplausos para esta utilidad! _**nile**_ es una herramienta escrita en python que sirve de cliente de Amazon Games en Linux, todo mediante simples comandos.

Actualmente es una utilidad que descarga y crea un entorno portable de fácil accesibilidad. Perfecto para **SteamOS** que es el entorno en el que se quiere enfocar esta herramienta.

Es totalmente funcional a través de comandos _**nile**_, en esta herramienta: `Ason-cli.sh` y se van implementando a través del asistente [que es su objetivo].

## ¿Por qué el nombre de Asón? (Si el autor es de Murcia)
Amazon Games tiene nombre de río.
Nile tiene nombre de río.
Yo quería aportar mi granito de arena, pero es imposible compararme con los dos anteriores. ¡Son enormes! Así que he buscado algo bonito y pequeño en España:

Asón es el río más corto de España. Cuenta con una longitud total de 39 kilómetros y discurre por la cornisa cantábrica. Pese a su corta longitud su trazado es muy recomendable como paseo natural ya que está en un paisaje de gran belleza. ¡Todavía no lo he visitado!

## Instalar
Ejecuta en una línea de comandos:

`curl https://raw.githubusercontent.com/FranjeGueje/Ason/master/INSTALL/install.sh | bash -s`

No necesitas ser root. Este comando `install.sh` descarga el proyecto mediante git y hace un build con las herramientas necesarias. Todo lo empaqueta en un único directorio _**$HOME/Ason**_.

## Ejecución
Para la ejecución de Asón, corre directamente `Ason.sh` y te deberá de aparecer el menú del asistente a través de la utilidad *dialog* (incluida de forma portable en esta herramienta). Ahora mismo, este es el estado del proyecto:
![MenuPrincipal](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/01.png)
![Instalar](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/02.png)

También, puedes ejectuar los comandos de nile por tu cuenta. Recuerda que lo descargamos anteriormente y preparamos el entorno. Esto sí está al 100%. Podemos hacer cualquier cosa mediante comandos. Para correr nile, mediante comandos, dentro del directorio Ason ejecuta `Ason-cli.sh` con los parámetros correctos.

_**RECORDATORIO**_: nile deja la configuración en ~/.config/nile

# FAQ
## ¿Cómo se instala?
Fácil: Abre un terminal/consola y ejecuta este comando:

**`curl https://raw.githubusercontent.com/FranjeGueje/Ason/master/INSTALL/install.sh | bash -s`**

El asistente de instalación lo hará todo por ti y tendrás la última versión de la herramienta.

## ¿Dónde se instala?
Por defecto, se instala en la HOME del usuario, en el directorio **`$HOME/Ason`**. Si usas Deck, en /home/deck/Ason lo tendrás instalado.

## No me gusta esa ubicación, ¿puedo cambiarla?
Sí. Aunque se recomienda esa ubicación, Asón es portable y debería de poder moverse y seguir funcionando.

## ¿Cómo se ejecuta?
Tienes tres formas de ejecutar Asón:
* Doble clic en **Ason.desktop**. _RECOMENDADO_
* Desde la línea de comandos, ejecuta: `Anson.sh`
* Desde la línea de comandos, puedes ejecutar cada comando de Anson/Nile como un profesional. _Para usuarios experimentados_

## ¿Dónde se instalan los juegos?
Por defecto Ansón lo guarda en la capeta HOME, dentro de una subcarpeta llamada "Games/nile". Es decir, en SteamOS en **/home/deck/Games/nile**

## ¿Se puede cambiar la ubicación de instalación de videojuegos?
Sí, desde el menú de opciones.

## ¿Cómo se desinstala? No quiero ningún resto.
Simple. Para desinstalalar Ansó únicamente borra las carpetas con sus subcarpetas y ficheros:
* $HOME/Anson
* $HOME/.config/nile

## Parece que sacas versiones continuamente, que estás mejorándolo, ¿como me actualizo a la última versión?
Fácil, borra la carpeta de Ansón (recuerda, la carpeta por defecto está en $HOME/Anson) y lanza el comando de instalación desde un terminal/consola. Se volverá a descargar la última versión.

## He visto que lo has ejecutado desde el GAMEMODE de Steam Deck, ¿cómo lo hago yo?
Fáci (sí, otra vez). Añade un programa de no Steam como estarás acostumbrado a hacer... Los parámetros que tienes que ponerle son:
- Comando a ejecutar: `"/usr/bin/xterm"`
- Ubicación: `"/home/deck/Anson"` (o donde tengas Ansón)
- Parámetros: `-e "/home/deck/Anson/Anson.sh"` (o donde tengas Ansón)

# TODO
- Mejorar Wizard para ejecutar juegos en bottles. En versión 2.
- Avisar de que el juego tiene dependencias de terceros. En versión 2.
- ¿Instalar las dependencias de terceros en bottles? ¿En versión 2?
- ...
