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

#########################################
##         GLOBAL VARIABLES 
#########################################
# Basic
NOMBRE="ASON - [Amazon Games on Steam OS over Nile]"
VERSION=2.0.0b1

# Configs of nile
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
DIRINSTALL="/run/media/mmcblk0p1/tmp/"

# Configs of Ason
ASONTITFILE="$ASONCACHE""/ason.tit"; ATIT=()
ASONIMGFILE="$ASONCACHE""/ason.img"; AIMG=()
ASONGENFILE="$ASONCACHE""/ason.gen"; AGEN=()
AID_NAME="$ASONCACHE""/ason.id-name"

# Queue for download
QASON="$ASONCACHE""/ason.donwload"
# Pid of downloader
PID_DOWNLOADER=
# Log of downloader
LOGDOWNLOADER="$ASONCACHE"ason.downloader.log

# Where is Steam, compatdata,shadercache, and grid
#STEAM="$HOME/.local/share/Steam"
#COMPATDATA="$STEAM/steamapps/compatdata"
#SHADERCACHE="$STEAM/steamapps/shadercache"
#DIRGRID="$STEAM/userdata/??*/config/grid/"

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
#TITTLE="--title=\"[A]mazon Game[S] [O]ver [N]ile\""
TITTLE="--title=$NOMBRE - $VERSION"
ICON="--window-icon=$ASONLOGO"

# Set language
case "$LANG" in
    es_ES.UTF-8)
        lNOLOGIN="Ason no ha podido encontrar la informacion necesaria para poder login en Amazon Games.\n\n\
Por favor, haz login correctamente."
        lLIBRARY=Biblioteca
        lINSTALLED=Instalados
        lOPTIONS=Opciones
        lEXIT=Salir
        lEXITMSG='Gracias por usar ASON. Hasta pronto.'
        lDOWNLOADSM='Descargas'
        lNODOWLOADS='No hay descargas en curso.'
        lDOWNLOADING='Descargando'
        lGAME='Juego'
        lTITTLE='Titulo'
        lGENRE='Genero'
        lDETAILS='Detalles'
        lBACK='Volver'
        lINSTALL='Instalar'
        lUNINSTALL='Desinstalar'
        lRUN='Lanzar'
        lDELETE='Borrar'
        lNOINSTALLED='No hay juegos instalados'
        lPATH='Ruta'
        ;;
    *)
        lNOLOGIN="Ason could not find the information needed to login to Amazon Games.\n\n\
Please login correctly."
        lLIBRARY=Library
        lINSTALLED=Installed
        lOPTIONS=Options
        lEXIT=Exit
        lEXITMSG='Thanks for use ASON. Bye Bye...'
        lDOWNLOADSM='Downloads'
        lNODOWLOADS='There are no downloads in progress.'
        lDOWNLOADING='Downloading'
        lGAME='Game'
        lTITTLE='Tittle'
        lGENRE='Genre'
        lDETAILS='Details'
        lBACK='Back'
        lINSTALL='Install'
        lUNINSTALL='Uninstall'
        lRUN='Run'
        lDELETE='Delete'
        lNOINSTALLED='There are no installed games.'
        lPATH='Path'
        ;;
esac

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#########################################
##         FUNCTIONS 
#########################################

#########################
# AUXILIARY FUNCT BEGIN #
#########################

##
# getCache
# Download the cache images from internet.
#
# $1 = source varname ( url to download )
# $2 = target filename ( file to save the download )
#
function getCache()
{
    local __url=$1
    local __file=$2

    [ -f "$__file" ] || wget "$__url" -O "$__file" > /dev/null 2> /dev/null &
}

