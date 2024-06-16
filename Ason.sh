#!/bin/bash
##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# PROJECT: ASON (Amazon on SteamOS Over Nile)
# ABOUT: script with the objective of displaying an interface, i.e. a frontend for the unofficial Amazon Games linux client called 'nile'.
#
# PARAMS: Nope.
# DEBUG MODE: run 'DEBUG=Y path-to-Ason/Ason.sh'
#
# REQUERIMENTS: NILE, YAD, JQ, SHORTCUTSNAMEID, WGET, SHUF, FILE, FIND, ... gnu utils :D
#
# EXITs:
# 0 --> OK!!!.
# 1 --> Missing required component.
# 99 -> No login...
##############################################################################################################################################################

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         GLOBAL VARIABLES
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Basic
NOMBRE="ASON - [Amazon Games on Steam OS over Nile]"
VERSION=2.0.1

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
NAMEID="$ASONBIN/shortcutsNameID"
GRIDER="$ASONBIN/grider"

# Locations
DIRINSTALL="$HOME/Games"
DEBUGFILE="$ASONPATH/debug.log"

# Config files of Ason
ASONOPTIONFILE="$HOME/.config/nile/ason.config"

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
    lOLGRID='Clave para descargar grids desde Steamgriddb'
    lODGAMESPATH='Ruta de descarga'
    lSAVE='Guardar'
    lABOUT='Acerca de'
    lADREBOOT='Es necesario reiniciar Ason para iniciar con los nuevos cambios'
    lREMEMBERADDSTEAM='Ya tienes tu juego en Steam.\n\n<b>MUY IMPORTANTE</b>, debes de configurar su compatibilidad de Proton desde Steam.\
    Si no haces este cambio, probablemente <b>el juego no va a funcionar</b>.\n\nRecuerda, los juegos son gestionados y configurados desde Steam.'
    lSUREADDSTEAM='Estas <b>SEGURO</b> de que tu quieres add to Steam este juego?\n\nEs posible que el juego sea duplicado si ya lo instalaste anteriormente.\
    \n\n<b>RECUERDA</b>:\n\n\tGestiona tus juegos desde Steam.'
    lSCREENSHOTS='Screenshots'
    lSUREUNINSTALL='¿Estas <b>SEGURO</b> de que tu quieres desinstalar este juego y borrar su carpeta de instalación?\
    \n\n<b>RECUERDA</b>: podría contener información valiosa del juego como saves.'
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
    lOLGRID='Key for download grids from steamgriddb'
    lODGAMESPATH='Download path'
    lSAVE='Save'
    lABOUT='About'
    lADREBOOT='You have to close Ason to load the new configuration.'
    lREMEMBERADDSTEAM='You just have the game add to Steam.Now, <b>VERY IMPORTANT</b>, you must configure its Proton compatibility in the game.\
    \n\nIf you do not change the compatibility option on the Steam Game, you can not run the game.\n\n\nGames are managed and configured directly from Steam.'
    lSUREADDSTEAM='Are you <b>SURE</b> you want to add to Steam this game?\n\nIt is possible that the game will be duplicated if you have already installed it.\
    \n\n<b>REMEMBER</b>:\n\n\tManage the game from Steam directly.'
    lSCREENSHOTS='Screenshots'
    lSUREUNINSTALL='Are you <b>SURE</b> you want to uninstall this game and delete its installation folder?\
    \n\n<b>REMEMBER</b>: it might contain valuable game information such as saves'.
    ;;
esac

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!         FUNCTIONS
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

##
# get_nile_title
# Show a message on screen
# return The title of game.
#
# $1 = source varname ( id of Amazon Game )
# return The title of game.
#
function get_nile_title() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILELIBR" | "$JQ" -r --arg v "$__id" '.[] | select (.product.id == $v ) | .product.title '
}

##
# get_nile_logo
# Show a message on screen
# return The logo file of game.
#
# $1 = source varname ( id of Amazon Game )
# return The logo file of game.
#
function get_nile_logo() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILELIBR" | "$JQ" -r --arg v "$__id" '.[] | select (.product.id == $v ) | .product.productDetail.details.logoUrl ' | sed "s|https://m.media-amazon.com/images/I/|$ASONCACHE|g"
}

