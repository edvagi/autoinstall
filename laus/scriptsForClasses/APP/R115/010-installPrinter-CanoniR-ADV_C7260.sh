#!/bin/bash


### USAGE:
## installs printer ${PRINTER_NAME}
## with driver ${PRINTER_DRIVER}
## and ${PRINTER_LOCATION}
## and ${PRINTER_CONNECTION}
##
## AND should be named after printer modell 
## example: installPrinter_Brother_HL-7050.sh
##
## BECAUSE, enables installation of new printer with new name
## without problems

#### START DEFINE PARAMETER

PRINTER_NAME_SW="KonfZi-Kopierer_sw"
PRINTER_NAME_COLOR="KonfZi-Kopierer_color"

PRINTER_LOCATION_SW="Kopierer Gang AS S/W"
PRINTER_LOCATION_COLOR="Kopierer Gang AS COLOR"

PRINTER_CONNECTION_SW="socket://r115pr02"
PRINTER_CONNECTION_COLOR="socket://r115pr02"

## HELP to find printer modell:
## Find Print Driver with:
## >> lpinfo --make-and-model 'Lexmark' -m

PRINTER_DRIVER="lsb/usr/CNRCUPSIRADVC7270ZK.ppd"

#### END DEFINE PARAMETER

#### START install CANON print diver
. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles/Canon/UFRII
cd ${SOURCE_PATH}
./install.sh

#### END install CANON print diver


## check if printer ${PRINTER_NAME_SW} and ${PRINTER_NAME_COLOR } already installed
## remove, if already installed, and enable installation of new one
if [ "$(lpstat -v | grep ${PRINTER_NAME_SW})" != "" ];
then
	lpadmin -x ${PRINTER_NAME_SW}
fi

if [ "$(lpstat -v | grep ${PRINTER_NAME_COLOR})" != "" ];
then
	lpadmin -x ${PRINTER_NAME_COLOR}
fi


## Options in lpadmin declared:
# -E		Enables the destination and accepts jobs
# -p		Specifies a PostScript Printer Description file to use with the printer.
# -v		device-uri
# -m		Sets a standard System V interface script or PPD file for the printer from the model directory or using one of the driver interfaces
# -L		Provides a textual location of the destination.

#	Note the two -E options. The first one (before -p) forces encryption when connecting to the server. The last one enables the destination and starts accepting jobs.

# Install Queue on Server UNIFLOW uniflow01 for Black/White
lpadmin -E -p "${PRINTER_NAME_SW}" -v ${PRINTER_CONNECTION_SW} -m "${PRINTER_DRIVER}" -L "${PRINTER_LOCATION_SW}" -E

# Install Queue on Server UNIFLOW uniflow01 for Color
lpadmin -E -p "${PRINTER_NAME_COLOR}" -v ${PRINTER_CONNECTION_COLOR} -m "${PRINTER_DRIVER}" -L "${PRINTER_LOCATION_COLOR}" -E

# set Standard Print-Queue
lpadmin -d ${PRINTER_NAME_SW}



