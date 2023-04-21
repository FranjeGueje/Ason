#!/bin/bash
##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# PROJECT: ASON (Amazon on SteamOS Over Nile)
# ABOUT: script with the objective of displaying an interface, i.e. a frontend for the unofficial Amazon Games linux client called 'nile'.
#
# PARAMS: Nope.
#
# REQUERIMENTS: NILE, YAD, JQ, WGET, SHUF, gnu utils :D
#
# EXITs:
# 0 --> OK!!!.
# 1 --> Missing required component.
##############################################################################################################################################################

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         GLOBAL VARIABLES
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Basic
NOMBRE="ASON - [Amazon Games on Steam OS over Nile]"
VERSION=2.0.0b2

# Config files of nile
NILEUSER="$HOME/.config/nile/user.json"
NILELIBR="$HOME/.config/nile/library.json"
NILEINSTALLED="$HOME/.config/nile/installed.json"

# Where is the app and binaries
ASONPATH=$(readlink -f "$(dirname "$0")")
ASONBIN="$ASONPATH/bin"
ASONCACHE="$HOME/.cache/ason/"
YAD="$ASONBIN/yad"
NILE="$ASONBIN/nile"
JQ="$ASONBIN/jq"

# Locations
DIRINSTALL="$HOME/Games"
DEBUGFILE="$ASONPATH/debug.log"

PATH="$PATH:$ASONBIN"

# Config files of Ason
ASONOPTIONFILE="$HOME/.config/nile/ason.config"
ASONTITFILE="$ASONCACHE""/ason.tit"
ATIT=()
ASONIMGFILE="$ASONCACHE""/ason.img"
AIMG=()
ASONIMGDFILE="$ASONCACHE""/ason.img_detail"
AIMGD=()
ASONGENFILE="$ASONCACHE""/ason.gen"
AGEN=()
AID_NAME="$ASONCACHE""/ason.id-name"
ASONCACHEVER="$ASONCACHE""/ason.versioncache"

# Queue for download
QASON="$ASONCACHE""/ason.donwload"
# Pid of downloader
PID_DOWNLOADER=

# IMG dir
ASONIMAGES="$ASONPATH/img/"
ASONSIMGPLASH="$ASONIMAGES/splash/"
ASONIMGMAIN="$ASONIMAGES/main/"
ASONLOGO="$ASONIMAGES/Ason_64.jpeg"
ASONWARNING="$ASONIMAGES/Ason_warning.png"
ASONCOMPATING="$ASONIMAGES/Ason_compatibility.png"

#* Tittle and share Window components
TITTLE="--title=$NOMBRE - $VERSION"
ICON="--window-icon=$ASONLOGO"

# Set language
case "$LANG" in
es_ES.UTF-8)
    lNOLOGIN="\n\nAson no ha podido encontrar la informacion necesaria para poder inicar en Amazon Games.\n\n\nPor favor, <b>haz login correctamente</b>."
    lLIBRARY=Biblioteca
    lINSTALLED=Instalado
    lOPTIONS=Opciones
    lEXIT=Salir
    lEXITMSG='Espero que hayas disfrutado de ASON. Hasta pronto.'
    lDOWNLOADSM='Descargas'
    lNODOWLOADS='No hay descargas en curso.'
    lGAME='Juego'
    lTITTLE='Titulo'
    lGENRE='Genero'
    lDETAILS='Detalles'
    lBACK='Volver'
    lINSTALL='Instalar'
    lUNINSTALL='Desinstalar'
    lDELETE='Borrar'
    lNOINSTALLED='No hay juegos instalados'
    lPATH='Ruta'
    lUNINSTALLED='Desinstalado'
    lUNINSTALLING='Desinstalando'
    lADDDOWNLOAD='Añadido a la cola de descargas'
    lSEARCH='Buscar'
    lSYNC='Sincronizar'
    lADDMENU='Add Steam...'
    lUPDATE='Actualizar'
    lUPDATING='Actualizando'
    lSYNCHRONIZING='Sincronizando'
    lREFRESH='Refrescar'
    lWAIT='Esperar'
    lASKWAIT='Hay descargas en curso.\n\n¿Quieres esperar a que terminen antes de salir?'
    lALLSTOPED='Todos los procesos han sido detenidos'
    lALLNOSTOPED='Cerrando Ason pero continuando las descargas en segundo plano.\n\nAparecera un mensaje al finalizar'
    lOLWHERE='Donde quieres guardar los juegos descargados?'
    lODGAMESPATH='Ruta de descarga'
    lSAVE='Guardar'
    lABOUT='Acerca de'
    lADREBOOT='Es necesario reiniciar Ason para iniciar con los nuevos cambios'
    lREMEMBERADDSTEAM='Ya tienes tu juego en Steam.\n\n<b>MUY IMPORTANTE</b>, debes de configurar su compatibilidad de Proton desde Steam.\
    Si no haces este cambio, probablemente <b>el juego no va a funcionar</b>.\n\nRecuerda, los juegos son gestionados y configurados desde Steam.'
    lSUREADDSTEAM='Estas <b>SEGURO</b> de que tu quieres add to Steam este juego?\n\nEs posible que el juego sea duplicado si ya lo instalaste anteriormente.\
    \n\n<b>RECUERDA</b>:\n\n\tGestiona tus juegos desde Steam.'
    lSCREENSHOTS='Screenshots'
    ;;