##
# get_nile_image
# Show a message on screen
# return The image file of game.
#
# $1 = source varname ( id of Amazon Game )
# return The image file of game.
#
function get_nile_image() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILELIBR" | "$JQ" -r --arg v "$__id" '.[] | select (.product.id == $v ) | .product.productDetail.details.pgCrownImageUrl ' | sed "s|https://m.media-amazon.com/images/I/|$ASONCACHE|g"
}

##
# get_nile_screenshots
# Show a message on screen
# return All screenshots files of game.
#
# $1 = source varname ( id of Amazon Game )
# return All screenshots files of game.
#
function get_nile_screenshots() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILELIBR" | "$JQ" -r --arg v "$__id" '.[] | select (.product.id == $v ) | .product.productDetail.details.screenshots[] '
}

##
# get_nile_detail
# Show a message on screen
# return The details of game.
#
# $1 = source varname ( id of Amazon Game )
# return The details of game.
#
function get_nile_detail() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILELIBR" | "$JQ" -r --arg v "$__id" '.[] | select (.product.id == $v ) | "\(.product.productDetail.details.releaseDate)|\(.product.productDetail.details.developer)|\(.product.productDetail.details.publisher)|\(.product.productDetail.details.esrbRating)|\(.product.productDetail.details.genres)|\(.product.productDetail.details.gameModes)|\(.product.productDetail.details.shortDescription)|\(.product.productDetail.details.screenshots)"'
}

##
# get_nile_path_installed_game
# Show a message on screen
# return path of a installed game.
#
# $1 = source varname ( id of Amazon Game )
# return path of a installed game.
#
function get_nile_path_installed_game() {
    local __id=$1

    # Requisite of jq
    # shellcheck disable=SC2016
    iconv -c "$NILEINSTALLED" | "$JQ" -r --arg v "$__id" '.[] | select (.id == $v ) | .path'
}

