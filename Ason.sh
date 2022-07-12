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
    # ENTORNO DE DIALOG
    # Importamos las librerías necesarias del dialog "portable"
    LD_LIBRARY_PATH="$(pwd)/dialog"
    export LD_LIBRARY_PATH
    DIALOG="$LD_LIBRARY_PATH/dialog"

    # Variable de ejecución para acortar las intrucciones de 'dialog'
    BIENVENIDA='Bienvenido a ASON\n\n([A]mazon on [S]teamOS [O]ver [N]ile)'
    DESPEDIDA='Gracias por utilizar ASON\n\n([A]mazon on [S]teamOS [O]ver [N]ile)'
    D="$DIALOG --backtitle ASON --title "
    TMAX=" 40 120 "

    # ENTORNO NILE
    NILE="$(pwd)/Ason-cli.sh"
    USER="$HOME/.config/nile/user.json"
    INSTALLED="$HOME/.config/nile/installed.json"
    LIBRARY="$HOME/.config/nile/library.json"
    JQ="$(pwd)/jq/jq-1.6-linux64"

    # Bienvenido!
    $D Bienvenido --msgbox "$BIENVENIDA" 10 45
}

# Función con los procedimientos a realizar antes de salir
function salir() {
    # Hasta luego!
    $D "Hasta luego" --msgbox "$DESPEDIDA" 10 45
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
        D "(NO DISPONIBLE) Desinstalar un juego instalado." \
        A "(NO DISPONIBLE) Actualizar un juego instalado." \
        S "(NO DISPONIBLE) Sincronizar Bibioteca." \
        O "(NO DISPONIBLE) Opciones." \
        L "(NO DISPONIBLE) --Logout--" \
        G "(NO DISPONIBLE) --Force Login--")
}

# Función para efectuar la opcion
function ejecutarOpcion() {
    # Opciones y menus
    case "$OPCION" in
    I)
        # No hacemos nada más, porque showhelp se saldrá del programa
        menuInstalar
        ;;
    D)
        menuDesinstalar
        ;;
    A)
        menuActualizar
        ;;
    S)
        menuSincronizar
        ;;
    O)
        menuOpciones
        ;;
    L)
        menuLogout
        ;;
    G)
        menuLogin
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
    if [ "$NUM" == 0 ] ; then
        echo "Salimos."
    else
        LISTA=()
        for ((i=0; i < $NUM; i++)); do
            LISTA+=("$i" "$($JQ ".[$i].product.title" "$LIBRARY")" "o")
        done
        RUN=$($D "SELECCION" --stdout \
        --checklist "Selecciona los juegos a instalar..." 0 0 0 "${LISTA[@]}")
        
        SALIDATEMP=/tmp/Ason.tmp
        for i in $RUN ; do
            ID=$($JQ ".[$i].id" "$LIBRARY")
            EJECUTAR="$NILE install $ID"
            echo "Instalando $($JQ .[$i].product.title "$LIBRARY"). Espere ..."
            temp=$(eval "$EJECUTAR" 2>> "$SALIDATEMP")
        done
        
        [ -f "$SALIDATEMP" ] && $D LOG-Install --textbox "$SALIDATEMP" 0 0
        rm -f "$SALIDATEMP"
    fi
}

# Función para mostrar el menu menuDesinstalar
function menuDesinstalar() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuActualizar
function menuActualizar() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuSincronizar
function menuSincronizar() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuOpciones
function menuOpciones() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuLogout
function menuLogout() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuLogin
function menuLogin() {
    $D "WIP" --msgbox "Work in progres..." 0 0
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
Si elige NO ASON terminara su ejecucion. \n\n\nElige tu respuesta..." 15 50 && dologin || break
done

while :; do
    menuPrincipal
    ejecutarOpcion
done

# Salimos de ASON
salir

exit 0