*)
    lNOLOGIN="\n\nAson could not find the information needed to login to Amazon Games.\n\n\nPlease, <b>login correctly</b>."
    lLIBRARY=Library
    lINSTALLED=Installed
    lOPTIONS=Options
    lEXIT=Exit
    lEXITMSG='Thanks for use ASON. Bye Bye...'
    lDOWNLOADSM='Downloads'
    lNODOWLOADS='There are no downloads in progress.'
    lGAME='Game'
    lTITTLE='Tittle'
    lGENRE='Genre'
    lDETAILS='Details'
    lBACK='Back'
    lINSTALL='Install'
    lUNINSTALL='Uninstall'
    lDELETE='Delete'
    lNOINSTALLED='There are no installed games.'
    lPATH='Path'
    lUNINSTALLED='Uninstalled'
    lUNINSTALLING='Uninstalling'
    lADDDOWNLOAD='Add to download'
    lSEARCH='Search'
    lSYNC='Sync'
    lADDMENU='Add Steam...'
    lUPDATE='Update'
    lUPDATING='Updating'
    lSYNCHRONIZING='Synchronizing'
    lREFRESH='Refresh'
    lWAIT='Wait'
    lASKWAIT='There are downloads in progress.\n\nDo you want to wait for them to finish before exiting?'
    lALLSTOPED='All processes have been stopped.'
    lALLNOSTOPED='Closing Ason but continuing downloads in the background.\n\nA message will appear when finished.'
    lOLWHERE='Where do you want to save the downloaded games?'
    lODGAMESPATH='Download path'
    lSAVE='Save'
    lABOUT='About'
    lADREBOOT='You have to close Ason to load the new configuration.'
    lREMEMBERADDSTEAM='You just have the game add to Steam.Now, <b>VERY IMPORTANT</b>, you must configure its Proton compatibility in the game.\
    \n\nIf you do not change the compatibility option on the Steam Game, you can not run the game.\n\n\nGames are managed and configured directly from Steam.'
    lSUREADDSTEAM='Are you <b>SURE</b> you want to add to Steam this game?\n\nIt is possible that the game will be duplicated if you have already installed it.\
    \n\n<b>REMEMBER</b>:\n\n\tManage the game from Steam directly.'
    lSCREENSHOTS='Screenshots'
    ;;
esac

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         FUNCTIONS
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

##
# requisites
# Show the detail of a game
#
# $1 = Text to Debub file
#
function to_debug_file() {
    echo -e "$1" >>"$DEBUGFILE"
}

##
# requisites
# Show the detail of a game
#
function requisites() {
    local __other_requisites=("wget" "iconv" "shuf")
    local __test=

    if [ ! -f "$YAD" ]; then
        if __test=$(which "yad" 2>/dev/null); then
            [ -n "$DEBUG" ] && to_debug_file "DBG: Using yad from $__test"
            YAD=$__test
        else
            [ -n "$DEBUG" ] && to_debug_file "DBG: Missing required component yad"
            echo "Missing required component yad" && exit 1
        fi
    fi

    if [ ! -f "$NILE" ]; then
        if __test=$(which "nile" 2>/dev/null); then
            [ -n "$DEBUG" ] && to_debug_file "DBG: Using nile from $__test"
            NILE=$__test
        else
            [ -n "$DEBUG" ] && to_debug_file "DBG: Missing required component nile"
            echo "Missing required component nile" && exit 1
        fi
    fi

    if [ ! -f "$JQ" ]; then
        if __test=$(which "jq" 2>/dev/null); then
            [ -n "$DEBUG" ] && to_debug_file "DBG: Using jq from $__test"
            JQ=$__test
        else
            [ -n "$DEBUG" ] && to_debug_file "DBG: Missing required component jq"
            echo "Missing required component jq" && exit 1
        fi
    fi

    for i in "${__other_requisites[@]}"; do
        if ! __test=$(which "$i" 2>/dev/null); then
            [ -n "$DEBUG" ] && to_debug_file "DBG: Missing required component jq"
            echo "Missing required component $i" && exit 1
        fi
    done

}

##
# fileRandomInDir
# Return a random file from dir.
#
# $1 = source varname ( dir )
# return The random file in dir.
#
function fileRandomInDir() {
    local __dir=$1

    find "$__dir" -mindepth 0 -maxdepth 1 -type f | shuf -n 1
}

##
# get_cache
# Download the cache images from internet.
#
# $1 = source varname ( url to download )
# $2 = target filename ( file to save the download )
#
function get_cache() {
    local __url=$1
    local __file=$2

    [ ! -f "$__file" ] && wget "$__url" -O "$__file" >/dev/null 2>/dev/null && [ -n "$DEBUG" ] && to_debug_file "DBG: Download image $__url to $__file" &
}

##
# delete_cache
# Delete all cache of Ason
#
function delete_cache() {
    rm "$ASONTITFILE" "$ASONIMGFILE" "$ASONIMGDFILE" "$ASONGENFILE" "$AID_NAME" "$ASONCACHEVER" 2>/dev/null
    [ -n "$DEBUG" ] && to_debug_file "DBG: Delete cache files"
}

