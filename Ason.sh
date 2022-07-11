# /bin/bash

# Variable de binario
NILE="$(pwd)/nile/bin/nile"

# Importamos las librerías necesarias del dialog "portable"
LD_LIBRARY_PATH="$(pwd)/dialog"
export LD_LIBRARY_PATH

DIALOG="$LD_LIBRARY_PATH/dialog"

# Cargamos el entorno
source env/bin/activate

$NILE
$DIALOG --backtitle ASON --title "Work in progress" --msgbox "Proximamente..." 0 0

exit 0

