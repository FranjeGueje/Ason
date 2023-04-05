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
NOMBRE="[A]mazon Game[S] [O]ver [N]ile"
VERSION=2.0.0

# Configs of nile
NILEUSER="$HOME/.config/nile/user.json"
NILELIBR="$HOME/.config/nile/library.json"
NILEINSTALLED="$HOME/.config/nile/installed.json"

# Configs of Ason
ASONLIBRARYFILE="$HOME/.config/nile/ason.library"
ALIB=()

# Where is Steam, compatdata,shadercache, and grid
STEAM="$HOME/.local/share/Steam"
COMPATDATA="$STEAM/steamapps/compatdata"
SHADERCACHE="$STEAM/steamapps/shadercache"
DIRGRID="$STEAM/userdata/??*/config/grid/"

# Desktop file
DESKTOP_NAME_FILE="$HOME/.local/share/applications"
ENTRY_DESKTOP="[Desktop Entry]\nIcon="

# Startup content
CONTENT_DESKTOP="[Desktop Entry]\n\
Name=Ason\n\
Exec=\"$(readlink -f "$0")\"\n\
Terminal=false\n\
Type=Application\n"

# Where is the app and binaries
ASONPATH=$(readlink -f "$(dirname "$0")")
ASONBIN="$ASONPATH/bin"
YAD="$ASONBIN/yad"
NILE="$ASONBIN/nile"
JQ="$ASONBIN/jq"

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
        ;;
    *)
        lNOLOGIN="Ason could not find the information needed to login to Amazon Games.\n\n\
Please login correctly."
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

    [ -f "$__file" ] || wget "$__url" -O "$__file" &
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
    if [ ! -f "$ASONLIBRARYFILE" ];then
        ALIB=()
        local __num=
        __num=$($JQ ". | length" "$NILELIBR")
        local __url=
        local __file=
        for ((i = 0; i < __num; i++)); do
            #! indice + img + titulo + Genero
            __url="$($JQ -r ".[$i].product.productDetail.details.logoUrl" "$NILELIBR")"
            __file="$HOME/.cache/ason/$(basename "$__url")"
            [ -f "$__file" ] || getCache "$__url" "$__file"
            ALIB+=("$i" "$__file" "$($JQ -r ".[$i].product.title" "$NILELIBR")" "$($JQ -r \
".[$i].product.productDetail.details.genres[0]" "$NILELIBR")")
        done

        local __serialized=
        serialize_array ALIB __serialized '|'
        echo "$__serialized" > "$ASONLIBRARYFILE"
    
    else
        local __serialized=
        __serialized="$(cat "$ASONLIBRARYFILE")"
        deserialize_array __serialized ALIB '|'
    fi
    
}

##
# loading
# The global process to caching
#
function loading()
{
    local __pid    
    
    # splash Window
    "$YAD" "$TITTLE" --center --splash --image="$(fileRandomInDir "$ASONSIMGPLASH")" --no-buttons & __pid=$!

    cache

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
    --button=Biblioteca:0 --button=Instalados:1 --button=Opciones:2 --button="Re/login":3 --button="About":4\
    "$ICON" --fixed --on-top
    
    MENU=$?
}

##
# libraryW
# Show the LIBRARY Window
#
function libraryW()
{
    ALIB=()
    if [ ${#ALIB[@]} -eq 0 ]; then
        # Recaching
        loading
    fi
    "$YAD" "$TITTLE" "$ICON" --list --with=900 --height=900 --hide-column=1 --column=ID --column=Juego:IMG --column=Titulo --column=Genero \
    "${ALIB[@]}"
sleep 333
    TOTAL=$(echo "$RUN" | wc -w)
    n=1

    [ -f "$SALIDATEMP" ] && rm -f "$SALIDATEMP"
    for i in $RUN; do
        ID=$($JQ -r ".[$i].id" "$LIBRARY")
        EJECUTAR="$NILE install $ID --base-path $RUTAINSTALL"
        echo $((n * 100 / TOTAL)) | $D "Instalando $($JQ -r .["$i"].product.title "$LIBRARY")" --gauge "Espere..." 10 60 0
        ((n++))
        temp=$(eval "$EJECUTAR" 2>>"$SALIDATEMP")
    done

    mostrarResultado
}

##
# installedW
# Show the INSTALLED Window
#
function installedW()
{
    "$YAD" "$TITTLE" --center --no-buttons --text="Installed"
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
    "$YAD" "$TITTLE" --center --no-buttons --text="exit"
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#########################################
##         MAIN 
#########################################

loading

while [ ! -f "$NILEUSER" ] || [ ! -f "$NILELIBR" ];do
    "$YAD" "$TITTLE" --center --splash --image="$ASONWARNING" --text="$lNOLOGIN" \
    --timeout=4 --no-buttons --timeout-indicator=top
    dologin
done

MENU=0
while [ $MENU -ne 252 ];do
    mainW
    case $MENU in
        0) libraryW;;
        1) installedW;;
        2) optionW;;
        3) loginW;;
        4) aboutW;;
        252) exitW;;
    esac
done

exit 0