#! /bin/bash

# Descargamos la última versión de nile
echo "Descargamos la última versión de nile" && git submodule update --init 

# Creamos el entorno de python "portable"
echo "Creando el entorno..." && python3 -m venv env

# Cambiamos los varoles de las variables VIRTUAL_ENV para hacerlo "portable"
sed -i "s#$(pwd)#\$\(pwd\)#g" env/bin/activate
sed -i "s#$(pwd)#\$\(pwd\)#g" env/bin/activate.csh


# Activamos el entorno creado
source env/bin/activate

# Descargamos los requerimiento
pip3 install -r nile/requirements.txt

echo "Prueba de ejecución" && nile/bin/nile --help
