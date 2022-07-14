#! /bin/bash

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# NOMBRE DEL PROYECTO: ASON (Amazon on SteamOS Over Nile)
# ABOUT: script con objetivo de mostrar una interface, es decir, un frontend para el cliente de linux no oficial de Amazon Games llamado 'nile'
#
# PARÁMETRO: No tiene.
#
# REQUISITOS: No tiene más allá de los requeridos por el proyecto global ASON..
#
# EXITs:
# 0 --> Salida correcta.
# 1 --> Necesitas revisar el comando. Se sale tras mostrar la ayuda.
# 2 --> Usas -S, -C o -K conjutamente.
# 3 --> El directorio de script no existe.
# 4 --> El usuario no tiene una contraseña en blanco y para el caso es necesario
# 88 -> No se encuntra la utilidad dialog y se necesita
##############################################################################################################################################################

#
# FUNCIONES PARA EL DESARROLLO DE LA APLICACION
#

# Función con los procedimientos a realizar antes de comenzar el programa
function entrar() {
    # Recuperamos version actual
    read -r VERSION <CHANGELOG.md
    # ENTORNO DE DIALOG
    # Importamos las librerías necesarias del dialog "portable"
    LD_LIBRARY_PATH="$(pwd)/dialog"
    export LD_LIBRARY_PATH
    DIALOG="$LD_LIBRARY_PATH/dialog"

    # Variable de ejecución para acortar las intrucciones de 'dialog'
    BIENVENIDA='Bienvenido a ASON\n\n([A]mazon on [S]teamOS [O]ver [N]ile)'
    DESPEDIDA='Gracias por utilizar ASON\n\n([A]mazon on [S]teamOS [O]ver [N]ile)'
    D="$DIALOG --backtitle ASON-[A]mazon.on.[S]teamOS.[O]ver.[N]ile-$VERSION --title "

    # ENTORNO NILE
    NILE="$(pwd)/Ason-cli.sh"
    USER="$HOME/.config/nile/user.json"
    INSTALLED="$HOME/.config/nile/installed.json"
    LIBRARY="$HOME/.config/nile/library.json"
    JQ="$(pwd)/jq/jq-1.6-linux64"

    # Otras variables
    SALIDATEMP=/tmp/Ason.tmp
    TEMPIDNAME=/tmp/AsonID-Name.txt
    CONFIGRUTA="$HOME/.config/nile/installPath.txt"
    RUTAINSTALL="$HOME/Games/nile"
    [ -f "$CONFIGRUTA" ] && read -r RUTAINSTALL <"$CONFIGRUTA"

    # Bienvenido!
    $D "Bienvenido a ASON" --infobox "$BIENVENIDA" 10 45
    sleep 1
}

# Función con los procedimientos a realizar antes de salir
function salir() {
    # Hasta luego!
    $D "Hasta pronto" --infobox "$DESPEDIDA" 10 45

    [ -f "$TEMPIDNAME" ] && rm -f "$TEMPIDNAME"
    [ -f "$SALIDATEMP" ] && rm -f "$SALIDATEMP"
    sleep 1
}

# Función para hacer login
function dologin() {
    # Haciendo login
    $NILE auth --login
}

# Función con el menú principal
function menuPrincipal() {
    OPCION=$($D "MENU PRINCIPAL" \
        --stdout \
        --menu "Selecciona la opcion a realizar:" 10 50 0 \
        I "Instalar un juego." \
        D "Desinstalar un juego instalado." \
        A "Actualizar un juego instalado." \
        S "Sincronizar Biblioteca." \
        O "Opciones.")
}

