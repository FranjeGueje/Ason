# Asón
_**A GUI for an unofficial Amanzon Games Launcher (nile)**_

Esta utilidad **querrá** ser un frontend, GUI o asistente para Amazon Games Launcher en Linux. Para esto, Asón se apoya en nile https://github.com/imLinguin/nile ¡Todos los aplausos para esta utilidad! _**nile**_ es una herramienta escrita en python que sirve de cliente de Amazon Games en Linux, todo mediante simples comandos.

Actualmente es una utilidad que descarga y crea un entorno portable de fácil accesibilidad. Perfecto para **SteamOS** que es el entorno en el que se quiere enfocar esta herramienta.

Es totalmente funcional a través de comandos _**nile**_ pero no a través de un asistente que es su objetivo.

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
![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/01.png)

También, puedes ejectuar los comandos de nile por tu cuenta. Recuerda que lo descargamos anteriormente y preparamos el entorno. Esto sí está al 100%. Podemos hacer cualquier cosa mediante comandos. Para correr nile, mediante comandos, dentro del directorio Ason ejecuta `nile.sh` con los parámetros correctos.

_**RECORDATORIO**_: nile deja la configuración en ~/.config/nile

# TODO
- Utilidad para la descarga de la herramienta automáticamente o bien crear una release.
- Asistente en dialog portable, que no haya que instalar nada de paquetes en SteamOS.
- Wizard básico para: listar y descargar juegos.
- Mejorar Wizard para ejecutar juegos en bottles.
- ...