##
# serialize_array
# Serializes a bash array to a string, with a configurable seperator.
#
# $1 = source varname ( contains array to be serialized )
# $2 = target varname ( will contian the serialized string )
# $3 = seperator ( optional, defaults to $'\x01' )
#
# example:
#
#    my_arry=( one "two three" four )
#    serialize_array my_array my_string '|'
#
function serialize_array() {
    declare -n _array="${1}" _str="${2}" # _array, _str => local reference vars
    local IFS="${3:-$'\x01'}"
    # shellcheck disable=SC2034 # Reference vars assumed used by caller
    _str="${_array[*]}" # * => join on IFS
}

##
# deserialize_array
# Deserializes a string into a bash array, with a configurable seperator.
#
# $1 = source varname ( contains string to be deserialized )
# $2 = target varname ( will contain the deserialized array )
# $3 = seperator ( optional, defaults to $'\x01' )
#
# example:
#
#    my_string="one|two three|four"
#    deserialize_array my_string my_array '|'
#
function deserialize_array() {
    IFS="${3:-$'\x01'}" read -r -a "${2}" <<<"${!1}" # -a => split on IFS
}

##
# save cache
# Save the arrays to cache files
#
function save_cache() {
    local __serialized=
    serialize_array ATIT __serialized '|'
    echo "$__serialized" >"$ASONTITFILE"
    [ -n "$DEBUG" ] && to_debug_file "DBG: TITTLES:\n $__serialized\n"
    serialize_array AGEN __serialized '|'
    echo "$__serialized" >"$ASONGENFILE"
    [ -n "$DEBUG" ] && to_debug_file "DBG: GENRES:\n $__serialized\n"
    serialize_array AIMG __serialized '|'
    echo "$__serialized" >"$ASONIMGFILE"
    [ -n "$DEBUG" ] && to_debug_file "DBG: IMG:\n $__serialized\n"
    serialize_array AIMGD __serialized '|'
    echo "$__serialized" >"$ASONIMGDFILE"
    [ -n "$DEBUG" ] && to_debug_file "DBG: IMGDescript:\n $__serialized\n"

    echo "$VERSION" >"$ASONCACHEVER"
    [ -n "$DEBUG" ] && to_debug_file "DBG: Cache Version: $VERSION"
}

##
# load_cache
# Load the cache files to arrays
#
function load_cache() {
    local __serialized=
    __serialized="$(cat "$ASONTITFILE")"
    deserialize_array __serialized ATIT '|'
    __serialized="$(cat "$ASONGENFILE")"
    deserialize_array __serialized AGEN '|'
    __serialized="$(cat "$ASONIMGFILE")"
    deserialize_array __serialized AIMG '|'
    __serialized="$(cat "$ASONIMGDFILE")"
    deserialize_array __serialized AIMGD '|'
}

##
# reload_library
# Load in memory the Library of ASON
#
function reload_library() {
    #! indice + img + titulo + Genero
    ALIB=()
    local __num=
    __num=$($JQ ". | length" "$NILELIBR")

    for ((i = 0; i < __num; i++)); do
        ALIB+=("$i" "${AIMG[$i]}" "$(echo "${ATIT[$i]}" | iconv -c)" "${AGEN[$i]}")
    done

    [ -n "$DEBUG" ] && to_debug_file "DBG: RELOAD LIBRARY:\n ${ALIB[*]}"

}