##
# to_debug_file
# Save a msg to debug
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

    # Magick is optional
    if [ -f "$ASONBIN/magick" ]; then
        MAGICK="$ASONBIN/magick"
    fi

    [ -d "$QASON" ] || mkdir -p "$QASON"

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
# download_grid
# Download the grids for a game
#
# $1 = Name of game
#
function download_grid() {
    local __NOMBRE=$1
    local __ANAMEID="/tmp/ason.nameID"
    local __ANAMES="/tmp/ason.names"
    local __AGRIDS="/tmp/ason.grid"
    [ -n "$GRIDKEY" ] || GRIDKEY=0
    mkdir -p "$__AGRIDS"
    rm -f "$__ANAMEID"
    sleep 3
    find "$HOME/.local/share/Steam/userdata/" -name "shortcuts.vdf" -type f -exec "$NAMEID" {} \; >>  "$__ANAMEID"
    cut -f1 -d $'\t' "$__ANAMEID" > "$__ANAMES"
    if grep -w "$__NOMBRE".bat < "$__ANAMES" >/dev/null ; then
        local __id=
        __id=$(grep -m 1 "$__NOMBRE".bat$'\t' < "$__ANAMEID" | cut -f2 -d $'\t')
        "$GRIDER" -dest "$__AGRIDS" "$GRIDKEY" "$__NOMBRE" "$__id"
        for dir in "$HOME"/.local/share/Steam/userdata/*/; do
            cp "$__AGRIDS"/* "$dir/config/grid/"
        done
        rm -f $__AGRIDS/*
    fi
}

##
# get_cache
# Download the cache images from internet.
#
# $1 = source varname ( url to download )
# $2 = target filename ( file to save the download )
# $3 = size limit (in format widthxheight)
#
function get_cache() {
    local __url=$1
    local __file=$2
    local __limit=$3

    local __w=
    __w=$(echo "$__limit" | cut -d 'x' -f1)

    wget "$__url" -O "$__file" >/dev/null 2>/dev/null && file "$__file" | grep -v "$__w" && [ -n "$MAGICK" ] && "$MAGICK" convert "$__file" -resize "$__limit"'>' "$__file"
    [ -n "$DEBUG" ] && to_debug_file "DBG: Download image $__url to $__file"
}

##
# cache
# Check or generate the cache of ASON
#
function cache() {

    local __ACACHED=/tmp/ason.cached
    local __ACACHING=/tmp/ason.to_caching
    local __ACACH_REQ=/tmp/ason.required_cache
    local __ASONCACHEVER="$ASONCACHE""cache/ason.versioncache"

    #***This new version, does it need recaching??
    local __need_recaching=Y

    [ "$__need_recaching" == 'Y' ] && if [ ! -f "$__ASONCACHEVER" ] || [ "$(cat "$__ASONCACHEVER")" != "$VERSION" ]; then
        # Remove old cache because change of ver
        find "$ASONCACHE" -mindepth 0 -maxdepth 1  -type f -exec rm -f {} \;
    fi
    
    # All necessary cache
    local __A= ; __A=$("$JQ" -r -c '.[].product.productDetail.details | "\(.logoUrl)\n\(.pgCrownImageUrl)"' "$NILELIBR" | grep -w -v null | sed "s|https://m.media-amazon.com/images/I/||g" | sort | uniq)
    # Get local cache
    find "$ASONCACHE" -mindepth 0 -maxdepth 1  -type f | sed "s|$ASONCACHE||g" | sort | uniq >"$__ACACHED"

    [ "$__A" == "$(cat "$__ACACHED")" ] && echo 100 && return

    [ -n "$DEBUG" ] && to_debug_file "DBG: Necessary caching!!"
        
    # Get necesary cache (LOGO)
    "$JQ" -r -c .[].product.productDetail.details.logoUrl "$NILELIBR" | grep -w -v null | sed "s|https://m.media-amazon.com/images/I/||g" >"$__ACACHING"

    if grep -vFf "$__ACACHED" <"$__ACACHING" >"$__ACACH_REQ"; then
        local __num=
        __num=$(wc -l <"$__ACACH_REQ")
        local __counter=0
        local __file=
        # Get the logo image
        while read -r __url; do
            __file=$ASONCACHE/$(basename "$__url")
            [ ! -f "$__file" ] && get_cache "$__url" "$__file" "400x225" &
            echo $((__counter * 50 / __num))
            ((__counter++))
        done < <("$JQ" -r -c .[].product.productDetail.details.logoUrl "$NILELIBR" | grep -w -v null | grep -Ff "$__ACACH_REQ")
    fi

    # Get necesary cache (IMAGE DETAIL)
    "$JQ" -r -c .[].product.productDetail.details.pgCrownImageUrl "$NILELIBR" | grep -w -v null | sed "s|https://m.media-amazon.com/images/I/||g" >"$__ACACHING"

    if grep -vFf "$__ACACHED" <"$__ACACHING" >"$__ACACH_REQ"; then
        local __num=
        __num=$(wc -l <"$__ACACH_REQ")
        local __counter=0
        local __file=
        # Get the detail image
        while read -r __url; do
            __file=$ASONCACHE/$(basename "$__url")
            [ ! -f "$__file" ] && get_cache "$__url" "$__file" "512x288" &
            echo $((50 + __counter * 50 / __num))
            ((__counter++))
        done < <("$JQ" -r -c .[].product.productDetail.details.pgCrownImageUrl "$NILELIBR" | grep -w -v null | grep -Ff "$__ACACH_REQ")
    fi

    rm "$__ACACHED" "$__ACACHING" "$__ACACH_REQ"
    
    # Save the cache version
    mkdir -p "$ASONCACHE"cache ; echo "$VERSION" > "$__ASONCACHEVER"
    
}

##
# delete_old_cache
# Delete all old cache of Ason
#
function delete_old_cache() {

    #Old files for cache purposes
    local ASONTITFILE="$ASONCACHE""/ason.tit"
    local ASONIDNAME="$ASONCACHE""/ason.id-name"
    local ASONIMGFILE="$ASONCACHE""/ason.img"
    local ASONIMGDFILE="$ASONCACHE""/ason.img_detail"
    local ASONGENFILE="$ASONCACHE""/ason.gen"
    local ASONNULL="$ASONCACHE""/null"

    rm "$ASONTITFILE" "$ASONIMGFILE" "$ASONIMGDFILE" "$ASONGENFILE" "$ASONCACHE/ason.versioncache" "$ASONIDNAME" "$ASONNULL" 2>/dev/null
}

##
# reload_library
# Load in memory the Library of ASON
#
# $1 = source varname ( [OPTIONAL] text to search)
#
function reload_library() {
    #! REMEMBER: ID + Logo + Title + Genre

    __search=$1
    # Requisite of jq
    # shellcheck disable=SC2016
    readarray -t -d '|' \
        ALIB < <("$JQ" -r -j --arg v "$__search" '.[] | select(.product.title | ascii_downcase | contains ($v)) | "\(.product.id)|\(.product.productDetail.details.logoUrl)|\(.product.title)|\(.product.productDetail.details.genres[0])|"' "$NILELIBR" | sed "s|https://m.media-amazon.com/images/I/|$ASONCACHE|g" | iconv -c)

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
#
function add_download() {
    local __id=$1
    local __name=
    __name=$(get_nile_title "$__id")
    local __image=
    __image=$(get_nile_logo "$__id")

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
# load_options
# Load the options from the file
#
function load_options() {
    if [ -f "$ASONOPTIONFILE" ]; then
        [ -n "$DEBUG" ] && to_debug_file "DBG: using the options of file $ASONOPTIONFILE"
        DIRINSTALL=$(cut -d '|' -f1 <"$ASONOPTIONFILE")
        GRIDKEY=$(cut -d '|' -f2 <"$ASONOPTIONFILE")
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

    [ -n "$DEBUG" ] && to_debug_file "DBG: Generating the cache"
    delete_old_cache
    cache | "$YAD" "$ICON" --on-top --text="Caching..." --progress --auto-close --no-buttons --undecorated --no-escape --no-markup
    [ -n "$DEBUG" ] && to_debug_file "DBG: Cache generated"

    [ -n "$DEBUG" ] && to_debug_file "DBG: Load options"
    load_options
    [ -n "$DEBUG" ] && to_debug_file "DBG: Reload Library"

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
    local __search=$1

    if [ -n "$__search" ]; then
        reload_library "$__search"
    else
        reload_library
    fi

    # Result of YAD dialog
    local __salida=
    local __boton=0

    [ -n "$DEBUG" ] && to_debug_file "DBG: Showing the library list:\n${ALIB[*]}"

    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        __salida=$("$YAD" "$TITTLE" "$ICON" --center --on-top --list --width=1280 --height=800 --hide-column=1 --sticky --no-markup --buttons-layout=spread \
            --button="$lBACK":1 --button="$lSEARCH":3 --button="$lDETAILS":0 --button="$lSYNC":4 --button="$lINSTALL":2 \
            --column=ID --column="$lGAME":IMG --column="$lTITTLE" --column="$lGENRE" "${ALIB[@]}")

        local __boton=$?
        local __id=
        __id=$(echo "$__salida" | cut -d'|' -f1)

        case $__boton in
        0) # Details
            [ -n "$DEBUG" ] && to_debug_file "DBG: Get game detail of $__id ID"
            gameDetailW "$__id"
            ;;

        2) # Install
            local __name=
            __name=$(echo "$__salida" | cut -d'|' -f3)
            show_msg "$lADDDOWNLOAD" "$(get_nile_logo "$__id")"
            add_download "$__id"
            ;;
        3) # Buscar
            __salida=$("$YAD" "$TITTLE" "$ICON" --center --on-top --no-escape --button="OK":0 --form --field="$lSEARCH:")
            __salida=${__salida::-1}
            __salida=$(echo "$__salida" | tr '[:upper:]' '[:lower:]')
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
# $1 = source varname ( contains the ID of game in Amazon Games)
#
function gameDetailW() {
    local __id=$1
    local __fecha=
    local __developer=
    local __publicador=
    local __esrb=
    local __generos=
    local __modos=
    local __desc=
    local __info=
    __info=$(get_nile_detail "$__id")

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
    __image="$(get_nile_image "$__id")"

    [ "$__image" == 'null' ] && __image="$(get_nile_logo "$__id")"

    [ -n "$DEBUG" ] && to_debug_file "DBG: Detail of game:\n$__text\nAnd image: $__image"

    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        "$YAD" "$TITTLE" "$ICON" --center --image="$__image" --sticky --buttons-layout=spread --width=512 --no-markup --no-markup --form \
            --item-separator="#@#" --field="$__text":LBL --button="$lBACK":1 --button="$lSCREENSHOTS":4 --button="$lINSTALL":8 >/dev/null

        local __boton=$?
        case "$__boton" in
        0) ;;
        4)
            [ -n "$DEBUG" ] && to_debug_file "DBG: View screenshot of $__id OD"
            screnshotsW "$__id"
            ;;
        8)
            local __name=
            __name=$(get_nile_title "$__id")
            show_msg "$lADDDOWNLOAD" "$(get_nile_logo "$__id")"
            add_download "$__id"
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
    local __id=$1
    local __tempS=/tmp/ason.screenshots/

    [ ! -d "$__tempS" ] && mkdir "$__tempS"

    get_nile_screenshots "$__id" >"$__tempS/urls"

    wget -i "$__tempS/urls" -P "$__tempS/." >/dev/null 2>/dev/null
    rm "$__tempS/urls"

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

    # Result of YAD dialog
    local __salida=
    local __boton=0
    while [ $__boton -ne 1 ] && [ $__boton -ne 252 ]; do
        if [ ! -f "$NILEINSTALLED" ] || [ "$("$JQ" ". | length" "$NILEINSTALLED")" == 0 ]; then
            show_msg "$lNOINSTALLED"
            break
        fi

        local __num=
        __num=$("$JQ" ". | length" "$NILEINSTALLED")
        local __LISTA=()
        local __ID=
        local __NOMBRE=
        local __IMG=
        local __PATH=

        for ((i = 0; i < __num; i++)); do
            __ID=$("$JQ" -r ".[$i].id" "$NILEINSTALLED")
            __NOMBRE=$(get_nile_title "$__ID" | iconv -c)
            __IMG=$(get_nile_logo "$__ID")
            __PATH=$("$JQ" -r .[$i].path "$NILEINSTALLED" | iconv -c)
            __LISTA+=("$__ID" "$__NOMBRE" "$__IMG" "$__PATH")
        done

        [ -n "$DEBUG" ] && to_debug_file "DBG: Showing the installed list:\n${__LISTA[*]}"

        __salida=$("$YAD" "$TITTLE" "$ICON" --center --list --width=1280 --height=800 --hide-column=1 --sticky --buttons-layout=spread \
            --no-markup --column=Index --column="$lTITTLE" --column="$lGAME":IMG --column="$lPATH" \
            --button="$lBACK":1 --button="$lADDMENU":0 --button="$lUPDATE":4 --button="$lUNINSTALL":2 "${__LISTA[@]}")

        local __boton=$?
        __ID=$(echo "$__salida" | cut -d '|' -f1)
        __NOMBRE=$(echo "$__salida" | cut -d '|' -f2)
        __PATH=$(get_nile_path_installed_game "$__ID")

        case "$__boton" in
        0) # Run Menu
            if "$YAD" "$TITTLE" "$ICON" --center --text="$lSUREADDSTEAM"; then
                [ -n "$DEBUG" ] && to_debug_file "DBG: Creating the bat files"
                create_bat_file "$__NOMBRE" "$__PATH"
                [ -n "$DEBUG" ] && to_debug_file "DBG: Adding to Steam"
                add_steam_game "$__PATH/$__NOMBRE".bat

                download_grid "$__NOMBRE" &

                "$YAD" "$TITTLE" "$ICON" --center --text="$lREMEMBERADDSTEAM" --button="OK":0 --image="$ASONCOMPATING"
            fi
            ;;
        2) # Uninstall
            if "$YAD" "$TITTLE" "$ICON" --center --text="$lSUREUNINSTALL"; then
                uninstallW "$__ID"
            fi
            ;;
        4) # Update
            show_msg "$lUPDATING $__NOMBRE" "$(get_nile_logo "$__ID")" &
            [ ! -d "$DIRINSTALL" ] && mkdir -p "$DIRINSTALL"
            [ -n "$DEBUG" ] && to_debug_file "DBG: Updating $__NOMBRE"
            "$NILE" install --base-path "$DIRINSTALL" "$__ID" 2>>"$DEBUGFILE"
            show_msg "Updated $__NOMBRE" "$(get_nile_logo "$__ID")"
            ;;
        *) ;;

        esac
    done
}

##
# uninstallW
# Uninstall a game
#
# $1 = source varname ( contains the id of game on Amazon Games)
#
function uninstallW() {
    local __ID=$1
    local __PATH=
    __PATH=$(get_nile_path_installed_game "$__ID")

    show_msg "$lUNINSTALLING $(get_nile_title "$__ID")" "$(get_nile_logo "$__ID")" &
    [ -n "$DEBUG" ] && to_debug_file "DBG: Uninstalling $(get_nile_title "$__ID" | iconv -c)"
    "$NILE" uninstall "$__ID" 2>>"$DEBUGFILE"

    # Sure that id is delete from installed.json
    cp "$NILEINSTALLED" "$NILEINSTALLED".bak
    # Requisite of jq
    # shellcheck disable=SC2016
    "$JQ" -c -r --arg v "$__ID" 'map(select(.id != $v ))' "$NILEINSTALLED" >"$NILEINSTALLED".tmp && mv "$NILEINSTALLED".tmp "$NILEINSTALLED"

    # Sure that PATH is delete
    [ -d "$__PATH" ] && rm -rf "$__PATH" && [ -n "$DEBUG" ] && to_debug_file "DBG: Removed the dir $__PATH"
    # Sure that manifest is deleted
    local __manifest="$HOME/.config/nile/manifests/$__ID".json
    [ -f "$__manifest" ] && rm -rf "$__manifest" && [ -n "$DEBUG" ] && to_debug_file "DBG: Removed the manifest $__manifest"

    show_msg "$lUNINSTALLED $(get_nile_title "$__ID")" "$(get_nile_logo "$__ID")"
}

##
# optionW
# Show the OPTION Window
#
function optionW() {
    local __salida=

    __salida=$("$YAD" "$TITTLE" "$ICON" --columns=1 --form --image="$(fileRandomInDir "$ASONSIMGPLASH")" \
        --button="$lBACK":1 --button="$lSAVE":0 --button="Logout":3 --button="$lABOUT":2 --buttons-layout=edge --align=center \
        --field="$lOLWHERE:LBL" --field="$lODGAMESPATH:DIR" '' "$DIRINSTALL" --field="$lOLGRID:" "$GRIDKEY")

    local __boton=$?

    case "$__boton" in
    0)
        local __ruta=
        local __opciones=
        __ruta=$(echo "$__salida" | cut -d '|' -f2)
        __opciones="${__salida:1:-1}"
        echo "$__opciones"'|' >"$ASONOPTIONFILE"
        [ ! -d "$__ruta" ] && mkdir "$__ruta"
        DIRINSTALL=$__ruta
        GRIDKEY=$(echo "$__opciones" | cut -d '|' -f2)
        "$YAD" "$TITTLE" "$ICON" --center --on-top --align=center --undecorated --text="$lADREBOOT" --button=OK:0
        ;;
    2)
        aboutW
        ;;
    3)
        dologout
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

max_num=2
#* While the user is not logged
while [ ! -f "$NILEUSER" ] || [ ! -f "$NILELIBR" ] || [ ! "$max_num" ]; do
    [ -n "$DEBUG" ] && to_debug_file "DBG: Nile files are missing. Do login"
    "$YAD" "$TITTLE" --center --splash --image="$ASONWARNING" --text="$lNOLOGIN" \
        --timeout=3 --no-buttons --timeout-indicator=top
    dologin
    ((max_num--))
    [ $max_num -eq 0 ] && echo "Maximum login attempts" && exit 99
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