##
# fileRandomInDir
# Return a random file from dir.
#
# $1 = source varname ( dir )
# return The random file in dir.
#
function fileRandomInDir()
{
    local __dir=$1
    
    find "$__dir" -mindepth 0 -maxdepth 1 -type f | shuf -n 1
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
function save_cache()
{
    local __serialized=
    serialize_array ATIT __serialized '|'
    echo "$__serialized" > "$ASONTITFILE"
    serialize_array AGEN __serialized '|'
    echo "$__serialized" > "$ASONGENFILE"
    serialize_array AIMG __serialized '|'
    echo "$__serialized" > "$ASONIMGFILE"
}

##
# load_cache
# Load the cache files to arrays
#
function load_cache()
{
    local __serialized=
    __serialized="$(cat "$ASONTITFILE")"
    deserialize_array __serialized ATIT '|'
    __serialized="$(cat "$ASONGENFILE")"
    deserialize_array __serialized AGEN '|'
    __serialized="$(cat "$ASONIMGFILE")"
    deserialize_array __serialized AIMG '|'
}

##
# reload_library
# Load in memory the Library of ASON
#
function reload_library()
{
    #! indice + img + titulo + Genero
    ALIB=()
    local __num=
    __num=$($JQ ". | length" "$NILELIBR")
    
    for ((i = 0; i < __num; i++)); do
        ALIB+=( "$i" "${AIMG[$i]}" "$(echo "${ATIT[$i]}" | iconv -c)" "${AGEN[$i]}" )
    done
}

##
# downloader
# Downloader main daemon
#
# $1 = source varname ( contains pid of father process )
#
function downloader()
{
    local __fpid=$1 ; local __file_downloading= ; local __downloading= ; local __files= ; local __name= ; local __image=
    find "$QASON" -type f -exec rm -Rf {} \;

    echo "Starting the Descargador." > "$LOGDOWNLOADER"
    while kill -0 "$__fpid" 2>/dev/null || [ "$(ls -A "$QASON")" ] ;do

        if [ "$(ls -A "$QASON")" ];then
            __files=("$QASON"/*)
            __file_downloading="${__files[0]}"
            __downloading=$(basename "$__file_downloading")
            __name=$(cut -d '|' -f1 < "$__file_downloading")
            __image=$(cut -d '|' -f2 < "$__file_downloading")
            "$YAD" --tittle="$lDOWNLOADING" "$ICON" --image="$__image" --posx=1 --poxy=1 --no-buttons --undecorated \
            --no-escape --no-focus &
            local __pimage=$!
            echo "Downloader: Downloading a game with ID: $__downloading and name $__name" >> "$LOGDOWNLOADER"
            "$NILE" install --base-path "$DIRINSTALL" "$__downloading" >> "$LOGDOWNLOADER" 2>> "$LOGDOWNLOADER"
            echo "Downloader: Finish the game with ID: $__downloading and name $__name" >> "$LOGDOWNLOADER"
            kill "$__pimage"
            sleep 0.5
            if [ -f "$__file_downloading" ];then
                rm "$__file_downloading" 
            else
                "$NILE" uninstall "$__downloading" >> "$LOGDOWNLOADER" 2>> "$LOGDOWNLOADER"
            fi
        else
            sleep 5
        fi
    done

    echo "Exiting of descargador." >> "$LOGDOWNLOADER"

}

##
# add_download
# Add a game to download
#
# $1 = source varname ( contains the ID (of game) )
# S2 = source varname ( name of game )
# S3 = source varname ( path of game image )
#
function add_download()
{
    local __id=$1
    local __name=$2
    local __image=$3

    echo -ne "$__name|$__image" > "$QASON/$__id"
}

#########################
# AUXILIARY FUNCT END   #
#########################
##
# dologin
# Login on Amazon Games over Nile.
#
function dologin()
{
    "$NILE" auth --login --no-sandbox
}

##
# cache
# Load or generate the cache of ASON
#
function cache()
{
    ATIT=();AGEN=();AIMG=()
    local __num=
    __num=$($JQ ". | length" "$NILELIBR")
    local __url=
    local __file=
    for ((i = 0; i < __num; i++)); do
        echo $((i * 100 / __num))
        __url="$($JQ -r ".[$i].product.productDetail.details.logoUrl" "$NILELIBR")"
        __file="$ASONCACHE/$(basename "$__url")"
        [ -f "$__file" ] || getCache "$__url" "$__file"
        ATIT+=( "$($JQ -r ".[$i].product.title" "$NILELIBR")" )
        AGEN+=( "$($JQ -r ".[$i].product.productDetail.details.genres[0]" "$NILELIBR")" )
        AIMG+=( "$__file" )
    done

    save_cache
}

##
# loading
# The global process to caching
#
function loading()
{
    local __pid=
    
    # splash Window
    "$YAD" "$TITTLE" --center --splash --no-escape --on-top --image="$(fileRandomInDir "$ASONSIMGPLASH")" --no-buttons & __pid=$!

    [ -d "$ASONCACHE" ] || mkdir -p "$ASONCACHE"
    [ -d "$QASON" ] || mkdir -p "$QASON"
    
    if [ ! -f "$ASONTITFILE" ] || [ ! -f "$ASONGENFILE" ] || [ ! -f "$ASONIMGFILE" ];then
        cache | "$YAD" "$ICON" --on-top --text="Caching..." --progress --auto-close --no-buttons --undecorated --no-escape
    fi

    if [ ! -f AID_NAME ];then
        "$JQ" -r '.[] | "\(.id)==\(.product.title)==\(.product.productDetail.details.logoUrl)"' "$NILELIBR" >"$AID_NAME"
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
function mainW()
{
    "$YAD" "$TITTLE" --center --image="$(fileRandomInDir "$ASONIMGMAIN")" --sticky --buttons-layout=spread \
    --button=$lLIBRARY:0 --button=$lINSTALLED:1 --button=$lOPTIONS:2 --button="$lDOWNLOADSM":3 --button="$lEXIT":100 "$ICON" --fixed --on-top

    MENU=$?
}

##
# libraryW
# Show the LIBRARY Window
#
function libraryW()
{
    local __salida=
    __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 \
    --button="$lDETAILS":0 --button="$lBACK":1 --button="$lINSTALL":2 --column=ID --column="$lGAME":IMG --column="$lTITTLE" --column="$lGENRE" "${ALIB[@]}")
    
    local __boton=$?
    local __index=
    __index=$(echo "$__salida" | cut -d'|' -f1)

    case $__boton in
        0) gameDetailW "$__index";;
        2) 
            local __id= ; local __name= 
            __id=$($JQ -r ".[$__index].id" "$NILELIBR")
            __name=$(echo "$__salida" | cut -d'|' -f3)
            add_download "$__id" "$__name" "${AIMG[$__index]}" ;;
        *) ;;
    esac

}

##
# gestor_descargasW
# Show the downloads queue
#
function gestor_descargasW()
{
    local __descargas= ; local __name= ; local __DLIB=()

    if [ "$(ls -A "$QASON")" ];then
        __descargas=("$QASON"/*)

        [ "${#__descargas[@]}" -eq 0 ] || for i in "${__descargas[@]}"; do
            __name=$(cut -d '|' -f1 < "$i")
            __image=$(cut -d '|' -f2 < "$i")
            __DLIB+=( "0" "$i" "$__image" "$__name" )
        done

        local __salida=
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --checklist --width=1280 --height=800 --hide-column=2 \
    --column="" --column=File --column="$lGAME":IMG --column="$lTITTLE" --button="$lBACK":1 --button="$lDELETE":0 "${__DLIB[@]}")
        
        local __boton=$?

        if [ "$__boton" -eq 0 ];then
            for i in $(echo "$__salida" | cut -d'|' -f2);do
                rm "$i"
            done
        fi
    else
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --align=center --timeout=2 --undecorated --text="$lNODOWLOADS"       
    fi

}

##
# gameDetailW
# Show the detail of a game
#
# $1 = source varname ( contains the index of game in JSON)
#
function gameDetailW()
{
    "$YAD" "$TITTLE" --center --no-buttons --text="Game Detail $1"
}

##
# installedW
# Show the INSTALLED Window
#
function installedW()
{
    local __num=

    if [ ! -f "$NILEINSTALLED" ] || [ "$("$JQ" ". | length" "$NILEINSTALLED")" == 0 ]; then
        "$YAD" "$TITTLE" "$ICON" --center --no-buttons --align=center --timeout=2 --undecorated --text="$lNOINSTALLED" 
    else
        local __num=
        __num=$("$JQ" ". | length" "$NILEINSTALLED")
        local __LISTA=() ; local __ID= ; local __NOMBRE= ; local __IMG=; local __PATH=

        for ((i = 0; i < __num; i++)); do
            __ID=$("$JQ" -r ".[$i].id" "$NILEINSTALLED")
            __NOMBRE=$(grep "$__ID" <"$AID_NAME" | cut -d '=' -f3)
            __IMG=$(grep "$__ID" <"$AID_NAME" | cut -d '=' -f5)
            __PATH=$("$JQ" -r .[$i].path "$NILEINSTALLED")
            __LISTA+=( "$i" "$ASONCACHE/$(basename "$__IMG")" "$__NOMBRE" "$__PATH" )
        done

        local __salida=
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 \
    --column=Index --column="$lGAME":IMG --column="$lTITTLE" --column="$lPATH" --button="$lBACK":1 --button="$lRUN":2 --button="$lUNINSTALL":0 "${__LISTA[@]}")

    fi
}

##
# optionW
# Show the OPTION Window
#
function optionW()
{
    "$YAD" "$TITTLE" --center --no-buttons --text="Options"
}

##
# loginW
# Show the LOGIN Window
#
function loginW()
{
    "$YAD" "$TITTLE" --center --no-buttons --text="login"
}

##
# aboutW
# Show the ABOUT Window
#
function aboutW()
{
    "$YAD" "$TITTLE" --about --pname="ASON" --pversion="$VERSION" --comments="Play at your games of Amazon in Linux" \
    --authors="Paco Guerrero <fjgj1@hotmail.com>" --website="https://github.com/FranjeGueje/Ason" "$ICON" --image="$ASONLOGO"
}

##
# installedW
# Show the EXIT Window
#
function exitW()
{
    "$YAD" "$TITTLE" --splash --no-buttons --image="$(fileRandomInDir "$ASONSIMGPLASH")" --form --field="$lEXITMSG:LBL" --align=center --timeout=3

    kill -0 "$PID_DOWNLOADER" 2>/dev/null && [ "$(ls -A "$QASON")" ] && echo "Downloader Activo"
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#########################################
##         MAIN 
#########################################

#* While the user is not logged
while [ ! -f "$NILEUSER" ] || [ ! -f "$NILELIBR" ];do
    "$YAD" "$TITTLE" --center --splash --image="$ASONWARNING" --text="$lNOLOGIN" \
    --timeout=4 --no-buttons --timeout-indicator=top
    dologin
done

loading

downloader $$ &
PID_DOWNLOADER=$!


MENU=0
while [ $MENU -ne 252 ] && [ $MENU -ne 100 ];do
    mainW
    case $MENU in
        0) libraryW;;
        1) installedW;;
        2) optionW;;
        3) gestor_descargasW;;
        252 | 100) exitW;;
    esac
done

exit 0