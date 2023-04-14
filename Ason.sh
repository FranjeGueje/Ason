#!/bin/bash
##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# PROJECT: ASON (Amazon on SteamOS Over Nile)
# ABOUT: script with the objective of displaying an interface, i.e. a frontend for the unofficial Amazon Games linux client called 'nile'.
#
# PARAMS: Nope.
#
# REQUERIMENTS: It does not have more than those required by the NILE project.
#
# EXITs:
# 0 --> OK!!!.
##############################################################################################################################################################

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         GLOBAL VARIABLES
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Basic
NOMBRE="ASON - [Amazon Games on Steam OS over Nile]"
VERSION=2.0.0b1

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
#TODO para las opciones de configuracion (Temporal)
DIRINSTALL="$HOME/Games"

# Config files of Ason
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
# Log of downloader
LOGDOWNLOADER="$ASONCACHE"ason.downloader.log

# Desktop file
#DESKTOP_NAME_FILE="$HOME/.local/share/applications/ason.desktop"

# Startup content
#CONTENT_DESKTOP="[Desktop Entry]\n\
#Name=Ason\n\
#Exec=\"$(readlink -f "$0")\"\n\
#Terminal=false\n\
#Type=Application\n"

# IMG dir
ASONIMAGES="$ASONPATH/img/"
ASONSIMGPLASH="$ASONIMAGES/splash/"
ASONIMGMAIN="$ASONIMAGES/main/"
ASONLOGO="$ASONIMAGES/Ason_64.jpeg"
ASONWARNING="$ASONIMAGES/warning.png"

#* Tittle and share Window components
TITTLE="--title=$NOMBRE - $VERSION"
ICON="--window-icon=$ASONLOGO"

# Set language
case "$LANG" in
es_ES.UTF-8)
    lNOLOGIN="Ason no ha podido encontrar la informacion necesaria para poder login en Amazon Games.\n\nPor favor, haz login correctamente."
    lLIBRARY=Biblioteca
    lINSTALLED=Instalado
    lOPTIONS=Opciones
    lEXIT=Salir
    lEXITMSG='Gracias por usar ASON. Hasta pronto.'
    lDOWNLOADSM='Descargas'
    lNODOWLOADS='No hay descargas en curso.'
    lGAME='Juego'
    lTITTLE='Titulo'
    lGENRE='Genero'
    lDETAILS='Detalles'
    lBACK='Volver'
    lINSTALL='Instalar'
    lUNINSTALL='Desinstalar'
    #lADD_STEAM='Add to Steam'
    lDELETE='Borrar'
    lNOINSTALLED='No hay juegos instalados'
    lPATH='Ruta'
    lUNINSTALLED='Desinstalado'
    lUNINSTALLING='Desinstalando'
    lADDDOWNLOAD='Añadido a la cola de descargas'
    lSEARCH='Buscar'
    lSYNC='Sincronizar'
    lRUNMENU='Lanzar...'
    lUPDATE='Actualizar'
    lUPDATING='Actualizando'
    lSYNCHRONIZING='Sincronizando'
    lREFRESH='Refrescar'
    lWAIT='Esperar'
    lASKWAIT='Hay descargas en curso.\n\n¿Quieres esperar a que terminen antes de salir?'
    lALLSTOPED='Todos los procesos han sido detenidos'
    lALLNOSTOPED='Cerrando Ason pero continuando las descargas en segundo plano.\n\nAparecerá un mensaje al finalizar'
    ;;
*)
    lNOLOGIN="Ason could not find the information needed to login to Amazon Games.\n\nPlease login correctly."
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
    #lADD_STEAM='Add to Steam'
    lDELETE='Delete'
    lNOINSTALLED='There are no installed games.'
    lPATH='Path'
    lUNINSTALLED='Uninstalled'
    lUNINSTALLING='Uninstalling'
    lADDDOWNLOAD='Add to download'
    lSEARCH='Search'
    lSYNC='Sync'
    lRUNMENU='Run...'
    lUPDATE='Update'
    lUPDATING='Updating'
    lSYNCHRONIZING='Synchronizing'
    lREFRESH='Refresh'
    lWAIT='Wait'
    lASKWAIT='There are downloads in progress.\n\nDo you want to wait for them to finish before exiting?'
    lALLSTOPED='All processes have been stopped.'
    lALLNOSTOPED='Closing Ason but continuing downloads in the background.\n\nA message will appear when finished.'
    ;;
