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
    SALIDATEMP=/tmp/Ason.tmp

    # Bienvenido!
    $D "Bienvenido a ASON" --infobox "$BIENVENIDA" 10 45
    sleep 2
}

# Función con los procedimientos a realizar antes de salir
function salir() {
    # Hasta luego!
    $D "Hasta pronto" --infobox "$DESPEDIDA" 10 45
    sleep 2
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
        S "Sincronizar Bibioteca." \
        O "(NO DISPONIBLE) Opciones." \
        L "--Logout--" \
        G "--Force Login--")
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
    if [ "$NUM" == 0 ]; then
        echo "Salimos."
    else
        LISTA=()
        for ((i = 0; i < $NUM; i++)); do
            LISTA+=("$i" "$($JQ ".[$i].product.title" "$LIBRARY")" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --checklist "Selecciona los juegos a instalar..." 0 0 0 "${LISTA[@]}")

        for i in $RUN; do
            ID=$($JQ ".[$i].id" "$LIBRARY")
            EJECUTAR="$NILE install $ID"
            echo "Instalando $($JQ .["$i"].product.title "$LIBRARY"). Espere ..."
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
        done

        limpiar
        [ -f "$SALIDATEMP" ] && $D LOG-Install --msgbox "$temp" 0 0
        rm -f "$SALIDATEMP"
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
        for ((i = 0; i < $NUM; i++)); do
            ID=$($JQ ".[$i].id" "$INSTALLED")
            for ((j = 0; j < $NUML; j++)); do
                temp=$($JQ ".[$j].id==$ID" "$LIBRARY")
                if [ "$temp" = "true" ]; then
                    break
                fi
            done
            LISTA+=("$i" "$($JQ ".[$j].product.title" "$LIBRARY")" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --radiolist "Selecciona el juego a desinstalar..." 0 0 0 "${LISTA[@]}")

        if [ -n "$RUN" ]; then
            ID=$($JQ ".[$RUN].id" "$INSTALLED")
            EJECUTAR="$NILE uninstall $ID"
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
            limpiar
            [ -f "$SALIDATEMP" ] && $D LOG-Uninstall --msgbox "$temp" 0 0
            rm -f "$SALIDATEMP"
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
        for ((i = 0; i < $NUM; i++)); do
            ID=$($JQ ".[$i].id" "$INSTALLED")
            for ((j = 0; j < $NUML; j++)); do
                temp=$($JQ ".[$j].id==$ID" "$LIBRARY")
                if [ "$temp" = "true" ]; then
                    break
                fi
            done
            LISTA+=("$i" "$($JQ ".[$j].product.title" "$LIBRARY")" "off")
        done
        RUN=$($D "SELECCION" --stdout \
            --checklist "Selecciona el juego a actualizar..." 0 0 0 "${LISTA[@]}")

        for i in $RUN; do
            ID=$($JQ ".[$i].id" "$LIBRARY")
            EJECUTAR="$NILE update $ID"
            echo "Actualizando $($JQ .["$i"].product.title "$LIBRARY"). Espere ..."
            temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
        done

        limpiar
        [ -f "$SALIDATEMP" ] && $D LOG-Update --msgbox "$temp" 0 0
        rm -f "$SALIDATEMP"
    fi
}

# Función para mostrar el menu menuSincronizar
function menuSincronizar() {
    $D "Sincronizar Biblioteca" --msgbox "Se procedera a sincronizar la biblioteca de Amazon Games con Ason.\nPulse OK y espere." 0 0
    $NILE library sync 2>"$SALIDATEMP"

    limpiar
    [ -f "$SALIDATEMP" ] && $D LOG-Logout --msgbox "$temp" 0 0
    rm -f "$SALIDATEMP"
}

# Función para mostrar el menu menuOpciones
function menuOpciones() {
    $D "WIP" --msgbox "Work in progres..." 0 0
}

# Función para mostrar el menu menuLogout
function menuLogout() {
    $D "Forzar Cierre de Usuario" --yesno "Se procedera a hacer logout de tu cuenta de Amazon y salir de Ason.\nQuiere continuar?" 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        $NILE auth --logout 2>"$SALIDATEMP"
        rm -f "$USER"

        limpiar
        [ -f "$SALIDATEMP" ] && $D LOG-Logout --msgbox "$temp" 0 0
        rm -f "$SALIDATEMP"

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

        limpiar
        [ -f "$SALIDATEMP" ] && $D LOG-Login_Logout --msgbox "$temp" 0 0
        rm -f "$SALIDATEMP"
    fi
}

# Función auxiliar para limpiar la salida
function limpiar() {
    temp=$(grep -v destruction <"$SALIDATEMP" | grep -v ubuntu | grep -v wl_display | grep -v wayland)
    # Deja en una valiable temp el fichero $SALIDATEMP limpiado de errores de Deck
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
Si elige NO ASON terminara su ejecucion. \n\n\nElige tu respuesta..." 15 50
    ans=$?
    if [ $ans -eq 0 ]; then
        dologin
    else
        break
    fi
done

while :; do
    menuPrincipal
    ejecutarOpcion
done

# Salimos de ASON
salir

exit 0