##
# downloader_daemon
# Downloader main daemon
#
# $1 = source varname ( contains pid of father process )
#
function downloader_daemon() {
    # PID of father
    local __fpid=$1
    # File that is downloading
    local __file_downloading=
    # Name of downloading file
    local __downloading=
    # Queue of files to download
    local __files=
    # Name of game
    local __name=
    # Image of game
    local __image=

    [ -d "$QASON" ] || mkdir -p "$QASON"
    find "$QASON" -type f -exec rm -Rf {} \;

    [ -n "$DEBUG" ] && to_debug_file "Downloader: Starting the Descargador."
    while kill -0 "$__fpid" 2>/dev/null || [ "$(ls -A "$QASON")" ]; do

        if [ "$(ls -A "$QASON")" ]; then
            __files=("$QASON"/*)
            __file_downloading="${__files[0]}"
            __downloading=$(basename "$__file_downloading")
            __name=$(cut -d '|' -f1 <"$__file_downloading")
            __image=$(cut -d '|' -f2 <"$__file_downloading")

            {
                echo "Downloader: Downloading a game with ID: $__downloading and name $__name"
                [ ! -d "$DIRINSTALL" ] && mkdir -p "$DIRINSTALL"
                "$NILE" install --base-path "$DIRINSTALL" "$__downloading"
                echo "Downloader: Finish the game with ID: $__downloading and name $__name"
            } >>"$DEBUGFILE" 2>>"$DEBUGFILE"

            sleep 0.5
            if [ -f "$__file_downloading" ]; then
                rm "$__file_downloading"
                show_msg "$lINSTALLED" "$__image"
                [ -n "$DEBUG" ] && to_debug_file "Downloader: Installed $lINSTALLED $__image"
            else
                [ -n "$DEBUG" ] && to_debug_file "Downloader: Uninstalling $__downloading because the user deleted it from the queue"
                "$NILE" uninstall "$__downloading" >>"$DEBUGFILE" 2>>"$DEBUGFILE"
                [ -n "$DEBUG" ] && to_debug_file "Downloader: Uninstalled $__downloading because the user deleted it from the queue"
            fi
        else
            sleep 5
        fi
    done

    [ -n "$DEBUG" ] && to_debug_file "Downloader: Exiting of descargador."

}

##
# add_download
# Add a game to download
#
# $1 = source varname ( contains the ID (of game) )
# S2 = source varname ( name of game )
# S3 = source varname ( path of game image )
#
function add_download() {
    local __id=$1
    local __name=$2
    local __image=$3

    echo -ne "$__name|$__image" | iconv -c >"$QASON/$__id"
    [ -n "$DEBUG" ] && to_debug_file "Downloader: Add to download queue the $(echo -ne "$__name|$__image" | iconv -c)"
}

##
# add_steam_game
# Add a game to Steam
#
# $1 = source varname ( The executable of game )
#
function add_steam_game() {
    if ! grep -i "x-scheme-handler/steam=" <"$HOME"/.config/mimeapps.list >/dev/null 2>/dev/null; then
        echo "x-scheme-handler/steam=steam.desktop;" >>"$HOME"/.config/mimeapps.list
    fi
    #x-scheme-handler/steam=steam.desktop;
    local __encodedUrl=
    __encodedUrl="steam://addnonsteamgame/$(python3 -c "import urllib.parse;print(urllib.parse.quote(\"$1\", safe=''))")"
    touch /tmp/addnonsteamgamefile
    xdg-open "$__encodedUrl" >>"$DEBUGFILE"

    [ -n "$DEBUG" ] && to_debug_file "DBG: Add to steam the url:\n$__encodedUrl\n"
}

##
# create_bat_file
# Create the bat file for windows. Create a bat script (for Windows). This script 1st install dependencies, then run the game
#
# $1 = source varname ( The tittle of game )
# S2 = source varname ( The path of game )
#
function create_bat_file() {
    local __name=$1
    local __path=$2

    local __F=$__path/fuel.json

    local __exec=
    local __dep=
    __exec="$("$JQ" .Main.Command "$__F") $("$JQ" -r '.Main.Args | @sh' "$__F")"

    local __dep=
    local __num=
    local __args=
    local ARG=()
    __num=$("$JQ" ".PostInstall | length" "$__F")
    for ((i = 0; i < __num; i++)); do
        __args=$("$JQ" ".PostInstall[$i].Args | length" "$__F")
        ARG=()
        for ((j = 0; j < __args; j++)); do
            ARG+=("$("$JQ" -r ".PostInstall[$i].Args[$j]" "$__F")")
        done
        __dep+="\n$("$JQ" ".PostInstall[$i].Command" "$__F") ${ARG[*]}"
    done

    local __ason_bat="@echo off\n\n\
IF EXIST c:\\\\ason.dependencies (\n\
   REM Dependencies are installed\n\
)ELSE (\n\
   REM To install the dependencies\n\
   echo Intalling dependencies\n\
$__dep \n\
   echo Installed > c:\\\\ason.dependencies \n\
)\n\
REM Run the app\n\
echo Run Game...\n\
START \"\" $__exec \n\
\n\
exit 0"

    [ -n "$DEBUG" ] && to_debug_file "DBG: Generated the bat file with content:\n $__ason_bat \n"
    echo -ne "$__ason_bat" >"$__path/$__name".bat
    [ -n "$DEBUG" ] && to_debug_file "DBG: Created the bat file in $__path/$__name.bat"
    echo -ne "$__ason_bat" >"$__path/ason.bat"
    [ -n "$DEBUG" ] && to_debug_file "DBG: Created the bat file in $__path/ason.bat"
    echo -ne "$__dep" >"$__path/ason.dependencies.bat"
    [ -n "$DEBUG" ] && to_debug_file "DBG: Created the DEPENDENCIES bat file in $__path/ason.dependencies.bat"

}

##
# show_msg
# Show a message on screen
#
# $1 = source varname ( Text to show )
# $2 = source varname ( [OPTIONAL] image to show )
#
function show_msg() {
    if [ -n "$2" ]; then
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --on-top --align=center --timeout=2 --undecorated --text="$1" --image="$2" --no-markup
    else
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --on-top --align=center --timeout=2 --undecorated --text="$1" --no-markup
    fi
}

##
# dologin
# Login on Amazon Games over Nile.
#
function dologin() {
    [ -n "$DEBUG" ] && to_debug_file "DBG: Doing login"
    "$NILE" auth --login --no-sandbox
    [ -n "$DEBUG" ] && to_debug_file "DBG: Login exit"
}

##
# dologout
# Logout on Amazon Games over Nile.
#
function dologout() {
    [ -n "$DEBUG" ] && to_debug_file "DBG: Doing Logout"
    "$NILE" auth --logout
    [ -n "$DEBUG" ] && to_debug_file "DBG: Logout exit"
}

##
# cache
# Load or generate the cache of ASON
#
function cache() {
    # List of tittles
    ATIT=()
    # List of genres
    AGEN=()
    # List of images
    AIMG=()
    # List of images on detail dialog
    AIMGD=()

    local __num=
    __num=$($JQ ". | length" "$NILELIBR")
    local __url=
    local __file=
    for ((i = 0; i < __num; i++)); do
        echo $((i * 100 / __num))
        __url="$($JQ -r ".[$i].product.productDetail.details.logoUrl" "$NILELIBR")"
        __file="$ASONCACHE/$(basename "$__url")"
        [ -f "$__file" ] || get_cache "$__url" "$__file"
        ATIT+=("$($JQ -r ".[$i].product.title" "$NILELIBR" | iconv -c)")
        AGEN+=("$($JQ -r ".[$i].product.productDetail.details.genres[0]" "$NILELIBR" | iconv -c)")
        AIMG+=("$__file")
        __url="$($JQ -r ".[$i].product.productDetail.details.pgCrownImageUrl" "$NILELIBR")"
        __file="$ASONCACHE/$(basename "$__url")"
        [ -f "$__file" ] || get_cache "$__url" "$__file"
        AIMGD+=("$__file")
    done

    save_cache
}

##
# load_options
# Load the options from the file
#
function load_options() {
    if [ -f "$ASONOPTIONFILE" ]; then
        [ -n "$DEBUG" ] && to_debug_file "DBG: using the options of file $ASONOPTIONFILE"
        DIRINSTALL=$(cut -d '|' -f1 <"$ASONOPTIONFILE")
    else
        [ -n "$DEBUG" ] && to_debug_file "DBG: Using the default options"
    fi
}

##
# loadingW
# The global process to caching
#
function loadingW() {
    # PID of the new dialog
    local __pid=

    # splash Window
    "$YAD" "$TITTLE" --center --splash --on-top --image="$(fileRandomInDir "$ASONSIMGPLASH")" --no-buttons &
    __pid=$!

    [ -d "$ASONCACHE" ] || mkdir -p "$ASONCACHE"

    local __ver_cache=0 && [ -f "$ASONCACHEVER" ] && __ver_cache=$(cat "$ASONCACHEVER")

    if [ ! -f "$ASONTITFILE" ] || [ ! -f "$ASONGENFILE" ] || [ ! -f "$ASONIMGFILE" ] || [ "$__ver_cache" != "$VERSION" ] || [ ! -f "$ASONIMGDFILE" ]; then
        [ -n "$DEBUG" ] && to_debug_file "DBG: Some file cache is missing. Generating the cache"
        delete_cache
        cache | "$YAD" "$ICON" --on-top --text="Caching..." --progress --auto-close --no-buttons --undecorated --no-escape --no-markup
    fi

    if [ ! -f "$AID_NAME" ]; then
        [ -n "$DEBUG" ] && to_debug_file "DBG: Generating the ID and name cache"
        "$JQ" -r '.[] | "\(.id)==\(.product.title)==\(.product.productDetail.details.logoUrl)"' "$NILELIBR" | iconv -c >"$AID_NAME"
    fi

    [ -n "$DEBUG" ] && to_debug_file "DBG: Load cache"
    load_cache
    [ -n "$DEBUG" ] && to_debug_file "DBG: Load options"
    load_options
    [ -n "$DEBUG" ] && to_debug_file "DBG: Reload Library"
    reload_library

    # Kill the splash windows
    kill $__pid
}

##
# mainW
# Show the MAIN Window
#
function mainW() {
    "$YAD" "$TITTLE" --center --image="$(fileRandomInDir "$ASONIMGMAIN")" --sticky --buttons-layout=spread --no-markup \
        --button=$lLIBRARY:0 --button=$lINSTALLED:1 --button=$lOPTIONS:2 --button="$lDOWNLOADSM":3 --button="$lEXIT":100 "$ICON" --fixed --on-top

    MENU=$?
}

##
# libraryW
# Show the LIBRARY Window
#
# $1 = source varname ( [OPTIONAL] text to search)
#
function libraryW() {
    local __ASLIB=()

    if [ -n "$1" ]; then
        local __string=$1 && local __i=0 && local __ID= && local __IMG= && local __TITTLE= && local __GENRE= && local __long=
        __long=${#ALIB[@]}

        while [ "$__i" -lt "$__long" ]; do
            __ID=${ALIB[$__i]} && __i=$((__i + 1))
            __IMG=${ALIB[$__i]} && __i=$((__i + 1))
            __TITTLE=${ALIB[$__i]} && __i=$((__i + 1))
            __GENRE=${ALIB[$__i]} && __i=$((__i + 1))

            if echo "$__TITTLE" | grep -i "$__string" >/dev/null; then
                __ASLIB+=("$__ID" "$__IMG" "$__TITTLE" "$__GENRE")
            fi

        done
    else
        __ASLIB=("${ALIB[@]}")
    fi

    # Result of YAD dialog
    local __salida=
    local __boton=0

    [ -n "$DEBUG" ] && to_debug_file "DBG: Showing the library list:\n${__ASLIB[*]}"

    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --on-top --list --width=1280 --height=800 --hide-column=1 --sticky --no-markup --buttons-layout=spread \
            --button="$lBACK":1 --button="$lSEARCH":3 --button="$lDETAILS":0 --button="$lSYNC":4 --button="$lINSTALL":2 \
            --column=ID --column="$lGAME":IMG --column="$lTITTLE" --column="$lGENRE" "${__ASLIB[@]}")

        local __boton=$?
        local __index=
        __index=$(echo "$__salida" | cut -d'|' -f1)

        case $__boton in
        0) # Details
            [ -n "$DEBUG" ] && to_debug_file "DBG: Get game detail of $__index index"
            gameDetailW "$__index"
            ;;

        2) # Install
            local __id=
            local __name=
            __id=$($JQ -r ".[$__index].id" "$NILELIBR")
            __name=$(echo "$__salida" | cut -d'|' -f3)
            show_msg "$lADDDOWNLOAD" "${AIMG[$__index]}"
            add_download "$__id" "$__name" "${AIMG[$__index]}"
            ;;
        3) # Buscar
            __salida=$("$YAD" "$TITTLE" "$ICON" --center --on-top --no-escape --button="OK":0 --form --field="$lSEARCH:")
            __salida=${__salida::-1}
            [ -n "$DEBUG" ] && to_debug_file "DBG: Searching the title:\n$__salida\n"
            libraryW "$__salida"
            break
            ;;
        4) # Sincronizar
            show_msg "$lSYNCHRONIZING..." &
            local __num= && local __num_new=
            __num=$($JQ ". | length" "$NILELIBR")
            "$NILE" library sync 2>"$DEBUGFILE"
            __num_new=$($JQ ". | length" "$NILELIBR")
            if [ "$__num" -ne "$__num_new" ]; then
                [ -n "$DEBUG" ] && to_debug_file "DBG: The library is changed"
                delete_cache
                loadingW
                break
            fi
            ;;
        *) ;;
        esac
    done
}

##
# download_managerW
# Show the downloads queue
#
function download_managerW() {

    # Result of YAD dialog
    local __salida=
    local __boton=0
    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do

        if [ "$(ls -A "$QASON")" ]; then
            # List of downloads
            local __descargas=
            # Name of game
            local __name=
            # Image of game
            local __image=
            # List of Ason's download
            local __ADOWN=()
            __descargas=("$QASON"/*)

            [ "${#__descargas[@]}" -eq 0 ] || for i in "${__descargas[@]}"; do
                __name=$(cut -d '|' -f1 <"$i")
                __image=$(cut -d '|' -f2 <"$i")
                __ADOWN+=("$i" "$__image" "$__name")
            done

            local __salida=
            __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 --sticky --no-markup --buttons-layout=spread \
                --column=File --column="$lGAME":IMG --column="$lTITTLE" --button="$lBACK":1 --button="$lREFRESH":2 --button="$lDELETE":0 "${__ADOWN[@]}")

            local __boton=$?

            if [ "$__boton" -eq 0 ]; then
                [ -n "$DEBUG" ] && to_debug_file "DBG: Deleting the download $(echo "$__salida" | cut -d'|' -f1)"
                rm "$(echo "$__salida" | cut -d'|' -f1)"
            fi
        else
            show_msg "$lNODOWLOADS"
            __boton=1
        fi
    done

}

##
# gameDetailW
# Show the detail of a game
#
# $1 = source varname ( contains the index of game in JSON)
#
function gameDetailW() {
    local __index=$1
    local __fecha=
    local __developer=
    local __publicador=
    local __esrb=
    local __generos=
    local __modos=
    local __desc=
    local __info=
    __info=$("$JQ" -r '.['"$__index"'].product.productDetail.details | "\(.releaseDate)|\(.developer)|\(.publisher)|\(.esrbRating)|\(.genres)|\(.gameModes)|\(.shortDescription)|\(.screenshots)"' "$NILELIBR")

    __fecha=$(echo "$__info" | cut -d '|' -f1 | iconv -c)
    __fecha="${__fecha:0:10}"
    __developer=$(echo "$__info" | cut -d '|' -f2 | iconv -c)
    __publicador=$(echo "$__info" | cut -d '|' -f3 | iconv -c)
    __esrb=$(echo "$__info" | cut -d '|' -f4 | iconv -c)
    __generos=$(echo "$__info" | cut -d '|' -f5 | iconv -c)
    __modos=$(echo "$__info" | cut -d '|' -f6 | iconv -c)
    __desc=$(echo "$__info" | cut -d '|' -f7 | iconv -c)

    local __text=
    __text="Rel. Date: $__fecha\tDeveloper: $__developer\tPublisher: $__publicador\n\nESRB: $__esrb\tGenre: $__generos\tModes: $__modos\n\nDescription: $__desc"

    local __image=
    [ "$(basename "${AIMGD[$__index]}")" == 'null' ] && __image=${AIMG[$__index]} || __image=${AIMGD[$__index]}

    [ -n "$DEBUG" ] && to_debug_file "DBG: Detail of game:\n$__text\nAnd image: $__image"

    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        "$YAD" "$TITTLE" "$ICON" --center --image="$__image" --sticky --buttons-layout=spread --width=512 --no-markup --no-markup --form \
            --item-separator="#@#" --field="$__text":LBL --button="$lBACK":1 --button="$lSCREENSHOTS":4 --button="$lINSTALL":8 >/dev/null

        local __boton=$?
        case "$__boton" in
        0) ;;
        4)
            [ -n "$DEBUG" ] && to_debug_file "DBG: View screenshot of $__index index"
            screnshotsW "$__index"
            ;;
        8)
            local __id=
            local __name=
            __id=$($JQ -r ".[$__index].id" "$NILELIBR")
            __name=${ATIT[$__index]}
            show_msg "$lADDDOWNLOAD" "${AIMG[$__index]}"
            add_download "$__id" "$__name" "${AIMG[$__index]}"
            ;;
        *) ;;
        esac
    done
}

##
# screnshotsW
# Show the SCREENSHOTS Window
#
# $1 = source varname ( contains the index of game in JSON)
#
function screnshotsW() {
    local __index=$1
    local __tempS=/tmp/ason.screenshots/

    [ ! -d "$__tempS" ] && mkdir "$__tempS"
    [ -f "$__tempS/urls" ] && rm "$__tempS/urls"

    for ((j = 0; j < $("$JQ" -r .["$__index"].product.productDetail.details.screenshots "$NILELIBR" | jq length); j++)); do
        "$JQ" -r .["$__index"].product.productDetail.details.screenshots[$j] "$NILELIBR" >>"$__tempS/urls"
    done

    wget -i "$__tempS/urls" -P "$__tempS/." >/dev/null 2>/dev/null && rm "$__tempS/urls"

    for i in "$__tempS"/*; do
        [ -n "$DEBUG" ] && to_debug_file "DBG: Showing the screenshot $i"
        "$YAD" "$TITTLE" "$ICON" --picture --filename="$i" --size=fit --buttons-layout=edge --width=1280 --height=800 \
            --no-markup --button=Exit:252 --button=Next:0 || break
    done

    rm "$__tempS"/*
}

##
# installedW
# Show the INSTALLED Window
#
function installedW() {

    if [ ! -f "$NILEINSTALLED" ] || [ "$("$JQ" ". | length" "$NILEINSTALLED")" == 0 ]; then
        show_msg "$lNOINSTALLED"
    else
        # Result of YAD dialog
        local __salida=
        local __boton=0
        while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
            local __num=
            __num=$("$JQ" ". | length" "$NILEINSTALLED")
            local __LISTA=()
            local __ID=
            local __NOMBRE=
            local __IMG=
            local __PATH=

            for ((i = 0; i < __num; i++)); do
                __ID=$("$JQ" -r ".[$i].id" "$NILEINSTALLED")
                __NOMBRE=$(grep "$__ID" <"$AID_NAME" | cut -d '=' -f3 | iconv -c)
                __IMG=$(grep "$__ID" <"$AID_NAME" | cut -d '=' -f5)
                __PATH=$("$JQ" -r .[$i].path "$NILEINSTALLED" | iconv -c)
                __LISTA+=("$i" "$__NOMBRE" "$ASONCACHE/$(basename "$__IMG")" "$__PATH")
            done

            [ -n "$DEBUG" ] && to_debug_file "DBG: Showing the installed list:\n${__LISTA[*]}"

            __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 --sticky --buttons-layout=spread \
                --no-markup --column=Index --column="$lTITTLE" --column="$lGAME":IMG --column="$lPATH" \
                --button="$lBACK":1 --button="$lADDMENU":0 --button="$lUPDATE":4 --button="$lUNINSTALL":2 "${__LISTA[@]}")

            local __boton=$?
            __ID=$(echo "$__salida" | cut -d '|' -f1)
            __NOMBRE=$(echo "$__salida" | cut -d '|' -f2)
            __PATH=$("$JQ" -r .["$__ID"].path "$NILEINSTALLED")

            case "$__boton" in
            0) # Run Menu
                if "$YAD" "$TITTLE" "$ICON" --center --text="$lSUREADDSTEAM"; then
                    [ -n "$DEBUG" ] && to_debug_file "DBG: Creating the bat files"
                    create_bat_file "$__NOMBRE" "$__PATH"
                    [ -n "$DEBUG" ] && to_debug_file "DBG: Adding to Steam"
                    add_steam_game "$__PATH/$__NOMBRE".bat
                    "$YAD" "$TITTLE" "$ICON" --center --text="$lREMEMBERADDSTEAM" --button="OK":0 --image="$ASONCOMPATING"
                fi
                ;;
            2) # Uninstall
                show_msg "$lUNINSTALLING $(echo "$__NOMBRE" | iconv -c)" &
                [ -n "$DEBUG" ] && to_debug_file "DBG: Uninstalling $(echo "$__NOMBRE" | iconv -c)"
                "$NILE" uninstall "$("$JQ" -r ".[$__ID].id" "$NILEINSTALLED")" 2>>"$DEBUGFILE"
                show_msg "$lUNINSTALLED $(echo "$__NOMBRE" | iconv -c)"
                ;;
            4) # Update
                show_msg "$lUPDATING $(echo "$__NOMBRE" | iconv -c)" &
                [ ! -d "$DIRINSTALL" ] && mkdir -p "$DIRINSTALL"
                [ -n "$DEBUG" ] && to_debug_file "DBG: Updating $(echo "$__NOMBRE" | iconv -c)"
                "$NILE" install --base-path "$DIRINSTALL" "$("$JQ" -r ".[$__ID].id" "$NILEINSTALLED")" 2>>"$DEBUGFILE"
                show_msg "Updated $(echo "$__NOMBRE" | iconv -c)"
                ;;
            *) ;;

            esac
        done
    fi

}

##
# optionW
# Show the OPTION Window
#
function optionW() {
    local __salida=

    __salida=$("$YAD" "$TITTLE" "$ICON" --columns=1 --form --image="$(fileRandomInDir "$ASONSIMGPLASH")" \
        --button="$lBACK":1 --button="$lSAVE":0 --button="Logout":3 --button="$lABOUT":2 --buttons-layout=edge --align=center \
        --field="$lOLWHERE:LBL" --field="$lODGAMESPATH:DIR" '' "$DIRINSTALL")

    local __boton=$?

    case "$__boton" in
    0)
        local __ruta=
        __ruta=$(echo "$__salida" | cut -d '|' -f2)
        echo "$__ruta"'|' >"$ASONOPTIONFILE"
        [ ! -d "$__ruta" ] && mkdir "$__ruta"
        DIRINSTALL=$__ruta
        "$YAD" "$TITTLE" "$ICON" --center --on-top --align=center --undecorated --text="$lADREBOOT" --button=OK:0
        ;;
    2)
        aboutW
        ;;
    3)
        dologout
        delete_cache
        show_msg "Exiting from Ason"
        rm -f "$NILEUSER" "$NILELIBR"
        exit 0
        ;;
    *) ;;
    esac
}

##
# aboutW
# Show the ABOUT Window
#
function aboutW() {
    "$YAD" "$TITTLE" "$ICON" --about --pname="ASON" --pversion="$VERSION" --comments="Play at your games of Amazon in Linux." \
        --authors="Paco Guerrero [fjgj1@hotmail.com],Nobody else XD" --website="https://github.com/FranjeGueje/Ason" --image="$ASONLOGO"
    "$YAD" "$TITTLE" "$ICON" --text='Thanks to my family for their patience... My wife and children have earned heaven.\nAnd to you, my Elena.\n\n\nCredits to:\n\tNile <a href="https://github.com/imLinguin/nile">Link</a> - Cli to downloads Amazon Games on Linux\n\tYAD <a href="https://github.com/v1cont/yad">Link</a> - Advaced Dialogs on Linux\n\tJQ <a href="https://stedolan.github.io/jq">Link</a> - To work with json files\n\nAnd the Linux comunity.' \
        --width=480 --height=230
}

##
# exitW
# Show the EXIT Window
#
function exitW() {
    "$YAD" "$TITTLE" --splash --no-buttons --image="$(fileRandomInDir "$ASONSIMGPLASH")" --form --field="$lEXITMSG:LBL" --align=center --timeout=3 \
        --item-separator="#@#" --no-markup

    if kill -0 "$PID_DOWNLOADER" 2>/dev/null && [ "$(ls -A "$QASON")" ]; then
        [ -n "$DEBUG" ] && to_debug_file "DBG: Downloader is active"
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --sticky --buttons-layout=spread --no-escape \
            --button="$lWAIT":1 --button="$lEXIT":0 --text="$lASKWAIT")

        local __boton=$?
        if [ $__boton -eq 0 ]; then
            [ -n "$DEBUG" ] && to_debug_file "DBG: Killing the $PID_DOWNLOADER pid"
            kill "$PID_DOWNLOADER"
            [ -n "$DEBUG" ] && to_debug_file "DBG: Killing all nile process"
            pkill nile
            [ -n "$DEBUG" ] && to_debug_file "DBG: Quiting with brute force"
            show_msg "$lALLSTOPED"
        else
            [ -n "$DEBUG" ] && to_debug_file "DBG: Exiting but waiting to downloader"
            show_msg "$lALLNOSTOPED"
        fi
    fi
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         MAIN
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#* Check the requisites and required components
requisites

[ -n "$DEBUG" ] && [ -f "$DEBUGFILE" ] && rm "$DEBUGFILE"

#* While the user is not logged
while [ ! -f "$NILEUSER" ] || [ ! -f "$NILELIBR" ]; do
    [ -n "$DEBUG" ] && to_debug_file "DBG: Nile files are missing. Do login"
    "$YAD" "$TITTLE" --center --splash --image="$ASONWARNING" --text="$lNOLOGIN" \
        --timeout=4 --no-buttons --timeout-indicator=top
    dologin
done

[ -n "$DEBUG" ] && to_debug_file "DBG: LOADING"
loadingW

downloader_daemon $$ &
PID_DOWNLOADER=$!

MENU=0
while [ $MENU -ne 252 ] && [ $MENU -ne 100 ]; do
    mainW
    case $MENU in
    0) libraryW ;;
    1) installedW ;;
    2) optionW ;;
    3) download_managerW ;;
    252 | 100) exitW ;;
    esac
done

[ -n "$DEBUG" ] && to_debug_file "DBG: Exit"

exit 0