esac

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         FUNCTIONS
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

    [ -f "$__file" ] || wget "$__url" -O "$__file" >/dev/null 2>/dev/null &
}

##
# delete_cache
# Delete all cache of Ason
#
function delete_cache() {
    rm "$ASONTITFILE" "$ASONIMGFILE" "$ASONIMGDFILE" "$ASONGENFILE" "$AID_NAME" "$ASONCACHEVER" 2>/dev/null
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
    serialize_array AGEN __serialized '|'
    echo "$__serialized" >"$ASONGENFILE"
    serialize_array AIMG __serialized '|'
    echo "$__serialized" >"$ASONIMGFILE"
    serialize_array AIMGD __serialized '|'
    echo "$__serialized" >"$ASONIMGDFILE"

    echo "$VERSION" >"$ASONCACHEVER"
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

    echo "Starting the Descargador." >"$LOGDOWNLOADER"
    while kill -0 "$__fpid" 2>/dev/null || [ "$(ls -A "$QASON")" ]; do

        if [ "$(ls -A "$QASON")" ]; then
            __files=("$QASON"/*)
            __file_downloading="${__files[0]}"
            __downloading=$(basename "$__file_downloading")
            __name=$(cut -d '|' -f1 <"$__file_downloading")
            __image=$(cut -d '|' -f2 <"$__file_downloading")

            {
                echo "Downloader: Downloading a game with ID: $__downloading and name $__name"
                "$NILE" install --base-path "$DIRINSTALL" "$__downloading"
                echo "Downloader: Finish the game with ID: $__downloading and name $__name"
            } >>"$LOGDOWNLOADER" 2>>"$LOGDOWNLOADER"

            sleep 0.5
            if [ -f "$__file_downloading" ]; then
                rm "$__file_downloading"
                show_msg "$lINSTALLED" "$__image"
            else
                "$NILE" uninstall "$__downloading" >>"$LOGDOWNLOADER" 2>>"$LOGDOWNLOADER"
            fi
        else
            sleep 5
        fi
    done

    echo "Exiting of descargador." >>"$LOGDOWNLOADER"

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

    echo -ne "$__name|$__image" >"$QASON/$__id"
}

##
# add_steam
# Add a game to Steam
#
# $1 = source varname ( The tittle of game )
# S2 = source varname ( The path of game )
#
function add_steam() {
    local __name=$1
    local __path=$2

    local __ason_bat="@echo off\n\n\
    IF EXIST \"ason.dependencies\" (\n\
    	REM Requisitos instalados\n\
    )ELSE (\n\
    	REM Instalar requisitos\n\
    	echo Intalling dependencies\n\
    	$__name \n\
    	echo Installed > ason.dependencies\n\
    )\n\
    \n\
    REM Lanzo la app\n\
    echo Run Game\n\
    $__path \n\
    \n\
    exit 0"

    echo "$__name $__path"
    echo -ne "$__ason_bat" >"$__path/$__name".bat
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
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --on-top --align=center --timeout=2 --undecorated --text="$1" --image="$2"
    else
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --on-top --align=center --timeout=2 --undecorated --text="$1"
    fi
}

##
# dologin
# Login on Amazon Games over Nile.
#
function dologin() {
    "$NILE" auth --login --no-sandbox
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
# loadingW
# The global process to caching
#
function loadingW() {
    # PID of the new dialog
    local __pid=

    # splash Window
    "$YAD" "$TITTLE" --center --splash  --on-top --image="$(fileRandomInDir "$ASONSIMGPLASH")" --no-buttons &
    __pid=$!

    [ -d "$ASONCACHE" ] || mkdir -p "$ASONCACHE"

    local __ver_cache=0 && [ -f "$ASONCACHEVER" ] && __ver_cache=$(cat "$ASONCACHEVER")

    if [ ! -f "$ASONTITFILE" ] || [ ! -f "$ASONGENFILE" ] || [ ! -f "$ASONIMGFILE" ] || [ "$__ver_cache" != "$VERSION" ] || [ ! -f "$ASONIMGDFILE" ]; then
        delete_cache
        cache | "$YAD" "$ICON" --on-top --text="Caching..." --progress --auto-close --no-buttons --undecorated --no-escape
    fi

    if [ ! -f AID_NAME ]; then
        "$JQ" -r '.[] | "\(.id)==\(.product.title)==\(.product.productDetail.details.logoUrl)"' "$NILELIBR" | iconv -c >"$AID_NAME"
    fi

    load_cache
    reload_library

    # Kill the splash windows
    kill $__pid
}

##
# mainW
# Show the MAIN Window
#
function mainW() {
    "$YAD" "$TITTLE" --center --image="$(fileRandomInDir "$ASONIMGMAIN")" --sticky --buttons-layout=spread \
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

    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --on-top --list --width=1280 --height=800 --hide-column=1 --sticky --buttons-layout=spread \
            --button="$lBACK":1 --button="$lSEARCH":3 --button="$lDETAILS":0 --button="$lSYNC":4 --button="$lINSTALL":2 \
            --column=ID --column="$lGAME":IMG --column="$lTITTLE" --column="$lGENRE" "${__ASLIB[@]}")

        local __boton=$?
        local __index=
        __index=$(echo "$__salida" | cut -d'|' -f1)

        case $__boton in
        # Details
        0) gameDetailW "$__index" ;;

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
            libraryW "$__salida"
            break
            ;;
        4) # Sincronizar
            show_msg "$lSYNCHRONIZING..." &
            local __num= && local __num_new=
            __num=$($JQ ". | length" "$NILELIBR")
            "$NILE" library sync 2>/tmp/ason.msg
            __num_new=$($JQ ". | length" "$NILELIBR")
            show_msg "$(cat /tmp/ason.msg)"
            if [ "$__num" -ne "$__num_new" ]; then
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
            __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 --sticky --buttons-layout=spread \
                --column=File --column="$lGAME":IMG --column="$lTITTLE" --button="$lBACK":1 --button="$lREFRESH":2 --button="$lDELETE":0 "${__ADOWN[@]}")

            local __boton=$?

            if [ "$__boton" -eq 0 ]; then
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
    local __fecha= ; local __developer= ;local __publicador= ;local __esrb= ;local __generos= ;local __modos= ;local __desc= ; local __info=
    __info=$("$JQ" -r '.['"$__index"'].product.productDetail.details | "\(.releaseDate)|\(.developer)|\(.publisher)|\(.esrbRating)|\(.genres)|\(.gameModes)|\(.shortDescription)|\(.screenshots)"' "$NILELIBR")
    
    __fecha=$(echo "$__info" | cut -d '|' -f1)
    __developer=$(echo "$__info" | cut -d '|' -f2)
    __publicador=$(echo "$__info" | cut -d '|' -f3)
    __esrb=$(echo "$__info" | cut -d '|' -f4)
    __generos=$(echo "$__info" | cut -d '|' -f5)
    __modos=$(echo "$__info" | cut -d '|' -f6)
    __desc=$(echo "$__info" | cut -d '|' -f7)

    local __text=
    __text="<b>Rel. Date:</b> $__fecha\t<b>Dev:</b> $__developer\t<b>Publ:</b> $__publicador\n\n<b>ESRB:</b> $__esrb\t<b>Genre:</b> $__generos\t<b>Modes:</b> $__modos\n\n<b>Description:</b> $__desc"

    local __image=
    [ "$(basename "${AIMGD[$__index]}")" == 'null' ] && __image=${AIMG[$__index]} || __image=${AIMGD[$__index]}
    
    "$YAD" "$TITTLE" --center --image="$__image" --sticky --buttons-layout=spread --width=512 --form --field="$__text":LBL --button="$lBACK":1 --button="$lINSTALL":8 > /dev/null

    local __boton=$?
    if [ "$__boton" -eq 8 ];then
        local __id=
        local __name=
        __id=$($JQ -r ".[$__index].id" "$NILELIBR")
        __name=${ATIT[$__index]}
        show_msg "$lADDDOWNLOAD" "${AIMG[$__index]}"
        add_download "$__id" "$__name" "${AIMG[$__index]}"
    fi

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

            __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 --sticky --buttons-layout=spread \
                --column=Index --column="$lTITTLE" --column="$lGAME":IMG --column="$lPATH" \
                --button="$lBACK":1 --button="$lRUNMENU":0 --button="$lUPDATE":4 --button="$lUNINSTALL":2 "${__LISTA[@]}")

            local __boton=$?
            __ID=$(echo "$__salida" | cut -d '|' -f1)
            __NOMBRE=$(echo "$__salida" | cut -d '|' -f2)
            __PATH=$("$JQ" -r .["$__ID"].path "$NILEINSTALLED")

            case "$__boton" in
            0) # Run
                #TODO llamar a la función de añadir a Steam que creará un .bat con los requisitos y lanzar el juego gracias a fuel.json
                add_steam "$__NOMBRE" "$__PATH"
                ;;
            2) # Uninstall
                show_msg "$lUNINSTALLING $(echo "$__NOMBRE" | iconv -c)" &
                "$NILE" uninstall "$("$JQ" -r ".[$__ID].id" "$NILEINSTALLED")" 2>/tmp/ason.msg
                show_msg "$lUNINSTALLED $(echo "$__NOMBRE" | iconv -c):\n $(cat /tmp/ason.msg)"
                ;;
            4) # Update
                show_msg "$lUPDATING $(echo "$__NOMBRE" | iconv -c)" &
                "$NILE" install --base-path "$DIRINSTALL" "$("$JQ" -r ".[$__ID].id" "$NILEINSTALLED")" 2>/tmp/ason.msg
                show_msg "Updated $(echo "$__NOMBRE" | iconv -c):\n $(cat /tmp/ason.msg)"
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
    aboutW
}

##
# aboutW
# Show the ABOUT Window
#
function aboutW() {
    "$YAD" "$TITTLE" --about --pname="ASON" --pversion="$VERSION" --comments="Play at your games of Amazon in Linux" \
        --authors="Paco Guerrero <fjgj1@hotmail.com>" --website="https://github.com/FranjeGueje/Ason" "$ICON" --image="$ASONLOGO"
}

##
# exitW
# Show the EXIT Window
#
function exitW() {
    "$YAD" "$TITTLE" --splash --no-buttons --image="$(fileRandomInDir "$ASONSIMGPLASH")" --form --field="$lEXITMSG:LBL" --align=center --timeout=3

    if kill -0 "$PID_DOWNLOADER" 2>/dev/null && [ "$(ls -A "$QASON")" ];then
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --sticky --buttons-layout=spread --no-escape \
            --button="$lWAIT":1 --button="$lEXIT":0 --text="$lASKWAIT")

        local __boton=$?
        if [ $__boton -eq 0 ]; then
            kill "$PID_DOWNLOADER"
            pkill nile
            show_msg "$lALLSTOPED"
        else
            show_msg "$lALLNOSTOPED"
        fi
    fi
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         MAIN
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#* While the user is not logged
while [ ! -f "$NILEUSER" ] || [ ! -f "$NILELIBR" ]; do
    "$YAD" "$TITTLE" --center --splash --image="$ASONWARNING" --text="$lNOLOGIN" \
        --timeout=4 --no-buttons --timeout-indicator=top
    dologin
done

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

exit 0