# Función para efectuar la opcion
function ejecutarOpcion() {
    # Opciones y menus
    case "$OPCION" in
    I)
        echo -ne "--> Entrando en menú de INSTALACION" && menuInstalar
        ;;
    D)
        echo -ne "--> Entrando en menú de DESINSTALACION" && menuDesinstalar
        ;;
    A)
        echo -ne "--> Entrando en menú de ACTUALIZACION" && menuActualizar
        ;;
    S)
        echo -ne "--> Entrando en menú de SINCRONIZACION" && menuSincronizar
        ;;
    O)
        echo -ne "--> Entrando en menú de OPCIONES" && menuOpciones
        ;;
    *)
        $D "Desea Salir?" --stdout --yesno "Esta seguro que desea salir?\n\n\nElige tu respuesta..." 15 50
        ans=$?
        if [ $ans -eq 0 ]; then
            salir
            exit 0
        fi
        ;;
    esac
    OPCION=""
}

# Función para mostrar el menu menuInstalar
function menuInstalar() {
    NUM=$($JQ ". | length" "$LIBRARY")
    if [ "$NUM" == 0 ]; then
        echo "Salimos."
    else
        LISTA=()
        for ((i = 0; i < NUM; i++)); do
            LISTA+=("$i" "$($JQ ".[$i].product.title" "$LIBRARY")" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --checklist "Selecciona los juegos a instalar..." 0 0 0 "${LISTA[@]}")

        TOTAL=$(echo "$RUN" | wc -w)
        n=1

        [ -f "$SALIDATEMP" ] && rm -f "$SALIDATEMP"
        for i in $RUN; do
            ID=$($JQ ".[$i].id" "$LIBRARY")
            EJECUTAR="$NILE install $ID --base-path $RUTAINSTALL"
            echo $((n * 100 / TOTAL)) | $D "Instalando $($JQ .["$i"].product.title "$LIBRARY")" --gauge "Espere..." 10 60 0
            ((n++))
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
        done

        mostrarResultado
    fi
}

# Función para mostrar el menu menuDesinstalar
function menuDesinstalar() {
    NUM=$($JQ ". | length" "$INSTALLED")
    NUML=$($JQ ". | length" "$LIBRARY")
    if [ "$NUM" == 0 ] || [ "$NUML" == 0 ]; then
        echo "Salimos."
    else
        LISTA=()
        for ((i = 0; i < NUM; i++)); do
            ID=$($JQ -r ".[$i].id" "$INSTALLED")
            NOMBRE=$(grep "$ID" <"$TEMPIDNAME" | cut -d '=' -f3)
            LISTA+=("$i" "$NOMBRE" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --radiolist "Selecciona el juego a desinstalar..." 0 0 0 "${LISTA[@]}")

        [ -f "$SALIDATEMP" ] && rm -f "$SALIDATEMP"
        if [ -n "$RUN" ]; then
            ID=$($JQ ".[$RUN].id" "$INSTALLED")
            EJECUTAR="$NILE uninstall $ID"
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")

            mostrarResultado
        fi
    fi
}

# Función para mostrar el menu menuActualizar
function menuActualizar() {
    NUM=$($JQ ". | length" "$INSTALLED")
    NUML=$($JQ ". | length" "$LIBRARY")
    if [ "$NUM" == 0 ] || [ "$NUML" == 0 ]; then
        echo "Salimos."
    else
        LISTA=()
        for ((i = 0; i < NUM; i++)); do
            ID=$($JQ -r ".[$i].id" "$INSTALLED")
            NOMBRE=$(grep "$ID" <"$TEMPIDNAME" | cut -d '=' -f3)
            LISTA+=("$i" "$NOMBRE" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --checklist "Selecciona el juego a actualizar..." 0 0 0 "${LISTA[@]}")

        TOTAL=$(echo "$RUN" | wc -w)
        n=1

        [ -f "$SALIDATEMP" ] && rm -f "$SALIDATEMP"
        for i in $RUN; do
            ID=$($JQ ".[$i].id" "$INSTALLED")
            EJECUTAR="$NILE update $ID"
            echo $((n * 100 / TOTAL)) | $D "Actualizando $n de $TOTAL" --gauge "Espere..." 10 60 0
            ((n++))
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
        done

        mostrarResultado
    fi
}

