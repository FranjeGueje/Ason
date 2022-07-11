# Asón
_**A GUI for an unofficial Amanzon Games Launcher (nile)**_

Esta utilidad **querrá** ser un frontend, GUI o asistente para Amazon Games Launcher en Linux. Para esto, Asón se apoya en nile https://github.com/imLinguin/nile ¡Todos los aplausos para esta utilidad!

Actualmente es una utilidad que descarga y crea un entorno portable de fácil accesibilidad. Perfecto para **SteamOS** que es el entorno en el que se quiere enfocar esta herramienta.

Es totalmente funcional a través de comandos _**nile**_ pero no a través de un asistente que es su objetivo.

## ¿Por qué el nombre de Asón? (Si el autor es de Murcia)
Amazon Games tiene nombre de río.
Nile tiene nombre de río.
Yo quería aportar mi granito de arena, pero es imposible compararme con los dos anteriores. ¡Son enormes! Así que he buscado algo bonito y pequeño en España:

Asón es el río más corto de España. Cuenta con una longitud total de 39 kilómetros y discurre por la cornisa cantábrica. Pese a su corta longitud su trazado es muy recomendable como paseo natural ya que está en un paisaje de gran belleza. ¡Todavía no lo he visitado!

## Build
Descarga el proyecto y ejecuta `build.sh` para automatizar la descarga y creación del paquete Asón.
También podrás descargar una release próximamente.

## Ejecución
Para la ejecución de Asón, corre directamente `Ason.sh` y te deberá de aparecer el menú del asistente a través de la utilidad *dialog* (incluida de forma portable en esta herramienta). Ahora mismo, este es el estado del proyecto:
![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/01.png)

También, puedes ejectuar los comandos de nile por tu cuenta. Recuerda que lo descargamos anteriormente en Build:
* Entra en el directorio de Ason.
* Ejecuta `source env/bin/activate`
* Después prueba a ejecutar `nile/bin/nile` para ver que todo esté correcto.

# TODO
- Utilidad para la descarga de la herramienta automáticamente o bien crear una release.
- Asistente en dialog portable, que no haya que instalar nada de paquetes en SteamOS.
- Wizard básico para: listar y descargar juegos.
- Mejorar Wizard para ejecutar juegos en bottles.
- ...