# Función para mostrar el menu menuSincronizar
function menuSincronizar() {
    
    $D "Sincronizar Biblioteca" --msgbox "Se procedera a sincronizar la biblioteca de Amazon Games con Ason.\nPulse OK y espere." 0 0
    $NILE library sync 2>"$SALIDATEMP"

    mostrarResultado
}

# Función para mostrar el menu menuOpciones
function menuOpciones() {
    OPCION=$($D "MENU OPCIONES" \
        --stdout \
        --menu "Selecciona la opcion a realizar:" 10 50 0 \
        C "Cambiar ruta de instalacion" \
        L "Logout en Amazon Games" \
        G "Forzar hacer login en Amazon Games")

    # Opciones y menus
    case "$OPCION" in
    C)
        menuCambioUbi
        ;;
    L)
        menuLogout
        ;;
    G)
        menuLogin
        ;;
    *)
        OPCION=""
        ;;
    esac
}

# Función para mostrar el menu de cambio de ubicación de instalación
function menuCambioUbi() {
    NUEVARUTA=$($D "Cambio del directorio de instalacion de juegos" --stdout --inputbox "Nuevo directorio de instalacion" 0 0 "$RUTAINSTALL")
    [ ! -d "$NUEVARUTA" ] && $D "ATENCION!!!" --msgbox "La ruta que indicas no existe.\nNo se realiza ningun cambio." 0 0
    [ -d "$NUEVARUTA" ] && RUTAINSTALL="$NUEVARUTA" && echo "$NUEVARUTA" > "$CONFIGRUTA"
}

# Función para mostrar el menu menuLogout
function menuLogout() {
    $D "Forzar Cierre de Usuario" --yesno "Se procedera a hacer logout de tu cuenta de Amazon y salir de Ason.\nQuiere continuar?" 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        $NILE auth --logout 2>"$SALIDATEMP"
        rm -f "$USER"

        mostrarResultado

        salir
        exit 0
    fi
}

# Función para mostrar el menu menuLogin
function menuLogin() {
    $D "Sin login de usuario" --yesno "Se procedera a hacer logout de tu cuenta de Amazon y volver a iniciar.\nQuiere continuar?" 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        $NILE auth --logout 2>"$SALIDATEMP"
        rm -f "$USER"
        $NILE auth -l 2>>"$SALIDATEMP"

        mostrarResultado
    fi
}

# Función auxiliar para mostrar la salida (limpiada) y limpiar temporales
function mostrarResultado() {
    if [ -f "$SALIDATEMP" ]; then
        temp=$(grep -v destruction <"$SALIDATEMP" | grep -v ubuntu | grep -v wl_display | grep -v wayland)
        $D "Resultado Operacion" --msgbox "$temp" 0 0 && rm -f "$SALIDATEMP"
    fi
}

##############################################################################################################################################################
#                                                    MAIN (PRINCIPAL)
##############################################################################################################################################################

# Preparamos el entorno y lanzamos la funcion entrar()
entrar

SIZE="$(stat -c "%s" "$USER")"
# Si el fichero con los datos de usuario está vacío, lo borramos para que vuelva a pedir login
[ "$SIZE" -eq "0" ] && rm "$USER" -f

while [ ! -f "$USER" ]; do
    $D "Sin login de usuario" --yesno "No se encuentra informacion sobre el login. \n\nQuieres lanzar la peticion de login?\n\
Elija su respuesta...\n\n\nSi elige NO --> ASON *NO* terminara su ejecucion, pero su funcionamiento sera limitado. Tenlo en cuenta! " 15 50
    ans=$?
    if [ $ans -eq 0 ]; then
        dologin
    else
        break
    fi
done

if [ -f "$LIBRARY" ]; then
    $JQ -r '.[] | "\(.id)==\(.product.title)"' "$LIBRARY" >"$TEMPIDNAME"
fi

while :; do
    menuPrincipal
    ejecutarOpcion
done

# Salimos de ASON
salir

exit 0
